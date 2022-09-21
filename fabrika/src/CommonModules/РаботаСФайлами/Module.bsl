////////////////////////////////////////////////////////////////////////////////
// Подсистема "Работа с файлами".
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Создает карточку Файла в БД вместе с версией
// Параметры
// Владелец - владелец файла - будет установлен в реквизит ВладелецФайла у созданного файла
// ПутьКФайлуНаДиске  - Строка - полный путь (включающий имя и расширение) к файлу на диске (файл должен находиться на сервере)
//
// Возвращаемое значение:
//    СправочникСсылка.Файлы - созданный файл
//
Функция СоздатьФайлНаОсновеФайлаНаДиске(Владелец, ПутьКФайлуНаДиске) Экспорт
	
	Файл = Новый Файл(ПутьКФайлуНаДиске);
	
	ДвоичныеДанные = Новый ДвоичныеДанные(ПутьКФайлуНаДиске);
	АдресВременногоХранилищаФайла = ПоместитьВоВременноеХранилище(ДвоичныеДанные);
	
	АдресВременногоХранилищаТекста = "";
	
	Если ФайловыеФункцииСлужебный.ИзвлекатьТекстыФайловНаСервере() Тогда
		// Текст извлечет регламентное задание.
		АдресВременногоХранилищаТекста = ""; 
	Иначе
		// Попытка извлечения текста, если сервер под Windows.
		Если ФайловыеФункцииСлужебный.ЭтоПлатформаWindows() Тогда
			Текст = ФайловыеФункцииСлужебныйКлиентСервер.ИзвлечьТекст(ПутьКФайлуНаДиске);
			АдресВременногоХранилищаТекста = Новый ХранилищеЗначения(Текст);
		КонецЕсли;
	КонецЕсли;
	
	ФайлСсылка = РаботаСФайламиСлужебныйВызовСервера.СоздатьФайлСВерсией(
		Владелец,
		Файл.ИмяБезРасширения,
		Файл.Расширение,
		Файл.ПолучитьВремяИзменения(),
		Файл.ПолучитьУниверсальноеВремяИзменения(),
		Файл.Размер(),
		АдресВременногоХранилищаФайла,
		АдресВременногоХранилищаТекста,
		Ложь);
		
	Возврат ФайлСсылка;
	
КонецФункции

// Обработчик события ПриЗаписи. Определен для объектов (кроме Документ), владельцев Файла.
Процедура УстановитьПометкуУдаленияФайловПередЗаписью(Источник, Отказ) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда 
		Возврат;
	КонецЕсли; 
	
	Если Источник.ПометкаУдаления <> ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Источник.Ссылка, "ПометкаУдаления") Тогда
		ПометитьНаУдалениеПриложенныеФайлы(Источник.Ссылка, Источник.ПометкаУдаления);
	КонецЕсли;
	
КонецПроцедуры

// Обработчик события ПриЗаписи. Определен для объектов типа Документ, владельцев Файла.
Процедура УстановитьПометкуУдаленияФайловДокументовПередЗаписью(Источник, Отказ, РежимЗаписи, РежимПроведения) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда 
		Возврат;
	КонецЕсли; 
	
	Если Источник.ПометкаУдаления <> ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Источник.Ссылка, "ПометкаУдаления") Тогда
		ПометитьНаУдалениеПриложенныеФайлы(Источник.Ссылка, Источник.ПометкаУдаления);
	КонецЕсли;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// Вспомогательные процедуры и функции

// Помечает/снимает пометку удаления у приложенных файлов.
Процедура ПометитьНаУдалениеПриложенныеФайлы(ВладелецФайла, ПометкаУдаления)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Файлы.Ссылка КАК Ссылка,
	|	Файлы.Редактирует КАК Редактирует
	|ИЗ
	|	Справочник.Файлы КАК Файлы
	|ГДЕ
	|	Файлы.ВладелецФайла = &ВладелецФайла";
	
	Запрос.УстановитьПараметр("ВладелецФайла", ВладелецФайла);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		Если ПометкаУдаления И Не Выборка.Редактирует.Пустая() Тогда
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = '""%1"" не может быть удален,
				           |т.к. содержит файл ""%2"",
				           |занятый для редактирования.'"),
				Строка(ВладелецФайла),
				Строка(Выборка.Ссылка));
		КонецЕсли;
		ФайлОбъект = Выборка.Ссылка.ПолучитьОбъект();
		ФайлОбъект.Заблокировать();
		ФайлОбъект.УстановитьПометкуУдаления(ПометкаУдаления);
	КонецЦикла;
	
КонецПроцедуры	

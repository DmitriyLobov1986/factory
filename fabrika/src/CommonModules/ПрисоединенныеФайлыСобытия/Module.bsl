////////////////////////////////////////////////////////////////////////////////
// Обработчики подписок

// Обработчик подписки "перед записью" присоединенного файла
//
Процедура ПередЗаписьюПрисоединенногоФайла(Источник, Отказ) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ПрисоединенныеФайлы.ПроверитьИмяФайлаУникально(Источник.Наименование, Источник.ВладелецФайла, Источник.Ссылка) Тогда
		Отказ = Истина;
		ВызватьИсключение НСтр("ru = 'Файл с таким именем уже присутствует списке присоединенных файлов.'");
	КонецЕсли;
	
	Источник.ИндексКартинки = ФайловыеФункцииСлужебныйКлиентСервер.ПолучитьИндексПиктограммыФайла(Источник.Расширение);
	
	Если Источник.ЭтоНовый() Тогда
		Источник.Автор = ОбщегоНазначения.ТекущийПользователь();
	КонецЕсли;
	
КонецПроцедуры

// Обработчик подписки "перед удалением" присоединенного файла
//
Процедура ПередУдалениемПрисоединенногоФайла(Источник, Отказ) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПрисоединенныеФайлы.ПередУдалениемПрисоединенногоФайлаСервер(Источник.Ссылка, Источник.ВладелецФайла, Источник.Том, Источник.ТипХраненияФайла, Источник.ПутьКФайлу);
	
КонецПроцедуры

// Обработчик подписки "при записи" присоединенного файла
//
Процедура ПриЗаписиПрисоединенногоФайла(Источник, Отказ) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		ЗаписатьДанныеФайлаВРегистрПриОбмене(Источник);
		Возврат;
	КонецЕсли;
	
	ПрисоединенныеФайлы.ПриЗаписиПрисоединенногоФайлаСервер(Источник.ВладелецФайла);
	
КонецПроцедуры

// Обработчик подписки "перед записью" владельца присоединенного файла
// Помечает на удаление связанные файлы.
//
// Параметры:
//  Источник - объект - владелец присоединенного файла
//  Отказ - булево - признак отказа от записи
// 
Процедура УстановитьПометкуУдаленияПрисоединенныхФайлов(Источник, Отказ) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПометитьНаУдалениеПриложенныеФайлы(Источник);
	
КонецПроцедуры

// Обработчик подписки "перед записью" владельца присоединенного файла документа
// Помечает на удаление связанные файлы.
//
// Параметры:
//  Источник - объект - владелец присоединенного файла документа
//  Отказ - булево - признак отказа от записи
// 
Процедура УстановитьПометкуУдаленияПрисоединенныхФайловДокументов(Источник, Отказ, РежимЗаписи, РежимПроведения) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если РежимЗаписи = РежимЗаписиДокумента.Запись Тогда
		ПометитьНаУдалениеПриложенныеФайлы(Источник);
	КонецЕсли;
	
КонецПроцедуры


Процедура ПометитьНаУдалениеПриложенныеФайлы(Источник)
	
	Если Источник.ЭтоНовый() ТОгда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ИсточникСсылкаПометкаУдаления = ОбщегоНазначения.ПолучитьЗначениеРеквизита(Источник.Ссылка, "ПометкаУдаления");
	
	Если Источник.ПометкаУдаления = ИсточникСсылкаПометкаУдаления Тогда
		Возврат;
	КонецЕсли;
	
	ИмяОбъекта = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Источник.Метаданные().ПолноеИмя(), ".")[1];
	ПолноеИмяОМ = "Справочник." + ИмяОбъекта + "ПрисоединенныеФайлы";
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	Файлы.Ссылка КАК Ссылка,
	|	Файлы.Редактирует КАК Редактирует
	|ИЗ
	|	[ПолноеИмяОМ] КАК Файлы
	|ГДЕ
	|	Файлы.ВладелецФайла = &ВладелецФайла";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "[ПолноеИмяОМ]", ПолноеИмяОМ);
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("ВладелецФайла", Источник.Ссылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Если Источник.ПометкаУдаления И Не Выборка.Редактирует.Пустая() Тогда
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = '""%1"" не может быть удален, т.к. содержит файл ""%2"", занятый для редактирования.'"),
				Строка(Источник.Ссылка),
				Строка(Выборка.Ссылка));
		КонецЕсли;
		ФайлОбъект = Выборка.Ссылка.ПолучитьОбъект();
		ФайлОбъект.Заблокировать();
		ФайлОбъект.УстановитьПометкуУдаления(Источник.ПометкаУдаления);
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаписатьДанныеФайлаВРегистрПриОбмене(Источник)
	
	Перем ДвоичныеДанныеФайла;
	
	Если Источник.ДополнительныеСвойства.Свойство("ДвоичныеДанныеФайла", ДвоичныеДанныеФайла) Тогда
		НаборЗаписей = РегистрыСведений.ПрисоединенныеФайлы.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.ПрисоединенныйФайл.Использование = Истина;
		НаборЗаписей.Отбор.ПрисоединенныйФайл.Значение = Источник.Ссылка;
		
		Запись = НаборЗаписей.Добавить();
		Запись.ПрисоединенныйФайл = Источник.Ссылка;
		Запись.ХранимыйФайл = Новый ХранилищеЗначения(ДвоичныеДанныеФайла, Новый СжатиеДанных(9));
		
		НаборЗаписей.ОбменДанными.Загрузка = Истина;
		НаборЗаписей.Записать();
		
		Источник.ДополнительныеСвойства.Удалить("ДвоичныеДанныеФайла");
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий обмена

// Проверяет, что переданный элемент данных - это объект присоединенного файла
//
Функция ЭтоЭлементПрисоединенныеФайлы(ЭлементДанных) Экспорт
	
	Подстроки = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ЭлементДанных.Метаданные().ПолноеИмя(), ".");
	Если (Подстроки[0] = "Справочник" ИЛИ Подстроки[0] = "Catalog") И Прав(Подстроки[1], 19) = "ПрисоединенныеФайлы" Тогда
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

// Используется при создании начального образа работы с файлами
//
Функция УстановитьИмяФайлаПриОтправкеДанныхФайла(ЭлементДанных, ИмяКаталогаФайлов, УникальныйИдентификатор) Экспорт
	
	НовыйПутьФайла = Неопределено;
	
	Если ЭтоЭлементПрисоединенныеФайлы(ЭлементДанных) Тогда
		НовыйПутьФайла = ИмяКаталогаФайлов + "\" + УникальныйИдентификатор + "CatalogRef_"+ЭлементДанных.Метаданные().Имя;
	КонецЕсли;
	
	Возврат НовыйПутьФайла;
	
КонецФункции

// Используется в обмене при получении данных
//
Процедура ДобавитьНаДискПриПолученииДанныхФайла(ЭлементДанных, ДвоичныеДанные, ПутьКФайлуНаТоме, СсылкаНаТом, ВремяИзменения, ИмяБезРасширения, Расширение, РазмерФайла, Зашифрован) Экспорт
	
	Если ЭтоЭлементПрисоединенныеФайлы(ЭлементДанных) Тогда
		ФайловыеФункции.ДобавитьНаДиск(ДвоичныеДанные, ПутьКФайлуНаТоме, СсылкаНаТом, ВремяИзменения, "", ИмяБезРасширения, Расширение, РазмерФайла, Зашифрован);
	КонецЕсли;
	
КонецПроцедуры

// Выполняет дополнительную обработку при отправке данных обмена.
// Помещает данные присоединенного файла из регистра во временное хранилище, адрес которого
// запоминается в реквизите ФайлХранилище.
//
Процедура ВыполнитьДополнительнуюОбработкуПриОтправкеДанных(ЭлементДанных) Экспорт
	
	Если Не ЭтоЭлементПрисоединенныеФайлы(ЭлементДанных) Тогда
		Возврат;
	КонецЕсли;
	
	АдресВоВременномХранилище = ПрисоединенныеФайлы.ПолучитьДанныеФайла(ЭлементДанных.Ссылка).СсылкаНаДвоичныеДанныеФайла;
	
	ЭлементДанных.ФайлХранилище = Новый ХранилищеЗначения(ПолучитьИзВременногоХранилища(АдресВоВременномХранилище), Новый СжатиеДанных(9));
	ЭлементДанных.ТипХраненияФайла = Перечисления.ТипыХраненияФайлов.ВИнформационнойБазе;
	ЭлементДанных.ПутьКФайлу = "";
	ЭлементДанных.Том = Справочники.ТомаХраненияФайлов.ПустаяСсылка();
	
КонецПроцедуры

// Выполняет дополнительную обработку при получении данных обмена.
// Размещает присоединенные файлы в регистре.
//
Процедура ВыполнитьДополнительнуюОбработкуПриПолученииДанных(ЭлементДанных) Экспорт
	
	Если Не ЭтоЭлементПрисоединенныеФайлы(ЭлементДанных) Тогда
		Возврат;
	КонецЕсли;
	
	Значение = ЭлементДанных.ФайлХранилище.Получить();
	Если ТипЗнч(Значение) = Тип("ДвоичныеДанные") Тогда
		ЭлементДанных.ДополнительныеСвойства.Вставить("ДвоичныеДанныеФайла", Значение);
	КонецЕсли;
	
	ЭлементДанных.ФайлХранилище = Новый ХранилищеЗначения(Неопределено);
	ЭлементДанных.Том = Справочники.ТомаХраненияФайлов.ПустаяСсылка();
	ЭлементДанных.ПутьКФайлу = "";
	ЭлементДанных.ТипХраненияФайла = Перечисления.ТипыХраненияФайлов.ВИнформационнойБазе;
	
КонецПроцедуры

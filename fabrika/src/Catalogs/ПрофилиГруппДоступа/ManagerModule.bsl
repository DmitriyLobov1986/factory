#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЙ ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Процедура Обновляет описание поставляемых профилей в
// параметрах ограничения доступа при изменении конфигурации.
// 
// Параметры:
//  ЕстьИзменения - Булево (возвращаемое значение) - если производилась запись,
//                  устанавливается Истина, иначе не изменяется.
//
Процедура ОбновитьОписаниеПоставляемыхПрофилей(ЕстьИзменения = Неопределено, ТолькоПроверка = Ложь) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ТолькоПроверка ИЛИ МонопольныйРежим() Тогда
		СнятьМонопольныйРежим = Ложь;
	Иначе
		СнятьМонопольныйРежим = Истина;
		УстановитьМонопольныйРежим(Истина);
	КонецЕсли;
	
	ПоставляемыеПрофили = ПоставляемыеПрофили();
	
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("Константа.ПараметрыОграниченияДоступа");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	
	НачатьТранзакцию();
	Попытка
		Блокировка.Заблокировать();
		
		Параметры = СтандартныеПодсистемыСервер.ПараметрыРаботыПрограммы(
			"ПараметрыОграниченияДоступа");
		
		Сохраненные = Неопределено;
		
		Если Параметры.Свойство("ПоставляемыеПрофилиГруппДоступа") Тогда
			Сохраненные = Параметры.ПоставляемыеПрофилиГруппДоступа;
			
			Если НЕ ОбщегоНазначения.ДанныеСовпадают(ПоставляемыеПрофили, Сохраненные) Тогда
				Сохраненные = Неопределено;
			КонецЕсли;
		КонецЕсли;
		
		Если Сохраненные = Неопределено Тогда
			ЕстьИзменения = Истина;
			Если ТолькоПроверка Тогда
				ЗафиксироватьТранзакцию();
				Возврат;
			КонецЕсли;
			СтандартныеПодсистемыСервер.УстановитьПараметрРаботыПрограммы(
				"ПараметрыОграниченияДоступа",
				"ПоставляемыеПрофилиГруппДоступа",
				ПоставляемыеПрофили);
		КонецЕсли;
		
		СтандартныеПодсистемыСервер.ПодтвердитьОбновлениеПараметраРаботыПрограммы(
			"ПараметрыОграниченияДоступа", "ПоставляемыеПрофилиГруппДоступа");
		
		Если НЕ ТолькоПроверка Тогда
			СтандартныеПодсистемыСервер.ДобавитьИзмененияПараметраРаботыПрограммы(
				"ПараметрыОграниченияДоступа",
				"ПоставляемыеПрофилиГруппДоступа",
				?(Сохраненные = Неопределено,
				  Новый ФиксированнаяСтруктура("ЕстьИзменения", Истина),
				  Новый ФиксированнаяСтруктура()) );
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		Если СнятьМонопольныйРежим Тогда
			УстановитьМонопольныйРежим(Ложь);
		КонецЕсли;
		ВызватьИсключение;
	КонецПопытки;
	
	Если СнятьМонопольныйРежим Тогда
		УстановитьМонопольныйРежим(Ложь);
	КонецЕсли;
	
КонецПроцедуры

// Процедура Обновляет состав предопределенных профилей в
// параметрах ограничения доступа при изменении конфигурации.
// 
// Параметры:
//  ЕстьИзменения - Булево (возвращаемое значение) - если производилась запись,
//                  устанавливается Истина, иначе не изменяется.
//
Процедура ОбновитьСоставПредопределенныхПрофилей(ЕстьИзменения = Неопределено, ТолькоПроверка = Ложь) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ТолькоПроверка ИЛИ МонопольныйРежим() Тогда
		СнятьМонопольныйРежим = Ложь;
	Иначе
		СнятьМонопольныйРежим = Истина;
		УстановитьМонопольныйРежим(Истина);
	КонецЕсли;
	
	ПредопределенныеПрофили = СтандартныеПодсистемыСервер.ИменаПредопределенныхДанных(
		"Справочник.ПрофилиГруппДоступа");
	
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("Константа.ПараметрыОграниченияДоступа");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	
	НачатьТранзакцию();
	Попытка
		Блокировка.Заблокировать();
		
		Параметры = СтандартныеПодсистемыСервер.ПараметрыРаботыПрограммы(
			"ПараметрыОграниченияДоступа");
		
		ЕстьУдаленные = Ложь;
		Сохраненные = Неопределено;
		
		Если Параметры.Свойство("ПредопределенныеПрофилиГруппДоступа") Тогда
			Сохраненные = Параметры.ПредопределенныеПрофилиГруппДоступа;
			
			Если НЕ ПредопределенныеПрофилиСовпадают(ПредопределенныеПрофили, Сохраненные, ЕстьУдаленные) Тогда
				Сохраненные = Неопределено;
			КонецЕсли;
		КонецЕсли;
		
		Если Сохраненные = Неопределено Тогда
			ЕстьИзменения = Истина;
			Если ТолькоПроверка Тогда
				ЗафиксироватьТранзакцию();
				Возврат;
			КонецЕсли;
			СтандартныеПодсистемыСервер.УстановитьПараметрРаботыПрограммы(
				"ПараметрыОграниченияДоступа",
				"ПредопределенныеПрофилиГруппДоступа",
				ПредопределенныеПрофили);
		КонецЕсли;
		
		СтандартныеПодсистемыСервер.ПодтвердитьОбновлениеПараметраРаботыПрограммы(
			"ПараметрыОграниченияДоступа",
			"ПредопределенныеПрофилиГруппДоступа");
		
		Если НЕ ТолькоПроверка Тогда
			СтандартныеПодсистемыСервер.ДобавитьИзмененияПараметраРаботыПрограммы(
				"ПараметрыОграниченияДоступа",
				"ПредопределенныеПрофилиГруппДоступа",
				?(ЕстьУдаленные,
				  Новый ФиксированнаяСтруктура("ЕстьУдаленные", Истина),
				  Новый ФиксированнаяСтруктура()) );
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		Если СнятьМонопольныйРежим Тогда
			УстановитьМонопольныйРежим(Ложь);
		КонецЕсли;
		ВызватьИсключение;
	КонецПопытки;
	
	Если СнятьМонопольныйРежим Тогда
		УстановитьМонопольныйРежим(Ложь);
	КонецЕсли;
	
КонецПроцедуры

// Процедура обновляет поставляемые профили справочника по результату изменения
// описаний поставляемых профилей, сохраненных в параметрах ограничения доступа.
//
Процедура ОбновитьПоставляемыеПрофилиПоИзменениямКонфигурации() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Параметры = УправлениеДоступомСлужебныйПовтИсп.Параметры();
	
	ПоследниеИзменения = СтандартныеПодсистемыСервер.ИзмененияПараметраРаботыПрограммы(
		Параметры, "ПоставляемыеПрофилиГруппДоступа");
		
	Если ПоследниеИзменения = Неопределено Тогда
		ТребуетсяОбновление = Истина;
	Иначе
		ТребуетсяОбновление = Ложь;
		Для каждого ЧастьИзменений Из ПоследниеИзменения Цикл
			
			Если ТипЗнч(ЧастьИзменений) = Тип("ФиксированнаяСтруктура")
			   И ЧастьИзменений.Свойство("ЕстьИзменения")
			   И ТипЗнч(ЧастьИзменений.ЕстьИзменения) = Тип("Булево") Тогда
				
				Если ЧастьИзменений.ЕстьИзменения Тогда
					ТребуетсяОбновление = Истина;
					Прервать;
				КонецЕсли;
			Иначе
				ТребуетсяОбновление = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Если ТребуетсяОбновление Тогда
		ОбновитьПоставляемыеПрофили();
	КонецЕсли;
	
КонецПроцедуры

// Обновляет поставляемые профили, и при необходимости обновляет группы доступа этих профилей.
// Создаются не найденные поставляемые профили групп доступа.
//
// Особенности обновления настраиваются в процедуре ЗаполнитьПоставляемыеПрофилиГруппДоступа
// общего модуля УправлениеДоступомПереопределяемый (см. комментарий к процедуре).
//
// Параметры:
//  ЕстьИзменения - Булево (возвращаемое значение) - если производилась запись,
//                  устанавливается Истина, иначе не изменяется.
//
Процедура ОбновитьПоставляемыеПрофили(ЕстьИзменения = Неопределено) Экспорт
	
	ПоставляемыеПрофили = УправлениеДоступомСлужебныйПовтИсп.Параметры(
		).ПоставляемыеПрофилиГруппДоступа;
	
	ОписанияПрофилей    = ПоставляемыеПрофили.ОписанияПрофилей;
	ПараметрыОбновления = ПоставляемыеПрофили.ПараметрыОбновления;
	
	ОбновленныеПрофили       = Новый Массив;
	ОбновленныеГруппыДоступа = Новый Массив;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ПрофилиГруппДоступа.ПоставляемыйПрофильИзменен,
	|	ПрофилиГруппДоступа.ИдентификаторПоставляемыхДанных,
	|	ПрофилиГруппДоступа.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ПрофилиГруппДоступа КАК ПрофилиГруппДоступа");
	ТекущиеПрофили = Запрос.Выполнить().Выгрузить();
	
	Для каждого ОписаниеПрофиля Из ОписанияПрофилей Цикл
		СвойстваПрофиля = ОписаниеПрофиля.Значение;
		
		СтрокаТекущегоПрофиля = ТекущиеПрофили.Найти(
			Новый УникальныйИдентификатор(СвойстваПрофиля.Идентификатор),
			"ИдентификаторПоставляемыхДанных");
		
		ПрофильОбновлен = Ложь;
		
		Если СтрокаТекущегоПрофиля = Неопределено Тогда
			// Создание нового поставляемого профиля.
			Если ОбновитьПрофильГруппДоступа(СвойстваПрофиля) Тогда
				ЕстьИзменения = Истина;
			КонецЕсли;
			Профиль = ПоставляемыйПрофильПоИдентификатору(СвойстваПрофиля.Идентификатор);
			
		Иначе
			Профиль = СтрокаТекущегоПрофиля.Ссылка;
			Если НЕ СтрокаТекущегоПрофиля.ПоставляемыйПрофильИзменен
			 ИЛИ ПараметрыОбновления.ОбновлятьИзмененныеПрофили Тогда
				// Обновление поставляемого профиля.
				ПрофильОбновлен = ОбновитьПрофильГруппДоступа(СвойстваПрофиля, Истина);
			КонецЕсли;
		КонецЕсли;
		
		Если ПараметрыОбновления.ОбновлятьГруппыДоступа Тогда
			ГруппыДоступаПрофиляОбновлены = Справочники.ГруппыДоступа.ОбновитьГруппыДоступаПрофиля(
				Профиль, ПараметрыОбновления.ОбновлятьГруппыДоступаСУстаревшимиНастройками);
			
			ПрофильОбновлен = ПрофильОбновлен ИЛИ ГруппыДоступаПрофиляОбновлены;
		КонецЕсли;
		
		Если ПрофильОбновлен Тогда
			ЕстьИзменения = Истина;
			ОбновленныеПрофили.Добавить(Профиль);
		КонецЕсли;
	КонецЦикла;
	
	// Обновление ролей пользователей.
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СоставыГруппПользователей.Пользователь
	|ИЗ
	|	РегистрСведений.СоставыГруппПользователей КАК СоставыГруппПользователей
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ГруппыДоступа.Пользователи КАК ГруппыДоступаПользователи
	|		ПО СоставыГруппПользователей.ГруппаПользователей = ГруппыДоступаПользователи.Пользователь
	|			И (ГруппыДоступаПользователи.Ссылка.Профиль В (&Профили))";
	Запрос.УстановитьПараметр("Профили", ОбновленныеПрофили);
	ПользователиДляОбновления = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Пользователь");
	
	УправлениеДоступом.ОбновитьРолиПользователей(ПользователиДляОбновления);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Возвращает строку уникального идентификатора
// поставляемого и предопределенного профиля Администратор.
//
Функция ИдентификаторПрофиляАдминистратор() Экспорт
	
	Возврат "6c4b0307-43a4-4141-9c35-3dd7e9586d41";
	
КонецФункции

// Возвращает ссылку на поставляемый профиль по идентификатору.
//
// Параметры:
//  Идентификатор - Строка - имя или уникальный идентификатор поставляемого профиля.
//
Функция ПоставляемыйПрофильПоИдентификатору(Идентификатор) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ПоставляемыеПрофили = УправлениеДоступомСлужебныйПовтИсп.Параметры(
		).ПоставляемыеПрофилиГруппДоступа;
	
	СвойстваПрофиля = ПоставляемыеПрофили.ОписанияПрофилей.Получить(Идентификатор);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ИдентификаторПоставляемыхДанных",
		Новый УникальныйИдентификатор(СвойстваПрофиля.Идентификатор));
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПрофилиГруппДоступа.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ПрофилиГруппДоступа КАК ПрофилиГруппДоступа
	|ГДЕ
	|	ПрофилиГруппДоступа.ИдентификаторПоставляемыхДанных = &ИдентификаторПоставляемыхДанных";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Ссылка;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

// Возвращает строку уникального идентификатора
// данных поставляемого профиля.
//
Функция ИдентификаторПоставляемогоПрофиля(Профиль) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Профиль);
	
	Запрос.УстановитьПараметр("ПустойУникальныйИдентификатор",
		Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000"));
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПрофилиГруппДоступа.ИдентификаторПоставляемыхДанных
	|ИЗ
	|	Справочник.ПрофилиГруппДоступа КАК ПрофилиГруппДоступа
	|ГДЕ
	|	ПрофилиГруппДоступа.Ссылка = &Ссылка
	|	И ПрофилиГруппДоступа.ИдентификаторПоставляемыхДанных <> &ПустойУникальныйИдентификатор";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		
		ПоставляемыеПрофили = УправлениеДоступомСлужебныйПовтИсп.Параметры(
			).ПоставляемыеПрофилиГруппДоступа;
		
		СвойстваПрофиля = ПоставляемыеПрофили.ОписанияПрофилей.Получить(
			Строка(Выборка.ИдентификаторПоставляемыхДанных));
		
		Возврат Строка(Выборка.ИдентификаторПоставляемыхДанных);
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

// Проверяет изменен ли поставляемый профиль по сравнению с описанием из процедуры
// УправлениеДоступомПереопределяемый.ЗаполнитьПоставляемыеПрофилиГруппДоступа().
//
// Параметры:
//  Профиль      - СправочникСсылка.ПрофилиГруппДоступа
//                     (возвращается реквизит ПоставляемыйПрофильИзменен),
//               - СправочникОбъект.ПрофилиГруппДоступа
//                     (возвращается результат сравнения заполнения объекта
//                      с описанием в переопределяемом общем модуле).
//
// Возвращаемое значение:
//  Булево.
//
Функция ПоставляемыйПрофильИзменен(Профиль) Экспорт
	
	Если ТипЗнч(Профиль) = Тип("СправочникСсылка.ПрофилиГруппДоступа") Тогда
		Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Профиль, "ПоставляемыйПрофильИзменен");
	КонецЕсли;
	
	СвойстваПрофиля = УправлениеДоступомСлужебныйПовтИсп.Параметры(
		).ПоставляемыеПрофилиГруппДоступа.ОписанияПрофилей.Получить(
			Строка(Профиль.ИдентификаторПоставляемыхДанных));
	
	Если СвойстваПрофиля = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
		
	ОписаниеРолейПрофиля = ОписаниеРолейПрофиля(СвойстваПрофиля);
	
	Если ВРег(Профиль.Наименование) <> ВРег(СвойстваПрофиля.Наименование) Тогда
		Возврат Истина;
	КонецЕсли;
	
	Если Профиль.Роли.Количество()            <> ОписаниеРолейПрофиля.Количество()
	 ИЛИ Профиль.ВидыДоступа.Количество()     <> СвойстваПрофиля.ВидыДоступа.Количество()
	 ИЛИ Профиль.ЗначенияДоступа.Количество() <> СвойстваПрофиля.ЗначенияДоступа.Количество() Тогда
		Возврат Истина;
	КонецЕсли;
	
	Для каждого Роль Из ОписаниеРолейПрофиля Цикл
		МетаданныеРоли = Метаданные.Роли.Найти(Роль);
		Если МетаданныеРоли = Неопределено Тогда
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'При проверке поставляемого профиля ""%1""
				           |роль ""%2"" не найдена в метаданных.'"),
				СвойстваПрофиля.Наименование,
				Роль);
		КонецЕсли;
		ИдентификаторРоли = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(МетаданныеРоли);
		Если Профиль.Роли.НайтиСтроки(Новый Структура("Роль", ИдентификаторРоли)).Количество() = 0 Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;
	
	Для каждого ОписаниеВидаДоступа Из СвойстваПрофиля.ВидыДоступа Цикл
		Отбор = Новый Структура;
		Отбор.Вставить("ВидДоступа", ПланыВидовХарактеристик.ВидыДоступа[ОписаниеВидаДоступа.Ключ]);
		Отбор.Вставить("Предустановленный", ОписаниеВидаДоступа.Значение = "Предустановленный");
		Отбор.Вставить("ДоступРазрешен",    ОписаниеВидаДоступа.Значение = "ВначалеВсеРазрешены");
		Если Профиль.ВидыДоступа.НайтиСтроки(Отбор).Количество() = 0 Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;
	
	Для каждого ОписаниеЗначенияДоступа Из СвойстваПрофиля.ЗначенияДоступа Цикл
		Отбор = Новый Структура;
		Отбор.Вставить("ВидДоступа", ПланыВидовХарактеристик.ВидыДоступа[ОписаниеЗначенияДоступа.ВидДоступа]);
		Запрос = Новый Запрос(СтрЗаменить("Выбрать Значение(%1) КАК Значение", "%1", ОписаниеЗначенияДоступа.ЗначениеДоступа));
		Отбор.Вставить("ЗначениеДоступа", Запрос.Выполнить().Выгрузить()[0].Значение);
		Если Профиль.ЗначенияДоступа.НайтиСтроки(Отбор).Количество() = 0 Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

// Определяет наличие начального заполнения для профиля групп доступа в переопределяемом модуле.
//
// Параметры:
//  Профиль      - СправочникСсылка.ПрофилиГруппДоступа.
//  
// Возвращаемое значение:
//  Булево.
//
Функция ЕстьНачальноеЗаполнениеПрофиля(Знач Профиль) Экспорт
	
	ИдентификаторПоставляемыхДанных = Строка(ОбщегоНазначения.ПолучитьЗначениеРеквизита(
		Профиль, "ИдентификаторПоставляемыхДанных"));
	
	СвойстваПрофиля = УправлениеДоступомСлужебныйПовтИсп.Параметры(
		).ПоставляемыеПрофилиГруппДоступа.ОписанияПрофилей.Получить(ИдентификаторПоставляемыхДанных);
	
	Возврат СвойстваПрофиля <> Неопределено;
	
КонецФункции

// Определяет запрет изменения поставляемого профиля.
// Не поставляемый профиль не может иметь запрета изменения.
//
// Параметры:
//  Профиль      - СправочникОбъект.ПрофилиГруппДоступа,
//                 ДанныеФормыСтруктура созданные по объекту.
//  
// Возвращаемое значение:
//  Булево.
//
Функция ЗапретИзмененияПрофиля(Знач Профиль) Экспорт
	
	Если Профиль.ИдентификаторПоставляемыхДанных =
			Новый УникальныйИдентификатор(ИдентификаторПрофиляАдминистратор()) Тогда
		// Изменение профиля Администратор всегда запрещено.
		Возврат Истина;
	КонецЕсли;
	
	ПоставляемыеПрофили = УправлениеДоступомСлужебныйПовтИсп.Параметры(
		).ПоставляемыеПрофилиГруппДоступа;
	
	СвойстваПрофиля = ПоставляемыеПрофили.ОписанияПрофилей.Получить(
		Строка(Профиль.ИдентификаторПоставляемыхДанных));
	
	Возврат СвойстваПрофиля <> Неопределено
	      И ПоставляемыеПрофили.ПараметрыОбновления.ЗапретитьИзменениеПрофилей;
	
КонецФункции

// Возвращает описание назначения поставляемого профиля.
//
// Параметры:
//  Профиль - СправочникСсылка.ПрофилиГруппДоступа.
//
// Возвращаемое значение:
//  Строка.
//
Функция ОписаниеПоставляемогоПрофиля(Профиль) Экспорт
	
	ИдентификаторПоставляемыхДанных = Строка(ОбщегоНазначения.ПолучитьЗначениеРеквизита(
		Профиль, "ИдентификаторПоставляемыхДанных"));
	
	СвойстваПрофиля = УправлениеДоступомСлужебныйПовтИсп.Параметры(
		).ПоставляемыеПрофилиГруппДоступа.ОписанияПрофилей.Получить(ИдентификаторПоставляемыхДанных);
	
	Текст = "";
	Если СвойстваПрофиля <> Неопределено Тогда
		Текст = СвойстваПрофиля.Описание;
	КонецЕсли;
	
	Возврат Текст;
	
КонецФункции

// Создает поставляемый профиль в справочнике ПрофилиГруппДоступа, свойственный
// прикладному решению и позволяет перезаполнить ранее созданный поставляемый профиль
// по его поставляемому описанию.
//  Поиск начального заполнения осуществляется по строке уникального идентификатора профиля.
//
// Параметры:
//  Профиль      - СправочникСсылка.ПрофилиГруппДоступа.
//                 Если для указанного профиля описание начального заполнения найдено,
//                 содержимое профиля полностью замещается.
//
// ОбновитьГруппыДоступа - Булево, если Истина, виды доступа групп доступа профиля будут обновлены.
//
Процедура ЗаполнитьПоставляемыйПрофиль(Знач Профиль, Знач ОбновитьГруппыДоступа) Экспорт
	
	ИдентификаторПоставляемыхДанных = Строка(ОбщегоНазначения.ПолучитьЗначениеРеквизита(
		Профиль, "ИдентификаторПоставляемыхДанных"));
	
	СвойстваПрофиля = УправлениеДоступомСлужебныйПовтИсп.Параметры(
		).ПоставляемыеПрофилиГруппДоступа.ОписанияПрофилей.Получить(ИдентификаторПоставляемыхДанных);
	
	Если СвойстваПрофиля <> Неопределено Тогда
		
		ОбновитьПрофильГруппДоступа(СвойстваПрофиля);
		
		Если ОбновитьГруппыДоступа Тогда
			Справочники.ГруппыДоступа.ОбновитьГруппыДоступаПрофиля(Профиль, Истина);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Обработчики обновления информационной базы.

// Заполняет идентификаторы поставляемых данных по совпадению с идентификатором ссылки.
Процедура ЗаполнитьИдентификаторыПоставляемыхДанных() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ПоставляемыеПрофили = УправлениеДоступомСлужебныйПовтИсп.Параметры(
		).ПоставляемыеПрофилиГруппДоступа;
	
	СсылкиПоставляемыхПрофилей = Новый Массив;
	
	Для каждого ОписаниеПрофиля Из ПоставляемыеПрофили.ОписанияПрофилей Цикл
		СсылкиПоставляемыхПрофилей.Добавить(
			Справочники.ПрофилиГруппДоступа.ПолучитьСсылку(
				Новый УникальныйИдентификатор(ОписаниеПрофиля.Значение.Идентификатор)));
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ПустойУникальныйИдентификатор",
		Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000"));
	
	Запрос.УстановитьПараметр("СсылкиПоставляемыхПрофилей", СсылкиПоставляемыхПрофилей);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПрофилиГруппДоступа.Ссылка
	|ИЗ
	|	Справочник.ПрофилиГруппДоступа КАК ПрофилиГруппДоступа
	|ГДЕ
	|	ПрофилиГруппДоступа.ИдентификаторПоставляемыхДанных = &ПустойУникальныйИдентификатор
	|	И ПрофилиГруппДоступа.Ссылка В (&СсылкиПоставляемыхПрофилей)";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		ПрофильОбъект = Выборка.Ссылка.ПолучитьОбъект();
		ПрофильОбъект.ИдентификаторПоставляемыхДанных = Выборка.Ссылка.УникальныйИдентификатор();
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(ПрофильОбъект);
	КонецЦикла;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Вспомогательные процедуры и функции

Функция ПоставляемыеПрофили()
	
	ПараметрыОбновления = Новый Структура;
	// Свойства обновления поставляемых профилей.
	ПараметрыОбновления.Вставить("ОбновлятьИзмененныеПрофили", Истина);
	ПараметрыОбновления.Вставить("ЗапретитьИзменениеПрофилей", Истина);
	// Свойства обновления групп доступа поставляемых профилей.
	ПараметрыОбновления.Вставить("ОбновлятьГруппыДоступа",                        Истина);
	ПараметрыОбновления.Вставить("ОбновлятьГруппыДоступаСУстаревшимиНастройками", Ложь);
	
	ОписанияПрофилей = Новый Массив;
	
	ОбработчикиСобытия = ОбщегоНазначения.ОбработчикиСлужебногоСобытия(
		"СтандартныеПодсистемы.УправлениеДоступом\ПриЗаполненииПоставляемыхПрофилейГруппДоступа");
	Для Каждого Обработчик Из ОбработчикиСобытия Цикл
		Обработчик.Модуль.ПриЗаполненииПоставляемыхПрофилейГруппДоступа(ОписанияПрофилей, ПараметрыОбновления);
	КонецЦикла;
	
	УправлениеДоступомПереопределяемый.ЗаполнитьПоставляемыеПрофилиГруппДоступа(
		ОписанияПрофилей, ПараметрыОбновления);
	
	ЗаголовокОшибки =
		НСтр("ru = 'Ошибка в процедуре ЗаполнитьПоставляемыеПрофилиГруппДоступа
		           |модуля УправлениеДоступомПереопределяемый.
		           |
		           |'");
	
	Если ПараметрыОбновления.ЗапретитьИзменениеПрофилей
	   И НЕ ПараметрыОбновления.ОбновлятьИзмененныеПрофили Тогда
		
		ВызватьИсключение ЗаголовокОшибки +
			НСтр("ru = 'Когда в переменной ПараметрыОбновления свойство
			           |ОбновлятьИзмененныеПрофили установлено Ложь,
			           |тогда свойство ЗапретитьИзменениеПрофилей тоже
			           |должно быть установлено Ложь.'");
	КонецЕсли;
	
	// Описание для заполнения предопределенного профиля "Администратор".
	ОписаниеПрофиляАдминистратор = УправлениеДоступом.НовоеОписаниеПрофиляГруппДоступа();
	
	ОписаниеПрофиляАдминистратор.Имя           = "Администратор";
	ОписаниеПрофиляАдминистратор.Идентификатор = ИдентификаторПрофиляАдминистратор();
	ОписаниеПрофиляАдминистратор.Наименование  = НСтр("ru = 'Администратор'");
	ОписаниеПрофиляАдминистратор.Роли.Добавить("ПолныеПрава");
	
	ОписаниеПрофиляАдминистратор.Описание =
		НСтр("ru = 'Предназначен для:
		           |- настройки параметров работы и обслуживания информационной системы,
		           |- настройки прав доступа других пользователей,
		           |- удаления помеченных объектов,
		           |- в редких случаях для внесения изменений в конфигурацию.
		           |
		           |Рекомендуется не использовать для ""обычной"" работы в информационной системе.
		           |'");
	ОписанияПрофилей.Добавить(ОписаниеПрофиляАдминистратор);
	
	ВсеРоли = ПользователиСлужебный.ВсеРоли().Соответствие;
	// Преобразование описаний в соответствие идентификаторов и
	// свойств для хранения и быстрой обработки.
	СвойстваПрофилей = Новый Соответствие;
	Для каждого ОписаниеПрофиля Из ОписанияПрофилей Цикл
		// Проверка наличия ролей в метаданных.
		Для каждого Роль Из ОписаниеПрофиля.Роли Цикл
			Если ВсеРоли.Получить(Роль) = Неопределено Тогда
				ВызватьИсключение ЗаголовокОшибки + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'В описании профиля ""%1""
					           |роль ""%2"" не найдена в метаданных.'"),
					ОписаниеПрофиля.Наименование,
					Роль);
			КонецЕсли;
		КонецЦикла;
		Если СвойстваПрофилей.Получить(ОписаниеПрофиля.Идентификатор) <> Неопределено Тогда
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Профиль с идентификатором ""%1"" уже существует.'"),
				ОписаниеПрофиля.Идентификатор);
		КонецЕсли;
		СвойстваПрофилей.Вставить(ОписаниеПрофиля.Идентификатор, ОписаниеПрофиля);
		Если ЗначениеЗаполнено(ОписаниеПрофиля.Имя) Тогда
			Если СвойстваПрофилей.Получить(ОписаниеПрофиля.Имя) <> Неопределено Тогда
				ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Профиль с именем ""%1"" уже существует.'"),
					ОписаниеПрофиля.Имя);
			КонецЕсли;
			СвойстваПрофилей.Вставить(ОписаниеПрофиля.Имя, ОписаниеПрофиля);
		КонецЕсли;
		// Преобразование СпискаЗначений к Соответствию для фиксации.
		ВидыДоступа = Новый Соответствие;
		Для каждого ЭлементСписка Из ОписаниеПрофиля.ВидыДоступа Цикл
			ВидыДоступа.Вставить(ЭлементСписка.Значение, ЭлементСписка.Представление);
		КонецЦикла;
		ОписаниеПрофиля.ВидыДоступа = ВидыДоступа;
		
		ЗначенияДоступа = Новый Массив;
		Для каждого ЭлементСписка Из ОписаниеПрофиля.ЗначенияДоступа Цикл
			ОписаниеЗначенияДоступа = Новый Структура;
			ОписаниеЗначенияДоступа.Вставить("ВидДоступа",      ЭлементСписка.Значение);
			ОписаниеЗначенияДоступа.Вставить("ЗначениеДоступа", ЭлементСписка.Представление);
			ЗначенияДоступа.Добавить(ОписаниеЗначенияДоступа);
		КонецЦикла;
		ОписаниеПрофиля.ЗначенияДоступа = ЗначенияДоступа;
	КонецЦикла;
	
	Возврат ОбщегоНазначения.ФиксированныеДанные(Новый Структура(
		"ПараметрыОбновления, ОписанияПрофилей", ПараметрыОбновления, СвойстваПрофилей));
	
КонецФункции

Функция ПредопределенныеПрофилиСовпадают(НовыеПрофили, СтарыеПрофили, ЕстьУдаленные)
	
	ПредопределенныеПрофилиСовпадают =
		НовыеПрофили.Количество() = СтарыеПрофили.Количество();
	
	Для каждого Профиль Из СтарыеПрофили Цикл
		Если НовыеПрофили.Найти(Профиль) = Неопределено Тогда
			ПредопределенныеПрофилиСовпадают = Ложь;
			ЕстьУдаленные = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Возврат ПредопределенныеПрофилиСовпадают;
	
КонецФункции

// Замещает имеющийся или создает новый поставляемый профиль групп доступа по его описанию.
//
// Параметры:
//  СвойстваПрофиля - ФиксированнаяСтруктура - свойства профиля, как в структуре возвращаемой
//                    функцией НовоеОписаниеПрофиляГруппДоступа общего модуля УправлениеДоступом.
// 
// Возвращаемое значение:
//  Булево. Истина - профиль изменен.
//
Функция ОбновитьПрофильГруппДоступа(СвойстваПрофиля, НеОбновлятьРолиПользователей = Ложь)
	
	ПрофильИзменен = Ложь;
	
	ПрофильСсылка = ПоставляемыйПрофильПоИдентификатору(СвойстваПрофиля.Идентификатор);
	Если ПрофильСсылка = Неопределено Тогда
		
		Если ЗначениеЗаполнено(СвойстваПрофиля.Имя) Тогда
			Запрос = Новый Запрос;
			Запрос.Текст =
			"ВЫБРАТЬ
			|	ПрофилиГруппДоступа.Ссылка КАК Ссылка,
			|	НЕОПРЕДЕЛЕНО КАК ИмяПредопределенныхДанных
			|ИЗ
			|	Справочник.ПрофилиГруппДоступа КАК ПрофилиГруппДоступа
			|ГДЕ
			|	ПрофилиГруппДоступа.Предопределенный = ИСТИНА";
			Если СтандартныеПодсистемыПовтИсп.ЭтоПлатформа83БезРежимаСовместимости() Тогда
				Запрос.Текст = СтрЗаменить(Запрос.Текст, "НЕОПРЕДЕЛЕНО", "ПрофилиГруппДоступа.ИмяПредопределенныхДанных");
			КонецЕсли;
			Выборка = Запрос.Выполнить().Выбрать();
			
			Пока Выборка.Следующий() Цикл
				Если СтандартныеПодсистемыПовтИсп.ЭтоПлатформа83БезРежимаСовместимости() Тогда
					ИмяПредопределенного = Выборка.ИмяПредопределенныхДанных;
				Иначе
					ИмяПредопределенного = ПолучитьИмяПредопределенного(Выборка.Ссылка);
				КонецЕсли;
				Если ВРег(СвойстваПрофиля.Имя) = ВРег(ИмяПредопределенного) Тогда
					ПрофильСсылка = Выборка.Ссылка;
					Прервать;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		
		Если ПрофильСсылка = Неопределено Тогда
			// Поставляемый профиль не найден, нужно создать новый.
			ПрофильОбъект = Справочники.ПрофилиГруппДоступа.СоздатьЭлемент();
		Иначе
			// Поставляемый профиль не связан с предопределенным элементом.
			ПрофильОбъект = ПрофильСсылка.ПолучитьОбъект();
		КонецЕсли;
		
		ПрофильОбъект.ИдентификаторПоставляемыхДанных =
			Новый УникальныйИдентификатор(СвойстваПрофиля.Идентификатор);
		
		ПрофильИзменен = Истина;
	Иначе
		ПрофильОбъект = ПрофильСсылка.ПолучитьОбъект();
		ПрофильИзменен = ПоставляемыйПрофильИзменен(ПрофильОбъект);
	КонецЕсли;
	
	Если ПрофильИзменен Тогда
		ЗаблокироватьДанныеДляРедактирования(ПрофильОбъект.Ссылка, ПрофильОбъект.ВерсияДанных);
		
		ПрофильОбъект.Наименование = СвойстваПрофиля.Наименование;
		
		ПрофильОбъект.Роли.Очистить();
		Для каждого Роль Из ОписаниеРолейПрофиля(СвойстваПрофиля) Цикл
			МетаданныеРоли = Метаданные.Роли.Найти(Роль);
			Если МетаданныеРоли = Неопределено Тогда
				ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'При обновлении поставляемого профиля ""%1""
					           |роль ""%2"" не найдена в метаданных.'"),
					СвойстваПрофиля.Наименование,
					Роль);
			КонецЕсли;
			ПрофильОбъект.Роли.Добавить().Роль =
				ОбщегоНазначения.ИдентификаторОбъектаМетаданных(МетаданныеРоли)
		КонецЦикла;
		
		ПрофильОбъект.ВидыДоступа.Очистить();
		Для каждого ОписаниеВидаДоступа Из СвойстваПрофиля.ВидыДоступа Цикл
			Строка = ПрофильОбъект.ВидыДоступа.Добавить();
			Строка.ВидДоступа        = ПланыВидовХарактеристик.ВидыДоступа[ОписаниеВидаДоступа.Ключ];
			Строка.Предустановленный = ОписаниеВидаДоступа.Значение = "Предустановленный";
			Строка.ДоступРазрешен    = ОписаниеВидаДоступа.Значение = "ВначалеВсеРазрешены";
		КонецЦикла;
		
		ПрофильОбъект.ЗначенияДоступа.Очистить();
		Для каждого ОписаниеЗначенияДоступа Из СвойстваПрофиля.ЗначенияДоступа Цикл
			СтрокаЗначения = ПрофильОбъект.ЗначенияДоступа.Добавить();
			СтрокаЗначения.ВидДоступа = ПланыВидовХарактеристик.ВидыДоступа[ОписаниеЗначенияДоступа.ВидДоступа];
			Запрос = Новый Запрос(СтрЗаменить("Выбрать Значение(%1) КАК Значение", "%1", ОписаниеЗначенияДоступа.ЗначениеДоступа));
			СтрокаЗначения.ЗначениеДоступа = Запрос.Выполнить().Выгрузить()[0].Значение;
		КонецЦикла;
		
		Если НеОбновлятьРолиПользователей Тогда
			ПрофильОбъект.ДополнительныеСвойства.Вставить("НеОбновлятьРолиПользователей");
		КонецЕсли;
		ПрофильОбъект.Записать();
		РазблокироватьДанныеДляРедактирования(ПрофильОбъект.Ссылка);
	КонецЕсли;
	
	Возврат ПрофильИзменен;
	
КонецФункции

Функция ОписаниеРолейПрофиля(ОписаниеПрофиля)
	
	ОписаниеРолейПрофиля = Новый Массив;
	РазделениеВключено = ОбщегоНазначенияПовтИсп.РазделениеВключено();
	
	Если РазделениеВключено Тогда
		// Удаление из описаний профилей ролей, содержащих права,
		// недоступные разделенным пользователям.
		НедоступныеРоли = ПользователиСлужебный.НедоступныеРолиПоТипуПользователей(
			Перечисления.ТипыПользователей.ПользовательОбластиДанных);
		
	ИначеЕсли ОписаниеПрофиля.Идентификатор = ИдентификаторПрофиляАдминистратор() Тогда
		
		ИмяРолиАдминистратораСистемы = Пользователи.РольАдминистратораСистемы().Имя;
		
		Если ОписаниеРолейПрофиля.Найти(ИмяРолиАдминистратораСистемы) = Неопределено Тогда
			ОписаниеРолейПрофиля.Добавить(ИмяРолиАдминистратораСистемы);
		КонецЕсли;
	КонецЕсли;
	
	Для каждого Роль Из ОписаниеПрофиля.Роли Цикл
		Если РазделениеВключено Тогда
			Если НедоступныеРоли.Получить(Роль) <> Неопределено Тогда
				Продолжить;
			КонецЕсли;
		КонецЕсли;
		ОписаниеРолейПрофиля.Добавить(Роль);
	КонецЦикла;
	
	Возврат ОписаниеРолейПрофиля;
	
КонецФункции

#КонецЕсли

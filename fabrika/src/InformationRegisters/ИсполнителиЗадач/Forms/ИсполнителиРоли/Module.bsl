////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Исполнители, 
		"РольИсполнителя", Параметры.РольИсполнителя, ВидСравненияКомпоновкиДанных.Равно);
	СвойстваРоли = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Параметры.РольИсполнителя, "ИспользуетсяСОбъектамиАдресации,ТипыДополнительногоОбъектаАдресации,ТипыОсновногоОбъектаАдресации");
	Если СвойстваРоли.ИспользуетсяСОбъектамиАдресации Тогда
		ПолеГруппировки = Исполнители.Группировка.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
		ПолеГруппировки.Поле = Новый ПолеКомпоновкиДанных("ОсновнойОбъектАдресации");
		ПолеГруппировки.Использование = Истина;
		Если Не СвойстваРоли.ТипыДополнительногоОбъектаАдресации.Пустая() Тогда
			ПолеГруппировки = Исполнители.Группировка.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
			ПолеГруппировки.Поле = Новый ПолеКомпоновкиДанных("ДополнительныйОбъектАдресации");
			ПолеГруппировки.Использование = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	КлючВарианта = Параметры.КлючВарианта;
	
	Если НЕ ЗначениеЗаполнено(КлючВарианта) Тогда
		Параметры.КлючВарианта = "1ec6cb34-ab2a-4d6d-8e6c-60bbc18b29ae";
	КонецЕсли;
	
	
	Отборы = Новый Структура;
	
	Попытка
		Отборы.Вставить("Организация", Параметры.Организация);
	Исключение
	КонецПопытки;
	
	Попытка
		Отборы.Вставить("Контрагент", Параметры.Контрагент);
	Исключение
	КонецПопытки;
	
	Попытка
		Отборы.Вставить("Период", Параметры.Период);
	Исключение
	КонецПопытки;
			
	
КонецПроцедуры


&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
		
    
    //
	Отчет.КомпоновщикНастроек.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("СписокДоговоров", ДоговорыКомиссии);
    
	
КонецПроцедуры


&НаСервере
Процедура ПриОбновленииСоставаПользовательскихНастроекНаСервере(СтандартнаяОбработка)
    
    Для Каждого Отбор Из Отборы Цикл
        
        НастройкиКомпоновки = Отчет.КомпоновщикНастроек.Настройки;
        
        Если Отбор.Ключ = "Период" Тогда
            ПараметрПериод = НастройкиКомпоновки.ПараметрыДанных.Элементы.Найти(Отбор.Ключ);
            ПараметрПериод.ИдентификаторПользовательскойНастройки = Отбор.Ключ;
        Иначе
            НастройкиКомпоновки.Отбор.Элементы.Очистить();
            //
            ОтборОрганизации = НастройкиКомпоновки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
            ОтборОрганизации.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(Отбор.Ключ);
            ОтборОрганизации.ИдентификаторПользовательскойНастройки = Отбор.Ключ;
        КонецЕсли;
        
        //=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>
        
        ПользовательскиеНастройки = Отчет.КомпоновщикНастроек.ПользовательскиеНастройки; 
        
        ОтборОрганизации = ПользовательскиеНастройки.Элементы.Найти(Отбор.Ключ);
        ПравоеЗначение = ?(Отбор.Ключ = "Период", "Значение", "ПравоеЗначение");
        
        Если ОтборОрганизации <> Неопределено Тогда
            ОтборОрганизации[ПравоеЗначение] = Отбор.Значение;
            ОтборОрганизации.Использование = Истина;
        КонецЕсли;
        
    КонецЦикла;
    

КонецПроцедуры



&НаКлиенте
Процедура ПриОткрытии(Отказ)
	СкомпоноватьРезультат();
	Результат.ПоказатьУровеньГруппировокСтрок(4);
КонецПроцедуры

//=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>


&НаКлиенте
Процедура РезультатОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОповеститьОВыборе(ОбщийМодульСервер.ПолучениеРасшифровкиВСтруктуру(Расшифровка, ДанныеРасшифровки, Новый Структура));
	
КонецПроцедуры















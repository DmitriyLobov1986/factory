
//////////////////////////////////////ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ//////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	
	Если Параметры.Владелец = "ТаможняРассчёты" Тогда
		Владелец = "ТаможняРассчёты"; 
		ГТДкОплате.Параметры.УстановитьЗначениеПараметра("Документ", Параметры.Документ);
		ГТДкОплате.Параметры.УстановитьЗначениеПараметра("ГтдДокумента", Параметры.Документ.ПодборГтд.ВыгрузитьКолонку("ГТД"));
		ГТДкОплате.Параметры.УстановитьЗначениеПараметра("Организация", Параметры.Организация);
		ГТДкОплате.Параметры.УстановитьЗначениеПараметра("Контрагент", Параметры.Контрагент);
		ГТДкОплате.Параметры.УстановитьЗначениеПараметра("ВалютаОплаты", Параметры.ВалютаОплаты);
		ГТДкОплате.Параметры.УстановитьЗначениеПараметра("ВалютаРассчёта", Параметры.ДоговорКонтрагента.Валюта);
		ГТДкОплате.Параметры.УстановитьЗначениеПараметра("ДатаДокумента", Параметры.ДатаДокумента);
		ГТДкОплате.Параметры.УстановитьЗначениеПараметра("ВариантРаспределенияПлатежа", Параметры.ВариантРаспределенияПлатежа);
		//
		Если ЗначениеЗаполнено(Параметры.ДатаСреза) Тогда
			ГТДкОплате.Параметры.УстановитьЗначениеПараметра("ДатаСреза", КонецДня(Параметры.ДатаСреза));
		КонецЕсли;	
		//
	Иначе
		ГТДкОплате.Параметры.УстановитьЗначениеПараметра("Документ", Параметры.Документ);
		//
		ГтдДокумента = Новый СписокЗначений;
		ГтдДокумента.Добавить(Параметры.Документ.ГТД);
		//
		ГТДкОплате.Параметры.УстановитьЗначениеПараметра("ГтдДокумента", ГтдДокумента);
		ГТДкОплате.Параметры.УстановитьЗначениеПараметра("ДатаСреза", Параметры.ДатаСреза);
		ГТДкОплате.Параметры.УстановитьЗначениеПараметра("Организация", Справочники.Организации.ПустаяСсылка());
		ГТДкОплате.Параметры.УстановитьЗначениеПараметра("Контрагент", Справочники.Контрагенты.ПустаяСсылка());
		ГТДкОплате.Параметры.УстановитьЗначениеПараметра("ВалютаОплаты", Справочники.Валюты.НайтиПоКоду("840"));
		ГТДкОплате.Параметры.УстановитьЗначениеПараметра("ВалютаРассчёта", Справочники.Валюты.НайтиПоКоду("840"));
		ГТДкОплате.Параметры.УстановитьЗначениеПараметра("ДатаДокумента", Параметры.ДатаДокумента);
		ГТДкОплате.Параметры.УстановитьЗначениеПараметра("ВариантРаспределенияПлатежа", Перечисления.ВариантРаспределенияПлатежа.ПоИнвойсу);
		//
		Если ЗначениеЗаполнено(Параметры.ДатаСреза) Тогда
			ГТДкОплате.Параметры.УстановитьЗначениеПараметра("ДатаСреза", КонецДня(Параметры.ДатаСреза));
		КонецЕсли;	
        //		
	КонецЕсли;
	
	
	Попытка
		Если Параметры.ВариантРаспределенияПлатежа = Перечисления.ВариантРаспределенияПлатежа.Аванс Тогда
			ВариантРаспределенияПлатежа = "Аванс";
		КонецЕсли;	
	Исключение
	КонецПопытки;
	
	
	//
	Попытка
		ПолучитьПодборкуГТД(Параметры.АдресПодборкиГТД);
	Исключение
	КонецПопытки;	
    //
	
	ЗакрыватьПриЗакрытииВладельца = Истина;
				
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ВариантРаспределенияПлатежа = "Аванс" Тогда
		ВладелецФормы.РаспределениеОплатыПоГТД();
		Отказ = Истина;
		Возврат;
	КонецЕсли;	
	
	
	Если Владелец = "ТаможняРассчёты" Тогда
		ОбновитьТекущиеДанные();
	КонецЕсли;	
	
		  
КонецПроцедуры
/////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////





//////////////////////////////////////ОБРАБОТЧИКИ ПОДБОРА ГТД К ОПЛАТЕ////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////
////Дима 27.10.2017 10:07:39////Получить подборку ГТД по параметрам
&НаСервере
Процедура ПолучитьПодборкуГТД(АдресПодборки)

	//Запишем настройки динамичсекого списка в реквизиты формы
	Схема = Элементы.ГТДкОплате.ПолучитьИсполняемуюСхемуКомпоновкиДанных();
	Настройки = Элементы.ГТДкОплате.ПолучитьИсполняемыеНастройкиКомпоновкиДанных();
	//
	
	
	//Добавим в настройки курсы валют
	КурсВалютыОплаты = Настройки.Структура[0].Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
	КурсВалютыОплаты.Поле = Новый ПолеКомпоновкиДанных("КурсВалютыОплаты");
	КурсВалютыОплаты.Использование = Истина;
	КурсUSD = Настройки.Структура[0].Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
	КурсUSD.Поле = Новый ПолеКомпоновкиДанных("КурсUSD");
	КурсUSD.Использование = Истина;
	//
	
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных();
	МакетКомпоновки = КомпоновщикМакета.Выполнить(Схема, Настройки,,, Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки);
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	
	Результат = ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	//
	ПоместитьВоВременноеХранилище(ОбщегоНазначения.ТаблицаЗначенийВМассив(Результат), АдресПодборки);
    //
	
	
КонецПроцедуры
//конец Дима


////Дима 27.10.2017 10:49:53////Обновить нераспределённую сумму
&НаКлиенте
Процедура ОбновитьТекущиеДанные()

	Если ВладелецФормы.Объект.ПодборГТД.Количество() = 0 Тогда 
		Нераспределено = ВладелецФормы.Объект.Сумма;
	Иначе
		Нераспределено = ВладелецФормы.Нераспределено;
	КонецЕсли;
	//
	Оформление = ГТДкОплате.КомпоновщикНастроек.Настройки.УсловноеОформление.Элементы[0];
	Оформление.Использование = Ложь;
	Оформление.Отбор.Элементы.Очистить();
	ГруппаИли = Оформление.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаИли.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
	//
	Для Каждого ГТД ИЗ ВладелецФормы.Объект.ПодборГТД Цикл  
		//
		Оформление.Использование = Истина;
		//
		ГруппаИ = ГруппаИли.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
		ГруппаИ.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
		//
		Элемент = ГруппаИ.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		Элемент.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ГТД");
		Элемент.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		Элемент.ПравоеЗначение = ГТД.ГТД;
		Элемент = ГруппаИ.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		Элемент.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ПодИнвойсНомер");
		Элемент.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		Элемент.ПравоеЗначение = ГТД.ПодинвойсНомер;
		//
	КонецЦикла;	
	
			           
КонецПроцедуры


//=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>

&НаКлиенте
Процедура ГТДкОплатеВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;	
	
	Если Владелец <> "ТаможняРассчёты" Тогда
		ОповеститьОВыборе(Элемент.ТекущиеДанные); 
		
	Иначе
		//
		Отбор = Новый Структура("ГТД, ПодИнвойсНомер", Элемент.ТекущиеДанные.ГТД, Элемент.ТекущиеДанные.ПодИнвойсНомер);
		Результат = ВладелецФормы.Объект.ПодборГТД.НайтиСтроки(Отбор);
		//
		Если Результат.Количество() <> 0 Тогда
			Для Каждого Строка Из Результат Цикл
				ВладелецФормы.Объект.ПодборГТД.Удалить(Строка);
			КонецЦикла;	
		Иначе
			//
			Если Нераспределено = 0 Тогда
				Сообщить("Сумма уже распределена!!!");
				Возврат;
			КонецЕсли;
			//
			ЗаполнитьЗначенияСвойств(ВладелецФормы.Объект.ПодборГТД.Добавить(), Элемент.ТекущиеДанные);
		КонецЕсли;
		ВладелецФормы.РаспределениеОплатыПоГТД(Ложь);
		ОбновитьТекущиеДанные();
	КонецЕсли;
	
	
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьЗапись(Команда)
	
	ПараметрыОткрытияФормы = Новый Структура("Ключ", Элементы.ГТДкОплате.ТекущиеДанные.ГТД); 
	ОповещениеОЗакрытии = Новый ОписаниеОповещения("ОбновитьСписок", ЭтаФорма);
	
	
	ОткрытьФорму("Документ.ПриходМашины.Форма.ФормаДокумента", ПараметрыОткрытияФормы,,,,, ОповещениеОЗакрытии, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
	
КонецПроцедуры

&НаКлиенте
Процедура ПодобратьПоСумме(Команда)
	ВладелецФормы.РаспределениеОплатыПоГТД();
	ОбновитьТекущиеДанные();
КонецПроцедуры


////Дима 12.04.2016 15:15:42////ОбновлениеДинамическогоСписка
&НаКлиенте
Процедура ОбновитьСписок(РезультатЗакрытия, ДополнительныеПараметры) Экспорт 
	
	Элементы.ГТДкОплате.Обновить();
	
	//
	ПолучитьПодборкуГТД(ВладелецФормы.АдресПодборкиГТД);
	ВладелецФормы.Объект.ПодборГТД.Очистить();
	ОбновитьТекущиеДанные();
	
КонецПроцедуры	
//конец Дима

//////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////








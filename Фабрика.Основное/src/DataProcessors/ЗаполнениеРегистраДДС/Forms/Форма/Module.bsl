
#Область Задолженности


&НаКлиенте
Процедура Расш1_Задолженности(Команда)
	
	
	Отбор = ПолучитьСтруктураОтбораСервер(Объект.Расшифровка);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Организация", Объект.Расшифровка.Организация);
    ПараметрыФормы.Вставить("Период", Отбор.Период);
    
    Отбор.Удалить("Период");
    
    ПараметрыФормы.Вставить("Отбор", Отбор);
	ПараметрыФормы.Вставить("КлючВарианта", Отбор.КлючВарианта);
			
	ОткрытьФорму("Отчет.ЗадолженностиПоТовару.Форма.ФормаОтчета", ПараметрыФормы, ЭтаФорма, Истина, ВариантОткрытияОкна.ОтдельноеОкно,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
	
КонецПроцедуры


&НаСервереБезКонтекста
Функция ПолучитьСтруктураОтбораСервер(Расшифровка)
	
	
	Отбор = Новый Структура;
	Отбор.Вставить("КонтрагентИНН", Расшифровка.Получатель.ИНН);
	Отбор.Вставить("ТаможняЗадолженностиОрганизацияИНН", Расшифровка.Получатель.ИНН);
	Отбор.Вставить("ТаможняЗадолженностиКонтрагентИНН", Расшифровка.Организация.ИНН);
	//=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>
	
	ПериодОтчета = Новый СтандартныйПериод;
	ПериодОтчета.ДатаНачала = НачалоКвартала(ТекущаяДата());
	ПериодОтчета.ДатаОкончания = НачалоДня(ТекущаяДата());
	//=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>
	
    ПолучательОрганизация = Справочники.Организации.НайтиПоРеквизиту("ИНН", Расшифровка.Получатель.ИНН);
    Если ПолучательОрганизация <> Неопределено Тогда
        ПериодОтчета.ДатаНачала = ?(ПолучательОрганизация.ТипОрганизации = Перечисления.ТипОрганизации.Таможня, 
                                                                                              Дата("20170101"), 
                                                                                              ПериодОтчета.ДатаНачала);
    КонецЕсли;
    
	
	Если Расшифровка.Получатель.Родитель.Наименование = "ИП" Тогда
		КлючВарианта = "4d4478a6-38ca-47b2-92e6-2673fad6b092";
	Иначе	
		КлючВарианта = "ДляДДС";
		Отбор.Вставить("Период", ПериодОтчета);
		Отбор.Вставить("ПлановаяЗадолженность", Истина);
	КонецЕсли;
	Отбор.Вставить("КлючВарианта", КлючВарианта); 	
	//=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>
	
	
	Возврат Отбор;
	
	
КонецФункции



#КонецОбласти




&НаКлиенте
Процедура Расш1_ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	строка = Элементы.РаспределениеПоСчетам.ТекущиеДанные;
	
	Если ЗначениеЗаполнено(строка.НомерВБухгалтерии) Тогда
		Возврат;
	КонецЕсли;  
	 
	Если ВыбранноеЗначение.Свойство("ДоговорМод") Тогда 
		строка.ДоговорыКонтрагентов = ВыбранноеЗначение.ДоговорМод;
	КонецЕсли;	

	Если ВыбранноеЗначение.Свойство("Месяц") Тогда 
		строка.Комментарий = "за " + Формат(ВыбранноеЗначение.Месяц, "ДФ='MMMM yyyy'");
	КонецЕсли;	
        	 
		
КонецПроцедуры


////Дима 23.12.2017 17:32:48////Обновляет данные по счетам
&НаКлиенте
Процедура Расш1_Обновить(Команда)
	ОбновитьЗаполнениеПоСчетам(Неопределено, Неопределено);
КонецПроцедуры




//////////////////////////////////////РЕДАКТИРОВАНИЕ ВАЛЮТНЫХ ПЕРЕВОДОВ//////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////
&НаКлиенте
Процедура Расш1_РедактироватьВалютныйПлатежПеред(Команда)
	
	Если НЕ СоздаватьПлатёжныеДокументы(Контрагент) Тогда
		УстановитьВыполнениеОбработчиковСобытия(Ложь);
		РедактироватьСумму(Неопределено);
	КонецЕсли;	
	
	
КонецПроцедуры
//конец Дима
//////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////


&НаСервереБезКонтекста
Функция СоздаватьПлатёжныеДокументы(Контрагент)

  Свойство = ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоРеквизиту("Заголовок", "Создавать платёжные документы");
  Значение = Контрагент.ДополнительныеРеквизиты.Найти(Свойство, "Свойство");
  
  Если Значение <> Неопределено Тогда
	  Возврат Значение.Значение;
  Иначе
	  Возврат Ложь;
  КонецЕсли;	  
	

КонецФункции // СоздаватьПлатёжныеДокументы()

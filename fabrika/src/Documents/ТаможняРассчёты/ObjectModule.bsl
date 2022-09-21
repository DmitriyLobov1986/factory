//////////////////////////////////////ОБРАБОТКИ ПРОВЕДЕНИЯ//////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////
Процедура ОбработкаПроведения(Отказ, Режим)
	
	ПроведениеПоРегиструТаможняВзаимозадолженности(Отказ);
	
	Если Контрагент.ВалютныйРассчёт 
		И ВариантРаспределенияПлатежа <> Перечисления.ВариантРаспределенияПлатежа.Аванс
		  И НЕ Отказ Тогда
		  ПроведениеПоРегиструТаможняОплатаГТД(Отказ);	
  	КонецЕсли;	
	
КонецПроцедуры

Процедура ПроведениеПоРегиструТаможняВзаимозадолженности(Отказ)
	
	// регистр ТаможняВзаимозадолженности Расход
	Движения.ТаможняВзаимозадолженности.Записывать = Истина;
	Движение = Движения.ТаможняВзаимозадолженности.Добавить();
	//
	Если ДоговорыКонтрагентов.ВидДоговора <> Перечисления.ВидДоговораКонтрагента.ВозвратЗайма Тогда
		Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
		Движение.ТипДвижения = "Оплата задолженности";
	Иначе
		Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
		Движение.ТипДвижения = "Возврат";
	КонецЕсли; 
	//	
	Движение.Период = Дата;
	Движение.Организация = Организация;
	Движение.Контрагент = Контрагент;
	Движение.ДоговорыКонтрагентов = ДоговорыКонтрагентов;
	
	Если Контрагент.ВалютныйРассчёт И ДоговорыКонтрагентов.Валюта.Код <> "643"  Тогда
		Движение.ВалютнаяСуммаДолга = ПодборГТД.Итог("Сумма");
		Отказ = ПроверкаРаспределения();
		
	ИначеЕсли Контрагент.ВалютныйРассчёт Тогда
		Движение.СуммаДолга = ПодборГТД.Итог("Сумма");
		Отказ = ПроверкаРаспределения();
		
	Иначе		
		Движение.СуммаДолга = Сумма;
	КонецЕсли;
	
	
	
КонецПроцедуры

Процедура ПроведениеПоРегиструТаможняОплатаГТД(Отказ)
	
	//Движения.ТаможняОплатаГТД.Записывать = Ложь;
	
	//регистр ТаможняОплатаГТД
	Для Каждого ТекСтрокаПодборГТД Из ПодборГТД Цикл
		
		Движение = Движения.ТаможняОплатаГТД.Добавить();
		Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
		Движение.Период = Дата;
		Движение.ГТД = ТекСтрокаПодборГТД.ГТД;
		Движение.ПодИнвойсНомер = ТекСтрокаПодборГТД.ПодИнвойсНомер;
		Движение.Сумма = ТекСтрокаПодборГТД.Сумма;
		Движение.ТипДвижения = "Оплата машин";
		
	КонецЦикла;
	
	//Движения.ТаможняОплатаГТД.Записать();
	Движения.ТаможняОплатаГТД.Записать();
	
	//Проверка остатков
	Если НЕ ПроверкаОстатка() Тогда
		Отказ = Истина;
		возврат;
	КонецЕсли;	
	
КонецПроцедуры
///////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////


////Дима 05.07.2019 12:59:02////Заполнение из данных основания
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка) 
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
	  ДанныеЗаполнения.Вставить("ВалютаОплаты", ДанныеЗаполнения.СчетОрганизации.Валюта);
	КонецЕсли;  
	
КонецПроцедуры	
//конец Дима

////Дима 16.03.2015 10:08:48////Если проходит оплата зарубежному контрагенту, то добавляем "СчетКонтрагенты" в обязательные для заполнения реквизиты.
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если Контрагент.ВалютныйРассчёт Тогда
		ПроверяемыеРеквизиты.Добавить("СчетКонтрагента");
		ПроверяемыеРеквизиты.Добавить("ДоговорыКонтрагентов");
	КонецЕсли;
	
	Если Боркин.Количество() > 0 Тогда
		ПроверяемыеРеквизиты.Добавить("Боркин.Организация");
		ПроверяемыеРеквизиты.Добавить("Боркин.СчетОрганизации");
		ПроверяемыеРеквизиты.Добавить("Боркин.Контрагент");
		ПроверяемыеРеквизиты.Добавить("Боркин.ДатаПрихода");
		ПроверяемыеРеквизиты.Добавить("Боркин.Сумма");
	КонецЕсли;	
	
	
	ТЗ = УправлениеСвойствамиСлужебный.ПолучитьНаборыСвойствОбъекта(Контрагент);	
КонецПроцедуры	
//конец Дима

////Дима 01.05.2015 18:08:37////Если документ создаётся копированием, то очистим табличную часть Полдбор ГТД
Процедура ПриКопировании(ОбъектКопирования)
	ПодборГТД.Очистить();
	Сумма = 0;
	ДатаСрезаИнвойсов = Неопределено;
КонецПроцедуры
//конец Дима

////Дима 24.07.2015 10:34:32////Проверка остатков регистра при проведении
Функция ПроверкаОстатка()
	
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ТаможняОплатаГТДОстатки.ГТД,
	               |	ТаможняОплатаГТДОстатки.СуммаОстаток
	               |ИЗ
	               |	РегистрНакопления.ТаможняОплатаГТД.Остатки(&ДатаСреза, ГТД В (&СписокГТД)) КАК ТаможняОплатаГТДОстатки";
				   
				   
	Запрос.УстановитьПараметр("ДатаСреза", КонецДня(ДатаСрезаИнвойсов));			   
	Запрос.УстановитьПараметр("СписокГТД", ПодборГТД.ВыгрузитьКолонку("ГТД"));
				   
	Результат = Запрос.Выполнить().Выгрузить();
	
	Для каждого Строка из Результат Цикл
		
		Если строка.СуммаОстаток < 0 Тогда
			
			Индекс = ПодборГТД.Индекс(ПодборГТД.Найти(строка.ГТД, "ГТД"));
			ОбщийМодульСервер.ДобавитьСоообщениеВмассив(ЭтотОбъект, "Не хватает суммы ГТД!!!",, "ПодборГТД[" + Индекс + "].ГТД");
			возврат Ложь;
			
		КонецЕсли;
		
	КонецЦикла;
	
	возврат Истина;
	
	
КонецФункции
//конец Дима

////Дима 10.08.2015 12:09:05////ПроверкаРаспределения
Функция ПроверкаРаспределения()

	Если Сумма <> ПодборГТД.Итог("СуммаВалютаОплаты") Тогда
		ОбщийМодульСервер.ДобавитьСоообщениеВмассив(, "Сумма оплаты нераспределена!!!");
		возврат Истина;
	КонецЕсли;
	
	возврат Ложь;

КонецФункции
//конец Дима

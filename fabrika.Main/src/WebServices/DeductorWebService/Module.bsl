
Функция UpdateData(TypeBase, DateStart)
	
	Если TypeBase = "Зуп" Тогда
		База = Перечисления.ТипОрганизации.Упп;
	Иначе
		База = Перечисления.ТипОрганизации.Представительства;
	КонецЕсли;
	
	СтрутураПодключений = Новый Структура;
	АдресСтруктурыПодключений = ПоместитьВоВременноеХранилище(СтрутураПодключений);
	
	Отказ = Ложь;
	ПодключениеКВнешнимИБ.ПроверкаПодключения(База, АдресСтруктурыПодключений, Отказ);
	
	
	
	Если Отказ Тогда
		Сообщения = ПолучитьСообщенияПользователю(Истина);
		Возврат Сообщения[0].Текст;
	Иначе
		Если TypeBase = "Зуп" Тогда
			Возврат ПолучитьДанныеЗупВXml(АдресСтруктурыПодключений);
		Иначе
			Возврат ПолучитьДанныеДОвФайл(АдресСтруктурыПодключений, DateStart);
		КонецЕсли;  
	КонецЕсли;  
	
		
КонецФункции


Функция ПолучитьДанныеЗупВXml(АдресПодключений)

	
	//Типы данных пакета Xdto
	//////////////////////////////////////////////////////////////////////////////////////////////
	
	//Командировки
	КомандировкаТип = ФабрикаXDTO.Тип("http://www.portal.ukritter/Deductor", "Komandirovka");
	СписокТип = ФабрикаXDTO.Тип("http://www.portal.ukritter/Deductor", "Spisok");
	СписокКомандировок = ФабрикаXDTO.Создать(СписокТип);
		
	
	//Справочник подразделений
	СотрудникТип = ФабрикаXDTO.Тип("http://www.portal.ukritter/Deductor", "Sotrudnik");
	СправочникТип = ФабрикаXDTO.Тип("http://www.portal.ukritter/Deductor", "Spravochnik");
	Справочник = ФабрикаXDTO.Создать(СправочникТип);
	

	СтруктураТип = ФабрикаXDTO.Тип("http://www.portal.ukritter/Deductor", "StructuraOtveta");
	СтруктураОтвета = ФабрикаXDTO.Создать(СтруктураТип);
	///////////////////////////////////////////////////////////////////////////////////////////////
	
	
	
	
	
	Подключения = ПолучитьИзВременногоХранилища(АдресПодключений);
	Зуп = Подключения.Упп.Подключение;
	
	Запрос = Зуп.NewObject("Запрос");
	Запрос.Текст = "ВЫБРАТЬ
					|	КомандировкиОрганизацийРаботникиОрганизации.ФизЛицо,
					|	КомандировкиОрганизацийРаботникиОрганизации.ФизЛицо.Наименование КАК Name,
					|	КомандировкиОрганизацийРаботникиОрганизации.ФизЛицо.СтраховойНомерПФР КАК Pfr,
					|	КомандировкиОрганизацийРаботникиОрганизации.ДатаНачала КАК DateStart,
					|	КомандировкиОрганизацийРаботникиОрганизации.ДатаОкончания КАК DateEnd
					|ИЗ
					|	Документ.КомандировкиОрганизаций.РаботникиОрганизации КАК КомандировкиОрганизацийРаботникиОрганизации
					|ГДЕ
					|	КомандировкиОрганизацийРаботникиОрганизации.Ссылка.Проведен = ИСТИНА
					|	И КомандировкиОрганизацийРаботникиОрганизации.ДатаНачала МЕЖДУ &НачалоКомандировки И &КонецКомандировки
					|;
					|
					|////////////////////////////////////////////////////////////////////////////////
					|ВЫБРАТЬ
					|	СотрудникиОрганизаций.Организация.Наименование КАК OrgName,
					|	СотрудникиОрганизаций.Наименование КАК Name,
					|	ЕСТЬNULL(СотрудникиОрганизаций.ТекущееПодразделениеОрганизации.Наименование, """") КАК TekPodrName,
					|	ЕСТЬNULL(СотрудникиОрганизаций.ТекущееПодразделениеОрганизации.ЕдиныйКод, """") КАК TekPodrEdinKod,
					|	ЕСТЬNULL(СотрудникиОрганизаций.ТекущаяДолжностьОрганизации.Наименование, """") КАК TekDolznost,
					|	СотрудникиОрганизаций.Код КАК Kod,
					|	СотрудникиОрганизаций.ДатаУвольнения КАК DateUvoln,
					|	СотрудникиОрганизаций.Актуальность КАК Actualnost,
					|	СотрудникиОрганизаций.Физлицо.СтраховойНомерПФР КАК Pfr,
					|	СотрудникиОрганизаций.ДатаПриемаНаРаботу КАК DatePriema,
					|	СотрудникиОрганизаций.ТарифнаяСтавка КАК TarifStavka,
					|	ЕСТЬNULL(СотрудникиОрганизаций.ТекущееПодразделениеОрганизации.Родитель.Наименование, """") КАК TekPodrRoditel,
					|	СотрудникиОрганизаций.Организация.ИНН КАК OrgInn,
					|	СотрудникиОрганизаций.Организация.Префикс КАК Prefiks,
					|	ЕСТЬNULL(СотрудникиОрганизаций.ВидДоговора.Порядок, 25) КАК VidDogovora,
					|	ЕСТЬNULL(СотрудникиОрганизаций.ВидЗанятости.Порядок, 25) КАК VidZanatosti
					|ИЗ
					|	Справочник.СотрудникиОрганизаций КАК СотрудникиОрганизаций
					|ГДЕ
					|	СотрудникиОрганизаций.ПометкаУдаления = ЛОЖЬ
					|	И СотрудникиОрганизаций.ЭтоГруппа = ЛОЖЬ";
					

    Запрос.УстановитьПараметр("НачалоКомандировки", НачалоМесяца(ДобавитьМесяц(ТекущаяДата(), -1)));
	Запрос.УстановитьПараметр("КонецКомандировки", КонецМесяца(ТекущаяДата()));					
					
	РезультатПакеты = Запрос.ВыполнитьПакет();
	
	
	Пакеты = ЗначениеИзСтрокиВнутр(Зуп.ЗначениеВСтрокуВнутр(РезультатПакеты));
	
	
	ВыборкаКомандировки = Пакеты[0].Выбрать();
	Пока ВыборкаКомандировки.Следующий() Цикл
		Командировка = ФабрикаXDTO.Создать(КомандировкаТип);
		ЗаполнитьЗначенияСвойств(Командировка, ВыборкаКомандировки);
		СписокКомандировок.Spisok.Добавить(Командировка);
	КонецЦикла;	

	
	ВыборкаСотрудники = Пакеты[1].Выбрать();
	Пока ВыборкаСотрудники.Следующий() Цикл 
		Сотрудник = ФабрикаXDTO.Создать(СотрудникТип);	
		ЗаполнитьЗначенияСвойств(Сотрудник, ВыборкаСотрудники,, "DatePriema, DateUvoln");
		Сотрудник.DateUvoln	= ?(ВыборкаСотрудники.DateUvoln = Дата(1, 1, 1), Дата(1989, 1, 1), ВыборкаСотрудники.DateUvoln);
		Сотрудник.DatePriema = ?(ВыборкаСотрудники.DatePriema = Дата(1, 1, 1), Дата(1989, 1, 1), ВыборкаСотрудники.DatePriema);
		Справочник.Spravochnik.Добавить(Сотрудник);
	КонецЦикла;	
		
	
			
	
	//Сформируем данные возврата
	СтруктураОтвета.Table1 = СписокКомандировок;
	СтруктураОтвета.Table2 = Справочник;
	
	
	НовыйЗаписьXML = Новый ЗаписьXML;
	НовыйЗаписьXML.ОткрытьФайл("\\main-ts01\Пользователи\Мобильная связь\Мобильная связь\Данные для загрузки\Справочник\Источники данных Deductor\Зуп.xml");
	НовыйЗаписьXML.ЗаписатьОбъявлениеXML();
	//НовыйЗаписьXML.УстановитьСтроку();
	ФабрикаXDTO.ЗаписатьXML(НовыйЗаписьXML, СтруктураОтвета, "Input");
	
	
	
	Возврат "Ok";
	
	
КонецФункции


Функция ПолучитьДанныеДОвФайл(АдресПодключений, ДатаНачалаЗагрузки)

	
	Подключения = ПолучитьИзВременногоХранилища(АдресПодключений);
	До = Подключения.Представительства.Подключение;
	
	
	Запрос = До.NewObject("Запрос");
	Запрос.Текст = "ВЫБРАТЬ
					|	ПланПлатежейПлатежи.Ссылка.Номер,
					|	ПланПлатежейПлатежи.Ссылка.Период,
					|	ПланПлатежейПлатежи.Организация.Наименование КАК Организация,
					|	ПланПлатежейПлатежи.Контрагент.Наименование КАК Контрагент,
					|	ПланПлатежейПлатежи.СтатьяРасхода.Наименование КАК Статья,
					|	ПланПлатежейПлатежи.ПлановаяДатаПлатежа,
					|	ПланПлатежейПлатежи.Валюта.Наименование КАК Валюта,
					|	ПланПлатежейПлатежи.Сумма,
					|	ПланПлатежейПлатежи.ПодразделениеЗатрат.Наименование КАК ПодразделениеЗатрат,
					|	ПланПлатежейПлатежи.НазначениеПлатежа КАК Назначение,
					|   ПланПлатежейПлатежи.Ссылка.Подразделение.Наименование КАК ПодразделениеОтветственный
					|ИЗ
					|	Документ.ПланПлатежей.Платежи КАК ПланПлатежейПлатежи
					|ГДЕ
					|	ПланПлатежейПлатежи.Ссылка.ПометкаУдаления = ЛОЖЬ
					|   И ПланПлатежейПлатежи.Ссылка.Период >= &ДатаНачалаЗагрузки";

					
					
	Запрос.УстановитьПараметр("ДатаНачалаЗагрузки", ДатаНачалаЗагрузки);				
	РезультатЗапроса = Запрос.Выполнить();
	
	
	ТЗрезультат = ЗначениеИзСтрокиВнутр(До.ЗначениеВСтрокуВнутр(РезультатЗапроса)).Выгрузить();
	
	
	//=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>
	ТекстовыйФайл = Новый ЗаписьТекста("\\main-ts01\\Пользователи\Юсупов Александр\Документооборот\Выгрузка.txt", КодировкаТекста.ANSI);
	
	Шапка = "";
	Для Каждого Колонка Из ТЗрезультат.Колонки Цикл
		Шапка = Шапка + Колонка.Имя + ";";
	КонецЦикла;
	ТекстовыйФайл.ЗаписатьСтроку(Шапка);
	
	
	Для Каждого Строка Из ТЗрезультат Цикл
		Запись = "";
		Для Каждого Колонка Из ТЗрезультат.Колонки Цикл
			Данные = ?(Колонка.Имя = "Сумма", Формат(Строка[Колонка.Имя], "ЧГ="), Строка[Колонка.Имя]); 			
			Запись = Запись + Данные + ";";
		КонецЦикла;
		ТекстовыйФайл.ЗаписатьСтроку(Запись);
	КонецЦикла;	
	
	ТекстовыйФайл.Закрыть();
	//=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>
	
	
	
	Возврат "Ok";
	

КонецФункции

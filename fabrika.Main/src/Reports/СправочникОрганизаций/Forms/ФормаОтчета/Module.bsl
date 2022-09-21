
/////////////////////////////////////СОБЫТИЯ ФОРМЫ//////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	
	Если ПустаяСтрока(Параметры.АдресТЗданных) Тогда
		ЗагрузитьXMLвТЗ();
		УстановитьТекущийВариант("Основной");
	КонецЕсли;
	
		
	//Передадим картинки кнопок на клиент
	//ПередатьИконкиНаКлиент(АдресИконок, УникальныйИдентификатор);
	
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	СформироватьОтчет(Неопределено);
КонецПроцедуры


/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////



&НаСервере
Процедура ЗагрузитьXMLвТЗ()
	
	
	ФайлыXSD = Новый Массив;
	ФайлыXSD.Добавить("\\main-sql02\Документация\Дмитрий\Web сервис\Фабрика\XSD схемы\СправочникОрганизаций.xsd");
	
	НоваяФабрикаXDTO = СоздатьФабрикуXDTO(ФайлыXSD);
	
	
	
	Колонки = НоваяФабрикаXDTO.Пакеты.Получить("http://www.portal.ukritter.ru/SpravOrg").Получить("Org").Свойства;
	ТЗсправочник = СформироватьТЗ(Колонки); 
		
	
	
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.ОткрытьФайл("\\main-sql02\Документация\Выгрузки\Справочник организаций.xml");
	
	СправочникОрганизаций = НоваяФабрикаXDTO.ПрочитатьXML(ЧтениеXML, НоваяФабрикаXDTO.Тип("http://www.portal.ukritter.ru/SpravOrg", "SpravOrg"));		
	Для Каждого Строка из СправочникОрганизаций.Org Цикл
		
		НоваяЗапись = ТЗсправочник.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяЗапись, Строка,, "DateRegistr, AccountClose, SotrudnikDate, PeriodObr");
		
		НоваяЗапись.DateRegistr = ?(НЕ ПустаяСтрока(Строка.DateRegistr), Дата(Строка.DateRegistr), Дата(1, 1, 1));
		НоваяЗапись.AccountClose = ?(НЕ ПустаяСтрока(Строка.AccountClose), Дата(Строка.AccountClose), Дата(1, 1, 1));
		НоваяЗапись.SotrudnikDate = ?(НЕ ПустаяСтрока(Строка.SotrudnikDate), Дата(Строка.SotrudnikDate), Дата(1, 1, 1));
		НоваяЗапись.PeriodObr = ?(НЕ ПустаяСтрока(Строка.PeriodObr), Дата(Строка.PeriodObr), Дата(1, 1, 1));
		
	КонецЦикла;	
	
	
	Параметры.АдресТЗданных = ПоместитьВоВременноеХранилище("", УникальныйИдентификатор);
	ПоместитьВоВременноеХранилище(ТЗсправочник, Параметры.АдресТЗданных);
	
	
	
КонецПроцедуры	


&НаСервереБезКонтекста
Функция СформироватьТЗ(Колонки)
	
	ТЗ = Новый ТаблицаЗначений;
	
	Для Каждого Колонка из Колонки Цикл
		ТЗ.Колонки.Добавить(Колонка.Имя);
	КонецЦикла;
	
	Возврат ТЗ;
	
	 	
КонецФункции	


&НаСервереБезКонтекста
Процедура ПередатьИконкиНаКлиент(АдресИконок, УникальныйИдентификатор)
	
	АдресИконок = Новый Структура;
	
	Банк = Новый ДвоичныеДанные("\\main-ts01\E$\Фабрика отчётов\Фабрика\Библиотека картинок\ikoni_dlya_podsistem_1s_8.2\Икони для подсистем 1С 8.2\banker.png");
	АдресИконок.Вставить("Банк", ПоместитьВоВременноеХранилище(Банк, УникальныйИдентификатор));
	

КонецПроцедуры


&НаКлиенте
Процедура НастроитьОтображение()
	
	Результат.ФиксацияСверху = 0;
	
	СписокПолей = Новый СписокЗначений;
	СписокПолей.Добавить(Результат.НайтиТекст("За Период"));
	СписокПолей.Добавить(Результат.НайтиТекст("Текущие данные"));
	СписокПолей.Добавить(Результат.НайтиТекст("КВ"));
	
	Для Каждого Поле Из СписокПолей Цикл
		Если Поле.Значение <> Неопределено Тогда
			Поле.Значение.ГоризонтальноеПоложение = ГоризонтальноеПоложение.Центр;	
		КонецЕсли;  
	КонецЦикла;	  
	
	
КонецПроцедуры








//////////////////////////////////////ФОРМИРОВАНИЕ ОТЧЕТА//////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////
&НаКлиенте
Процедура СформироватьОтчет(Команда)
	
	СформироватьОтчетНаСервере();
	НастроитьОтображение();
	
КонецПроцедуры

&НаСервере
Процедура СформироватьОтчетНаСервере()
	
	ОтчетОбъект = РеквизитФормыВЗначение("Отчет");
	
	
	//Создадим внешний набор данных
	Попытка
		СправочникОрганизаций = ПолучитьИзВременногоХранилища(Параметры.АдресТЗданных);
		ВнешнийНаборДанных = Новый Структура("СправочникОрганизаций", СправочникОрганизаций);
	Исключение
		ОбщийМодульСервер.ДобавитьСоообщениеВмассив(, "Не загружены данные справочника!!!");
		Возврат;
	КонецПопытки;	
	
	
	//Получим схему компоновки отчета
	Схема = ОтчетОбъект.ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");
		
	
	//Установка данных расшифровки
	РасшифровкаОтчета = Новый ДанныеРасшифровкиКомпоновкиДанных;
	
	
	//Передаем в макет компоновки схему, настройки и данные расшифровки
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	Макет = КомпоновщикМакета.Выполнить(Схема, Отчет.КомпоновщикНастроек.ПолучитьНастройки(), РасшифровкаОтчета);
	
	
	//Выполним компоновку с помощью процессора компоновки
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(Макет, ВнешнийНаборДанных, РасшифровкаОтчета);
	
	
	//Выводим результат в табличный документ
	Результат.Очистить();
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(Результат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	ДанныеРасшифровки = ПоместитьВоВременноеХранилище(РасшифровкаОтчета, ЭтаФорма.УникальныйИдентификатор);
	
	
	
КонецПроцедуры	



&НаКлиенте
Процедура РезультатОбработкаДополнительнойРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	Перем ВыполненноеДействие;
	Перем ПараметрВыбранногоДействия;
	
	Если НЕ ПустаяСтрока(КлючУникальности) Тогда
		Возврат;
	КонецЕсли;	
	
	СтандартнаяОбработка = Ложь;     
	
	
	ИсточникНастроек = Новый ИсточникДоступныхНастроекКомпоновкиДанных(Отчет);     
	ОбработкаРасшифровкиКД = Новый ОбработкаРасшифровкиКомпоновкиДанных(ДанныеРасшифровки, ИсточникНастроек);           
	
	
	ОсновныеДействия = Новый Массив;
	ОсновныеДействия.Добавить(ДействиеОбработкиРасшифровкиКомпоновкиДанных.ОткрытьЗначение);
	
	ДополнительныеДействия = Новый СписокЗначений ;
	ДополнительныеДействия.Добавить("БанковскиеСчета", "Банковские счета",, БиблиотекаКартинок.ОстаткиДенег);
	//ДополнительныеДействия.Добавить("Сотрудники",,, БиблиотекаКартинок.АктивныеПользователи);
	//ДополнительныеДействия.Добавить("КонтактнаяИнформация", "Контактная информация",, БиблиотекаКартинок.ПоказатьТолькоВыбранныеРоли);
	//ДополнительныеДействия.Добавить("Оборот", "Оборот",, БиблиотекаКартинок.СинхронизацияДанных);
	
	
	ОбработкаРасшифровкиКД.ВыбратьДействие(Расшифровка, ВыполненноеДействие, ПараметрВыбранногоДействия, ОсновныеДействия, ДополнительныеДействия);
	
	
	Если ВыполненноеДействие = ДействиеОбработкиРасшифровкиКомпоновкиДанных.Нет Тогда
		Возврат;
		
	Иначе	
		Организация = ОбщийМодульСервер.ПолучениеРасшифровкиВСтруктуру(Расшифровка, ДанныеРасшифровки, Новый Структура).Организация;
		Отбор = Новый Структура("Организация", Организация);
		
		Парам = Новый Структура("АдресТЗДанных, КлючВарианта, Отбор", Параметры.АдресТЗданных, ВыполненноеДействие, Отбор);		
		
		ОткрытьФорму(ИмяФормы, Парам,, Организация);
		
	КонецЕсли;	
	
	
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////






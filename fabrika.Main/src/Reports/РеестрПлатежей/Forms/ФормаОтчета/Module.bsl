
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ПроверитьДетализацию() Тогда
		СформироватьОтчет(ВладелецФормы.АдресДетализации);
	КонецЕсли;  
	
КонецПроцедуры

&НаКлиенте
Процедура ПриПовторномОткрытии()
	
	Если ПроверитьДетализацию() Тогда
		СформироватьОтчет(ВладелецФормы.АдресДетализации);	
	КонецЕсли;  	
	
КонецПроцедуры


//
&НаКлиенте
Функция ПроверитьДетализацию()
	
	Попытка
		ПолучитьИзВременногоХранилища(ВладелецФормы.АдресДетализации);
		Возврат Истина;
	Исключение
		сообщить("Не загружен реестр платежей!!!");
		Возврат Ложь;
	КонецПопытки;	
	
	
КонецФункции
//





//////////////////////////////////////ПРОЦЕДУРЫ ФОРМИРОВАНИЯ ОТЧЕТА//////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////
&НаКлиенте
Процедура Сформировать(Команда)
	
	Если ПроверитьДетализацию() Тогда
		СформироватьОтчет(ВладелецФормы.АдресДетализации);	
	КонецЕсли;  

КонецПроцедуры


&НаСервере
Процедура СформироватьОтчет(АдресДетализации)
	
	ОтчетОбъект = РеквизитФормыВЗначение("Отчет");
	
	
	//Получим схему компоновки данных
	Схема = ОтчетОбъект.ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");
	
	
	//Создадим внешний набор данных
	ВнешнийНаборДанных = Новый Структура("РеестрПлатежей", ПолучитьИзВременногоХранилища(АдресДетализации));
	
	
	
	//Передаем в макет компоновки схему, настройки и данные расшифровки
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	НовыеДанныеРасшифровки = Новый ДанныеРасшифровкиКомпоновкиДанных;
	Макет = КомпоновщикМакета.Выполнить(Схема, Отчет.КомпоновщикНастроек.ПолучитьНастройки(), НовыеДанныеРасшифровки);
	
	//Выполним компоновку с помощью процессора компоновки
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(Макет, ВнешнийНаборДанных, НовыеДанныеРасшифровки);
	
		
	//Выведем компоновку с помощью процессора вывода
	Результат.Очистить();	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(Результат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	ДанныеРасшифровки = ПоместитьВоВременноеХранилище(НовыеДанныеРасшифровки, ЭтаФорма.УникальныйИдентификатор);
	
		
КонецПроцедуры	

/////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////







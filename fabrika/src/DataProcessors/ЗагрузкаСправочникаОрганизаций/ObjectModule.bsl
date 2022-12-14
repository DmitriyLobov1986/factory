Процедура ПодключитьВыбранныеБазы(СписокБаз) Экспорт

	//Получим подключения к базам
	СтрутураПодключений = Новый Структура;
	АдресСтруктурыПодключений = ПоместитьВоВременноеХранилище(СтрутураПодключений);
	
	Для Каждого База Из СписокБаз Цикл
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Подключаем базу: " + Строка(База));
		ПодключениеКВнешнимИБ.ПроверкаПодключения(База, АдресСтруктурыПодключений);
	КонецЦикла;  
	
	
	//Запуск обработки обновления справочника организаций	
	ПолучениеСпискаКЗагрузке(АдресСтруктурыПодключений);
	
	
	
КонецПроцедуры






////Дима 17.07.2014 10:22:29////Загрузка справочника организаций
Процедура ПолучениеСпискаКЗагрузке(АдресСтруктурыПодключений = Неопределено) Экспорт

	Если АдресСтруктурыПодключений = Неопределено Тогда
		возврат;
	КонецЕсли;	
	
	СтруктураПодключений = ПолучитьИзВременногоХранилища(АдресСтруктурыПодключений);
	
	
	ТЗcom = ПолучитьТЗкЗагрузке();
	
	
	Для каждого Подключение Из СтруктураПодключений Цикл
		
		//Запрос к внешней базе с помещением результата во таблицу значений
		База = Подключение.Значение.Подключение;
		
		//
		Корректировка = "";
		Если Подключение.Значение.ТипОрганизации <> Перечисления.ТипОрганизации.Упп Тогда
			Корректировка = "И НЕ Организации.СтатусСуществованияОрганизации В (ЗНАЧЕНИЕ(Перечисление.СтатусСуществованияОрганизации.Ликвидирована), 
						     |ЗНАЧЕНИЕ(Перечисление.СтатусСуществованияОрганизации.ПеренесенаВДругуюБД))";
							 
		КонецЕсли;					 
        //
		
		
		ЗапросCOM=База.NewObject("Запрос");
		
		ЗапросCOM.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
						|	Организации.ИНН КАК Инн,
						|	Организации.Наименование КАК Наименование
						|ИЗ
						|	Справочник.Организации КАК Организации
						|ГДЕ
						|	Организации.ПометкаУдаления = ЛОЖЬ
						|	И НЕ Организации.Наименование ПОДОБНО ""%перенесена%""
						|	И НЕ Организации.Наименование ПОДОБНО ""я_%""
						|	И НЕ Организации.Наименование ПОДОБНО ""%(Л)%""" + Корректировка;
						
						
						
						
		Выборка = ЗапросCOM.Выполнить().Выбрать();
		
		Пока Выборка.Следующий() Цикл
			
			запись = ТЗcom.Добавить();
			запись.Инн = Выборка.Инн;
			запись.Наименование = Выборка.Наименование;
			запись.ТипОрганизации = Подключение.Значение.ТипОрганизации;
			
		КонецЦикла;
				
	КонецЦикла;

		
	
	//Запрос местный с использованием полученной таблицы значений
	ЗапросВТ = Новый Запрос;
	ЗапросВТ.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	ЗапросВТ.Текст = "ВЫБРАТЬ * ПОМЕСТИТЬ ВТ ИЗ &ТЗcom КАК ТЗcom";
                 	
	ЗапросВТ.УстановитьПараметр("ТЗcom", ТЗcom);
	ЗапросВТ.Выполнить();
	
	
	//Запрос местный с использованием полученной временной таблицы
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = ЗапросВТ.МенеджерВременныхТаблиц;		
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Организации.Ссылка,
	|	ОрганизацииБухгалтерии.Инн,
	|	ОрганизацииБухгалтерии.Наименование,
	|	ОрганизацииБухгалтерии.ТипОрганизации
	|ПОМЕСТИТЬ СравнениеТаблиц
	|ИЗ
	|	(ВЫБРАТЬ
	|		Организации.Ссылка КАК Ссылка
	|	ИЗ
	|		Справочник.Организации КАК Организации
	|	ГДЕ
	|		Организации.ПометкаУдаления = ЛОЖЬ
	|		И Организации.Закрыта = ЛОЖЬ
	|		И НЕ Организации.Ссылка В
	|					(ВЫБРАТЬ
	|						ВЫРАЗИТЬ(ДополнительныеСведения.Объект КАК Справочник.Организации) КАК Организация
	|					ИЗ
	|						РегистрСведений.ДополнительныеСведения КАК ДополнительныеСведения
	|					ГДЕ
	|						(ВЫРАЗИТЬ(ДополнительныеСведения.Значение КАК СТРОКА(100))) = ""Ручной ввод"")) КАК Организации
	|		ПОЛНОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			ОрганизацииБухгалтерии.Инн КАК Инн,
	|			МАКСИМУМ(ОрганизацииБухгалтерии.Наименование) КАК Наименование,
	|			МАКСИМУМ(ОрганизацииБухгалтерии.ТипОрганизации) КАК ТипОрганизации
	|		ИЗ
	|			ВТ КАК ОрганизацииБухгалтерии
	|		
	|		СГРУППИРОВАТЬ ПО
	|			ОрганизацииБухгалтерии.Инн) КАК ОрганизацииБухгалтерии
	|		ПО Организации.Ссылка.ИНН = ОрганизацииБухгалтерии.Инн
	|			И Организации.Ссылка.ТипОрганизации = ОрганизацииБухгалтерии.ТипОрганизации
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СравнениеТаблиц.Инн,
	|	СравнениеТаблиц.Наименование,
	|	СравнениеТаблиц.ТипОрганизации
	|ИЗ
	|	СравнениеТаблиц КАК СравнениеТаблиц
	|ГДЕ
	|	СравнениеТаблиц.Ссылка ЕСТЬ NULL 
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СравнениеТаблиц.Ссылка КАК Ссылка
	|ИЗ
	|	СравнениеТаблиц КАК СравнениеТаблиц
	|ГДЕ
	|	СравнениеТаблиц.Инн ЕСТЬ NULL 
	|	И СравнениеТаблиц.Ссылка.ТипОрганизации В
	|			(ВЫБРАТЬ
	|				СравнениеТаблиц.ТипОрганизации
	|			ИЗ
	|				СравнениеТаблиц КАК СравнениеТаблиц
	|			СГРУППИРОВАТЬ ПО
	|				СравнениеТаблиц.ТипОрганизации)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	Организации.Ссылка
	|ИЗ
	|	СравнениеТаблиц КАК СравнениеТаблиц
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Организации КАК Организации
	|		ПО СравнениеТаблиц.Инн = Организации.ИНН
	|ГДЕ
	|	СравнениеТаблиц.Ссылка ЕСТЬ NULL ";
	
	
	Результат = Запрос.ВыполнитьПакет();
	ТзСоздать = Результат[1].Выгрузить();
	ТзУдалить = Результат[2].Выгрузить();
	
	УдалитьЭлементыСправочника(ТзУдалить);
	СоздатьЭлементыСправочника(ТзСоздать);
	
	
	
	
	
КонецПроцедуры


Процедура СоздатьЭлементыСправочника(ТзСоздать)
	
	Если ТзСоздать.Количество() = 0 Тогда
		возврат;
	КонецЕсли;	
	
	//Привелигированный режим
	УстановитьПривилегированныйРежим(Истина);
	
		 	
	Для каждого Организация Из ТзСоздать Цикл
	
		Объект = Справочники.Организации.СоздатьЭлемент();
		Объект.Наименование = Организация.Наименование;
		Объект.ИНН = Организация.Инн;
		Объект.ТипОрганизации = Организация.ТипОрганизации;
		Объект.ДополнительныеСвойства.Вставить("НеКонтролироватьИНН", Истина);
		Объект.Записать();
		
		//
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Добавлено: " + Объект.Наименование);
		//
	
	КонецЦикла;
	
	//Привелигированный режим
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

Процедура УдалитьЭлементыСправочника(ТзУдалить)
	
	
	Если ТзУдалить.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;	
		
	
	//Привелигированный режим
	УстановитьПривилегированныйРежим(Истина);

	
	Для каждого Элемент Из ТзУдалить Цикл
		
		Объект = Элемент.Ссылка.ПолучитьОбъект();
		Объект.ДополнительныеСвойства.Вставить("НеКонтролироватьИНН", Ложь);
		Объект.УстановитьПометкуУдаления(Истина);
		
		//
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Удалено: " + Объект.Наименование);
		//
		
	КонецЦикла;
	
	//Привелигированный режим
	УстановитьПривилегированныйРежим(Ложь);
   	
КонецПроцедуры


//
Функция ПолучитьТЗкЗагрузке()
	
	Перем ТЗcom;
	
	ТЗcom = Новый ТаблицаЗначений;
	ТЗcom.Колонки.Добавить("Инн", Новый ОписаниеТипов("Строка", ,
	Новый КвалификаторыСтроки(100, ДопустимаяДлина.Переменная)));
	ТЗcom.Колонки.Добавить("Наименование", Новый ОписаниеТипов("Строка", ,
	Новый КвалификаторыСтроки(100, ДопустимаяДлина.Переменная)));
	
	ТЗcom.Колонки.Добавить("ТипОрганизации", Новый ОписаниеТипов("ПеречислениеСсылка.ТипОрганизации"));
	Возврат ТЗcom;

КонецФункции

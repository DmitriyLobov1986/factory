
Функция СравнитьТаблицыНаборовЗаписей(ТаблицаЗначений1, ТаблицаЗначений2) Экспорт

	Если ТипЗнч(ТаблицаЗначений1) <> Тип("ТаблицаЗначений") ИЛИ ТипЗнч(ТаблицаЗначений2) <> Тип("ТаблицаЗначений") Тогда
		Возврат Ложь;
	КонецЕсли; 
	
	Если ТаблицаЗначений1.Количество() <> ТаблицаЗначений2.Количество() Тогда
		Возврат Ложь;
	КонецЕсли; 

	Если ТаблицаЗначений1.Колонки.Количество() <> ТаблицаЗначений2.Колонки.Количество() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	// Проверим поля
	Для каждого Колонка Из ТаблицаЗначений1.Колонки Цикл
		Если ТаблицаЗначений2.Колонки.Найти(Колонка.Имя) = Неопределено Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЦикла; 
	Для каждого Колонка Из ТаблицаЗначений2.Колонки Цикл
		Если ТаблицаЗначений1.Колонки.Найти(Колонка.Имя) = Неопределено Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЦикла; 
	
	// сформируем строку индекса для оптимизации поиска по таблице значений
	СтрокаИндекса = "";
	Для каждого Колонка Из ТаблицаЗначений1.Колонки Цикл
		Если СтрокаИндекса = "" Тогда
			СтрокаИндекса = Колонка.Имя;
		Иначе
			СтрокаИндекса = СтрокаИндекса+","+Колонка.Имя;
		КонецЕсли;
	КонецЦикла;
	// добавим индекс
	ТаблицаЗначений2.Индексы.Добавить(СтрокаИндекса);
	
	// Проверим записи
	Для каждого СтрокаТаблицы Из ТаблицаЗначений1 Цикл
		СтруктураПоиска = Новый Структура;
		Для каждого Колонка Из ТаблицаЗначений1.Колонки Цикл
			СтруктураПоиска.Вставить(Колонка.Имя, СтрокаТаблицы[Колонка.Имя]);
		КонецЦикла;
		СтрокиТаблицы2 = ТаблицаЗначений2.НайтиСтроки(СтруктураПоиска);
		Если СтрокиТаблицы2.Количество() <> 1 Тогда
			Возврат Ложь;
		КонецЕсли; 
	КонецЦикла;
	
	// сформируем строку индекса для оптимизации поиска по таблице значений
	СтрокаИндекса = "";
	Для каждого Колонка Из ТаблицаЗначений2.Колонки Цикл
		Если СтрокаИндекса = "" Тогда
			СтрокаИндекса = Колонка.Имя;
		Иначе
			СтрокаИндекса = СтрокаИндекса+","+Колонка.Имя;
		КонецЕсли;
	КонецЦикла;
	// добавим индекс
	ТаблицаЗначений1.Индексы.Добавить(СтрокаИндекса);
	
	Для каждого СтрокаТаблицы Из ТаблицаЗначений2 Цикл
		СтруктураПоиска = Новый Структура;
		Для каждого Колонка Из ТаблицаЗначений2.Колонки Цикл
			СтруктураПоиска.Вставить(Колонка.Имя, СтрокаТаблицы[Колонка.Имя]);
		КонецЦикла;
		СтрокиТаблицы1 = ТаблицаЗначений1.НайтиСтроки(СтруктураПоиска);
		Если СтрокиТаблицы1.Количество() <> 1 Тогда
			Возврат Ложь;
		КонецЕсли; 
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции // СравнитьТаблицыЗначений()

Функция ПолучитьСтруктуруОтборовНабораЗаписей(ПраваДоступаПользователей) Экспорт
	
	СтруктураОтбора = Новый Структура;
	
	Для каждого ЭлементОтбора Из ПраваДоступаПользователей.Отбор Цикл
		Если ЭлементОтбора.Использование Тогда
			СтруктураОтбора.Вставить(ЭлементОтбора.Имя, ЭлементОтбора.Значение);
		КонецЕсли;
	КонецЦикла;
	
	Возврат СтруктураОтбора;
	
КонецФункции

/////////////////////////////////////////////////////////////////////////////////////
// ОБЩИЕ ПРОЦЕДУРЫ И ФУНКЦИИ ОБСЛУЖИВАНИЯ МЕХАНИЗМА НАСТРОЙКИ ПРАВ ДОСТУПА

Функция ПолучитьВидОбъектаДоступа(ОбъектДоступа) Экспорт

	Если ТипЗнч(ОбъектДоступа) = Тип("СправочникСсылка.Организации") Тогда
		Возврат Перечисления.ВидыОбъектовДоступа.Организации;
	ИначеЕсли ТипЗнч(ОбъектДоступа) = Тип("СправочникСсылка.ВнешниеОбработки") Тогда
		Возврат Перечисления.ВидыОбъектовДоступа.ВнешниеОбработки;
	Иначе
		Возврат Перечисления.ВидыОбъектовДоступа.ПустаяСсылка();
	КонецЕсли; 

КонецФункции

/////////////////////////////////////////////////////////////////////////////////////
// ОБЩИЕ ПРОЦЕДУРЫ И ФУНКЦИИ ОБСЛУЖИВАНИЯ МЕХАНИЗМА ДАТЫ ЗАПРЕТА РЕДАКТИРОВАНИЯ

// Проверка возможности записи данных документа с учетом даты запрета изменения данных (даты запрета редактирования)
//
Процедура ПередЗаписьюДокументовПроверкаДоступностиПериода(Источник, Отказ, РежимЗаписи, РежимПроведения) Экспорт
	Если Отказ ИЛИ Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	ПроверкаПериодаДокумента(Источник, Отказ, РежимЗаписи);
	#Если Клиент Тогда
		Если Отказ Тогда
			Сообщить("Редактирование данных этого периода запрещено. Изменения не могут быть записаны...", СтатусСообщения.Важное);
		КонецЕсли;
	#КонецЕсли
КонецПроцедуры	// ПередЗаписьюДокументовПроверкаДоступностиПериода

// Процедура проверки возможности записи (изменения) данных документа с учетом даты запрета изменения данных (даты запрета редактирования)
//
Процедура ПроверкаПериодаДокумента(ДокументОбъект, Отказ, РежимЗаписи = Неопределено)
	
	СоответствиеГраницЗапрета = ПараметрыСеанса.ГраницыЗапретаИзмененияДанных.Получить();
	
	// Для пользователя с полными правами проверок выполнять не нужно
	Если СоответствиеГраницЗапрета = Неопределено Тогда
		Возврат;
	КонецЕсли;
		
	ПараметрыПроверкиДокумента = ПолучитьПараметрыПроверкиДокумента(ДокументОбъект);
	
	Если Не ДокументОбъект.ЭтоНовый() Тогда
		СтараяВерсияДокумента = ПолучитьВерсиюДокументаПередИзменением(ДокументОбъект, ПараметрыПроверкиДокумента);
    	ПроверитьВерсиюДокумента(СтараяВерсияДокумента, ПараметрыПроверкиДокумента, СоответствиеГраницЗапрета, Отказ);
	КонецЕсли;
			
	Если Не Отказ Тогда
		ПроверитьВерсиюДокумента(ДокументОбъект, ПараметрыПроверкиДокумента, СоответствиеГраницЗапрета, Отказ, РежимЗаписи);
	КонецЕсли;
	
КонецПроцедуры // ПроверкаПериодаДокумента

// Функция возвращает из БД версию документа до его изменения
//
Функция ПолучитьВерсиюДокументаПередИзменением(ДокументОбъект, ПараметрыПроверкиДокумента)
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ 
	|Дата" 
	+ ?(ПараметрыПроверкиДокумента.ЕстьОрганизация, "," + Символы.ПС + "Организация КАК Организация", "")
	+ ?(ПараметрыПроверкиДокумента.ПроверятьПроведениеДокумента, "," + Символы.ПС + "Проведен КАК Проведен", "") + "	
	|ИЗ Документ." + ПараметрыПроверкиДокумента.МетаданныеДокумента.Имя + "
	|ГДЕ Ссылка = &Ссылка";
	Запрос.УстановитьПараметр("Ссылка", ДокументОбъект.Ссылка);
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	Возврат Выборка;
	
КонецФункции // ПолучитьВерсиюДокументаПередИзменением()

// Процедура проверки версии документа на нарушение даты запрета
//
Процедура ПроверитьВерсиюДокумента(ДокументОбъект, ПараметрыПроверкиДокумента, СоответствиеГраницЗапрета, Отказ, РежимЗаписи = Неопределено) Экспорт
	
	Если ПараметрыПроверкиДокумента.ПроверятьПроведениеДокумента Тогда		
		ДокументПроведен = ДокументОбъект.Проведен ИЛИ ?(РежимЗаписи = Неопределено, ЛОЖЬ, РежимЗаписи = РежимЗаписиДокумента.Проведение);
		Если Не ДокументПроведен Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;	
	
	// Не выполняется проверка дат запрета редактирования
	Если НЕ ПараметрыПроверкиДокумента.ПроверятьУправленческуюДатуЗапрета и
		НЕ ПараметрыПроверкиДокумента.ПроверятьРегламентированнуюДатуЗапрета Тогда
		
		Возврат;
	КонецЕсли;	
	
	// Проверка регламентированной даты запрета
	Если ПараметрыПроверкиДокумента.ПроверятьРегламентированнуюДатуЗапрета Тогда	
		ГраницаПоОрганизации = СоответствиеГраницЗапрета[ДокументОбъект.Организация];
		
		// Если регламентированная дата запрета для регламентного документа не определена
		// то используется общая дата запрета изменения данных
		Если ГраницаПоОрганизации = Неопределено Тогда
			ГраницаПоОрганизации = СоответствиеГраницЗапрета["ОбщаяДатаЗапретаРедактирования"];    
		КонецЕсли;
		
		Если НЕ ГраницаПоОрганизации = Неопределено 
			И ДокументОбъект.Дата <= ГраницаПоОрганизации	Тогда
			
			Отказ = Истина;			
		КонецЕсли;		
	КонецЕсли;		    
	
	// Проверка управленческой даты запрета
	Если ПараметрыПроверкиДокумента.ПроверятьУправленческуюДатуЗапрета Тогда        
		ГраницаПериода = СоответствиеГраницЗапрета[Справочники.Организации.ПустаяСсылка()];       
		// Если управленческая дата запрета для управленческого документа не определена
		// то используется общая дата запрета изменения данных
		Если ГраницаПоОрганизации = Неопределено Тогда
			ГраницаПоОрганизации = СоответствиеГраницЗапрета[Справочники.Организации.ПустаяСсылка()];    
		КонецЕсли;
		
		Если ГраницаПериода <> Неопределено Тогда
			
			Если ДокументОбъект.Дата <= ГраницаПериода Тогда
				Отказ = Истина;				
			КонецЕсли;         			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры // ПроверитьВерсиюДокумента()

// Функция возвращает структуру с параметрами проверки документа по умолчанию
//
Функция ПолучитьПараметрыПроверкиДокумента(ДокументОбъект) Экспорт
	
	ПараметрыПроверкиДокумента = Новый Структура;
	МетаданныеДокумента = ДокументОбъект.Метаданные();
	
	ПараметрыПроверкиДокумента.Вставить("МетаданныеДокумента", МетаданныеДокумента);
	
	// если  в документе есть реквизит организация, дата запрета определяется с учетом организации
	ПараметрыПроверкиДокумента.Вставить("ЕстьОрганизация", 			(МетаданныеДокумента.Реквизиты.Найти("Организация") <> Неопределено));
	
	// Если для документа проведение запрещено, проверка на дату запрета редактирования
	//проверяется без учета проведенности
	ПараметрыПроверкиДокумента.Вставить("ПроверятьПроведениеДокумента", (МетаданныеДокумента.Проведение = Метаданные.СвойстваОбъектов.Проведение.Разрешить));
		
	Если ЗаполнитьПараметрыПроверкиПоВидуДокумента(ДокументОбъект, ПараметрыПроверкиДокумента) Тогда
		Возврат ПараметрыПроверкиДокумента;
	КонецЕсли;
			
	ПараметрыПроверкиДокумента.Вставить("ПроверятьУправленческуюДатуЗапрета", 		Ложь);
	ПараметрыПроверкиДокумента.Вставить("ПроверятьРегламентированнуюДатуЗапрета", 	ПараметрыПроверкиДокумента.ЕстьОрганизация);	
	
	Возврат ПараметрыПроверкиДокумента;
	
КонецФункции // ПолучитьПараметрыПроверкиДокумента()

//Функция возвращает структуру параметров проверки документа для нетиповых случаев
//
Функция ЗаполнитьПараметрыПроверкиПоВидуДокумента(ДокументОбъект, ПараметрыПроверкиДокумента)
		
	//Если ПараметрыПроверкиДокумента.МетаданныеДокумента.Имя = "<ИмяДокумента>" Тогда		
	//	ЗаполнитьПараметрыПроверкиДокумента<ИмяДокумента>(ДокументОбъект, ПараметрыПроверкиДокумента);
	//Иначе
		Возврат Ложь;
	//КонецЕсли;	
	
	//Возврат Истина;
	
КонецФункции // ЗаполнитьПараметрыПроверкиПоВидуДокумента()
//
//// Процедура заполнения структуры параметров проверки для документа ЗаказПокупателя
////
//Процедура ЗаполнитьПараметрыПроверкиДокумента<ИмяДокумента>(ДокументОбъект, ПараметрыПроверкиДокумента)
//	
//	ПараметрыПроверкиДокумента.Вставить("ПроверятьУправленческуюДатуЗапрета", <ПроверятьУправленческуюДатуЗапрета>);
//	ПараметрыПроверкиДокумента.Вставить("ПроверятьРегламентированнуюДатуЗапрета", <ПроверятьРегламентированнуюДатуЗапрета>);
//	
//КонецПроцедуры // ЗаполнитьПараметрыПроверкиДокументаЗаказПокупателя()


// Процедура выполняет проверку возможности записи регистров сведений и регистров накопления
// с учетом даты запрета изменения данных (даты запрета редактирования)
//
Процедура ПроверкаПериодаЗаписейРегистров(НаборЗаписей, Отказ) Экспорт
	
	СоответствиеГраницЗапрета = ПараметрыСеанса.ГраницыЗапретаИзмененияДанных.Получить();
	
	// Для пользователя с полными правами проверок выполнять не нужно
	Если СоответствиеГраницЗапрета = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	МетаданныеНабора = НаборЗаписей.Метаданные();		
	ЕстьОрганизация = (МетаданныеНабора.Измерения.Найти("Организация")<>Неопределено);
	
	
	// Проверку существующих записей выполняем только для регистров сведений, подчиненных регистратору,
	// регистрам накопления и регистрам бухгалтерии.
	// Проверка необходима, так как удаление записей прошлого периода (в результате перезаписи набора)
	// тоже допускать нельзя.
	
	СтруктураПараметров = Новый Структура();
	СтруктураПараметров.Вставить("СоответствиеГраницЗапрета", 	СоответствиеГраницЗапрета);
	СтруктураПараметров.Вставить("МетаданныеНабора", 			МетаданныеНабора);
	СтруктураПараметров.Вставить("ЕстьОрганизация", 			ЕстьОрганизация);
	
	Если Метаданные.РегистрыСведений.Содержит(МетаданныеНабора) И НЕ МетаданныеНабора.РежимЗаписи = Метаданные.СвойстваОбъектов.РежимЗаписиРегистра.ПодчинениеРегистратору Тогда
		ПроверкаСуществующихЗаписейРегистраСОтборомПоИзмерениям(НаборЗаписей, СтруктураПараметров, Отказ);
	Иначе
		ПроверкаСуществующихЗаписейРегистра(НаборЗаписей, СтруктураПараметров, Отказ);
	КонецЕсли;
                  		
	Если НаборЗаписей.Количество() > 0 И НЕ Отказ Тогда				
		Отказ = Ложь;
		Если ЕстьОрганизация Тогда
			Для Каждого Запись ИЗ НаборЗаписей Цикл
				ГраницаПоОрганизации = СоответствиеГраницЗапрета[Запись.Организация];
				ЕСли ГраницаПоОрганизации <> Неопределено 
					 И Запись.Период <= ГраницаПоОрганизации Тогда
					Отказ = Истина;
					Возврат;
				КонецЕсли;
			КонецЦикла;
		Иначе
			ГраницаПериода = СоответствиеГраницЗапрета[Справочники.Организации.ПустаяСсылка()];
			Если ГраницаПериода <> Неопределено Тогда
				Для Каждого Запись ИЗ НаборЗаписей Цикл
					ЕСли Запись.Период <= ГраницаПериода Тогда
						Отказ = Истина;
						Возврат;
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
		КонецЕсли;		
	КонецЕсли;
КонецПроцедуры // ПроверкаПериодаЗаписейРегистров

Процедура ПроверкаСуществующихЗаписейРегистра(НаборЗаписей, СтруктураПараметров, Отказ)
	
	ИмяРегистра = СтруктураПараметров.МетаданныеНабора.ПолноеИмя();
	
	Запрос = Новый Запрос;
	ВложенныйЗапрос = "";
	ЕСли СтруктураПараметров.ЕстьОрганизация Тогда
		индекс = 1;
		ИмяПоляОрганизации = "Организация";
		Для Каждого КлючИЗначение ИЗ СтруктураПараметров.СоответствиеГраницЗапрета Цикл
			ВложенныйЗапрос = ВложенныйЗапрос + ?(ВложенныйЗапрос = "", "", "
			|ОБЪЕДИНИТЬ") +"
			|ВЫБРАТЬ &Организация"+индекс+" КАК Организация, &ДатаЗапрета" + Формат(индекс, "ЧГ=0") + " КАК ДатаЗапрета";
			Запрос.УстановитьПараметр("Организация"+индекс, КлючИЗначение.Ключ);
			ГраницаПериода = КлючИЗначение.Значение;
			Запрос.УстановитьПараметр("ДатаЗапрета"+индекс, ?(ГраницаПериода=Неопределено, NULL, ГраницаПериода));
			индекс = индекс + 1;
		КонецЦикла;
	Иначе
		ПустаяОрганизация = Справочники.Организации.ПустаяСсылка();
		ИмяПоляОрганизации = "&ПустаяОрганизация";
		ВложенныйЗапрос = "ВЫБРАТЬ &ПустаяОрганизация КАК Организация, &ДатаЗапрета КАК ДатаЗапрета";
		Запрос.УстановитьПараметр("ПустаяОрганизация", ПустаяОрганизация);
		ГраницаПериода = СтруктураПараметров.СоответствиеГраницЗапрета[ПустаяОрганизация];
		Запрос.УстановитьПараметр("ДатаЗапрета", ?(ГраницаПериода=Неопределено, NULL, ГраницаПериода));			
	КонецЕсли;			
	
	Запрос.Текст = "
	|ВЫБРАТЬ ПЕРВЫЕ 1 1
	|ИЗ
	|(
	|ВЫБРАТЬ " + ИмяПоляОрганизации + " КАК Организация, МИНИМУМ(Период) КАК Период  ИЗ " + ИмяРегистра + " КАК Набор
	|ГДЕ Регистратор = &Регистратор
	|СГРУППИРОВАТЬ ПО " + ИмяПоляОрганизации + "
	|) КАК НаборЗаписей
	|ЛЕВОЕ СОЕДИНЕНИЕ
	|(" + ВложенныйЗапрос + "		
	|) КАК ДатыЗапрета
	|ПО НаборЗаписей.Организация = ДатыЗапрета.Организация
	|ГДЕ НаборЗаписей.Период <= ДатыЗапрета.ДатаЗапрета ИЛИ ДатыЗапрета.ДатаЗапрета ЕСТЬ NULL";
	Запрос.УстановитьПараметр("Регистратор", НаборЗаписей.Отбор.Регистратор.Значение);				
	
	Если НЕ Запрос.Выполнить().Пустой() Тогда
		Отказ = Истина;
	Иначе
		Отказ = Ложь;
	КонецЕсли;
	
КонецПроцедуры // ПроверкаСуществующихЗаписейРегистра()

Процедура ПроверкаСуществующихЗаписейРегистраСОтборомПоИзмерениям(НаборЗаписей, СтруктураПараметров, Отказ)
	
    ИмяРегистра = СтруктураПараметров.МетаданныеНабора.ПолноеИмя();
    
    // Формируем текст условия блока ГДЕ основного запроса,
    // в соответствии с установленным отбором для набора записей
    
    Запрос = Новый Запрос;
       
    СписокПолейУсловияОтбораТекст = "";
    Итерация = 0;
    Для каждого ЭлементОтбора Из НаборЗаписей.Отбор Цикл                
        Если не ЭлементОтбора.Использование Тогда
            Продолжить;
        КонецЕсли;                
        
        Если НЕ Итерация = 0  Тогда            
            СписокПолейУсловияОтбораТекст = СписокПолейУсловияОтбораТекст  + " И ";
        КонецЕсли;        
        
        СписокПолейУсловияОтбораТекст = СписокПолейУсловияОтбораТекст +" Набор." + ЭлементОтбора.Имя + " = &" + ЭлементОтбора.Имя;                       
        Запрос.УстановитьПараметр(ЭлементОтбора.Имя, ЭлементОтбора.Значение);        
        
        Итерация = 1;
    КонецЦикла; 
    
    Если Итерация = 1 Тогда
        СписокПолейУсловияОтбораТекст = " ГДЕ " + СписокПолейУсловияОтбораТекст;    	            
    КонецЕсли;                   
    
    ВложенныйЗапрос = "";
    Если СтруктураПараметров.ЕстьОрганизация Тогда
    	индекс = 1;
    	ИмяПоляОрганизации = "Организация";
    	Для Каждого КлючИЗначение ИЗ СтруктураПараметров.СоответствиеГраницЗапрета Цикл
    		ВложенныйЗапрос = ВложенныйЗапрос + ?(ВложенныйЗапрос = "", "", "
    		|ОБЪЕДИНИТЬ") +"
    		|ВЫБРАТЬ &Организация"+индекс+" КАК Организация, &ДатаЗапрета" + Формат(индекс, "ЧГ=0") + " КАК ДатаЗапрета";
    		Запрос.УстановитьПараметр("Организация"+индекс, КлючИЗначение.Ключ);
    		ГраницаПериода = КлючИЗначение.Значение;
    		Запрос.УстановитьПараметр("ДатаЗапрета"+индекс, ?(ГраницаПериода=Неопределено, NULL, ГраницаПериода));
    		индекс = индекс + 1;
    	КонецЦикла;
    Иначе
    	ПустаяОрганизация = Справочники.Организации.ПустаяСсылка();
    	ИмяПоляОрганизации = "&ПустаяОрганизация";
    	ВложенныйЗапрос = "ВЫБРАТЬ &ПустаяОрганизация КАК Организация, &ДатаЗапрета КАК ДатаЗапрета";
    	Запрос.УстановитьПараметр("ПустаяОрганизация", ПустаяОрганизация);
    	ГраницаПериода = СтруктураПараметров.СоответствиеГраницЗапрета[ПустаяОрганизация];
    	Запрос.УстановитьПараметр("ДатаЗапрета", ?(ГраницаПериода=Неопределено, NULL, ГраницаПериода));			
    КонецЕсли;			    
    
    
    Запрос.Текст = "
    |ВЫБРАТЬ ПЕРВЫЕ 1 1
    |ИЗ
    |(
    |ВЫБРАТЬ " + ИмяПоляОрганизации + " КАК Организация, МИНИМУМ(Период) КАК Период  ИЗ " + ИмяРегистра + " КАК Набор
    | "+ СписокПолейУсловияОтбораТекст + "
    |СГРУППИРОВАТЬ ПО " + ИмяПоляОрганизации + "
    |) КАК НаборЗаписей
    |ЛЕВОЕ СОЕДИНЕНИЕ
    |(" + ВложенныйЗапрос + "		
    |) КАК ДатыЗапрета
    |ПО НаборЗаписей.Организация = ДатыЗапрета.Организация
    |ГДЕ НаборЗаписей.Период <= ДатыЗапрета.ДатаЗапрета ИЛИ ДатыЗапрета.ДатаЗапрета ЕСТЬ NULL";      
	
	Если НЕ Запрос.Выполнить().Пустой() Тогда
    	Отказ = Истина;
    Иначе
    	Отказ = Ложь;
    КонецЕсли;
	
КонецПроцедуры // ПроверкаСуществующихЗаписейРегистраСОтборомПоИзмерениям()

/////////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ  - ОБРАБОТЧИКИ ПОДПИСОК НА СОБЫТИЯ МЕХАНИЗМА ДАТЫ ЗАПРЕТА РЕДАКТИРОВАНИЯ
// Проверка возможности изменения записей регистров (дата запрета изменения данных)
//
Процедура ПередЗаписьюРегистраНакопленийПроверкаДоступностиПериода(Источник, Отказ, Замещение) Экспорт
	Если Отказ ИЛИ Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	ПроверкаПериодаЗаписейРегистров(Источник, Отказ);
	#Если Клиент Тогда
		Если Отказ Тогда
			Сообщить("Редактирование данных этого периода запрещено. Изменения не могут быть записаны...", СтатусСообщения.Важное);
		КонецЕсли;
	#КонецЕсли
КонецПроцедуры // ПередЗаписьюРегистраНакопленийПроверкаДоступностиПериода






/////////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБСЛУЖИВАЮЩИЕ СОБЫТИЯ ЭЛЕМЕНТОВ УПРАВЛЕНИЯ ФОРМ

#Если Клиент Тогда

Процедура РедактироватьПраваДоступа(Ссылка) Экспорт
	
	Если НЕ РольДоступна("ПолныеПрава") Тогда
		Предупреждение("Нарушение прав доступа!");
		Возврат;
	КонецЕсли;
	
	Обработки.НастройкаПравДоступа.ПолучитьФорму("НастройкаПравДоступа",,Ссылка).Открыть();
	
КонецПроцедуры

#КонецЕсли

Функция ДокументВЗакрытомПериоде(ДокументОбъект) Экспорт
	
	Результат = Ложь;
	
	СоответствиеГраницЗапрета = ПараметрыСеанса.ГраницыЗапретаИзмененияДанных.Получить();
	
	// Для пользователя с полными правами проверок выполнять не нужно
	Если СоответствиеГраницЗапрета = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ПараметрыПроверкиДокумента = ПолучитьПараметрыПроверкиДокумента(ДокументОбъект);
	ПроверитьВерсиюДокумента(ДокументОбъект, ПараметрыПроверкиДокумента, СоответствиеГраницЗапрета, Результат);
	
	Возврат Результат;
	
КонецФункции // ДокументВЗакрытомПериоде()

/////////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБСЛУЖИВАЮЩИЕ НАСЛЕДСТВЕННОСТЬ ПРАВ ДОСТУПА ИЕРАРХИЧЕСКИХ СПРАВОЧНИКОВ

Функция ПолучитьМассивДочернихЭлементов(Родитель) Экспорт
	
	МетаданныеРодителя = Родитель.Метаданные();
	Если ЗначениеЗаполнено(Родитель) и (Не МетаданныеРодителя.Иерархический или МетаданныеРодителя.ВидИерархии = Метаданные.СвойстваОбъектов.ВидИерархии.ИерархияГруппИЭлементов и Не Родитель.ЭтоГруппа) Тогда
		Возврат Новый Массив;
	КонецЕсли; 
	
	Если Метаданные.Перечисления.Содержит(МетаданныеРодителя) Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	_Таблица.Ссылка КАК Ссылка
		|ИЗ
		|	Перечисление." + МетаданныеРодителя.Имя + " КАК _Таблица";
	Иначе
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	_Таблица.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник." + МетаданныеРодителя.Имя + " КАК _Таблица";
		
		Если МетаданныеРодителя.Иерархический Тогда
			Запрос.Текст = Запрос.Текст + "
			|ГДЕ
			|	_Таблица.Ссылка В ИЕРАРХИИ(&Родитель)
			|	И _Таблица.Ссылка <> &Родитель";
			Запрос.УстановитьПараметр("Родитель", Родитель);
		КонецЕсли;
	КонецЕсли;
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
КонецФункции // () 

Процедура ЗаписатьПраваДоступаПользователейКОбъекту(ПраваДоступаПользователей, Ссылка, Отказ, ПрошлыйИзмененныйРодительОбъектаДоступа = Неопределено) Экспорт
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ОтборПоПользователю = ТипЗнч(Ссылка) = Тип("СправочникСсылка.ГруппыПользователей");
		
	Если ОтборПоПользователю Тогда
		ПраваДоступаПользователей.Отбор.Пользователь.Установить(Ссылка);
	Иначе
		ПраваДоступаПользователей.Отбор.ОбъектДоступа.Установить(Ссылка);
	КонецЕсли;
	
	ТаблицаПравДоступа = ПолучитьТаблицуПравДоступаБезУнаследуемыхЗаписей(ПраваДоступаПользователей);
	
	Для каждого СтрокаТаблицы Из ТаблицаПравДоступа Цикл
		Если ОтборПоПользователю Тогда
			СтрокаТаблицы.Пользователь  = Ссылка;
		Иначе
			СтрокаТаблицы.ОбъектДоступа = Ссылка;
		КонецЕсли;
		СтрокаТаблицы.ВладелецПравДоступа = СтрокаТаблицы.ОбъектДоступа;
	КонецЦикла;
	
	СтруктураОтбора = ПолучитьСтруктуруОтборовНабораЗаписей(ПраваДоступаПользователей);
	
	////Дима 15.08.2014 10:30:46////Закомментировал, т.к. нет модуля "Полные права"
	//ПолныеПрава.ЗаписатьПраваДоступаПользователей(ТаблицаПравДоступа,СтруктураОтбора, Отказ, "Не записаны права доступа к объекту """+ Ссылка + """!");
	
	Если НЕ Отказ Тогда
		ПрочитатьПраваДоступаКОбъекту(ПраваДоступаПользователей, Ссылка);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПрочитатьПраваДоступаКОбъекту(ПраваДоступаПользователей, Ссылка) Экспорт

	// Снимем все отборы
	Для каждого Отбор Из ПраваДоступаПользователей.Отбор Цикл
		Отбор.Использование = Ложь;
	КонецЦикла;
	
	Если ТипЗнч(Ссылка) = Тип("СправочникСсылка.Пользователи") ИЛИ ТипЗнч(Ссылка) = Тип("СправочникСсылка.ГруппыПользователей") Тогда
		ПраваДоступаПользователей.Отбор.Пользователь.Значение = Ссылка;
		ПраваДоступаПользователей.Отбор.Пользователь.Использование = Истина;
	Иначе
		ПраваДоступаПользователей.Отбор.ОбъектДоступа.Значение = Ссылка;
		ПраваДоступаПользователей.Отбор.ОбъектДоступа.Использование = Истина;
	КонецЕсли;
	
	ПраваДоступаПользователей.Прочитать();
	
КонецПроцедуры

Функция ПолучитьСписокВидовНаследованияПравДоступа(ОбъектДоступа) Экспорт
	
	СписокПеречисления = Новый СписокЗначений;
	
	Если НЕ ЗначениеЗаполнено(ОбъектДоступа) Тогда
		СписокПеречисления.Добавить(Перечисления.ВидыНаследованияПравДоступаИерархическихСправочников.РаспространитьНаПодчиненных);
		СписокПеречисления.Добавить(Перечисления.ВидыНаследованияПравДоступаИерархическихСправочников.ТолькоДляТекущегоПрава);
	Иначе
		Если Справочники.ТипВсеСсылки().СодержитТип(ТипЗнч(ОбъектДоступа)) Тогда
			МетаданныеОбъекта = ОбъектДоступа.Метаданные();
			Если МетаданныеОбъекта.Иерархический Тогда
				Если МетаданныеОбъекта.ВидИерархии = Метаданные.СвойстваОбъектов.ВидИерархии.ИерархияГруппИЭлементов Тогда
					Если ОбъектДоступа.ЭтоГруппа Тогда
						СписокПеречисления.Добавить(Перечисления.ВидыНаследованияПравДоступаИерархическихСправочников.РаспространитьНаПодчиненных);
					Иначе
						СписокПеречисления.Добавить(Перечисления.ВидыНаследованияПравДоступаИерархическихСправочников.ТолькоДляТекущегоПрава);
					КонецЕсли;
				Иначе
					СписокПеречисления.Добавить(Перечисления.ВидыНаследованияПравДоступаИерархическихСправочников.ТолькоДляТекущегоПрава);
					СписокПеречисления.Добавить(Перечисления.ВидыНаследованияПравДоступаИерархическихСправочников.РаспространитьНаПодчиненных);
				КонецЕсли;
			Иначе
				СписокПеречисления.Добавить(Перечисления.ВидыНаследованияПравДоступаИерархическихСправочников.ТолькоДляТекущегоПрава);
			КонецЕсли;
		Иначе
			СписокПеречисления.Добавить(Перечисления.ВидыНаследованияПравДоступаИерархическихСправочников.ТолькоДляТекущегоПрава);
		КонецЕсли;
	КонецЕсли;
	
	Возврат СписокПеречисления;
	
КонецФункции

Функция ПолучитьТаблицуПравДоступаБезУнаследуемыхЗаписей(ПраваДоступаПользователей) Экспорт
	
	ТаблицаПравДоступа = РегистрыСведений.НастройкиПравДоступаПользователей.СоздатьНаборЗаписей().Выгрузить();
	
	Для каждого СтрокаТаблицыНабора Из ПраваДоступаПользователей Цикл
		
		Если СтрокаТаблицыНабора.ВидНаследованияПравДоступаИерархическихСправочников = Перечисления.ВидыНаследованияПравДоступаИерархическихСправочников.ТолькоДляТекущегоПрава или СтрокаТаблицыНабора.ВидНаследованияПравДоступаИерархическихСправочников = Перечисления.ВидыНаследованияПравДоступаИерархическихСправочников.РаспространитьНаПодчиненных Тогда
			ЗаполнитьЗначенияСвойств(ТаблицаПравДоступа.Добавить(), СтрокаТаблицыНабора);
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ТаблицаПравДоступа;
	
КонецФункции

Процедура ДополнитьНаборПравДоступаНаследуемымиЗаписями(НаборПрав) Экспорт
	
	ИсходнаяТаблица = ПолучитьТаблицуПравДоступаБезУнаследуемыхЗаписей(НаборПрав);
	
	СоответствиеМассивовДочернихЭлементов     = Новый Соответствие;
	СоответствиеМассивовРодительскихЭлементов = Новый Соответствие;
	
	Для каждого СтрокаНабора Из ИсходнаяТаблица Цикл
		
		Если СтрокаНабора.ВидНаследованияПравДоступаИерархическихСправочников = Перечисления.ВидыНаследованияПравДоступаИерархическихСправочников.РаспространитьНаПодчиненных Тогда
			
			//Дополним набор записями для дочерних элементов
			МассивЭлементов = СоответствиеМассивовДочернихЭлементов[СтрокаНабора.ОбъектДоступа];
			Если МассивЭлементов = Неопределено Тогда
				МассивЭлементов = ПолучитьМассивДочернихЭлементов(СтрокаНабора.ОбъектДоступа);
				СоответствиеМассивовДочернихЭлементов.Вставить(СтрокаНабора.ОбъектДоступа,МассивЭлементов);
			КонецЕсли;
			
			Для каждого Ссылка Из МассивЭлементов Цикл
				Запись = НаборПрав.Добавить();
				ЗаполнитьЗначенияСвойств(Запись, СтрокаНабора,,"ОбъектДоступа,ВидНаследованияПравДоступаИерархическихСправочников");
				Запись.ОбъектДоступа = Ссылка;
				Запись.ВидНаследованияПравДоступаИерархическихСправочников = Перечисления.ВидыНаследованияПравДоступаИерархическихСправочников.НаследуетсяОтРодителя;
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры // () 

Процедура ДополнитьНаборПравДоступаУнаследованнымиЗаписями(ПраваДоступаПользователей, ОбъектДоступа, Родитель) Экспорт
	
	ОбъектДоступаМетаданные = ОбъектДоступа.Метаданные();
	
	// Добавим записи, унаследованные от родителей
	Родители = Новый Массив;
	ТекущийРодитель = Родитель;
	Пока ЗначениеЗаполнено(ТекущийРодитель) Цикл
		Родители.Добавить(ТекущийРодитель);
		ТекущийРодитель = ТекущийРодитель.Родитель;
	КонецЦикла;
	Родители.Добавить(ТекущийРодитель);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	*
	|ИЗ
	|	РегистрСведений.НастройкиПравДоступаПользователей КАК ПраваДоступаПользователей
	|ГДЕ
	|	ПраваДоступаПользователей.ОбъектДоступа В(&Родители)
	|	И ПраваДоступаПользователей.ВидНаследованияПравДоступаИерархическихСправочников = &РаспространитьНаПодчиненных";
		
	Если ПраваДоступаПользователей.Отбор.Пользователь.Использование Тогда
		Запрос.Текст = Запрос.Текст + "
		|	И ПраваДоступаПользователей.Пользователь = &Пользователь";
		Запрос.УстановитьПараметр("Пользователь", ПраваДоступаПользователей.Отбор.Пользователь.Значение);
	КонецЕсли;
		
	Запрос.УстановитьПараметр("Родители", Родители);
	Запрос.УстановитьПараметр("РаспространитьНаПодчиненных", Перечисления.ВидыНаследованияПравДоступаИерархическихСправочников.РаспространитьНаПодчиненных);
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		Запись = ПраваДоступаПользователей.Добавить();
		ЗаполнитьЗначенияСвойств(Запись, Выборка,,"ОбъектДоступа, ВидНаследованияПравДоступаИерархическихСправочников");
		Запись.ОбъектДоступа = ОбъектДоступа;
		Запись.ВидНаследованияПравДоступаИерархическихСправочников = Перечисления.ВидыНаследованияПравДоступаИерархическихСправочников.НаследуетсяОтРодителя;
	КонецЦикла;
	
КонецПроцедуры // () 

Процедура ПередЗаписьюНовогоОбъектаСПравамиДоступаПользователей(ЭтотОбъект, Отказ, Родитель, СсылкаНового = Неопределено) Экспорт

	Если ЭтотОбъект.ЭтоНовый() Тогда
				
		СсылкаНового = ЭтотОбъект.ПолучитьСсылкуНового();
		Если НЕ ЗначениеЗаполнено(СсылкаНового) Тогда
			СсылкаНового = Справочники[ЭтотОбъект.Метаданные().Имя].ПолучитьСсылку();
		КонецЕсли;
		
		////Дима 15.08.2014 10:30:46////Закомментировал, т.к. нет модуля "Полные права"
		//ПолныеПрава.ЗарегистрироватьПраваДоступаПользователяКОбъекту(СсылкаНового, Родитель, Отказ);

		Если НЕ Отказ И НЕ ЗначениеЗаполнено(ЭтотОбъект.ПолучитьСсылкуНового()) Тогда
			ЭтотОбъект.УстановитьСсылкуНового(СсылкаНового);
		КонецЕсли; 
	КонецЕсли;

КонецПроцедуры

Процедура ОбновитьПраваДоступаКИерархическимОбъектамПриНеобходимости(Ссылка,ПрошлыйИзмененныйРодительОбъектаДоступа, Отказ) Экспорт
	
	//В объекте не был изменен родитель. Обновлять права доступа нет необходимости
	Если ПрошлыйИзмененныйРодительОбъектаДоступа = Неопределено Или Отказ Тогда
		Возврат;
	КонецЕсли;
	
	МассивРодительскихЭлементов = Новый Массив;
	ТекущийРодитель = Ссылка.Родитель;
	Пока ЗначениеЗаполнено(ТекущийРодитель) Цикл
		МассивРодительскихЭлементов.Добавить(ТекущийРодитель);
		ТекущийРодитель = ТекущийРодитель.Родитель;
	КонецЦикла; 
	
	ТекущийРодитель = ПрошлыйИзмененныйРодительОбъектаДоступа;
	Пока ЗначениеЗаполнено(ТекущийРодитель) Цикл
		МассивРодительскихЭлементов.Добавить(ТекущийРодитель);
		ТекущийРодитель = ТекущийРодитель.Родитель;
	КонецЦикла; 
	ШапкаОшибки = "Права " + Ссылка + " не записан!";
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ПраваДоступаПользователей.ОбъектДоступа КАК Ссылка
	|ИЗ
	|	РегистрСведений.НастройкиПравДоступаПользователей КАК ПраваДоступаПользователей
	|ГДЕ
	|	(ПраваДоступаПользователей.ОбъектДоступа.Ссылка В ИЕРАРХИИ (&Ссылка)
	|			ИЛИ ПраваДоступаПользователей.ОбъектДоступа.Ссылка В (&Родители))
	|	И ПраваДоступаПользователей.ОбъектДоступа = ПраваДоступаПользователей.ВладелецПравДоступа";
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Родители", МассивРодительскихЭлементов);
	
	ОбновляемыеОбъекты = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
	Для каждого ОбновляемыйОбъект Из ОбновляемыеОбъекты Цикл
		
		////Дима 15.08.2014 10:30:46////Закомментировал, т.к. нет модуля "Полные права"
		////Если Не ПолныеПрава.ОбновитьПраваДоступаПользователейПоВладельцуДоступа(ОбновляемыйОбъект) Тогда
		//	Отказ = Истина;
		//	ОбщегоНазначения.СообщитьОбОшибке(ОписаниеОшибки()+Символы.ПС+ " .Не записаны права доступа к объекту: " + Ссылка);
		//	Возврат;
		//КонецЕсли;
		
	КонецЦикла;
	
	#Если Клиент Тогда
		Оповестить("ЗаписаныПраваДоступаПользователейКОбъекту");
	#КонецЕсли
	
КонецПроцедуры // () 

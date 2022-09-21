#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Перем ТребуетсяКонтроль;
Перем ТаблицаКонтроля;

Процедура ПередЗаписью(Отказ, Замещение)
	
	// Проверка значения свойства ОбменДанными.Загрузка отсутствует по причине того, что ограничения,
	// накладываемые данным кодом, не должны обходить установкой этого свойства равным Истина
	// (на стороне кода, который выполняет попытку записи в данный регистр).
	//
	// Данный регистр не должен входить в любые обмены или операции выгрузки / загрузки данных при включенном
	// разделении по областям данных.
	
	ТребуетсяКонтроль = ОбщегоНазначенияПовтИсп.РазделениеВключено() И ОбщегоНазначенияПовтИсп.ДоступноИспользованиеРазделенныхДанных();
	
	Если ТребуетсяКонтроль Тогда
		
		ПараметрыПолучения = Неопределено;
		Если Не ДополнительныеСвойства.Свойство("ПараметрыПолучения", ПараметрыПолучения) Тогда
			
			ВызватьИсключение НСтр("ru = 'При записи данных в регистр сведений КэшПрограммныхИнтерфейсов из сеансов 
                                    |с включенным разделением требуется передавать параметры получения данных для кэша
                                    |интерфейсов в дополнительном свойстве набора записей ПараметрыПолучения!'");
			
		КонецЕсли;
		
		Для Каждого Запись Из ЭтотОбъект Цикл
			
			Данные = ОбщегоНазначения.ПодготовитьДанныеКэшаВерсий(
				Запись.ТипДанных, ПараметрыПолучения);
			Запись.Данные = Новый ХранилищеЗначения(Данные);
			
		КонецЦикла;
		
		ТаблицаКонтроля = ЭтотОбъект.Выгрузить();
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	// Проверка значения свойства ОбменДанными.Загрузка отсутствует по причине того, что ограничения,
	// накладываемые данным кодом, не должны обходить установкой этого свойства равным Истина
	// (на стороне кода, который выполняет попытку записи в данный регистр).
	//
	// Данный регистр не должен входить в любые обмены или операции выгрузки / загрузки данных при включенном
	// разделении по областям данных.
	
	Если ТребуетсяКонтроль Тогда
		
		Для Каждого Запись Из ЭтотОбъект Цикл
			
			КонтрольныеСтроки = ТаблицаКонтроля.НайтиСтроки(
				Новый Структура("Идентификатор, ТипДанных", Запись.Идентификатор, Запись.ТипДанных));
			
			Если КонтрольныеСтроки.Количество() <> 1 Тогда
				ОшибкаКонтроля();
			Иначе
				
				КонтрольнаяСтрока = КонтрольныеСтроки.Получить(0);
				
				ТекущиеДанные = ОбщегоНазначения.ЗначениеВСтрокуXML(Запись.Данные.Получить());
				КонтрольныеДанные = ОбщегоНазначения.ЗначениеВСтрокуXML(КонтрольнаяСтрока.Данные.Получить());
				
				Если ТекущиеДанные <> КонтрольныеДанные Тогда
					ОшибкаКонтроля();
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОшибкаКонтроля()
	
	ВызватьИсключение НСтр("ru = 'Недопустимое изменение ресурса Данные записи регистра сведений КэшПрограммныхИнтерфейсов
                            |внутри транзакции записи из сеанса с включенным разделением!'");
	
КонецПроцедуры

#КонецЕсли

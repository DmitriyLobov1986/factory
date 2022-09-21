////////////////////////////////////////////////////////////////////////////////
// Подсистема "Банки".
// Процедуры и функции получения, сортировки данных классификатора
// банков РФ, запись полученных данных в справочник КлассификаторБанковРФ,
// обработка данных справочника КлассификаторБанковРФ.
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

////////////////////////////////////////////////////////////////////////////////
// Работа с данными справочника КлассификаторБанковРФ

// Получает данные из справочника КлассификаторБанковРФ по значениям БИК и КоррСчета 
// 
// Параметры
//  БИК			 - Строка					   - Значение БИК
//  КоррСчет	 - Строка					   - Значение корр.счета
//  ЗаписьОБанке - СправочникСсылка или строка - результат выборки
Процедура ПолучитьДанныеКлассификатораРФ(БИК = "", КоррСчет = "", ЗаписьОБанке) Экспорт
	Если Не ПустаяСтрока(БИК) Тогда
		КлассификаторБанковРФ = Справочники.КлассификаторБанковРФ;
		ЗаписьОБанке		  = КлассификаторБанковРФ.НайтиПоКоду(БИК);
		Если ЗаписьОБанке.Пустая() Тогда
			ЗаписьОБанке = "";
		КонецЕсли;	
	ИначеЕсли Не ПустаяСтрока(КоррСчет) Тогда
		КлассификаторБанковРФ = Справочники.КлассификаторБанковРФ;
		ЗаписьОБанке = КлассификаторБанковРФ.НайтиПоРеквизиту("КоррСчет", КоррСчет);
		Если ЗаписьОБанке.Пустая() Тогда
			ЗаписьОБанке = "";
		КонецЕсли;	
	Иначе
		ЗаписьОБанке = "";
	КонецЕсли;
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЙ ПРОГРАММНЫЙ ИНТЕРФЕЙС

// См. описание этой же процедуры в модуле СтандартныеПодсистемыСервер.
Процедура ПриДобавленииОбработчиковСлужебныхСобытий(КлиентскиеОбработчики, СерверныеОбработчики) Экспорт
	
	// КЛИЕНТСКИЕ ОБРАБОТЧИКИ.
	
	КлиентскиеОбработчики["СтандартныеПодсистемы.БазоваяФункциональность\ПриНачалеРаботыСистемы"].Добавить(
		"РаботаСБанкамиКлиент");
	
	// СЕРВЕРНЫЕ ОБРАБОТЧИКИ.
	
	СерверныеОбработчики["СтандартныеПодсистемы.БазоваяФункциональность\ПриДобавленииПараметровРаботыКлиентаПриЗапуске"].Добавить(
		"РаботаСБанками");
	
	Если ОбщегоНазначенияКлиентСервер.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса.ОчередьЗаданий") Тогда
		СерверныеОбработчики["СтандартныеПодсистемы.РаботаВМоделиСервиса.ОчередьЗаданий\ПриОпределенииИспользованияРегламентныхЗаданий"].Добавить(
			"РаботаСБанками");
	КонецЕсли;
		
	Если ОбщегоНазначенияКлиентСервер.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса") Тогда
		СерверныеОбработчики["СтандартныеПодсистемы.РаботаВМоделиСервиса.ВыгрузкаЗагрузкаДанных\ПриОпределенииСтандартныхТиповОбщихДанных"].Добавить(
			"РаботаСБанками");
	КонецЕсли;
	
КонецПроцедуры

// Заполняет параметры, которые используется клиентским кодом на запуске конфигурации.
//
// Параметры:
//   Параметры (Структура) Параметры запуска.
//
Процедура ПриДобавленииПараметровРаботыКлиентаПриЗапуске(Параметры) Экспорт
	
	ВыводитьОповещениеОНеактуальности = (
		Не ОбщегоНазначенияПовтИсп.РазделениеВключено() // В модели сервиса обновляется автоматически.
		И Не ОбщегоНазначения.ЭтоПодчиненныйУзелРИБ() // В узле РИБ обновляется автоматически.
		И ПравоДоступа("Изменение", Метаданные.Справочники.КлассификаторБанковРФ) // Пользователь с необходимыми правами.
		И Не КлассификаторАктуален()); // Классификатор уже обновлен.
		
	РаботаСБанкамиПереопределяемый.ПриОпределенииНеобходимостиПоказаПредупрежденияОбУстаревшемКлассификатореБанков(ВыводитьОповещениеОНеактуальности);
	
	Параметры.Вставить("Банки", Новый ФиксированнаяСтруктура("ВыводитьОповещениеОНеактуальности", ВыводитьОповещениеОНеактуальности));
	
КонецПроцедуры

// Добавляет в таблицу информацию о регламентных заданиях подсистемы для модели сервиса.
//
// Параметры:
//   ТаблицаИспользования (ТаблицаЗначений) Таблица регламентных заданий.
//      |- РегламентноеЗадание (Строка) Имя предопределенного регламентного задания.
//      |- Использование       (Булево) Истина, если регламентное задание должно
//                                      выполняться в модели сервиса.
//
Процедура ПриОпределенииИспользованияРегламентныхЗаданий(ТаблицаИспользования) Экспорт
	
	НоваяСтрока = ТаблицаИспользования.Добавить();
	НоваяСтрока.РегламентноеЗадание = "ЗагрузкаКлассификатораБанковРФССайтаРБК";
	НоваяСтрока.Использование       = Ложь;
	
КонецПроцедуры

// Заполняет массив типов неразделенных данных. Он используется при обновлении ссылок 
// при загрузке-выгрузке конфигурации
// 
// Параметры:
//    МассивТипов - массив
//
Процедура ПриОпределенииСтандартныхТиповОбщихДанных(Знач МассивТипов) Экспорт
	
	МассивТипов.Добавить(Тип("СправочникСсылка.КлассификаторБанковРФ"));
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

////////////////////////////////////////////////////////////////////////////////
// Работа с данными сайта РБК

// Формирует, дополняет текст сообщения пользователю в случае, если загрузка данных классификатора проведена успешно
// 
// Параметры
//	ПараметрыЗагрузкиКлассификатора - Соответствие:
//	Загружено						- Число  - Количество новых записей классификатора
//	Обновлено						- Число  - Количество обновленных записей классификатора
//	ТекстСообщения					- Строка - тест сообщения о результатах загрузки
//	ЗагрузкаВыполнена               - Булево - флаг успешного завершения загрузки данных классификатора
//
Процедура ДополнитьТекстСообщения(ПараметрыЗагрузкиКлассификатора) Экспорт
	
	Если ПустаяСтрока(ПараметрыЗагрузкиКлассификатора["ТекстСообщения"]) Тогда
		ТекстСообщения = НСтр("ru ='Загрузка классификатора банков РФ выполнена успешно.'");
	Иначе
		ТекстСообщения = ПараметрыЗагрузкиКлассификатора["ТекстСообщения"];
	КонецЕсли;
	
	Если ПараметрыЗагрузкиКлассификатора["Загружено"] > 0 Тогда
		
		ТекстСообщения = ТекстСообщения + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru ='
		|Загружено новых: %1.'"), ПараметрыЗагрузкиКлассификатора["Загружено"]);
	
	КонецЕсли;
	
	Если ПараметрыЗагрузкиКлассификатора["Обновлено"] > 0 Тогда
		
		ТекстСообщения = ТекстСообщения + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru ='
		|Обновлено записей: %1.'"), ПараметрыЗагрузкиКлассификатора["Обновлено"]);

	КонецЕсли;
	
	ПараметрыЗагрузкиКлассификатора.Вставить("ТекстСообщения", ТекстСообщения);
	
КонецПроцедуры	

// Получает, сортирует, записывает данные классификатора БИК РФ с сайта РБК
// 
// Параметры
//	ПараметрыЗагрузкиКлассификатора - Соответствие:
//	Загружено						- Число	 - Количество новых записей классификатора
//	Обновлено						- Число	 - Количество обновленных записей классификатора
//	ТекстСообщения					- Строка - тест сообщения о результатах загрузки
//	ЗагрузкаВыполнена               - Булево - флаг успешного завершения загрузки данных классификатора
//	АдресХранилища					- Строка - адрес внутреннего хранилища.
Процедура ПолучитьДанныеРБК(ПараметрыЗагрузкиКлассификатора, АдресХранилища = "") Экспорт
	ВременныйКаталог = ПолучитьИмяВременногоФайла();
	СоздатьКаталог(ВременныйКаталог);
	
	ПараметрыПолученияФайловРБК = Новый Соответствие;
	ПараметрыПолученияФайловРБК.Вставить("ПутьКФайлуРБК", "");
	ПараметрыПолученияФайловРБК.Вставить("ТекстСообщения", ПараметрыЗагрузкиКлассификатора["ТекстСообщения"]);
	ПараметрыПолученияФайловРБК.Вставить("ВременныйКаталог", ВременныйКаталог);
	
	ПолучитьДанныеРБКИзИнтернета(ПараметрыПолученияФайловРБК);
	
	Если Не ПустаяСтрока(ПараметрыПолученияФайловРБК["ТекстСообщения"]) Тогда
		ПараметрыЗагрузкиКлассификатора.Вставить("ТекстСообщения", ПараметрыПолученияФайловРБК["ТекстСообщения"]);
		Если НЕ ПустаяСтрока(АдресХранилища) Тогда
			ПоместитьВоВременноеХранилище(ПараметрыЗагрузкиКлассификатора, АдресХранилища);
		КонецЕсли;		
		Возврат;
	КонецЕсли;
	
	Попытка
		ZIPФайлРБК = Новый ЧтениеZipФайла(ПараметрыПолученияФайловРБК["ПутьКФайлуРБК"]);
	Исключение
		ТекстСообщения = НСтр("ru ='Возникли проблемы с файлом классификатора банков, полученным с сайта РБК.'");
		ТекстСообщения = ТекстСообщения + ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
	КонецПопытки;
	
	Если Не ПустаяСтрока(ТекстСообщения) Тогда
		ПараметрыЗагрузкиКлассификатора.Вставить("ТекстСообщения", ТекстСообщения);
		Если НЕ ПустаяСтрока(АдресХранилища) Тогда
			ПоместитьВоВременноеХранилище(ПараметрыЗагрузкиКлассификатора, АдресХранилища);
		КонецЕсли;		
		Возврат;
	КонецЕсли;
	
	Попытка
		ZIPФайлРБК.ИзвлечьВсе(ВременныйКаталог);
	Исключение
		ТекстСообщения = НСтр("ru ='Возникли проблемы с файлом классификатора банков, полученным с сайта РБК.'");
		ТекстСообщения = ТекстСообщения + ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
	КонецПопытки;	
	
	Если Не ПустаяСтрока(ТекстСообщения) Тогда
		ПараметрыЗагрузкиКлассификатора.Вставить("ТекстСообщения", ТекстСообщения);
		Если НЕ ПустаяСтрока(АдресХранилища) Тогда
			ПоместитьВоВременноеХранилище(ПараметрыЗагрузкиКлассификатора, АдресХранилища);
		КонецЕсли;		
		Возврат;
	КонецЕсли;
	
	ПутьКФайлуБИКРБК = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(ВременныйКаталог) + "bnkseek.txt";
	ФайлБИКРБК	   = Новый Файл(ПутьКФайлуБИКРБК);
	Если Не ФайлБИКРБК.Существует() Тогда
		ТекстСообщения = НСтр("ru ='Возникли проблемы с файлом классификатора банков, полученным с сайта РБК. 
									|Архив не содержит информацию - классификатор банков.'");
		ПараметрыЗагрузкиКлассификатора.Вставить("ТекстСообщения", ТекстСообщения);
		Если НЕ ПустаяСтрока(АдресХранилища) Тогда
			ПоместитьВоВременноеХранилище(ПараметрыЗагрузкиКлассификатора, АдресХранилища);
		КонецЕсли;		
		Возврат;
	КонецЕсли;
	
	ПутьКФайлуРегионовРБК = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(ВременныйКаталог) + "reg.txt";
	ФайлРегионовРБК		= Новый Файл(ПутьКФайлуРегионовРБК);
	Если Не ФайлРегионовРБК.Существует() Тогда
		ТекстСообщения = НСтр("ru ='Возникли проблемы с файлом классификатора банков, полученным с сайта РБК. 
									|Архив не содержит информацию о регионах.'");
		ПараметрыЗагрузкиКлассификатора.Вставить("ТекстСообщения", ТекстСообщения);
		Если НЕ ПустаяСтрока(АдресХранилища) Тогда
			ПоместитьВоВременноеХранилище(ПараметрыЗагрузкиКлассификатора, АдресХранилища);
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	ПутьКФайлуНедействующихБанков = ИмяФайлаНедействующихБанков(ВременныйКаталог);
	ФайлНедействующихБанков = Новый Файл(ПутьКФайлуНедействующихБанков);
	Если Не ФайлНедействующихБанков.Существует() Тогда
		ТекстСообщения = НСтр("ru ='Возникли проблемы с файлом классификатора банков, полученным с сайта РБК. 
									|Архив не содержит информацию о недействующих банках.'");
		ПараметрыЗагрузкиКлассификатора.Вставить("ТекстСообщения", ТекстСообщения);
		Если НЕ ПустаяСтрока(АдресХранилища) Тогда
			ПоместитьВоВременноеХранилище(ПараметрыЗагрузкиКлассификатора, АдресХранилища);
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	ПараметрыЗагрузкиФайловРБК = Новый Соответствие;
	ПараметрыЗагрузкиФайловРБК.Вставить("ПутьКФайлуБИКРБК", ПутьКФайлуБИКРБК);
	ПараметрыЗагрузкиФайловРБК.Вставить("ПутьКФайлуРегионовРБК", ПутьКФайлуРегионовРБК);
	ПараметрыЗагрузкиФайловРБК.Вставить("ПутьКФайлуНедействующихБанков", ПутьКФайлуНедействующихБанков);
	ПараметрыЗагрузкиФайловРБК.Вставить("ВременныйКаталог", ВременныйКаталог);
	ПараметрыЗагрузкиФайловРБК.Вставить("Загружено", ПараметрыЗагрузкиКлассификатора["Загружено"]);
	ПараметрыЗагрузкиФайловРБК.Вставить("Обновлено", ПараметрыЗагрузкиКлассификатора["Обновлено"]);
	ПараметрыЗагрузкиФайловРБК.Вставить("ТекстСообщения", ПараметрыЗагрузкиКлассификатора["ТекстСообщения"]);
	
	ЗагрузитьДанныеРБК(ПараметрыЗагрузкиФайловРБК);
	
	Если Не ПустаяСтрока(ПараметрыЗагрузкиФайловРБК["ТекстСообщения"]) Тогда
		Если НЕ ПустаяСтрока(АдресХранилища) Тогда
			ПоместитьВоВременноеХранилище(ПараметрыЗагрузкиКлассификатора, АдресХранилища);
		КонецЕсли;		
		Возврат;
	КонецЕсли;
	
	УстановитьВерсиюКлассификатораБанков();
	УдалитьФайлы(ВременныйКаталог);
	
	ПараметрыЗагрузкиКлассификатора.Вставить("Загружено", ПараметрыЗагрузкиФайловРБК["Загружено"]);
	ПараметрыЗагрузкиКлассификатора.Вставить("Обновлено", ПараметрыЗагрузкиФайловРБК["Обновлено"]);
	ПараметрыЗагрузкиКлассификатора.Вставить("ТекстСообщения", ПараметрыЗагрузкиФайловРБК["ТекстСообщения"]);
	ПараметрыЗагрузкиКлассификатора.Вставить("ЗагрузкаВыполнена", Истина);
	
	ДополнитьТекстСообщения(ПараметрыЗагрузкиКлассификатора);
	
	Если НЕ ПустаяСтрока(АдресХранилища) Тогда
		ПоместитьВоВременноеХранилище(ПараметрыЗагрузкиКлассификатора, АдресХранилища);
	КонецЕсли;
	
КонецПроцедуры

// Получает, сортирует, записывает данные классификатора БИК РФ с сайта РБК;
//
Процедура ЗагрузитьКлассификаторБанков() Экспорт
	
	Если ПустаяСтрока(ИмяПользователя()) Тогда
		УстановитьПривилегированныйРежим(Истина);
	КонецЕсли;
	
	ИмяСобытия	 = НСтр("ru ='Загрузка классификатора банков. Сайт РБК'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
	УровеньСобытия = УровеньЖурналаРегистрации.Информация;
	
	Если ОбщегоНазначения.ЭтоПодчиненныйУзелРИБ() Тогда
		ЗаписьЖурналаРегистрации(ИмяСобытия, УровеньСобытия, , , НСтр("ru = 'Загрузка в подчиненном узле РИБ не предусмотрена'"));
		Возврат;
	КонецЕсли;
	
	ПараметрыЗагрузкиКлассификатора = Новый Соответствие;
	ПараметрыЗагрузкиКлассификатора.Вставить("Загружено", 0);
	ПараметрыЗагрузкиКлассификатора.Вставить("Обновлено", 0);
	ПараметрыЗагрузкиКлассификатора.Вставить("ТекстСообщения", "");
	ПараметрыЗагрузкиКлассификатора.Вставить("ЗагрузкаВыполнена", Ложь);
	
	ПолучитьДанныеРБК(ПараметрыЗагрузкиКлассификатора);
	
	Если ПараметрыЗагрузкиКлассификатора["ЗагрузкаВыполнена"] Тогда
		Если ПустаяСтрока(ПараметрыЗагрузкиКлассификатора["ТекстСообщения"]) Тогда
			ДополнитьТекстСообщения(ПараметрыЗагрузкиКлассификатора);
		КонецЕсли;
	Иначе
		УровеньСобытия = УровеньЖурналаРегистрации.Ошибка;
	КонецЕсли;
	
	ЗаписьЖурналаРегистрации(ИмяСобытия, УровеньСобытия, , , ПараметрыЗагрузкиКлассификатора["ТекстСообщения"]);
	
КонецПроцедуры
 
// Сортирует, записывает данные классификатора БИК РФ с сайта РБК
// 
// Параметры
//	ПараметрыЗагрузкиФайловРБК - Соответствие:
//  ПутьКФайлуБИКРБК		   - Строка - путь к файлу с данными классификатора, размещенному во временном каталоге
//  ПутьКФайлуРегионовРБК	   - Строка - путь к файлу с информацией о регионах, размещенному во временном каталоге
//	Загружено				   - Число	- количество новых записей классификатора
//	Обновлено				   - Число	- количество обновленных записей классификатора
//	ТекстСообщения			   - Строка	- тест сообщения о результатах загрузки
//	ЗагрузкаВыполнена          - Булево - флаг успешного завершения загрузки данных классификатора
//
Процедура ЗагрузитьДанныеРБК(ПараметрыЗагрузкиФайловРБК) Экспорт
	
	СоответствиеРегионов = ПолучитьСоответствиеРегионов(ПараметрыЗагрузкиФайловРБК["ПутьКФайлуРегионовРБК"]);
	
	ТекстБИКРБК		   = Новый ЧтениеТекста(ПараметрыЗагрузкиФайловРБК["ПутьКФайлуБИКРБК"], "windows-1251");
	СтрокаТекстаБИКРБК = ТекстБИКРБК.ПрочитатьСтроку();
	
	ДатаЗагрузки = ТекущаяУниверсальнаяДата();
	
	ПараметрыЗагрузкиДанныхРБК = Новый Соответствие;
	ПараметрыЗагрузкиДанныхРБК.Вставить("Загружено", ПараметрыЗагрузкиФайловРБК["Загружено"]);
	ПараметрыЗагрузкиДанныхРБК.Вставить("Обновлено", ПараметрыЗагрузкиФайловРБК["Обновлено"]);
	
	Пока СтрокаТекстаБИКРБК <> Неопределено Цикл
		
		Строка = СтрокаТекстаБИКРБК;
	
		Если ПустаяСтрока(СокрЛП(Строка)) Тогда
			Продолжить;
		КонецЕсли;
		
		СтруктураБанк  = ПолучитьСтруктуруПолейБанка(Строка, СоответствиеРегионов);
		СтрокаТекстаБИКРБК = ТекстБИКРБК.ПрочитатьСтроку();
		
		Если ПустаяСтрока(СтруктураБанк) Тогда
			Продолжить;
		КонецЕсли;
		
		ПараметрыЗагрузкиДанныхРБК.Вставить("СтруктураБанк", СтруктураБанк);
		ЗаписатьЭлементКлассификатораБанковРФ(ПараметрыЗагрузкиДанныхРБК);
		
	КонецЦикла;
	
	// пометка недействующих банков
	ДействующиеБанки = ДействующиеБанкиИзФайла(ПараметрыЗагрузкиФайловРБК["ПутьКФайлуБИКРБК"]);
	НедействующиеБанки = НедействующиеБанкиИзФайла(ПараметрыЗагрузкиФайловРБК["ПутьКФайлуНедействующихБанков"]);
	КоличествоОтмеченных = ОтметитьНедействующиеБанки(ДействующиеБанки, НедействующиеБанки);
	ПараметрыЗагрузкиДанныхРБК["Обновлено"] = ПараметрыЗагрузкиДанныхРБК["Обновлено"] + КоличествоОтмеченных;
	
	ПараметрыЗагрузкиФайловРБК.Вставить("Загружено", ПараметрыЗагрузкиДанныхРБК["Загружено"]);
	ПараметрыЗагрузкиФайловРБК.Вставить("Обновлено", ПараметрыЗагрузкиДанныхРБК["Обновлено"]);
КонецПроцедуры 

// Получает файл http://cbrates.rbc.ru/bnk/bnk.zip.
// Параметры:
//	ПараметрыПолученияФайловРБК - Соответствие:
//	ПутьКФайлуРБК				- Строка - путь к полученному файлу, размещенному во временном каталоге
//	ВременныйКаталог			- Строка - путь к временному каталогу
//  ТекстСообщения				- Строка - текст сообщения об ошибке
Процедура ПолучитьДанныеРБКИзИнтернета(ПараметрыПолученияФайловРБК) Экспорт

	ТекстСообщения = "";
	ПутьКФайлуРБК  = "";
	
	СерверИсточник = "cbrates.rbc.ru";
	Адрес          = "bnk";
	ФайлБИК        = "bnk.zip";
		
	ФайлРБКНаВебСервере  = "http://" + СерверИсточник + "/" + Адрес+ "/" + ФайлБИК;
	ВременныйФайлРБК	 = ПараметрыПолученияФайловРБК["ВременныйКаталог"]+ "\" + ФайлБИК;
	ПараметрыПолучения	 = Новый Структура("ПутьДляСохранения");
	ПараметрыПолучения. Вставить("ПутьДляСохранения", ВременныйФайлРБК);
	РезультатИзИнтернета = ПолучениеФайловИзИнтернета.СкачатьФайлНаСервере(ФайлРБКНаВебСервере, ПараметрыПолучения);
   		
	Если РезультатИзИнтернета.Статус Тогда
		
		ПараметрыПолученияФайловРБК.Вставить("ПутьКФайлуРБК", РезультатИзИнтернета.Путь);
		
	Иначе
		Если ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
			ДополнительноеСообщение = 
				НСтр("ru ='
				|Возможно неточные или неправильные настройки подключения к Интернету.'");
		Иначе
			ДополнительноеСообщение =
				НСтр("ru ='
				|Возможно неточные или неправильные настройки подключения к Интернету на сервере 1С:Предприятие.'");
		КонецЕсли;	
		
		СообщениеОбОшибке = РезультатИзИнтернета.СообщениеОбОшибке + ДополнительноеСообщение; 
		
		ПараметрыПолученияФайловРБК.Вставить("ТекстСообщения", СообщениеОбОшибке);
	КонецЕсли;
		  	
КонецПроцедуры	

// Определяет по коду типа города строку типа города
// Параметры:
//  КодТипа - Строка - код типа населенного пункта
// Возвращаемое значение:
//  сокращенная строка типа населенного пункта
//
Функция ОпределитьТипГородаПоКоду(КодТипа)
	
	Если КодТипа = "1" Тогда
		Возврат "Г.";       // ГОРОД
	ИначеЕсли КодТипа = "2" Тогда
		Возврат "П.";       // ПОСЕЛОК
	ИначеЕсли КодТипа = "3" Тогда
		Возврат "С.";       // СЕЛО
	ИначеЕсли КодТипа = "4" Тогда
		Возврат "ПГТ.";     // ПОСЕЛОК ГОРОДСКОГО ТИПА
	ИначеЕсли КодТипа = "5" Тогда
		Возврат "СТ-ЦА.";   // СТАНИЦА
	ИначеЕсли КодТипа = "6" Тогда
		Возврат "АУЛ.";     // АУЛ
	ИначеЕсли КодТипа = "7" Тогда
		Возврат "РП.";      // РАБОЧИЙ ПОСЕЛОК 
	Иначе
		Возврат "";
	КонецЕсли;
	
КонецФункции

// Формирует соответствие кодов регионов и регионов.
// Параметры:
//	ПутьКФайлуРегионовРБК - Строка	   - путь к файлу с информацией о регионах, размещенному во временном каталоге 
// Возвращаемое значение:
//	СоответствиеРегионов  - Соответсвие - Код региона и регион
//	
Функция ПолучитьСоответствиеРегионов(ПутьКФайлуРегионовРБК)
	
	Разделитель					= Символы.Таб;
	СоответствиеРегионов		= Новый Соответствие;
	РегионыРБКТекстовыйДокумент = Новый ЧтениеТекста(ПутьКФайлуРегионовРБК, "windows-1251");
	СтрокаРегионовРБК			= РегионыРБКТекстовыйДокумент.ПрочитатьСтроку();
	
	Пока СтрокаРегионовРБК <> Неопределено Цикл

		Строка			  = СтрокаРегионовРБК;
		СтрокаРегионовРБК = РегионыРБКТекстовыйДокумент.ПрочитатьСтроку();

		Если (Лев(Строка,2) = "//") или (ПустаяСтрока(Строка)) Тогда
			Продолжить;
		КонецЕсли;
		
		МассивПодстрок = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Строка, Разделитель);
		
		Если МассивПодстрок.Количество() < 2 Тогда
			Продолжить;
		КонецЕсли;	
		
		Символ1 = СокрЛП(МассивПодстрок[0]);
        Символ2 = СокрЛП(МассивПодстрок[1]);
        		 		
		// Дополним код региона до двух знаков.
		Если СтрДлина(Символ1) = 1 Тогда
			Символ1 = "0" + Символ1;
		КонецЕсли;
		
		СоответствиеРегионов.Вставить(Символ1, Символ2);
 	КонецЦикла;	
		
	Возврат СоответствиеРегионов;

КонецФункции // ПолучитьСоответствиеРегионов()

// Формирует структуру полей для банка.
// Параметры:
//	Строка  - Строка	   - Строка из текстового файла классификатора
//	Регионы - Соответствие - Код региона и регион банка
// Возвращаемое значение:
//	Банк - Структура - Реквизиты банка
//
Функция ПолучитьСтруктуруПолейБанка(Знач Строка, Регионы)
	
	Банк		= Новый Структура;
	Разделитель = Символы.Таб;
			
	Пункт		 = "";
	ТипПункта	 = "";
	Наименование = "";
	ПризнакКода	 = "";
	БИК			 = "";
	КорСчет		 = "";
	
	МассивПодстрок = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Строка, Разделитель);
	
	Если МассивПодстрок.Количество() < 7 Тогда
		Возврат "";
	КонецЕсли;	
	
	Пункт		 = СокрЛП(МассивПодстрок[1]);
	ТипПункта    = ОпределитьТипГородаПоКоду(СокрЛП(МассивПодстрок[2]));
    Наименование = СокрЛП(МассивПодстрок[3]);
	ПризнакКода  = СокрЛП(МассивПодстрок[4]);
	БИК			 = СокрЛП(МассивПодстрок[5]);
    КоррСчет	 = СокрЛП(МассивПодстрок[6]);
 		
	Если СтрДлина(БИК) <> 9 Тогда
		Возврат "";
	КонецЕсли;		
		
	Банк.Вставить("БИК",		  БИК);
	Банк.Вставить("КоррСчет",	  КоррСчет);
	Банк.Вставить("Наименование", Наименование);
	Банк.Вставить("Город",		  СокрЛП(ТипПункта + " " + Пункт));
	Банк.Вставить("Телефоны",     "");
	Банк.Вставить("Адрес",        "");
	
	КодРегиона = Сред(Банк.БИК, 3, 2);
	Регион	   = Регионы[КодРегиона];
	Если Регион <> Неопределено Тогда
		Банк.Вставить("КодРегиона", КодРегиона);
		Банк.Вставить("Регион", 	Регион);
	Иначе
		Возврат "";
	КонецЕсли;
		
	Возврат Банк;
		
КонецФункции

// Выполняет загрузку классификатора банков РФ из файла, полученного с сайта РБК.
Функция ЗагрузитьДанныеИзФайлаРБК(ИмяФайла) Экспорт
	
	ПапкаСИзвлеченнымиФайлами = ИзвлечьФайлыИзАрхива(ИмяФайла);
	Если ФайлыКлассификатораПолучены(ПапкаСИзвлеченнымиФайлами) Тогда
		Параметры = Новый Соответствие;
		Параметры.Вставить("ПутьКФайлуБИКРБК", ИмяФайлаБИКРБК(ПапкаСИзвлеченнымиФайлами));
		Параметры.Вставить("ПутьКФайлуРегионовРБК", ИмяФайлаРегионовРБК(ПапкаСИзвлеченнымиФайлами));
		Параметры.Вставить("ПутьКФайлуНедействующихБанков", ИмяФайлаНедействующихБанков(ПапкаСИзвлеченнымиФайлами));
		Параметры.Вставить("Загружено", 0);
		Параметры.Вставить("Обновлено", 0);
		Параметры.Вставить("ТекстСообщения", "");
		Параметры.Вставить("ЗагрузкаВыполнена", Неопределено);
		
		ЗагрузитьДанныеРБК(Параметры);
		УстановитьВерсиюКлассификатораБанков();
	КонецЕсли;
	
КонецФункции

Функция ФайлыКлассификатораПолучены(ПапкаСФайлами)
	
	Результат = Истина;
	
	ИменаФайловДляПроверки = Новый Массив;
	ИменаФайловДляПроверки.Добавить(ИмяФайлаБИКРБК(ПапкаСФайлами));
	ИменаФайловДляПроверки.Добавить(ИмяФайлаРегионовРБК(ПапкаСФайлами));
	ИменаФайловДляПроверки.Добавить(ИмяФайлаНедействующихБанков(ПапкаСФайлами));
	
	Для Каждого ИмяФайла Из ИменаФайловДляПроверки Цикл
		Файл = Новый Файл(ИмяФайла);
		Если Не Файл.Существует() Тогда
			ЗаписатьОшибкуВЖурналРегистрации(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Не найден файл %1'"),
					ИмяФайла));
			Результат = Ложь;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция ИзвлечьФайлыИзАрхива(ZipФайл)
	
	ВременнаяПапка = ПолучитьИмяВременногоФайла();
	СоздатьКаталог(ВременнаяПапка);
	
	Попытка
		ЧтениеZipФайла = Новый ЧтениеZipФайла(ZipФайл);
		ЧтениеZipФайла.ИзвлечьВсе(ВременнаяПапка);
	Исключение
		ЗаписатьОшибкуВЖурналРегистрации(ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		УдалитьФайлы(ВременнаяПапка);
	КонецПопытки;
	
	Возврат ВременнаяПапка;
	
КонецФункции

Функция ИмяФайлаРегионовРБК(ПапкаСФайламиКлассификатора)
	
	Возврат ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(ПапкаСФайламиКлассификатора) + "reg.txt";
	
КонецФункции

Функция ИмяФайлаБИКРБК(ПапкаСФайламиКлассификатора)
	
	Возврат ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(ПапкаСФайламиКлассификатора) + "bnkseek.txt";
	
КонецФункции

Функция ИмяФайлаНедействующихБанков(ПапкаСФайламиКлассификатора)
	
	Возврат ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(ПапкаСФайламиКлассификатора) + "bnkdel.txt";
	
КонецФункции

Процедура ЗаписатьОшибкуВЖурналРегистрации(ТекстОшибки)
	
	ЗаписьЖурналаРегистрации(ИмяСобытияВЖурналеРегистрации(), УровеньЖурналаРегистрации.Ошибка,,, ТекстОшибки);
	
КонецПроцедуры

Функция ИмяСобытияВЖурналеРегистрации()
	
	Возврат НСтр("ru = 'Загрузка классификатора банков. Сайт РБК'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
	
КонецФункции

Функция НедействующиеБанкиИзФайла(ПутьКФайлу)
	
	Результат = Новый ТаблицаЗначений;
	Результат.Колонки.Добавить("БИК", Новый ОписаниеТипов("Строка",,Новый КвалификаторыСтроки(9)));
	Результат.Колонки.Добавить("Наименование", Новый ОписаниеТипов("Строка",,Новый КвалификаторыСтроки(100)));
	Результат.Колонки.Добавить("ДатаЗакрытия", Новый ОписаниеТипов("Дата",,,Новый КвалификаторыДаты(ЧастиДаты.Дата)));
	
	ЧтениеТекста = Новый ЧтениеТекста(ПутьКФайлу, "windows-1251");
	
	Строка = ЧтениеТекста.ПрочитатьСтроку();
	Пока Строка <> Неопределено Цикл
		СведенияОБанке = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Строка, Символы.Таб);
		Если СведенияОБанке.Количество() <> 8 Тогда
			Продолжить;
		КонецЕсли;
		Банк = Результат.Добавить();
		Банк.БИК = СведенияОБанке[6];
		Банк.Наименование = СведенияОБанке[4];
		Банк.ДатаЗакрытия = СведенияОБанке[1];
		
		Строка = ЧтениеТекста.ПрочитатьСтроку();
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция ДействующиеБанкиИзФайла(ПутьКФайлу)
	
	Результат = Новый ТаблицаЗначений;
	Результат.Колонки.Добавить("БИК", Новый ОписаниеТипов("Строка",,Новый КвалификаторыСтроки(9)));
	Результат.Колонки.Добавить("Наименование", Новый ОписаниеТипов("Строка",,Новый КвалификаторыСтроки(100)));
	
	ЧтениеТекста = Новый ЧтениеТекста(ПутьКФайлу, "windows-1251");
	
	Строка = ЧтениеТекста.ПрочитатьСтроку();
	Пока Строка <> Неопределено Цикл
		СведенияОБанке = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Строка, Символы.Таб);
		Если СведенияОБанке.Количество() <> 7 Тогда
			Продолжить;
		КонецЕсли;
		Банк = Результат.Добавить();
		Банк.БИК = СведенияОБанке[5];
		Банк.Наименование = СведенияОБанке[3];
		
		Строка = ЧтениеТекста.ПрочитатьСтроку();
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция ОтметитьНедействующиеБанки(ДействующиеБанки, НедействующиеБанки)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	НедействующиеБанки.БИК КАК БИК
	|ПОМЕСТИТЬ НедействующиеБанки
	|ИЗ
	|	&НедействующиеБанки КАК НедействующиеБанки
	|ГДЕ
	|	НЕ НедействующиеБанки.БИК В (&БИКи)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	БИК";
	Запрос.УстановитьПараметр("НедействующиеБанки", НедействующиеБанки);
	Запрос.УстановитьПараметр("БИКи", ДействующиеБанки.ВыгрузитьКолонку("БИК"));
	Запрос.Выполнить();
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	КлассификаторБанковРФ.Ссылка
	|ИЗ
	|	НедействующиеБанки КАК НедействующиеБанки
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.КлассификаторБанковРФ КАК КлассификаторБанковРФ
	|		ПО НедействующиеБанки.БИК = КлассификаторБанковРФ.Код
	|ГДЕ
	|	КлассификаторБанковРФ.ДеятельностьПрекращена = ЛОЖЬ
	|
	|СГРУППИРОВАТЬ ПО
	|	КлассификаторБанковРФ.Ссылка";
	
	ВыборкаБанков = Запрос.Выполнить().Выбрать();
	Пока ВыборкаБанков.Следующий() Цикл
		БанкОбъект = ВыборкаБанков.Ссылка.ПолучитьОбъект();
		БанкОбъект.ДеятельностьПрекращена = Истина;
		БанкОбъект.Записать();
	КонецЦикла;
	
	Возврат ВыборкаБанков.Количество();
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Работа с данными диска ИТС

// Сортирует, записывает данные классификатора БИК РФ с диска ИТС
// 
// Параметры
//	ПараметрыЗагрузкиФайловИТС		 - Соответствие:
//	ПодготовкаИТСАдресДвоичныхДанных - ВременноеХранилище - Обработка подготовки данных БИК ИТС
//  ДанныеИТСАдресДвоичныхДанных	 - ВременноеХранилище - Файл данных БИК ИТС
//	Загружено						 - Число		      - Количество новых записей классификатора
//	Обновлено						 - Число			  - Количество обновленных записей классификатора
//	ТекстСообщения					 - Строка			  - тест сообщения о результатах загрузки
//	ЗагрузкаВыполнена                - Булево             - флаг успешного завершения загрузки данных классификатора
//
Процедура ЗагрузитьДанныеДискИТС(ПараметрыЗагрузкиФайловИТС) Экспорт
	
	ВременныйКаталог = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(ПолучитьИмяВременногоФайла());
	СоздатьКаталог(ВременныйКаталог);
	
	ПодготовкаИТСДвоичныеДанные = ПолучитьИзВременногоХранилища(ПараметрыЗагрузкиФайловИТС["ПодготовкаИТСАдресДвоичныхДанных"]);
	ПодготовкаИТСПуть = ВременныйКаталог + "BIKr5v82_MA.epf";
	ПодготовкаИТСДвоичныеДанные.Записать(ПодготовкаИТСПуть);
	ОбработкаПодготовкиДанныхИТС = Новый Файл(ПодготовкаИТСПуть);
	
	ДанныеИТСДвоичныеДанные  = ПолучитьИзВременногоХранилища(ПараметрыЗагрузкиФайловИТС["ДанныеИТСАдресДвоичныхДанных"]);
	ПутьКДаннымИТС = ВременныйКаталог + "Morph.dlc";
	ДанныеИТСДвоичныеДанные.Записать(ПутьКДаннымИТС);
	ДанныеИТС = Новый ТекстовыйДокумент;
	ДанныеИТС.Прочитать(ПутьКДаннымИТС);
	
	ТаблицаКлассификатора = Новый ТаблицаЗначений;
	ТаблицаКлассификатора.Колонки.Добавить("БИК");
	ТаблицаКлассификатора.Колонки.Добавить("Наименование");
	ТаблицаКлассификатора.Колонки.Добавить("КоррСчет");
	ТаблицаКлассификатора.Колонки.Добавить("Город");
	ТаблицаКлассификатора.Колонки.Добавить("Адрес");
	ТаблицаКлассификатора.Колонки.Добавить("Телефоны");
	ТаблицаКлассификатора.Колонки.Добавить("КодРегиона");
	ТаблицаКлассификатора.Колонки.Добавить("Регион");
	
	ВнешняяОбработкаПодготовкиДанныхИТС = ВнешниеОбработки.Создать(ОбработкаПодготовкиДанныхИТС.ПолноеИмя);
	
	КоличествоСтрок = ДанныеИТС.КоличествоСтрок();
	
	СтрокаВерсии   = ДанныеИТС.ПолучитьСтроку(1);
	
	КоличествоЧастей = Окр(КоличествоСтрок/1000);
	СоответствиеРегионов = "";
	ТекстСообщения = "";
	ДатаВерсии = "";
	
	Для НомерЧасти = 1 По КоличествоЧастей Цикл	
		ВнешняяОбработкаПодготовкиДанныхИТС.СортироватьДанныеКлассификатора(ДанныеИТС, ТаблицаКлассификатора, 
																			СоответствиеРегионов, ДатаВерсии, 
																			НомерЧасти, ТекстСообщения);
		Если Не ПустаяСтрока(ТекстСообщения) Тогда
			Возврат;
		КонецЕсли;
		
		ПараметрыЗагрузкиДанныхИТС = Новый Соответствие;
		ПараметрыЗагрузкиДанныхИТС.Вставить("ТаблицаКлассификатора", ТаблицаКлассификатора);
		ПараметрыЗагрузкиДанныхИТС.Вставить("Загружено", ПараметрыЗагрузкиФайловИТС["Загружено"]);
		ПараметрыЗагрузкиДанныхИТС.Вставить("Обновлено", ПараметрыЗагрузкиФайловИТС["Обновлено"]);
		
		ЗаписатьДанныеКлассификатора(ПараметрыЗагрузкиДанныхИТС);
		
		ПараметрыЗагрузкиФайловИТС.Вставить("Загружено", ПараметрыЗагрузкиДанныхИТС["Загружено"]);
		ПараметрыЗагрузкиФайловИТС.Вставить("Обновлено", ПараметрыЗагрузкиДанныхИТС["Обновлено"]);
	
	КонецЦикла;
			
	УстановитьВерсиюКлассификатораБанков(ДатаВерсии);
	УдалитьФайлы(ВременныйКаталог);
	
	Если ПустаяСтрока(ПараметрыЗагрузкиФайловИТС["ТекстСообщения"]) Тогда
		ПараметрыЗагрузкиФайловИТС.Вставить("ЗагрузкаВыполнена", Истина);
		ДополнитьТекстСообщения(ПараметрыЗагрузкиФайловИТС);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Запись обработанных данных

/// Записывает/перезаписывает в справочник КлассификаторБанковРФ данные банка.
// Параметры:
//	ПараметрыЗагрузкиДанных - Соответствие:
//	СтруктураБанк			- Структура или СтрокаТаблицыЗначений - Данные банка
//	Загружено				- Число								 - Количество новых записей классификатора
//	Обновлено				- Число								 - Количество обновленных записей классификатора
//
Процедура ЗаписатьЭлементКлассификатораБанковРФ(ПараметрыЗагрузкиДанных)
	
	ФлагНовый		= Ложь;
	ФлагОбновленный = Ложь;
	Регион			= "";
	
	СтруктураБанк = ПараметрыЗагрузкиДанных["СтруктураБанк"];
	Загружено	  = ПараметрыЗагрузкиДанных["Загружено"];
	Обновлено	  = ПараметрыЗагрузкиДанных["Обновлено"];
	
	Если Не ПустаяСтрока(СтруктураБанк.КодРегиона) Тогда
		ТекущийРегион = Справочники.КлассификаторБанковРФ.НайтиПоКоду(СтруктураБанк.КодРегиона);
		Если ТекущийРегион.Пустая() Тогда
			Регион = Справочники.КлассификаторБанковРФ.СоздатьГруппу();
		Иначе
			Если ТекущийРегион.ЭтоГруппа Тогда 
				Регион = ТекущийРегион.ПолучитьОбъект();
			Иначе
				Регион = Справочники.КлассификаторБанковРФ.СоздатьГруппу();
			КонецЕсли;
		КонецЕсли;
		
		Если СокрЛП(Регион.Код) <> СокрЛП(СтруктураБанк.КодРегиона) Тогда
			Регион.Код = СокрЛП(СтруктураБанк.КодРегиона);
		КонецЕсли;
		
		Если СокрЛП(Регион.Наименование) <> СокрЛП(СтруктураБанк.Регион) Тогда
			Регион.Наименование = СокрЛП(СтруктураБанк.Регион);
		КонецЕсли;
		
		Если Регион.Модифицированность() Тогда
			Регион.Записать();
		КонецЕсли;
	КонецЕсли;	
	
	ЗаписываемыйЭлементСправочникаКлассификаторБанковРФ = 
		Справочники.КлассификаторБанковРФ.НайтиПоКоду(СтруктураБанк.БИК);
	
	Если ЗаписываемыйЭлементСправочникаКлассификаторБанковРФ.Пустая() Тогда
		КлассификаторБанковОбъект = Справочники.КлассификаторБанковРФ.СоздатьЭлемент();
		ФлагНовый				  = Истина;
	Иначе	
		КлассификаторБанковОбъект = ЗаписываемыйЭлементСправочникаКлассификаторБанковРФ.ПолучитьОбъект();
	КонецЕсли;
	
	Если КлассификаторБанковОбъект.ДеятельностьПрекращена Тогда
		КлассификаторБанковОбъект.ДеятельностьПрекращена = Ложь;
	КонецЕсли;
	
	Если КлассификаторБанковОбъект.Код <> СтруктураБанк.БИК Тогда
		КлассификаторБанковОбъект.Код = СтруктураБанк.БИК;
	КонецЕсли;
    	
	Если КлассификаторБанковОбъект.Наименование <> СтруктураБанк.Наименование Тогда
		Если Не ПустаяСтрока(СтруктураБанк.Наименование) Тогда
        	КлассификаторБанковОбъект.Наименование = СтруктураБанк.Наименование;
		КонецЕсли;	
	КонецЕсли;
	
	Если КлассификаторБанковОбъект.КоррСчет <> СтруктураБанк.КоррСчет Тогда
		Если Не ПустаяСтрока(СтруктураБанк.КоррСчет) Тогда
			КлассификаторБанковОбъект.КоррСчет	= СтруктураБанк.КоррСчет;
		КонецЕсли;	
	КонецЕсли;
	
	Если КлассификаторБанковОбъект.Город <> СтруктураБанк.Город Тогда
		Если Не ПустаяСтрока(СтруктураБанк.Город) Тогда
			КлассификаторБанковОбъект.Город = СтруктураБанк.Город;
		КонецЕсли;	
	КонецЕсли;
			
	Если КлассификаторБанковОбъект.Адрес <> СтруктураБанк.Адрес Тогда
		Если Не ПустаяСтрока(СтруктураБанк.Адрес) Тогда
			КлассификаторБанковОбъект.Адрес = СтруктураБанк.Адрес;
		КонецЕсли;	
	КонецЕсли;
	
	Если КлассификаторБанковОбъект.Телефоны <> СтруктураБанк.Телефоны Тогда
		Если Не ПустаяСтрока(СтруктураБанк.Телефоны) Тогда
			КлассификаторБанковОбъект.Телефоны = СтруктураБанк.Телефоны;
		КонецЕсли;	
	КонецЕсли;
	
	Если Не ПустаяСтрока(Регион) Тогда
		Если КлассификаторБанковОбъект.Родитель <> Регион.Ссылка Тогда
			КлассификаторБанковОбъект.Родитель = Регион.Ссылка;
		КонецЕсли;	
	КонецЕсли;	
    			
	Если КлассификаторБанковОбъект.Модифицированность() Тогда
		ФлагОбновленный		  = Истина;
		КлассификаторБанковОбъект.Записать();
	КонецЕсли;
	
	Если ФлагНовый Тогда
		Загружено = Загружено + 1;
	ИначеЕсли ФлагОбновленный Тогда
		Обновлено = Обновлено + 1;
	КонецЕсли;
	
	ПараметрыЗагрузкиДанных.Вставить("Загружено", Загружено);
	ПараметрыЗагрузкиДанных.Вставить("Обновлено", Обновлено);
	
КонецПроцедуры

// Записывает/перезаписывает в справочник КлассификаторБанковРФ данные банков.
// Параметры:
//	ПараметрыЗагрузкиДанныхИТС - Соответствие:
//	ТаблицаКлассификатора	   - ТаблицаЗначений - Данные банков
//	Загружено				   - Число			 - Количество новых записей классификатора
//	Обновлено				   - Число			 - Количество обновленных записей классификатора
//
Процедура ЗаписатьДанныеКлассификатора(ПараметрыЗагрузкиДанныхИТС)
	
	ТаблицаБанков = ПараметрыЗагрузкиДанныхИТС["ТаблицаКлассификатора"];
	
	ПараметрыЗагрузкиДанных = Новый Соответствие;
	ПараметрыЗагрузкиДанных.Вставить("Загружено", ПараметрыЗагрузкиДанныхИТС["Загружено"]);
	ПараметрыЗагрузкиДанных.Вставить("Обновлено", ПараметрыЗагрузкиДанныхИТС["Обновлено"]);
    
	Для СчетчикБанков = 1 по ТаблицаБанков.Количество() Цикл
		
		СтрокаТаблицыБанков = ТаблицаБанков.Получить(СчетчикБанков - 1);
		
		ПараметрыЗагрузкиДанных.Вставить("СтруктураБанк", СтрокаТаблицыБанков);
		ЗаписатьЭлементКлассификатораБанковРФ(ПараметрыЗагрузкиДанных);
				        				
	КонецЦикла;	
	
	ПараметрыЗагрузкиДанныхИТС.Вставить("Загружено", ПараметрыЗагрузкиДанных["Загружено"]);
	ПараметрыЗагрузкиДанныхИТС.Вставить("Обновлено", ПараметрыЗагрузкиДанных["Обновлено"]);
    				
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Прочие процедуры и функции

// Устанавливает значение даты загрузки данных классификатора
// 
// Параметры
//  ДатаВерсии - ДатаВремя - Дата загрузки данных классификатора
Процедура УстановитьВерсиюКлассификатораБанков(ДатаВерсии = "") Экспорт
	УстановитьПривилегированныйРежим(Истина);
	Если ТипЗнч(ДатаВерсии) <> Тип("Дата") Тогда
		Константы.ВерсияКлассификатораБанковРФ.Установить(ТекущаяУниверсальнаяДата());
	Иначе
		Константы.ВерсияКлассификатораБанковРФ.Установить(ДатаВерсии);
	КонецЕсли;
КонецПроцедуры

// Определяет нужно ли обновление данных классификатора.
//
Функция КлассификаторАктуален() Экспорт
	УстановитьПривилегированныйРежим(Истина);
	ПоследнееОбновление = Константы.ВерсияКлассификатораБанковРФ.Получить();
	ДопустимаяПросрочка = 30*60*60*24;
	
	Если ТекущаяДатаСеанса() > ПоследнееОбновление + ДопустимаяПросрочка Тогда
		Возврат Ложь; // Пошла просрочка.
	КонецЕсли;
	
	Возврат Истина;
КонецФункции

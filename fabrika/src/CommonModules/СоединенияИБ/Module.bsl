////////////////////////////////////////////////////////////////////////////////
// Подсистема "Завершение работы пользователей".
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

////////////////////////////////////////////////////////////////////////////////
// Блокировка и завершение соединений с ИБ.

// Устанавливает блокировку соединений ИБ.
// Если вызывается из сеанса с установленными значениями разделителей,
// то устанавливает блокировку сеансов области данных.
//
// Параметры
//  ТекстСообщения  – Строка – текст, который будет частью сообщения об ошибке
//                             при попытке установки соединения с заблокированной
//                             информационной базой.
// 
//  КодРазрешения - Строка -   строка, которая должна быть добавлена к параметру
//                             командной строки "/uc" или к параметру строки
//                             соединения "uc", чтобы установить соединение с
//                             информационной базой несмотря на блокировку.
//                             Не применимо для блокировки сеансов области данных.
//
// Возвращаемое значение:
//   Булево   – Истина, если блокировка установлена успешно.
//              Ложь, если для выполнения блокировки недостаточно прав.
//
Функция УстановитьБлокировкуСоединений(Знач ТекстСообщения = "",
	Знач КодРазрешения = "КодРазрешения") Экспорт
	
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено() И ОбщегоНазначенияПовтИсп.ДоступноИспользованиеРазделенныхДанных() Тогда
		
		Если Не Пользователи.ЭтоПолноправныйПользователь() Тогда
			Возврат Ложь;
		КонецЕсли;
		
		Блокировка = НовыеПараметрыБлокировкиСоединений();
		Блокировка.Установлена = Истина;
		Блокировка.Начало = ТекущаяДатаСеанса();
		Блокировка.Сообщение = СформироватьСообщениеБлокировки(ТекстСообщения, КодРазрешения);
		Блокировка.Эксклюзивная = Пользователи.ЭтоПолноправныйПользователь(, Истина);
		УстановитьБлокировкуСеансовОбластиДанных(Блокировка);
		Возврат Истина;
	Иначе
		Если Не Пользователи.ЭтоПолноправныйПользователь(, Истина) Тогда
			Возврат Ложь;
		КонецЕсли;
		
		Блокировка = Новый БлокировкаСеансов;
		Блокировка.Установлена = Истина;
		Блокировка.Начало = ТекущаяДатаСеанса();
		Блокировка.КодРазрешения = КодРазрешения;
		Блокировка.Сообщение = СформироватьСообщениеБлокировки(ТекстСообщения, КодРазрешения);
		УстановитьБлокировкуСеансов(Блокировка);
		Возврат Истина;
	КонецЕсли;
	
КонецФункции

// Определить, установлена ли блокировка соединений при пакетном 
// обновлении конфигурации информационной базы
//
// Возвращаемое значение:
//   Булево - Истина, если установлена, ложь - Иначе.
//
Функция УстановленаБлокировкаСоединений(ПараметрыБлокировки = Неопределено) Экспорт
	
	Если ПараметрыБлокировки = Неопределено Тогда
		ПараметрыБлокировки = СтруктураПараметровБлокировкиСеансов();
	КонецЕсли;
	
	Возврат ПараметрыБлокировки.УстановленаБлокировкаСоединений;
		
КонецФункции

// Получить параметры блокировки соединений ИБ для использования на стороне клиента.
//
// Параметры:
//  ПолучитьКоличествоСеансов - Булево - если Истина, то в возвращаемой структуре
//                                       заполняется поле КоличествоСеансов.
//
// Возвращаемое значение:
//   Структура – с полями:
//     Установлена - Булево - Истина, если установлена блокировка, Ложь - Иначе. 
//     Начало - Дата - дата начала блокировки. 
//     Конец - Дата - дата окончания блокировки. 
//     Сообщение - Строка - сообщение пользователю. 
//     ИнтервалОжиданияЗавершенияРаботыПользователей - Число - интервал в секундах.
//     КоличествоСеансов  - 0, если параметр ПолучитьКоличествоСеансов = Ложь
//     ТекущаяДатаСеанса - Дата - текущая дата сеанса.
//
Функция ПараметрыБлокировкиСеансов(Знач ПолучитьКоличествоСеансов = Ложь, ПараметрыБлокировки = Неопределено) Экспорт
	
	Если ПараметрыБлокировки = Неопределено Тогда
		ПараметрыБлокировки = СтруктураПараметровБлокировкиСеансов();
	КонецЕсли;
	
	Если ПараметрыБлокировки.УстановленаБлокировкаСоединенийИБНаДату Тогда
		ТекущийРежим = ПараметрыБлокировки.ТекущийРежимИБ;
	ИначеЕсли ПараметрыБлокировки.УстановленаБлокировкаСоединенийОбластиДанныхНаДату Тогда
		ТекущийРежим = ПараметрыБлокировки.ТекущийРежимОбластиДанных;
	ИначеЕсли ПараметрыБлокировки.ТекущийРежимИБ.Установлена Тогда
		ТекущийРежим = ПараметрыБлокировки.ТекущийРежимИБ;
	Иначе
		ТекущийРежим = ПараметрыБлокировки.ТекущийРежимОбластиДанных;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	Возврат Новый Структура(
		"Установлена,Начало,Конец,Сообщение,ИнтервалОжиданияЗавершенияРаботыПользователей,КоличествоСеансов,ТекущаяДатаСеанса",
		ТекущийРежим.Установлена,
		ТекущийРежим.Начало,
		ТекущийРежим.Конец,
		ТекущийРежим.Сообщение,
		15 * 60, // 15 минут; интервал ожидания завершения пользователей до момента установки
		         // блокировки информационной базы (в секундах).
		?(ПолучитьКоличествоСеансов, КоличествоСеансовИнформационнойБазы(), 0),
		ПараметрыБлокировки.ТекущаяДата);

КонецФункции

// Снять блокировку информационной базы.
//
// Возвращаемое значение:
//   Булево   – Истина, если операция выполнена успешно.
//              Ложь, если для выполнения операции недостаточно прав.
//
Функция РазрешитьРаботуПользователей() Экспорт
	
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено() И ОбщегоНазначенияПовтИсп.ДоступноИспользованиеРазделенныхДанных() Тогда
		
		Если Не Пользователи.ЭтоПолноправныйПользователь() Тогда
			Возврат Ложь;
		КонецЕсли;
		
		ТекущийРежим = ПолучитьБлокировкуСеансовОбластиДанных();
		Если ТекущийРежим.Установлена Тогда
			НовыйРежим = НовыеПараметрыБлокировкиСоединений();
			НовыйРежим.Установлена = Ложь;
			УстановитьБлокировкуСеансовОбластиДанных(НовыйРежим);
		КонецЕсли;
		Возврат Истина;
		
	Иначе
		Если НЕ Пользователи.ЭтоПолноправныйПользователь(, Истина) Тогда
			Возврат Ложь;
		КонецЕсли;
		
		ТекущийРежим = ПолучитьБлокировкуСеансов();
		Если ТекущийРежим.Установлена Тогда
			НовыйРежим = Новый БлокировкаСеансов;
			НовыйРежим.Установлена = Ложь;
			УстановитьБлокировкуСеансов(НовыйРежим);
		КонецЕсли;
		Возврат Истина;
	КонецЕсли;
	
КонецФункции	

////////////////////////////////////////////////////////////////////////////////
// Блокировка регламентных заданий.

// Установить или снять блокировку регламентных заданий.
//
// Параметры
//   Значение – Булево - Истина, если устанавливать, Ложь - Иначе.
//
Процедура УстановитьБлокировкуРегламентныхЗаданий(Значение) Экспорт
	
	Если Не Пользователи.ЭтоПолноправныйПользователь(, Истина) Тогда
		ВызватьИсключение НСтр("ru ='Недостаточно прав для выполнения операции'");
	КонецЕсли;
	УстановитьПривилегированныйРежим(Истина);
	СоединенияИБКлиентСервер.УстановитьБлокировкуРегламентныхЗаданий(Значение);
	
КонецПроцедуры	

// Получить текущее состояние блокировки регламентных заданий.
//
// Возвращаемое значение:
//   Булево – Истина, если блокировка установлена.
//
Функция БлокировкаРегламентныхЗаданийУстановлена() Экспорт
	
	Если Не Пользователи.ЭтоПолноправныйПользователь(, Истина) Тогда
		ВызватьИсключение НСтр("ru ='Недостаточно прав для выполнения операции'");
	КонецЕсли;
	УстановитьПривилегированныйРежим(Истина);
	Возврат СоединенияИБКлиентСервер.БлокировкаРегламентныхЗаданийУстановлена();
		
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Блокировка сеансов областей данных.

// Получить пустую структуру с параметрами блокировки сеансов области данных.
// 
// Возвращаемое значение:
//   Структура        – с полями:
//     Начало         - Дата   - время начала действия блокировки
//     Конец          - Дата   - время завершения действия блокировки
//     Сообщение      - Строка - сообщения для пользователей, выполняющих вход в заблокированную область данных
//     Установлена    - Булево - признак того, что блокировка установлена
//     Эксклюзивная   - Булево - блокировка не может быть изменена администратором приложения
//
Функция НовыеПараметрыБлокировкиСоединений() Экспорт
	
	Возврат Новый Структура("Конец,Начало,Сообщение,Установлена,Эксклюзивная",
		Дата(1,1,1), Дата(1,1,1), "", Ложь, Ложь);
		
КонецФункции

// Установить блокировку сеансов области данных.
// 
// Параметры:
//   Параметры         – Структура – см. НовыеПараметрыБлокировкиСоединений
//   ПоМестномуВремени - Булево - время начала и окончания блокировки указаны в местном времени сеанса.
//                                Если Ложь, то в универсальном времени.
//   ОбластьДанных - Число(7,0) - номер области данных, для которой устанавливается блокировка.
//     При вызове из сеанса, в котором заданы значения разделителей, может быть передано только значение,
//       совпадающее со значением разделителя в сеансе (или опущено).
//     При вызове из сеанса, в котором не заданы значения разделителей, значение параметра не может быть опущено.
//
Процедура УстановитьБлокировкуСеансовОбластиДанных(Параметры, Знач ПоМестномуВремени = Истина, Знач ОбластьДанных = -1) Экспорт
	
	Если Не Пользователи.ЭтоПолноправныйПользователь() Тогда
		ВызватьИсключение НСтр("ru ='Недостаточно прав для выполнения операции'");
	КонецЕсли;
	
	Эксклюзивная = Ложь;
	Если Не Параметры.Свойство("Эксклюзивная", Эксклюзивная) Тогда
		Эксклюзивная = Ложь;
	КонецЕсли;
	Если Эксклюзивная И Не Пользователи.ЭтоПолноправныйПользователь(, Истина) Тогда
		ВызватьИсключение НСтр("ru ='Недостаточно прав для выполнения операции'");
	КонецЕсли;
	
	Если ОбщегоНазначенияПовтИсп.ДоступноИспользованиеРазделенныхДанных() Тогда
		
		Если ОбластьДанных = -1 Тогда
			ОбластьДанных = ОбщегоНазначения.ЗначениеРазделителяСеанса();
		ИначеЕсли ОбластьДанных <> ОбщегоНазначения.ЗначениеРазделителяСеанса() Тогда
			ВызватьИсключение НСтр("ru = 'Из сеанса с используемыми значениями разделителей нельзя установить блокировку сеансов области данных, отличной от используемой в сеансе!'");
		КонецЕсли;
		
	Иначе
		
		Если ОбластьДанных = -1 Тогда
			ВызватьИсключение НСтр("ru = 'Невозможно установить блокировку сеансов области данных - не указана область данных!'");
		КонецЕсли;
		
	КонецЕсли;
	
	СтруктураНастроек = Параметры;
	Если ТипЗнч(Параметры) = Тип("БлокировкаСеансов") Тогда
		СтруктураНастроек = НовыеПараметрыБлокировкиСоединений();
		ЗаполнитьЗначенияСвойств(СтруктураНастроек, Параметры);
	КонецЕсли;

	УстановитьПривилегированныйРежим(Истина);
	НаборБлокировок = РегистрыСведений.БлокировкиСеансовОбластейДанных.СоздатьНаборЗаписей();
	НаборБлокировок.Отбор.ОбластьДанныхВспомогательныеДанные.Установить(ОбластьДанных);
	НаборБлокировок.Прочитать();
	НаборБлокировок.Очистить();
	Если Параметры.Установлена Тогда 
		Блокировка = НаборБлокировок.Добавить();
		Блокировка.ОбластьДанныхВспомогательныеДанные = ОбластьДанных;
		Блокировка.НачалоБлокировки = ?(ПоМестномуВремени И ЗначениеЗаполнено(СтруктураНастроек.Начало), 
			УниверсальноеВремя(СтруктураНастроек.Начало), СтруктураНастроек.Начало);
		Блокировка.КонецБлокировки = ?(ПоМестномуВремени И ЗначениеЗаполнено(СтруктураНастроек.Конец), 
			УниверсальноеВремя(СтруктураНастроек.Конец), СтруктураНастроек.Конец);
		Блокировка.СообщениеБлокировки = СтруктураНастроек.Сообщение;
		Блокировка.Эксклюзивная = СтруктураНастроек.Эксклюзивная;
	КонецЕсли;
	НаборБлокировок.Записать();
	
КонецПроцедуры

// Получить информацию о блокировке сеансов области данных.
// 
// Параметры:
//   ПоМестномуВремени - Булево - время начала и окончания блокировки необходимо вернуть 
//                                в местном времени сеанса. Если Ложь, то 
//                                возвращается в универсальном времени.
//
// Возвращаемое значение:
//   Структура – см. НовыеПараметрыБлокировкиСоединений
//
Функция ПолучитьБлокировкуСеансовОбластиДанных(Знач ПоМестномуВремени = Истина) Экспорт
	
	Результат = НовыеПараметрыБлокировкиСоединений();
	Если Не ОбщегоНазначенияПовтИсп.РазделениеВключено() Или Не ОбщегоНазначенияПовтИсп.ДоступноИспользованиеРазделенныхДанных() Тогда
		Возврат Результат;
	КонецЕсли;
	
	Если Не Пользователи.ЭтоПолноправныйПользователь() Тогда
		ВызватьИсключение НСтр("ru ='Недостаточно прав для выполнения операции'");
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	НаборБлокировок = РегистрыСведений.БлокировкиСеансовОбластейДанных.СоздатьНаборЗаписей();
	НаборБлокировок.Отбор.ОбластьДанныхВспомогательныеДанные.Установить(ОбщегоНазначения.ЗначениеРазделителяСеанса());
	НаборБлокировок.Прочитать();
	Если НаборБлокировок.Количество() = 0 Тогда
		Возврат Результат;
	КонецЕсли;
	Блокировка = НаборБлокировок[0];
	Результат.Начало = ?(ПоМестномуВремени И ЗначениеЗаполнено(Блокировка.НачалоБлокировки), 
		МестноеВремя(Блокировка.НачалоБлокировки), Блокировка.НачалоБлокировки);
	Результат.Конец = ?(ПоМестномуВремени И ЗначениеЗаполнено(Блокировка.КонецБлокировки), 
		МестноеВремя(Блокировка.КонецБлокировки), Блокировка.КонецБлокировки);
	Результат.Сообщение = Блокировка.СообщениеБлокировки;
	Результат.Эксклюзивная = Блокировка.Эксклюзивная;
	ТекущаяДата = ТекущаяДатаСеанса();
	Результат.Установлена = Истина;
	// уточняем результат по периоду блокировки
	Результат.Установлена = Не ЗначениеЗаполнено(Блокировка.КонецБлокировки) 
		Или Блокировка.КонецБлокировки >= ТекущаяДата 
		Или УстановленаБлокировкаСоединенийНаДату(Результат, ТекущаяДата);
	Возврат Результат;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЙ ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Заполняет структуру параметров, необходимых для работы клиентского кода
// конфигурации. 
//
// Параметры:
//   Параметры   - Структура - структура параметров.
//
Процедура ДобавитьПараметрыРаботыКлиента(Параметры) Экспорт
	Параметры.Вставить("ПараметрыБлокировкиСеансов", Новый ФиксированнаяСтруктура(ПараметрыБлокировкиСеансов()));
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики условных вызовов в эту подсистему

// Снимает блокировку информационной файловой базы.
//
Процедура ПриСнятииБлокировкиФайловойБазы() Экспорт
	
	Блокировка = Новый БлокировкаСеансов;
	Блокировка.Установлена = Ложь;
	УстановитьБлокировкуСеансов(Блокировка);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Добавление обработчиков событий.

// См. описание этой же процедуры в модуле СтандартныеПодсистемыСервер.
Процедура ПриДобавленииОбработчиковСлужебныхСобытий(КлиентскиеОбработчики, СерверныеОбработчики) Экспорт
	
	// КЛИЕНТСКИЕ ОБРАБОТЧИКИ.
	
	КлиентскиеОбработчики[
		"СтандартныеПодсистемы.БазоваяФункциональность\ПриОпределенииФормыАктивныхПользователей"].Добавить(
			"СоединенияИБКлиент");
	
	КлиентскиеОбработчики[
		"СтандартныеПодсистемы.БазоваяФункциональность\ПриОбработкеПараметровЗапуска"].Добавить(
			"СоединенияИБКлиент");
	
	// СЕРВЕРНЫЕ ОБРАБОТЧИКИ.
	
	СерверныеОбработчики[
		"СтандартныеПодсистемы.БазоваяФункциональность\ПриДобавленииПараметровРаботыКлиентскойЛогикиСтандартныхПодсистемПриЗапуске"].Добавить(
		"СоединенияИБ");
	
	СерверныеОбработчики[
		"СтандартныеПодсистемы.БазоваяФункциональность\ПриДобавленииПараметровРаботыКлиентскойЛогикиСтандартныхПодсистем"].Добавить(
		"СоединенияИБ");
	
	Если ОбщегоНазначенияКлиентСервер.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса") Тогда
		СерверныеОбработчики["СтандартныеПодсистемы.РаботаВМоделиСервиса\ПриЗаполненииТаблицыПараметровИБ"].Добавить(
			"СоединенияИБ");
	КонецЕсли;
	
	СерверныеОбработчики["СтандартныеПодсистемы.ОбновлениеВерсииИБ\ПриДобавленииОбработчиковОбновления"].Добавить(
		"СоединенияИБ");
	
	Если ОбщегоНазначенияКлиентСервер.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса") Тогда
		СерверныеОбработчики[
			"СтандартныеПодсистемы.РаботаВМоделиСервиса.ВыгрузкаЗагрузкаДанных\ПриОпределенииОбъектовМетаданныхИсключаемыхИзВыгрузкиЗагрузки"].Добавить(
				"СоединенияИБ");
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий подсистем БСП

// Формирует список параметров ИБ.
//
// Параметры:
// ТаблицаПараметров - ТаблицаЗначений - таблица описания параметров.
// Описание состав колонок - см. РаботаВМоделиСервиса.ПолучитьТаблицуПараметровИБ()
//
Процедура ПриЗаполненииТаблицыПараметровИБ(Знач ТаблицаПараметров) Экспорт
	
	Если ОбщегоНазначенияКлиентСервер.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса") Тогда
		МодульРаботаВМоделиСервиса = ОбщегоНазначенияКлиентСервер.ОбщийМодуль("РаботаВМоделиСервиса");
		МодульРаботаВМоделиСервиса.ДобавитьКонстантуВТаблицуПараметровИБ(ТаблицаПараметров, "СообщениеБлокировкиПриОбновленииКонфигурации");
	КонецЕсли;
	
КонецПроцедуры

// Заполнить структуру параметров, необходимых для работы клиентского кода
// данной подсистемы при запуске конфигурации, т.е. в обработчиках событий
// - ПередНачаломРаботыСистемы,
// - ПриНачалеРаботыСистемы
//
// Параметры:
//   Параметры - Структура - структура параметров запуска.
//
Процедура ПриДобавленииПараметровРаботыКлиентскойЛогикиСтандартныхПодсистемПриЗапуске(Параметры) Экспорт
	
	ПараметрыБлокировки = СтруктураПараметровБлокировкиСеансов();
	Параметры.Вставить("ПараметрыБлокировкиСеансов", Новый ФиксированнаяСтруктура(ПараметрыБлокировкиСеансов(, ПараметрыБлокировки)));
	
	Если Не ПараметрыБлокировки.УстановленаБлокировкаСоединений
		Или Не ОбщегоНазначенияПовтИсп.РазделениеВключено()
		Или Не ОбщегоНазначенияПовтИсп.ДоступноИспользованиеРазделенныхДанных() Тогда
		Возврат;
	КонецЕсли;
	
	// Дальнейший код актуален только для области данных с установленной блокировкой
	Если ОбновлениеИнформационнойБазы.ВыполняетсяОбновлениеИнформационнойБазы() 
		И Пользователи.ЭтоПолноправныйПользователь() Тогда
		// Администратор приложения может входить, несмотря на незавершенное обновление области (и блокировку области данных)
		// При этом он инициирует обновление области.
		Возврат; 
	КонецЕсли;	
	
	ТекущийРежим = ПараметрыБлокировки.ТекущийРежимОбластиДанных;
	
	Если ЗначениеЗаполнено(ТекущийРежим.Конец) Тогда
		ПериодБлокировки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'на период с %1 по %2'"),
			ТекущийРежим.Начало, ТекущийРежим.Конец);
	Иначе
		ПериодБлокировки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'с %1'"), ТекущийРежим.Начало);
	КонецЕсли;
	Если ЗначениеЗаполнено(ТекущийРежим.Сообщение) Тогда
		ПричинаБлокировки = НСтр("ru = 'по причине:'") + Символы.ПС + ТекущийРежим.Сообщение;
	Иначе
		ПричинаБлокировки = НСтр("ru = 'для проведения регламентных работ'");
	КонецЕсли;
	ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Администратором приложения установлена блокировка работы пользователей %1 %2.
			|
			|Приложение временно недоступно.'"),
		ПериодБлокировки, ПричинаБлокировки);
	Параметры.Вставить("СеансыОбластиДанныхЗаблокированы", ТекстСообщения);
	ТекстСообщения = "";
	Если Пользователи.ЭтоПолноправныйПользователь() Тогда
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Администратором приложения установлена блокировка работы пользователей %1 %2.
			    |
				|Войти в заблокированное приложение?'"),
			ПериодБлокировки, ПричинаБлокировки);
	КонецЕсли;
	Параметры.Вставить("ПредложениеВойти", ТекстСообщения);
	Если (Пользователи.ЭтоПолноправныйПользователь() И Не ТекущийРежим.Эксклюзивная) 
		Или Пользователи.ЭтоПолноправныйПользователь(, Истина) Тогда
		
		Параметры.Вставить("ВозможноСнятьБлокировку", Истина);
	Иначе
		Параметры.Вставить("ВозможноСнятьБлокировку", Ложь);
	КонецЕсли;
			
КонецПроцедуры

// Заполняет структуру параметров, необходимых для работы клиентского кода
// конфигурации.
//
// Параметры:
//   Параметры   - Структура - структура параметров.
//
Процедура ПриДобавленииПараметровРаботыКлиентскойЛогикиСтандартныхПодсистем(Параметры) Экспорт
	
	ДобавитьПараметрыРаботыКлиента(Параметры);
	
КонецПроцедуры

// Добавляет процедуры-обработчики обновления, необходимые данной подсистеме.
//
// Параметры:
//  Обработчики - ТаблицаЗначений - см. описание функции НоваяТаблицаОбработчиковОбновления
//                                  общего модуля ОбновлениеИнформационнойБазы.
// 
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "2.1.3.9";
	Обработчик.Процедура = "СоединенияИБ.ПеренестиБлокировкиСеансовОбластейДанныхВоВспомогательныеДанные";
	Обработчик.ОбщиеДанные = Истина;
	
КонецПроцедуры

// Обработчик, вызываемый при определении объектов метаданных, не переносимых между моделями при выгрузке / загрузке данных.
//
// Параметры
//  Объекты - Массив(ОбъектМетаданных).
//
Процедура ПриОпределенииОбъектовМетаданныхИсключаемыхИзВыгрузкиЗагрузки(Объекты) Экспорт
	
	Объекты.Добавить(Метаданные.РегистрыСведений.БлокировкиСеансовОбластейДанных);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ ОБНОВЛЕНИЯ ИНФОРМАЦИОННОЙ БАЗЫ

// Переносит данные из регистра сведений УдалитьБлокировкиСеансаОбластейДанных в регистр
//  сведений БлокировкиСеансовОбластейДанных
Процедура ПеренестиБлокировкиСеансовОбластейДанныхВоВспомогательныеДанные() Экспорт
	
	Если Не ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
		Возврат;
	КонецЕсли;
	
	НачатьТранзакцию();
	
	Попытка
		
		Блокировка = Новый БлокировкаДанных();
		БлокировкаРегистра = Блокировка.Добавить("РегистрСведений.БлокировкиСеансовОбластейДанных");
		БлокировкаРегистра.Режим = РежимБлокировкиДанных.Исключительный;
		Блокировка.Заблокировать();
		
		ТекстЗапроса =
		"ВЫБРАТЬ
		|	ЕСТЬNULL(БлокировкиСеансовОбластейДанных.ОбластьДанныхВспомогательныеДанные, УдалитьБлокировкиСеансовОбластиДанных.ОбластьДанных) КАК ОбластьДанныхВспомогательныеДанные,
		|	ЕСТЬNULL(БлокировкиСеансовОбластейДанных.НачалоБлокировки, УдалитьБлокировкиСеансовОбластиДанных.НачалоБлокировки) КАК НачалоБлокировки,
		|	ЕСТЬNULL(БлокировкиСеансовОбластейДанных.КонецБлокировки, УдалитьБлокировкиСеансовОбластиДанных.КонецБлокировки) КАК КонецБлокировки,
		|	ЕСТЬNULL(БлокировкиСеансовОбластейДанных.СообщениеБлокировки, УдалитьБлокировкиСеансовОбластиДанных.СообщениеБлокировки) КАК СообщениеБлокировки,
		|	ЕСТЬNULL(БлокировкиСеансовОбластейДанных.Эксклюзивная, УдалитьБлокировкиСеансовОбластиДанных.Эксклюзивная) КАК Эксклюзивная
		|ИЗ
		|	РегистрСведений.УдалитьБлокировкиСеансовОбластиДанных КАК УдалитьБлокировкиСеансовОбластиДанных
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.БлокировкиСеансовОбластейДанных КАК БлокировкиСеансовОбластейДанных
		|		ПО УдалитьБлокировкиСеансовОбластиДанных.ОбластьДанных = БлокировкиСеансовОбластейДанных.ОбластьДанныхВспомогательныеДанные";
		Запрос = Новый Запрос(ТекстЗапроса);
		
		Набор = РегистрыСведений.БлокировкиСеансовОбластейДанных.СоздатьНаборЗаписей();
		Набор.Загрузить(Запрос.Выполнить().Выгрузить());
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(Набор);
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		ВызватьИсключение;
		
	КонецПопытки;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Принудительное отключение сеансов.

// Отключает сеанс по номеру сеанса.
//
// Параметры
//  НомерСеанса - Число - номер сеанса для отключения
//  СообщениеОбОшибке - Строка - в этом параметре возвращается текст сообщения об ошибке в случае неудачи
// 
// Возвращаемое значение:
//  Булево – результат отключения сеанса.
//
Функция ОтключитьСеанс(НомерСеанса, СообщениеОбОшибке) Экспорт
	
	Если Не Пользователи.ЭтоПолноправныйПользователь() Тогда
		ВызватьИсключение НСтр("ru ='Недостаточно прав для выполнения операции'");
	КонецЕсли;
	
	СтандартнаяОбработка = Истина;
	Результат = Истина;
	ПриОтключенииСеанса(НомерСеанса, Результат, СообщениеОбОшибке, СтандартнаяОбработка);
	Если Не СтандартнаяОбработка Тогда
		Возврат Результат;
	КонецЕсли;
	Если СоединенияИБПовтИсп.ПараметрыОтключенияСеансов().WindowsПлатформаНаСервере Тогда
		УстановитьПривилегированныйРежим(Истина);
		Возврат СоединенияИБКлиентСервер.ОтключитьСеанс(НомерСеанса, СообщениеОбОшибке);
	Иначе // Для Linux
		СообщениеОбОшибке = НСтр("ru = 'Невозможно принудительно завершить сеансы,
			| так как на сервере не установлена ОС Microsoft Windows'");
		ЗаписатьНазванияСоединенийИБ(СообщениеОбОшибке);
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

// Отключить все активные соединения ИБ (кроме текущего сеанса).
//
// Параметры
//  ПараметрыАдминистрированияИБ – Структура – параметры администрирования ИБ.  
//
// Возвращаемое значение:
//   Булево   – результат отключения соединений.
//
Функция ОтключитьСоединенияИБ(ПараметрыАдминистрированияИБ) Экспорт
	
	Если Не Пользователи.ЭтоПолноправныйПользователь() Тогда
		ВызватьИсключение НСтр("ru ='Недостаточно прав для выполнения операции'");
	КонецЕсли;
	УстановитьПривилегированныйРежим(Истина);
	Возврат СоединенияИБКлиентСервер.ОтключитьСоединенияИБ(ПараметрыАдминистрированияИБ);
	
КонецФункции

// Осуществляет попытку подключиться к кластеру серверов и получить список 
// активных соединений к ИБ и использованием указанных параметров администрирования.
//
// Параметры
//  ПараметрыАдминистрированияИБ  – Структура – параметры администрирования ИБ
//  ВыдаватьСообщения             – Булево    – разрешить вывод интерактивных сообщений.
//
// Возвращаемое значение:
//   Булево – Истина, если проверка завершена успешно.
//
Процедура ПроверитьПараметрыАдминистрированияИБ(ПараметрыАдминистрированияИБ,
	Знач ПодробноеСообщениеОбОшибке = Ложь) Экспорт
	
	Если Не Пользователи.ЭтоПолноправныйПользователь() Тогда
		ВызватьИсключение НСтр("ru ='Недостаточно прав для выполнения операции'");
	КонецЕсли;
	УстановитьПривилегированныйРежим(Истина);
	СоединенияИБКлиентСервер.ПроверитьПараметрыАдминистрированияИБ(ПараметрыАдминистрированияИБ,
		ПодробноеСообщениеОбОшибке);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Прочее.

// Возвращает текст сообщения блокировки сеансов.
//
// Параметры:
//	Сообщение - Строка - сообщение для блокировки.
//  КодРазрешения - Строка - код разрешения для входа в информационную базу.
//
// Возвращаемое значение:
//   Строка - сообщение блокировки.
//
Функция СформироватьСообщениеБлокировки(Знач Сообщение, Знач КодРазрешения) Экспорт

	ПараметрыАдминистрированияИБ = СоединенияИБПовтИсп.ПолучитьПараметрыАдминистрированияИБ();
	ПризнакФайловогоРежима = Ложь;
	ПутьКИБ = СоединенияИБКлиентСервер.ПутьКИнформационнойБазе(ПризнакФайловогоРежима, 
		?(ПараметрыАдминистрированияИБ.Свойство("ПортКластераСерверов"), ПараметрыАдминистрированияИБ.ПортКластераСерверов, 0));
	СтрокаПутиКИнформационнойБазе = ?(ПризнакФайловогоРежима = Истина, "/F", "/S") + ПутьКИБ; 
	ТекстСообщения = "";                                 
	Если НЕ ПустаяСтрока(Сообщение) Тогда
		ТекстСообщения = Сообщение + Символы.ПС + Символы.ПС;
	КонецЕсли;
	
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено() И ОбщегоНазначенияПовтИсп.ДоступноИспользованиеРазделенныхДанных() Тогда
		ТекстСообщения = ТекстСообщения +
		    НСтр("ru = '%1
		               |Для разрешения работы пользователей можно открыть приложение с параметром РазрешитьРаботуПользователей. Например:
		               |http://<веб-адрес сервера>/?C=РазрешитьРаботуПользователей'");
	Иначе
		ТекстСообщения = ТекстСообщения +
		    НСтр("ru = '%1
		               |Для того чтобы разрешить работу пользователей, воспользуйтесь консолью кластера серверов или запустите ""1С:Предприятие"" с параметрами:
		               |ENTERPRISE %2 /CРазрешитьРаботуПользователей /UC%3'");
	КонецЕсли;
	ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения,
		СоединенияИБКлиентСервер.ТекстДляАдминистратора(), СтрокаПутиКИнформационнойБазе, 
		НСтр("ru = '<код разрешения>'"));
	
	Возврат ТекстСообщения;
	
КонецФункции

// Возвращает текстовую строку со списком активных соединений ИБ.
// Названия соединений разделены символом переноса строки.
//
// Параметры:
//	Сообщение - Строка - передаваемая строка.
//
// Возвращаемое значение:
//   Строка - названия соединений.
//
Функция ПолучитьНазванияСоединенийИБ(Знач Сообщение) Экспорт
	
	Результат = Сообщение;
	Для каждого Сеанс Из ПолучитьСеансыИнформационнойБазы() Цикл
		Если Сеанс.НомерСеанса <> НомерСеансаИнформационнойБазы() Тогда
			Результат = Результат + Символы.ПС + " - " + Сеанс;
		КонецЕсли;
	КонецЦикла; 
	
	Возврат Результат;
	
КонецФункции

// Получить сохраненные параметры администрирования кластера серверов.
// 
// Возвращаемое значение:
//   Структура – с полями, возвращаемыми функцией НовыеПараметрыАдминистрированияИБ.
//
Функция ПолучитьПараметрыАдминистрированияИБ() Экспорт
	
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено() И ОбщегоНазначенияПовтИсп.ДоступноИспользованиеРазделенныхДанных() Тогда
		
		Если Не Пользователи.ЭтоПолноправныйПользователь() Тогда
			ВызватьИсключение НСтр("ru ='Недостаточно прав для выполнения операции'");
		КонецЕсли;
		
	Иначе
		
		Если Не Пользователи.ЭтоПолноправныйПользователь(, Истина) Тогда
			ВызватьИсключение НСтр("ru ='Недостаточно прав для выполнения операции'");
		КонецЕсли;
		
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	Результат = СоединенияИБКлиентСервер.НовыеПараметрыАдминистрированияИБ();
	СтруктураНастроек = Константы.ПараметрыАдминистрированияИБ.Получить();
	Если СтруктураНастроек <> Неопределено Тогда
		СтруктураНастроек = СтруктураНастроек.Получить();
		Если ТипЗнч(СтруктураНастроек) = Тип("Структура") Тогда
			ЗаполнитьЗначенияСвойств(Результат, СтруктураНастроек);
		КонецЕсли;
	КонецЕсли;
	Возврат Результат;
	
КонецФункции

// Сохранить параметры администрирования кластера серверов в ИБ.
//
// Параметры:
//		Параметры - структура с полями, возвращаемыми функцией НовыеПараметрыАдминистрированияИБ.
//
Процедура ЗаписатьПараметрыАдминистрированияИБ(Параметры) Экспорт
	
	Константы.ПараметрыАдминистрированияИБ.Установить(Новый ХранилищеЗначения(Параметры));
	ОбновитьПовторноИспользуемыеЗначения();
	
КонецПроцедуры

// Получить число активных сеансов ИБ.
//
// Параметры:
//   УчитыватьКонсоль               - Булево - если Ложь, то исключить сеансы консоли кластера серверов.
//                                             сеансы консоли кластера серверов не препятствуют выполнению 
//                                             административных операций (установке монопольного режима и т.п.).
//   СообщенияДляЖурналаРегистрации - СписокЗначений - пакета сообщения для журнала регистрации
//                                                     сформированных на клиенте.
//
// Возвращаемое значение:
//   Число   – количество активных сеансов ИБ.
//
Функция КоличествоСеансовИнформационнойБазы(УчитыватьКонсоль = Истина, 
	СообщенияДляЖурналаРегистрации = Неопределено) Экспорт
	
	ОбщегоНазначения.ЗаписатьСобытияВЖурналРегистрации(СообщенияДляЖурналаРегистрации);
	
	СеансыИБ = ПолучитьСеансыИнформационнойБазы();
	Если УчитыватьКонсоль Тогда
		Возврат СеансыИБ.Количество();
	КонецЕсли;
	
	Результат = 0;
	Для каждого СеансИБ Из СеансыИБ Цикл
		Если СеансИБ.ИмяПриложения <> "SrvrConsole" Тогда
			Результат = Результат + 1;
		КонецЕсли;
	КонецЦикла;
	Возврат Результат;
	
КонецФункции

// Записать в журнал регистрации список сеансов ИБ.
//
// Параметры:
//   ТекстСообщения - Строка - опциональный текст с пояснениями.
//
Процедура ЗаписатьНазванияСоединенийИБ(Знач ТекстСообщения) Экспорт
	Сообщение = ПолучитьНазванияСоединенийИБ(ТекстНеУдалосьЗавершитьРаботуПользователей(ТекстСообщения));
	ЗаписьЖурналаРегистрации(СоединенияИБКлиентСервер.СобытиеЖурналаРегистрации(), 
		УровеньЖурналаРегистрации.Предупреждение, , , Сообщение);
КонецПроцедуры

// Возвращает текст о неудачном завершении работы пользователей.
//
// Параметры:
//	Сообщение - Строка - передаваемая строка.
//
// Возвращаемое значение:
//	Строка - сообщение о неудаче завершения работы пользователей.
//
Функция ТекстНеУдалосьЗавершитьРаботуПользователей(Знач Сообщение) 
	
	Если Не ПустаяСтрока(Сообщение) Тогда
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось завершить работу пользователей (%1):'"),
			Сообщение);
	Иначе		
		ТекстСообщения = НСтр("ru = 'Не удалось завершить работу пользователей:'");
	КонецЕсли;
	Возврат ТекстСообщения;
	
КонецФункции

// Возвращает установлена ли блокировка соединений на конкретную дату.
//
// Параметры:
//	ТекущийРежим - БлокировкаСеансов - блокировка сеансов.
//	ТекущаяДата - Дата - дата, на которую необходимо проверить.
//
// Возвращаемое значение:
//	Булево - Истина, если установлена.
//
Функция УстановленаБлокировкаСоединенийНаДату(ТекущийРежим, ТекущаяДата)
	
	Возврат (ТекущийРежим.Установлена И ТекущийРежим.Начало <= ТекущаяДата 
		И (Не ЗначениеЗаполнено(ТекущийРежим.Конец) Или ТекущаяДата <= ТекущийРежим.Конец));
		
КонецФункции

// Возвращает структуру, содержащую параметры блокировки сеансов
//
Функция СтруктураПараметровБлокировкиСеансов()
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТекущаяДата = ТекущаяДатаСеанса();
	ТекущийРежимИБ = ПолучитьБлокировкуСеансов();
	ТекущийРежимОбластиДанных = ПолучитьБлокировкуСеансовОбластиДанных();
	УстановленаБлокировкаСоединенийИБНаДату = УстановленаБлокировкаСоединенийНаДату(ТекущийРежимИБ, ТекущаяДата);
	УстановленаБлокировкаСоединенийОбластиДанныхНаДату = УстановленаБлокировкаСоединенийНаДату(ТекущийРежимОбластиДанных, ТекущаяДата);
	
	ПараметрыБлокировкиСеансов = Новый Структура;
	ПараметрыБлокировкиСеансов.Вставить("ТекущаяДата", ТекущаяДата);
	ПараметрыБлокировкиСеансов.Вставить("ТекущийРежимИБ", ТекущийРежимИБ);
	ПараметрыБлокировкиСеансов.Вставить("ТекущийРежимОбластиДанных", ТекущийРежимОбластиДанных);
	ПараметрыБлокировкиСеансов.Вставить("УстановленаБлокировкаСоединенийИБНаДату", УстановленаБлокировкаСоединенийНаДату(ТекущийРежимИБ, ТекущаяДата));
	ПараметрыБлокировкиСеансов.Вставить("УстановленаБлокировкаСоединенийОбластиДанныхНаДату", УстановленаБлокировкаСоединенийНаДату(ТекущийРежимОбластиДанных, ТекущаяДата));
	ПараметрыБлокировкиСеансов.Вставить("УстановленаБлокировкаСоединений", УстановленаБлокировкаСоединенийИБНаДату Или УстановленаБлокировкаСоединенийОбластиДанныхНаДату);
	
	Возврат ПараметрыБлокировкиСеансов;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Обработчики условных вызовов в другие подсистемы

// Вызывается при отключении сеанса на стороне сервера 1С:Предприятия.
//
// Параметры
//  НомерСеанса - Число - номер сеанса для отключения.
//  Результат - Булево – результат отключения сеанса.
//  СообщениеОбОшибке - Строка - в этом параметре возвращается текст сообщения об ошибке в случае неудачи.
//  СтандартнаяОбработка - Булево - вернуть Ложь, если необходимо запретить стандартную обработку отключения сеанса.
//
Процедура ПриОтключенииСеанса(НомерСеанса, Результат, СообщениеОбОшибке, СтандартнаяОбработка) Экспорт
	
	Если ОбщегоНазначенияКлиентСервер.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса.БазоваяФункциональностьВМоделиСервиса") Тогда
		
		Если СоединенияИБПовтИсп.ПараметрыОтключенияСеансов().WindowsПлатформаНаСервере Тогда
			Возврат;
		КонецЕсли;
			
		Если Не ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
			Возврат;
		КонецЕсли;
		
		// Если сервер работает не под управлением ОС Microsoft Windows, то передаем управление Агенту сервиса.
		СтандартнаяОбработка = Ложь;
		УстановитьПривилегированныйРежим(Истина);
		Параметры = СоединенияИБПовтИсп.ПолучитьПараметрыАдминистрированияИБ();
		Попытка
			МодульРаботаВМоделиСервиса = ОбщегоНазначенияКлиентСервер.ОбщийМодуль("РаботаВМоделиСервиса");
			Результат = МодульРаботаВМоделиСервиса.УдалитьСеансыИРазорватьСоединенияЧерезАгентСервиса(НомерСеанса, Параметры);
		Исключение
			СообщениеОбОшибке = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
			Результат = Ложь;
		КонецПопытки;
		
	КонецЕсли;
	
КонецПроцедуры

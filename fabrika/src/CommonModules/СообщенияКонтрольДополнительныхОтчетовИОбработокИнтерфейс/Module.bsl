////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИК ИНТЕРФЕЙСА СООБЩЕНИЙ КОНТРОЛЯ ДОПОЛНИТЕЛЬНЫХ ОТЧЕТОВ И ОБРАБОТОК
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Возвращает пространство имен текущей (используемой вызывающим кодом) версии интерфейса сообщений
Функция Пакет() Экспорт
	
	Возврат "http://www.1c.ru/1cFresh/ApplicationExtensions/Control/" + Версия();
	
КонецФункции

// Возвращает текущую (используемую вызывающим кодом) версию интерфейса сообщений
Функция Версия() Экспорт
	
	Возврат "1.0.1.1";
	
КонецФункции

// Возвращает название программного интерфейса сообщений
Функция ПрограммныйИнтерфейс() Экспорт
	
	Возврат "ApplicationExtensionsControl";
	
КонецФункции

// Выполняет регистрацию обработчиков сообщений в качестве обработчиков каналов обмена сообщениями
//
// Параметры:
//  МассивОбработчиков - массив.
//
Процедура ОбработчикиКаналовСообщений(Знач МассивОбработчиков) Экспорт
	
	
	
КонецПроцедуры

// Выполняет регистрацию обработчиков трансляции сообщений.
//
// Параметры:
//  МассивОбработчиков - массив.
//
Процедура ОбработчикиТрансляцииСообщений(Знач МассивОбработчиков) Экспорт
	
	МассивОбработчиков.Добавить(СообщенияКонтрольДополнительныхОтчетовИОбработокОбработчикТрансляции_1_0_0_1);
	
КонецПроцедуры

// Возвращает тип сообщения {http://www.1c.ru/1cFresh/ApplicationExtensions/Control/a.b.c.d}ExtensionInstalled
//
// Параметры:
//  ИспользуемыйПакет - строка, пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ТипXDTO
//
Функция СообщениеДополнительныйОтчетИлиОбработкаУстановлена(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "ExtensionInstalled");
	
КонецФункции

// Возвращает тип сообщения {http://www.1c.ru/1cFresh/ApplicationExtensions/Control/a.b.c.d}ExtensionDeleted
//
// Параметры:
//  ИспользуемыйПакет - строка, пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ТипXDTO
//
Функция СообщениеДополнительныйОтчетИлиОбработкаУдалена(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "ExtensionDeleted");
	
КонецФункции

// Возвращает тип сообщения {http://www.1c.ru/1cFresh/ApplicationExtensions/Control/a.b.c.d}ExtensionInstallFailed
//
// Параметры:
//  ИспользуемыйПакет - строка, пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ТипXDTO
//
Функция СообщениеОшибкаУстановкиДополнительногоОтчетаИлиОбработки(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "ExtensionInstallFailed");
	
КонецФункции

// Возвращает тип сообщения {http://www.1c.ru/1cFresh/ApplicationExtensions/Control/a.b.c.d}ExtensionDeleteFailed
//
// Параметры:
//  ИспользуемыйПакет - строка, пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ТипXDTO
//
Функция СообщениеОшибкаУдаленияДополнительногоОтчетаИлиОбработки(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "ExtensionDeleteFailed");
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Функция СоздатьТипСообщения(Знач ИспользуемыйПакет, Знач Тип)
	
	Если ИспользуемыйПакет = Неопределено Тогда
		ИспользуемыйПакет = Пакет();
	КонецЕсли;
	
	Возврат ФабрикаXDTO.Тип(ИспользуемыйПакет, Тип);
	
КонецФункции

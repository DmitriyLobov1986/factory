////////////////////////////////////////////////////////////////////////////////
// Подсистема "Рассылка отчетов" (вызов сервера)
// 
// Выполняется на сервере, но может вызываться с клиента.
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Для внутреннего использования.
//
Функция СформироватьСписокПолучателейРассылки(Знач Параметры) Экспорт
	ПараметрыЖурнала = Новый Структура("ИмяСобытия, Метаданные, Данные, МассивОшибок, БылиОшибки");
	ПараметрыЖурнала.ИмяСобытия   = НСтр("ru = 'Рассылка отчетов. Формирование списка получателей'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
	ПараметрыЖурнала.МассивОшибок = Новый Массив;
	ПараметрыЖурнала.БылиОшибки   = Ложь;
	ПараметрыЖурнала.Данные       = Параметры.Ссылка;
	ПараметрыЖурнала.Метаданные   = Метаданные.Справочники.РассылкиОтчетов;
	
	РезультатВыполнения = Новый Структура("Получатели, БылиКритичныеОшибки", , Ложь);
	РезультатВыполнения.Получатели = РассылкаОтчетов.СформироватьСписокПолучателейРассылки(ПараметрыЖурнала, Параметры);
	РезультатВыполнения.БылиКритичныеОшибки = РезультатВыполнения.Получатели.Количество() = 0;
	
	Если РезультатВыполнения.БылиКритичныеОшибки Тогда
		ТекстОшибок = РассылкаОтчетовКлиентСервер.СтрокаСообщенийПользователю(ПараметрыЖурнала.МассивОшибок, Ложь);
		
		РезультатВыполнения.Вставить(
			"ВыводПредупреждения", 
			Новый Структура(
				"Использование, Текст, ТекстОшибок",
				Истина,
				НСтр("ru = 'Не удалось сформировать список получателей'"),
				ТекстОшибок));
	КонецЕсли;
	
	Возврат РезультатВыполнения;
КонецФункции

// Обновляет состояние фонового задания и получает результат его выполнения из временного хранилища.
//
Функция ПроверитьВыполнениеФоновогоЗадания(ИдентификаторЗадания, АдресХранилища) Экспорт
	Результат = Новый Структура("Статус, Детали");
	Попытка
		Если ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания) Тогда
			Результат.Статус = "ВыполненоУспешно"; // Не локализуется
			Результат.Детали = ПолучитьИзВременногоХранилища(АдресХранилища);
		Иначе
			Результат.Статус = "Выполняется"; // Не локализуется
		КонецЕсли;
	Исключение
		Результат.Статус = "Исключение"; // Не локализуется
	КонецПопытки;
	Возврат Результат;
КонецФункции

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Процедура заполняет табличную часть списком валют. В список попадают только 
// валюты, курс которых не зависит от курса других валют.
//
Процедура ЗаполнитьСписокВалют() Экспорт
	
	СписокВалют.Очистить();
	
	ЗагружаемыеВалюты = РаботаСКурсамиВалют.ПолучитьМассивЗагружаемыхВалют();
	
	Для Каждого ЭлементВалюта Из ЗагружаемыеВалюты Цикл
		НоваяСтрока = СписокВалют.Добавить();
		НоваяСтрока.КодВалюты = ЭлементВалюта.Код;
		НоваяСтрока.Валюта    = ЭлементВалюта;
	КонецЦикла;
	
КонецПроцедуры

// Процедура для каждой загружаемой валюты запрашивает файл с курсами
// После загрузки, курсы, удовлетворяющие периоду записываются в регистр сведений
//
Функция ЗагрузитьКурсыВалют(ПриЗагрузкеВозниклиОшибки = Ложь) Экспорт
	
	Возврат РаботаСКурсамиВалютКлиентСервер.ЗагрузитьКурсыВалютПоПараметрам(
		СписокВалют,
		НачалоПериодаЗагрузки,
		ОкончаниеПериодаЗагрузки,
		ПриЗагрузкеВозниклиОшибки);
	
КонецФункции

#КонецЕсли

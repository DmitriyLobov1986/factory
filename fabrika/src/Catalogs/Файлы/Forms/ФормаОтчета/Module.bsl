////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Отчет = РаботаСФайламиСлужебныйВызовСервера.ИмпортФайловСформироватьОтчет(
		Параметры.МассивИменФайловСОшибками);
	
	Если Параметры.Свойство("Заголовок") Тогда
		Заголовок = Параметры.Заголовок;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ОтчетВыбор(Элемент, Область, СтандартнаяОбработка)
	
#Если Не ВебКлиент Тогда
	// Путь к файлу.
	Если Найти(Область.Текст, ":\") > 0 ИЛИ Найти(Область.Текст, ":/") > 0 Тогда
		ФайловыеФункцииСлужебныйКлиент.ОткрытьПроводникСФайлом(Область.Текст);
	КонецЕсли;
#КонецЕсли
	
КонецПроцедуры

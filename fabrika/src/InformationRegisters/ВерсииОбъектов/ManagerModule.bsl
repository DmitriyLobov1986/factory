#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Процедура УдалитьИнформациюОбАвтореВерсии(Знач АвторВерсии) Экспорт
	
	Если Не ОбщегоНазначенияПовтИсп.ДоступноИспользованиеРазделенныхДанных() Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ВерсииОбъектов.Объект,
	|	ВерсииОбъектов.НомерВерсии,
	|	ВерсииОбъектов.ВерсияОбъекта,
	|	НЕОПРЕДЕЛЕНО КАК АвторВерсии,
	|	ВерсииОбъектов.ДатаВерсии,
	|	ВерсииОбъектов.Комментарий,
	|	ВерсииОбъектов.ТипВерсииОбъекта,
	|	ВерсииОбъектов.ВерсияПроигнорирована
	|ИЗ
	|	РегистрСведений.ВерсииОбъектов КАК ВерсииОбъектов
	|ГДЕ
	|	ВерсииОбъектов.АвторВерсии = &АвторВерсии";
	
	Запрос.УстановитьПараметр("АвторВерсии", АвторВерсии);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		НаборЗаписей = РегистрыСведений.ВерсииОбъектов.СоздатьНаборЗаписей();
		
		НаборЗаписей.Отбор["Объект"].Установить(Выборка["Объект"]);
		НаборЗаписей.Отбор["НомерВерсии"].Установить(Выборка["НомерВерсии"]);
		
		ЗаполнитьЗначенияСвойств(НаборЗаписей.Добавить(), Выборка);
		
		НаборЗаписей.Записать();
		
	КонецЦикла;
	
КонецПроцедуры

#КонецЕсли
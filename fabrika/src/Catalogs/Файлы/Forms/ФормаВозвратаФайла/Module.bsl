////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Файл = Параметры.ФайлСсылка;
	
	Если Файл.ХранитьВерсии Тогда
		СоздатьНовуюВерсию = Истина;
	Иначе
		СоздатьНовуюВерсию = Ложь;
		Элементы.СоздатьНовуюВерсию.Доступность = Ложь;
	КонецЕсли;	
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ОК(Команда)
	СтруктураВозврата = Новый Структура("КомментарийКВерсии, СоздатьНовуюВерсию, КодВозврата", 
		КомментарийКВерсии, СоздатьНовуюВерсию, КодВозвратаДиалога.ОК);
	Закрыть(СтруктураВозврата);
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	СтруктураВозврата = Новый Структура("КомментарийКВерсии, СоздатьНовуюВерсию, КодВозврата", 
		КомментарийКВерсии, СоздатьНовуюВерсию, КодВозвратаДиалога.Отмена);
	Закрыть(СтруктураВозврата);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура УстановитьПараметрыИспользования(СтруктураПараметров) Экспорт
	
	Параметры.ФайлСсылка = СтруктураПараметров.ФайлСсылка;
	КомментарийКВерсии = СтруктураПараметров.КомментарийКВерсии;
	Файл = СтруктураПараметров.ФайлСсылка;
	СоздатьНовуюВерсию = СтруктураПараметров.СоздатьНовуюВерсию;
	Элементы.СоздатьНовуюВерсию.Доступность = СтруктураПараметров.СоздатьНовуюВерсиюДоступность;

КонецПроцедуры	

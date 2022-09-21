////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ВключитьОтключитьРегламентноеЗадание(Команда)
	
	ВыделенныеСтроки = Элементы.Список.ВыделенныеСтроки;
	
	Если ВыделенныеСтроки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	ВключитьОтключитьРегламентноеЗаданиеНаСервере(ВыделенныеСтроки, Не ТекущиеДанные.ИспользоватьРегламентноеЗадание);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура ВключитьОтключитьРегламентноеЗаданиеНаСервере(ВыделенныеСтроки, ИспользоватьРегламентноеЗадание)
	
	Для Каждого ДанныеСтроки ИЗ ВыделенныеСтроки Цикл
		
		Если ДанныеСтроки.ПометкаУдаления Тогда
			Продолжить;
		КонецЕсли;
		
		НастройкаОбъект = ДанныеСтроки.Ссылка.ПолучитьОбъект();
		НастройкаОбъект.ИспользоватьРегламентноеЗадание = ИспользоватьРегламентноеЗадание;
		НастройкаОбъект.Записать();
		
	КонецЦикла;
	
	// обновляем данные списка
	Элементы.Список.Обновить();
	
КонецПроцедуры


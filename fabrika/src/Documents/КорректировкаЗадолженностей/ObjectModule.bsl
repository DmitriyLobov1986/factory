
Процедура ОбработкаПроведения(Отказ, Режим)
	
	// регистр ТаможняВзаимозадолженности
	Движения.ТаможняВзаимозадолженности.Записывать = Истина;
	Движение = Движения.ТаможняВзаимозадолженности.Добавить();
	Движение.ВидДвижения = ?(Сумма < 0, ВидДвиженияНакопления.Расход, ВидДвиженияНакопления.Приход);
	Движение.Период = ДатаКорректировки;
	Движение.Организация = Организация;
	Движение.Контрагент = Контрагент;
	Движение.ДоговорыКонтрагентов = ДоговорыКонтрагентов;
	
	Если Контрагент.ВалютныйРассчёт И
		                              ДоговорыКонтрагентов.Валюта.Код <> "643" Тогда
		Движение.ВалютнаяСуммаДолга = Макс(Сумма, -Сумма);
	Иначе  
		Движение.СуммаДолга = Макс(Сумма, -Сумма);
	КонецЕсли;	
	
	Движение.ТипДвижения = "Корректировка задолженностей";
	
КонецПроцедуры

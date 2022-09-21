
Процедура ОбработкаПроведения(Отказ, Режим)
	
	Отказ = ПроверитьУникальностьМашины();  
	Если Отказ Тогда
		Возврат;
	КонецЕсли;	
	
	ПроведениеПоРегиструТаможня();
	
КонецПроцедуры

//Проведение по регистру таможня
Процедура ПроведениеПоРегиструТаможня()
	
	// регистр Таможня Приход
	Движения.Таможня.Записывать = Истина;
	Движение = Движения.Таможня.Добавить();
	Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
	Движение.Период = ДатаПрихода;
	Движение.СчётСписания = СчётСписания;
	Движение.Организация = Организация;
	
	Если НЕ ЗначениеЗаполнено(ВалютнаяСтоимость) Тогда
		Движение.СуммаUSD = ТаможенныйПлатёж;
		
	Иначе
		Если ЗначениеЗаполнено(Валюта) Тогда
			Движение.СуммаФакт = СуммаТамПлат;
		Иначе
			Движение.СуммаФакт = ТаможенныйПлатёж;
		КонецЕсли;  
		
	КонецЕсли;	
		
	Движение.ТипДвижения = "Заявка на машину";
		
КонецПроцедуры


//=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>
Функция ПроверитьУникальностьМашины()

	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ЗаявкаНаМашину.Ссылка
	               |ИЗ
	               |	Документ.ЗаявкаНаМашину КАК ЗаявкаНаМашину
	               |ГДЕ
	               |	ЗаявкаНаМашину.ПометкаУдаления = ЛОЖЬ
	               |	И ЗаявкаНаМашину.Ссылка <> &ТекущийОбъект
	               |	И ЗаявкаНаМашину.НомерМашины = &НомерМашины
	               |	И ГОД(ЗаявкаНаМашину.ДатаПрихода) = &Год
	               |	И ЗаявкаНаМашину.ВидМашины = &ВидМашины";
				   
	Запрос.УстановитьПараметр("ТекущийОбъект", Ссылка);
	Запрос.УстановитьПараметр("НомерМашины", НомерМашины);
	Запрос.УстановитьПараметр("ВидМашины", ВидМашины);
	Запрос.УстановитьПараметр("Год", Год(ДатаПрихода));
	
	Результат = Запрос.Выполнить().Выгрузить();
	
	Если Результат.Количество() > 0 Тогда
		Для Каждого Документ Из Результат Цикл
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Строка(ВидМашины) + " не уникальна!!!", Документ.Ссылка, "НомерМашины");
		КонецЦикла;
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
		

КонецФункции // ПроверитьУникальностьМашины()
//=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>




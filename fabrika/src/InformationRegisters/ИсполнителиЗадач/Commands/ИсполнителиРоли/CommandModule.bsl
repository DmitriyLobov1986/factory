
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	ПараметрыФормы = Новый Структура("РольИсполнителя", ПараметрКоманды);
	ОткрытьФорму("РегистрСведений.ИсполнителиЗадач.Форма.ИсполнителиРоли", ПараметрыФормы, 
		ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно);
КонецПроцедуры

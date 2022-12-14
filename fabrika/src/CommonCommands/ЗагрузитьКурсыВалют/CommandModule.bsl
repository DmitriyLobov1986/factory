
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	Если Вопрос("Будет произведена загрузка файла с полной информацией по курсами всех валют за все время из менеджера сервиса.
		|Курсы валют, помеченных в областях данных для загрузки из сети Интернет, будут заменены в фоновом задании. Продолжить?", 
		РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;
	
	ЗагрузитьКурсы();
	
	ПоказатьОповещениеПользователя(
		НСтр("ru = 'Загрузка запланирована.'"), ,
		НСтр("ru = 'Курсы будут загружены в фоновом режиме через непродолжительное время.'"),
		БиблиотекаКартинок.Информация32);
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьКурсы()
	
	КурсыВалютСлужебныйВМоделиСервиса.ЗагрузитьКурсы();
	
КонецПроцедуры

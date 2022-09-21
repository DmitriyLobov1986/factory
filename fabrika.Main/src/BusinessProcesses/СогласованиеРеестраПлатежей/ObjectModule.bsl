
&После("ВыполнитьПередСозданиемЗадач")
Процедура Расш1_ВыполнитьПередСозданиемЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, СтандартнаяОбработка)
	
	ОтправитьИнформациюВбитрикс(ТочкаМаршрутаБизнесПроцесса);

КонецПроцедуры




#Область Битрикс

Процедура ОтправитьИнформациюВбитрикс(ТочкаМаршрутаБизнесПроцесса)
	
	//
	УстановитьПривилегированныйРежим(Истина);
	//
	
	Попытка
		//Получим Обработку
		Telegram = Справочники.ДополнительныеОтчетыИОбработки.НайтиПоНаименованию("Telegram");
		ИмяОбработки = ДополнительныеОтчетыИОбработкиВызовСервера.ПодключитьВнешнююОбработку(Telegram);
		Битрикс = ВнешниеОбработки.Создать(ИмяОбработки);
		Битрикс.ЗаполнитьНастройкиTelegram();
		
		//Опеределим Код чата для отправки
		ОбъектПоиска = ?(Глоссаб, Перечисления.ТипОрганизации.Глоссаб, Перечисления.ТипОрганизации.Розница);
		Настройки = Битрикс.КодыЧатовБитрикс.НайтиСтроки(Новый Структура("Объект", ОбъектПоиска));
		Если Настройки = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		//Отправка
		Для Каждого Настройка Из Настройки Цикл 
			
			Точка = СтрЗаменить(ТочкаМаршрутаБизнесПроцесса.НаименованиеЗадачи, "Бухгалтерия", "Бухгалтерия_Финансовый директор");
			
			Сообщение = "[B]" + Наименование + ?(Глоссаб, "_Запад", "_Россия") + " " + Формат(ТекущаяДата(), "ДФ=ЧЧ:мм:сс")
		                                                                                 + " " + Строка(Точка) + "[/B]";
		    Битрикс.ОтправитьВБитрикс(Настройка.КодЧатаБитрикс, Сообщение);
		  
	    КонецЦикла;  
	  
	Исключение
	КонецПопытки;	
	
	//
	УстановитьПривилегированныйРежим(Ложь);
	//
	
	
КонецПроцедуры	
	




#КонецОбласти
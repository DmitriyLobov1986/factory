
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Разрешение = ОбщийМодульСервер.РазрешитьФормированиеОтчета("Остатки звена", 600);
	Элементы.ФормаЗагрузкаБухгалтерия.Доступность = НЕ Разрешение.Остатки_звена;
	Элементы.ФормаСформировать.Доступность = НЕ Разрешение.Остатки_звена;
	
	ПериодЗагрузки = Разрешение.МоментЗагрузки;
	Если Разрешение.МоментЗагрузки <> "" тогда
	  СкомпоноватьРезультат();
  Иначе 
	 ПодключитьОбработчикОжидания("Обработчик", 60);  
	КонецЕсли;
	  
КонецПроцедуры

&НаКлиенте
Процедура Обработчик()
	
  Разрешение = ОбщийМодульСервер.РазрешитьФормированиеОтчета("Остатки звена", 600);
  
  //Прочитаем последнюю запись в логе загрузки
  Если Разрешение.Остатки_звена Тогда
	  ОбщийМодульСервер.ЧтениеЛоговСценариевДедактор("Остатки звена");
  КонецЕсли;
	
  Если (ТекущаяДата()- МоментЗагрузки) > 60 Тогда
    Элементы.ФормаЗагрузкаБухгалтерия.Доступность = НЕ Разрешение.Остатки_звена;
	Элементы.ФормаСформировать.Доступность = НЕ Разрешение.Остатки_звена;
  КонецЕсли;
  
  ПериодЗагрузки = Разрешение.МоментЗагрузки;	
  Если Разрешение.МоментЗагрузки <> "" тогда
    СкомпоноватьРезультат();
	ОтключитьОбработчикОжидания("Обработчик");
	Элементы.Результат.ОтображениеСостояния.ДополнительныйРежимОтображения = ДополнительныйРежимОтображения.НеИспользовать;
	Элементы.Результат.ОтображениеСостояния.Видимость = Ложь;
  КонецЕсли;

  	
КонецПроцедуры	


//=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>
&НаКлиенте
Процедура ЗагрузкаБухгалтерия(Команда)
	
	ЗагрузитьВариантНаСервере("Бух");
	Элементы.ФормаЗагрузкаБухгалтерия.Доступность = Ложь;
	Элементы.ФормаСформировать.Доступность = Ложь;
	
	Элементы.Результат.ОтображениеСостояния.ДополнительныйРежимОтображения = ДополнительныйРежимОтображения.Неактуальность;
	Элементы.Результат.ОтображениеСостояния.Текст = "Отчет формируется ...";	
	Элементы.Результат.ОтображениеСостояния.Видимость = Истина;
	
	МоментЗагрузки = ТекущаяДата();
	ПодключитьОбработчикОжидания("Обработчик", 60);
   	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗагрузитьВариантНаСервере(Отчёт)
	
	Если Отчёт = "Бух" тогда
	  ОбщийМодульСервер.ЗапускСценарияДедактор("Остатки звена");
	КонецЕсли; 
	
	Если Отчёт = "Актуэль" тогда
	  ЗапуститьПриложение("C:\WWW\Авто загрузки\Актуэль.bat", "C:\WWW\Авто загрузки",Истина);
	КонецЕсли;
	
КонецПроцедуры	


//=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>
&НаКлиенте
Процедура ЗагрузкаАктуэль(Команда)
	
	Сообщить("Загрузка Актуэль");
	Элементы.ФормаЗагрузкаАктуэль.Доступность = Ложь;
	ПодключитьОбработчикОжидания("Обработчик2", 20);
	
КонецПроцедуры

&НаКлиенте
Процедура Обработчик2()
	
  ЗагрузитьВариантНаСервере("Актуэль");	
  Элементы.ФормаЗагрузкаАктуэль.Доступность = Истина;	
  ОтключитьОбработчикОжидания("Обработчик2");
  
	
КонецПроцедуры


//////////////////////////////////////ПРОЦЕДУРЫ И ФУНКЦИИ ИСПОЛНЯЕМЫЕ НА СЕРВЕРЕ//////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Функция РазрешитьФормированиеОтчета(ИмяОтчета, Таймаут) Экспорт 
	
		
		
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	dbo_KontrZagr.Otchet КАК Отчет,
		|	dbo_KontrZagr.Status КАК Статус,
		|	dbo_KontrZagr.Moment КАК Момент
		|ИЗ
		|	ВнешнийИсточникДанных.SqlLolita.Таблица.dbo_KontrZagr КАК dbo_KontrZagr
		|ГДЕ
		|	dbo_KontrZagr.Otchet В(&Otchet)";

	Запрос.УстановитьПараметр("Otchet", ИмяОтчета);

	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
    
	РезультатВозврата = Новый Структура;
	
	Пока Выборка.Следующий() Цикл
		Если (Выборка.Статус = 1 И (ТекущаяДата()- Выборка.Момент) < Таймаут)  Тогда //Загрузка не завершена
			
			РезультатВозврата.Вставить(СтрЗаменить(Выборка.Отчет, " ", "_"), Истина);
			
		Иначе
			
			РезультатВозврата.Вставить(СтрЗаменить(Выборка.Отчет, " ", "_"), Ложь);
			
		КонецЕсли;	
	КонецЦикла;
	
	Если Выборка.Статус = 0 Тогда                                                    //Загрузка завершена
		
		  РезультатВозврата.Вставить("МоментЗагрузки", Выборка.Момент);
		
	  Иначе 
		  РезультатВозврата.Вставить("МоментЗагрузки","");	
		  
	КонецЕсли;	  
	
	Возврат РезультатВозврата;
	
КонецФункции	

Функция РазрешитьФормированиеОтчета1(ИмяОтчета, Таймаут) Экспорт 
	

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	dbo_KontrZagr.Otchet,
		|	dbo_KontrZagr.Status,
		|	dbo_KontrZagr.Moment
		|ИЗ
		|	ВнешнийИсточникДанных.SqlLolita.Таблица.dbo_KontrZagr КАК dbo_KontrZagr
		|ГДЕ
		|	dbo_KontrZagr.Otchet = &Otchet";

	Запрос.УстановитьПараметр("Otchet", ИмяОтчета);

	Результат = Запрос.Выполнить();

	Если Не Результат.Пустой() Тогда
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		Если (Выборка.Status = 1 И (ТекущаяДата()- Выборка.Moment) < Таймаут)  Тогда
			
			Возврат Истина; 
			
		Иначе
			
			Возврат Ложь;
		КонецЕсли;	
	КонецЕсли;
	
КонецФункции	


////Дима 29.07.2014 16:17:52////Получение границы регистратора в регистре накопления
////Возвращает значения запрашиваемых полей(МассивПараметров) регистра
Функция ПолучениеЗаписейРегистраПоРегистратору(ИмяРегистраНакопления, Регистратор, МассивПараметров) Экспорт 
	
	Выборка = РегистрыНакопления[ИмяРегистраНакопления].ВыбратьПоРегистратору(Регистратор);
	ЗаписиРегистра = Новый Массив;	
	
	Пока Выборка.Следующий() Цикл
		
		ЗначенияПараметров = Новый Структура;
		Для каждого параметр Из МассивПараметров Цикл
			
			Если Параметр <> "МоментВремени" Тогда
				ЗначенияПараметров.Вставить(параметр, Выборка[параметр]) 	
			Иначе
				ЗначенияПараметров.Вставить(параметр, Выборка.МоментВремени())
			КонецЕсли;
			
		КонецЦикла;	
		
		ЗаписиРегистра.Добавить(ЗначенияПараметров); 
		
		
	КонецЦикла;	
	
	Возврат ЗаписиРегистра;
	
КонецФункции

////Дима 05.08.2014 17:23:01////Устанавливает границу периода загрузки
//Граница периода загрузки равна общей дате запрета для всех пользователей
Функция ГраницаПериодаЗагрузки() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ДатыЗапретаИзменения.ДатаЗапрета
		|ИЗ
		|	РегистрСведений.ДатыЗапретаИзменения КАК ДатыЗапретаИзменения
		|ГДЕ
		|	ДатыЗапретаИзменения.Пользователь = ЗНАЧЕНИЕ(Перечисление.ВидыНазначенияДатЗапрета.ДляВсехПользователей)";

	
	РезультатЗапроса = Запрос.Выполнить().Выгрузить();

	Если РезультатЗапроса.Количество() > 0 Тогда
		возврат РезультатЗапроса[0].ДатаЗапрета;
	Иначе
		возврат Дата(1,1,1);
	КонецЕсли; 
	
		

КонецФункции

////Дима 12.08.2014 12:46:01////Получение объектов с заданной дополнительной характеристикой
Функция ПолучениеДополнительныхХарактеристик(Характеристика, Значение) Экспорт 
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЗначенияХарактеристикОбъектов.Объект
		|ИЗ
		|	РегистрСведений.ЗначенияХарактеристикОбъектов КАК ЗначенияХарактеристикОбъектов
		|ГДЕ
		|	ЗначенияХарактеристикОбъектов.Характеристика = &Характеристика
		|	И ЗначенияХарактеристикОбъектов.Значение = &Значение";

	Запрос.УстановитьПараметр("Значение", Значение);
	Запрос.УстановитьПараметр("Характеристика", Характеристика);

	Результат = Запрос.Выполнить().Выгрузить();
	
	Если Результат.Количество() > 0 Тогда 
		возврат Результат.ВыгрузитьКолонку("Объект");
	Иначе
		возврат Неопределено;
	КонецЕсли;  
	

КонецФункции

////Добавить сообщение в массив сообщений пользователя
Процедура ДобавитьСоообщениеВмассив(Объект = Неопределено, 
	                                ТекстСообщения, 
									ИдентификаторФормы = Неопределено, 
									Поле = Неопределено) Экспорт
	
	Сообщение = Новый СообщениеПользователю;
	
	Если Объект <> Неопределено Тогда
		Сообщение.УстановитьДанные(Объект);
	КонецЕсли;	
		
	Если ИдентификаторФормы <> Неопределено Тогда
		Сообщение.ИдентификаторНазначения = ИдентификаторФормы;
	КонецЕсли;	
		
	Если Поле <> Неопределено Тогда
		Сообщение.Поле = Поле;
	КонецЕсли;	
	
	Сообщение.Текст = ТекстСообщения;
	Сообщение.Сообщить();
	
КонецПроцедуры

////Дима 27.08.2014 17:23:12////Процедура вызывает внешнюю обработку для отправки SMS сообщений
Процедура ОтправкаSMS(ТекстСМС, Получатель) Экспорт
	
  Ссылка = Справочники.ДополнительныеОтчетыИОбработки.НайтиПоНаименованию("ОтправкаSMS");
  ИмяОбработки = ДополнительныеОтчетыИОбработкиВызовСервера.ПодключитьВнешнююОбработку(Ссылка);
  
  Обработка = ВнешниеОбработки.Создать(ИмяОбработки);
  
  //////////////////////////////////////////////////////////////////////////////////////////
    
  ТЗ = Новый ТаблицаЗначений;
  
  ТЗ.Колонки.Добавить("Телефон", Новый ОписаниеТипов("Строка", ,
  Новый КвалификаторыСтроки(50, ДопустимаяДлина.Переменная)));
  
  ТЗ.Колонки.Добавить("Статус", Новый ОписаниеТипов("Строка", ,
  Новый КвалификаторыСтроки(50, ДопустимаяДлина.Переменная)));								 
  
  ТЗ.Колонки.Добавить("ИДСообщения", Новый ОписаниеТипов("Строка", ,
  Новый КвалификаторыСтроки(50, ДопустимаяДлина.Переменная)));								 								 
  
  ТЗ.Колонки.Добавить("Флаг", Новый ОписаниеТипов("Булево"));
  
  ТЗ.Колонки.Добавить("ТипСмс", Новый ОписаниеТипов("Строка", ,
  Новый КвалификаторыСтроки(100, ДопустимаяДлина.Переменная)));
  
  ТЗ.Колонки.Добавить("Текст", Новый ОписаниеТипов("Строка", ,
  Новый КвалификаторыСтроки(1000, ДопустимаяДлина.Переменная)));
  
  ТЗ.Колонки.Добавить("ВремяОтправки", Новый ОписаниеТипов("Дата", , ,
  Новый КвалификаторыДаты(ЧастиДаты.ДатаВремя)));								   
									
  
  Запись = ТЗ.Добавить();
  Запись.Телефон = Получатель;
  Запись.Текст = ТекстСМС;
  Запись.Флаг = Истина;
  Запись.ИДСообщения = "";
  Запись.ВремяОтправки = ТекущаяДата();
  
                            
  Логин = "79161793422";
  Пароль = "Mazda155dfe";
  Отправитель = "";
  ТекстСМС = ТекстСМС;
  
    
  Попытка
	  Обработка.ОтправитьНаСервереИзМодуляОбъекта(ТЗ, Логин, Пароль, Отправитель, ТекстСМС);
  Исключение
	  
  КонецПопытки;
  
  
  
  //Сохраним данные в константу
  //=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>
  ХранилищеЗначения = Константы.СмсРассылка.Получить();
  ТЗсмс = ХранилищеЗначения.Получить();
  
  Если ТипЗнч(ТЗсмс) = Тип("ТаблицаЗначений") Тогда
	  ЗаполнитьЗначенияСвойств(ТЗсмс.Добавить(), Запись);
  Иначе	  
	  ТЗсмс = ТЗ;
  КонецЕсли;
  
  Константы.СмсРассылка.Установить(Новый ХранилищеЗначения(ТЗсмс, Новый СжатиеДанных(9)));
  //=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>

  
  
КонецПроцедуры	


////Дима 29.10.2015 10:03:18////Проверка дублирования ИНН при записи справочников Организаций и Контрагентов
Процедура ПроверкаДублированияИННПередЗаписью(Источник, Отказ) Экспорт
	
	Попытка
		ИНН = Источник.ИНН;
	Исключение
		Возврат;
	КонецПопытки;
	
	
	Если Источник.ДополнительныеСвойства.Свойство("НеКонтролироватьИНН") Тогда
		Возврат;
	КонецЕсли;	
	
	
	ИмяИсточника = Источник.Метаданные().Имя;
	
	Запрос = Новый Запрос;
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	Справочник.Ссылка КАК Ссылка
	               |ИЗ
	               |	Справочник." + ИмяИсточника + " КАК Справочник
	               |ГДЕ
	               |	Справочник.Ссылка <> &Ссылка
	               |	И Справочник.ПометкаУдаления = ЛОЖЬ
	               |	И Справочник.ИНН = &ИНН";
				   
				     
				   
	Запрос.УстановитьПараметр("Ссылка", Источник.Ссылка);
	Запрос.УстановитьПараметр("ИНН", ИНН);
				   
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Отказ = Истина;
		ДобавитьСоообщениеВмассив(, "Запись с таким ИНН уже существует!!!" + Символы.ПС + Выборка.Ссылка.Наименование);
	КонецЦикла;
	

КонецПроцедуры
//конец Дима






//////////////////////РАБОТА СО СЦЕНАРИЯМИ DEDUCTOR//////////////////////
/////////////////////////////////////////////////////////////////////////


////Дима 04.09.2014 11:09:18////Запускает сценарий Дедактор
Процедура ЗапускСценарияДедактор(Сценарий) Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СценарииДедактор.Путь КАК Путь
		|ИЗ
		|	РегистрСведений.СценарииДедактор КАК СценарииДедактор
		|ГДЕ
		|	СценарииДедактор.Сценарий = &Сценарий";

	Запрос.УстановитьПараметр("Сценарий", Сценарий);

	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
				
		ЗапуститьПриложение(Выборка.Путь);
		
	Иначе
	  ДобавитьСоообщениеВмассив(,"Данный сценарий не прописан в регистре..." + Символы.ПС + Сценарий);
	  
    КонецЕсли;
		
	

КонецПроцедуры

////Дима 04.09.2014 11:28:27////Чтение логов сценариев
Процедура ЧтениеЛоговСценариевДедактор(Сценарий) Экспорт 
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СценарииДедактор.Лог КАК Лог
		|ИЗ
		|	РегистрСведений.СценарииДедактор КАК СценарииДедактор
		|ГДЕ
		|	СценарииДедактор.Сценарий = &Сценарий";
	
	Запрос.УстановитьПараметр("Сценарий", Сценарий);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		
		Файл = Новый Файл(Выборка.Лог);
		Если Файл.Существует() Тогда
			ВременныйФайл = ПолучитьИмяВременногоФайла("txt");
			КопироватьФайл(Выборка.Лог, ВременныйФайл);
			
			Текст = Новый ТекстовыйДокумент;
			Текст.Прочитать(ВременныйФайл);
			ДобавитьСоообщениеВмассив(,Текст.ПолучитьСтроку(Текст.КоличествоСтрок()));
			УдалитьФайлы(ВременныйФайл);
						
		Иначе
			ДобавитьСоообщениеВмассив(,"Лог сценария не обнаружен...");
		КонецЕсли;	 
		
	Иначе
		ДобавитьСоообщениеВмассив(,"К данному сценарию не прописан лог..." + Символы.ПС + Сценарий);
		
	КонецЕсли;
	
	
КонецПроцедуры

/////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////



//////////////////////////////////////РАБОТА С ХРАНИЛИЩАМИ НАСТРОЕК //////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////

////Дима 15.05.2015 16:54:14////Записать данные в кеш настроек форм 
Процедура ЗаписатьКэшНастроекФорм(ИмяФормы, КлючРазмераФормы) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	//=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>
	
	Кэш = ХранилищеОбщихНастроек.Загрузить("РазмерФормы",,, "ЛобовДМ");
	
	Если Кэш = Неопределено Тогда
		Кэш = Новый Массив;
	КонецЕсли;
	
	Кэш.Добавить(ИмяФормы + "/" + КлючРазмераФормы + "/НастройкиОкна");
	Кэш.Добавить(ИмяФормы + "/" + КлючРазмераФормы + "/Такси/НастройкиОкна");
	
	ХранилищеОбщихНастроек.Сохранить("РазмерФормы", , Кэш,, "ЛобовДМ");
	
	//=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>
	УстановитьПривилегированныйРежим(Ложь);

КонецПроцедуры
//конец Дима

////Дима 18.05.2015 12:02:11////ОчиститьКэшНастроекФорм
Процедура ОчиститьКэшНастроекФорм() Экспорт

  УстановитьПривилегированныйРежим(Истина);
  //=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>
	
  Кэш = ХранилищеОбщихНастроек.Загрузить("РазмерФормы",,, "ЛобовДМ");
  
  Если Кэш = Неопределено Тогда 
	  возврат;
  КонецЕсли;	  
  
  Для Каждого элемент из Кэш Цикл
	  ХранилищеСистемныхНастроек.Удалить(элемент, "", Неопределено);
  КонецЦикла;
  
  ХранилищеОбщихНастроек.Сохранить("РазмерФормы", , Неопределено,, "ЛобовДМ");
  
  //=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>
  УстановитьПривилегированныйРежим(Ложь);
  

КонецПроцедуры
//конец Дима

////Дима 18.05.2015 10:16:48////Установить эталонные настройки формы
Процедура УстановитьЭталонныеНастройкиФормы(ИмяФормы, КлючРазмераФормы) Экспорт
	
	//для обычного интерфейса
	РазмерФормы = ХранилищеСистемныхНастроек.Загрузить(ИмяФормы + "/" + КлючРазмераФормы + "Эталон/НастройкиОкна", "");
	ХранилищеСистемныхНастроек.Сохранить(ИмяФормы + "/" + КлючРазмераФормы + "/НастройкиОкна", "", РазмерФормы);
	
	//для интерфейса "Такси"
	РазмерФормыТакси = ХранилищеСистемныхНастроек.Загрузить(ИмяФормы + "/" + КлючРазмераФормы + "Эталон/Такси/НастройкиОкна", "");
	ХранилищеСистемныхНастроек.Сохранить(ИмяФормы + "/" + КлючРазмераФормы + "/Такси/НастройкиОкна", "", РазмерФормыТакси);
	
КонецПроцедуры
//конец Дима

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////






//////////////////////////////////////РАБОТА С ТАБЛИЧНЫМ ДОКУМЕНТОМ///////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////


////Дима 11.11.2014 14:39:49
//Функция возвращает массив со значениями расшифровки поля и родителей
//СтруктураРасшифровки - переменная типа структура
//Расшифровка - расшифровка выделенной области
//Данные расшифровки - данные расшифровки отчёта
Функция ПолучениеРасшифровкиВСтруктуру(Расшифровка, АдресРасшифровки, СтруктураРасшифровки, Группа = "", ПоследнееЗначение = Неопределено) Экспорт
    Перем Ответ;
    
        
    ДанныеРасшифровки = ПолучитьИзВременногоХранилища(АдресРасшифровки);
	
    Попытка
        ЭлементРасшифровки = ДанныеРасшифровки.Элементы[Расшифровка];
		Поля = ЭлементРасшифровки.ПолучитьПоля();
        Для Каждого Поле Из Поля Цикл
             СтруктураРасшифровки.Вставить(Поле.Поле, Поле.Значение);
             ПоследнееЗначение = Поле.Значение;
		КонецЦикла;
    Исключение
        Группа = Строка(ПоследнееЗначение) + Группа;
	КонецПопытки;
	
	Родители = ДанныеРасшифровки.Элементы[Расшифровка].ПолучитьРодителей();
	Для Каждого родитель из Родители Цикл
		ПолучениеРасшифровкиВСтруктуру(родитель.идентификатор, АдресРасшифровки, СтруктураРасшифровки, Группа, ПоследнееЗначение);	
	КонецЦикла;
    
        
	возврат СтруктураРасшифровки;
	
	
	
КонецФункции
//конец Дима



////Дима 18.05.2017 11:25:24////Объединение одинаковых заголовком группировки
//=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>

// Проверка двух смежных ячеек на идентичночность
Функция ОбъединятьЯчейки(ТабДок, индСтр, индКол)

    Ячейка = ТабДок.Область(индСтр, индКол);
    ЯчейкаСлед = ТабДок.Область(индСтр, индКол+1);
    Если ПустаяСтрока(Ячейка.Текст) Тогда

        Возврат ложь

    ИначеЕсли
        //Проверяем на соответствие заголовка
        Ячейка.Текст = ЯчейкаСлед.Текст
        // Проверяем на соответствие имени (отсеиваем уже объединенные ячейки)
        и Ячейка.Имя = "R"+индСтр+"C"+индКол Тогда

        Возврат Истина;

    Иначе

        Возврат ложь

    КонецЕсли;

КонецФункции

// Обработка заголовков таблицы
//
// Параметры
//  Табл  - < Тип.ТабличныйДокумент> - Табличный документ формы
Процедура ОбработатьЗаголовки(ТабДок) Экспорт

    ОбъединяемаяОбласть = Неопределено;

    //Для оптимизации здесь нужно будет ограничить высоту таблицы
    Для индСтр=1 По ТабДок.ВысотаТаблицы Цикл

        НачальнаяКолонка = 0;
        Для индКол=1 По ТабДок.ШиринаТаблицы Цикл

            // определяем начало объединения
            Если ОбъединятьЯчейки(ТабДок, индСтр, индКол) Тогда

                Если не НачальнаяКолонка Тогда

                    НачальнаяКолонка = индКол;

                КонецЕсли;

            ИначеЕсли НачальнаяКолонка Тогда
                // завершаем объединение

                ТекстЗаголовка = ТабДок.Область(индСтр, индКол).Текст;
                ОбъединяемаяОбласть = ТабДок.Область(индСтр, НачальнаяКолонка, индСтр, индКол);
                ОбъединяемаяОбласть.Объединить();
                ОбъединяемаяОбласть.ГоризонтальноеПоложение = ГоризонтальноеПоложение.Центр;
                ОбъединяемаяОбласть.Текст = ТекстЗаголовка;
                НачальнаяКолонка = 0;

            Иначе

                НачальнаяКолонка = 0;

            КонецЕсли;

        КонецЦикла;

        // Если нашли в строке области для объединения, то прекращаем дальнейшие поиски
        Если не ОбъединяемаяОбласть = Неопределено Тогда

            возврат;

        КонецЕсли;

    КонецЦикла;

КонецПроцедуры

//=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>
//конец Дима

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////








//////////////////////////////////////ОБРАБОЧИКИ ТАБЛИЦЫ ЗНАЧЕНИЙ//////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////

//////Дима 17.07.2014 16:25:24////Проверка организаций на соответствие справочнику 
//В подаваемой ТЗ обязательно должны присутствовать поля ИНН и ТипОрганизации
Процедура ПроверкаОрганизацийНаСоотвествие(ТЗ, СвоиОрганизации = Истина) экспорт
	
	МенеджерВТ = Новый МенеджерВременныхТаблиц;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВТ;
	Запрос.Текст = 
	"ВЫБРАТЬ
	| *
	|ПОМЕСТИТЬ ТаблицаДанных
	|ИЗ
	|	&ТЗ КАК ТаблицаДанных";
	
	Запрос.УстановитьПараметр("ТЗ", ТЗ);
	Запрос.Выполнить();
	
	//=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>
	
	Запрос2 = Новый Запрос;
	Запрос2.МенеджерВременныхТаблиц = МенеджерВТ;
	Запрос2.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ТаблицаДанных.*,
	|   Организации.Ссылка КАК Ссылка
	|ИЗ
	|	ТаблицаДанных КАК ТаблицаДанных
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Организации КАК Организации
	|		ПО ТаблицаДанных.Инн = Организации.ИНН";
	
	
	
	Если СвоиОрганизации Тогда
		Условие = "И  ТаблицаДанных.ТипОрганизации = Организации.ТипОрганизации
		           |ГДЕ	НЕ Организации.Ссылка ЕСТЬ NULL
	               |       И  Организации.ПометкаУдаления = ЛОЖЬ
	               |	    И Организации.Закрыта = ЛОЖЬ";
				   
	Иначе			   
		Условие = "ГДЕ	Организации.Ссылка ЕСТЬ NULL";
	КонецЕсли;			   
	   
	
	
	Запрос2.Текст = Запрос2.Текст + Символы.ПС + Условие;	
	ТЗ = Запрос2.Выполнить().Выгрузить();
	
	
	
	
КонецПроцедуры
//КонецДима


////Дима 07.07.2017 16:44:58////Построение иерархии по заданному столбцу
// ТЗ - таблица значений
//Столбец - имя колонки по которой требуется сделать группировку
Функция ПостроитьИерархиюПоСтолбцу(ТЗ, Столбец) Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	| *
	|ПОМЕСТИТЬ ТаблицаДанных
	|ИЗ
	|	&ТЗ КАК ТаблицаДанных
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	*
	|ИЗ
	|	ТаблицаДанных КАК ТаблицаДанных
	|ИТОГИ ПО " + Столбец;
	

	Запрос.УстановитьПараметр("ТЗ", ТЗ);
	
	Возврат Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	

КонецФункции // ПостроитьИерархиюПоСтолбцу()
//конец Дима


//Получение сложного отбора из таблицы значений
//Параметры:
//ТЗ - таблица значений
//Колонка - имя колонки для установки отбора
//ВидСравнения - вид сравнения (системное перечисление)
//Значение - значение отбора
Функция ПолучитьСложныйОтборТЗ(Таблица,        
	                           Колонка,
							   ВидСравнения = Неопределено,
							   ВидСортировки = Неопределено,
							   знач Значение = Неопределено)     Экспорт

							   
  Построитель = Новый ПостроительЗапроса;
  Построитель.ИсточникДанных = Новый ОписаниеИсточникаДанных(Таблица);
 
  Если ВидСравнения <> Неопределено Тогда
    тОтбор = Построитель.Отбор.Добавить(Колонка);
    тОтбор.ВидСравнения = ВидСравнения;
    тОтбор.Значение = Значение;
    тОтбор.Использование = Истина;
  КонецЕсли;

  Если ВидСортировки <> Неопределено Тогда
	  Построитель.Порядок.Добавить(Колонка,,, ВидСортировки);
  КонецЕсли;	  
	  
  Построитель.Выполнить();
  Возврат Построитель.Результат.Выгрузить();
 
  КонецФункции

///////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////





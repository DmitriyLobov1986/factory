//////////////////////////////////////ГЛОБАЛЬНЫЕ ПЕРЕМЕННЫЕ МОДУЛЯ//////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////
Перем НомерСтроки;
////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////



//Проверяет поля структуры на соответствие регистру ДДС
Функция ПроверитьНаСоответствиеРегиструДДС() Экспорт
	
	НаборЗаписейРегистраДДС = РегистрыСведений.ДДС.СоздатьНаборЗаписей();	
	
	Для Каждого измерение из НаборЗаписейРегистраДДС.Отбор Цикл
		
		Попытка
			измерение.Установить(Расшифровка[измерение.Имя]);
		Исключение
			//Если измерение.Имя = "Получатель" И Расшифровка.ТипДвижения <> Перечисления.ТипДвиженияДДС.Списание Тогда 
			//	Расшифровка.Вставить("Получатель", Неопределено);
			//	измерение.Установить();
			//	продолжить;
			//КонецЕсли;
			//
			//Если измерение.Имя = "СчетКонтрагента" Тогда 
			//	Расшифровка.Вставить("СчетКонтрагента", Неопределено);
			//	измерение.Установить();
			//	продолжить;
			//КонецЕсли;
			//
			//Если измерение.Имя = "ДоговорыКонтрагентов" Тогда 
			//	Расшифровка.Вставить("ДоговорыКонтрагентов", Неопределено);
			//	измерение.Установить();
			//	продолжить;
			//КонецЕсли;
			//
			//Если измерение.Имя = "НомерПлатежа" Тогда 
			//	Расшифровка.Вставить("НомерПлатежа", Неопределено);
			//	измерение.Установить();
			//	продолжить;
			//КонецЕсли;
			//
			//Если измерение.Имя = "ТипОрганизации" Тогда
			//	Продолжить;
			//КонецЕсли;
			//						
			//СообщенияПользователю.Добавить("Не заполнено значение поля: " + измерение.Имя);
			//возврат Ложь;
					
		КонецПопытки;	
		
	КонецЦикла;	
	
	возврат Истина;
	
КонецФункции

//Проверяет данные структуры на наличие в регистре НастройкаПолей
//Если передается Таблица, то обязательно должна присутствовать колонка "Путь к реквизиту формы" для вывода сообщения об ошибке у этого реквизита
Функция ПроверитьНаСоответствиеРегиструНастройкаПолей(ТаблицаЗаписи = Неопределено) Экспорт
	
	Если ТаблицаЗаписи = Неопределено Тогда
		ТЗ = НаборЗаписейРегистраДДС.ВыгрузитьКолонки();
		ЗаполнитьЗначенияСвойств(ТЗ.Добавить(), Расшифровка);
	Иначе
		ТЗ = ТаблицаЗаписи;
	КонецЕсли;	
	
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|   *	
	|ПОМЕСТИТЬ ВТ_ТЗ
	|ИЗ
	|	&ТЗ КАК ТЗ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|   *,
	|	(ВЫБОР КОГДА НастройкаПолейОтправки.Организация ЕСТЬ NULL ТОГДА ИСТИНА ИНАЧЕ ЛОЖЬ КОНЕЦ) КАК Неверные 
	|ИЗ
	|	ВТ_ТЗ КАК ВТ_ТЗ
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НастройкаПолейОтправки КАК НастройкаПолейОтправки
	|		ПО ВТ_ТЗ.Организация = НастройкаПолейОтправки.Организация
	|			И ВТ_ТЗ.Получатель = НастройкаПолейОтправки.Получатель
	|			И ВТ_ТЗ.ТипДвижения = НастройкаПолейОтправки.ТипДвижения";
	
	
		
	
	
	Запрос.УстановитьПараметр("ТЗ", ТЗ);
	
	Результат = Запрос.Выполнить().Выгрузить();
	
	
	Если Результат.Найти(Истина, "Неверные") = Неопределено Тогда
		возврат Истина;
		
	ИначеЕсли ТаблицаЗаписи = Неопределено Тогда
		
		СообщенияПользователю.Добавить("Проверьте настройку полей:"+Символы.ПС+
		                 Расшифровка.Организация + Символы.ПС + Расшифровка.ТипДвижения + символы.ПС +
						 ?(Расшифровка.Получатель = Неопределено, "Неопределено", Расшифровка.Получатель));
		
		Возврат Ложь;
		
	Иначе
		Для Каждого строка из Результат Цикл
			
			Если НЕ строка.Неверные Тогда
				Продолжить;
			КонецЕсли;	
			
			#Если Сервер Тогда			
				ОбщийМодульСервер.ДобавитьСоообщениеВмассив(, "Нет данных в настройке полей!!!", , строка.ПутьКРеквизиту);
			#КонецЕсли                                                         
			
			
			#Если Клиент Тогда
				Сообщить("Нет данных в настройке полей!!!" + символы.ПС + строка.Организация + " " + строка.Получатель);	
			#КонецЕсли
			
			строка.Сумма = 0;
			
		КонецЦикла;
		
				
	КонецЕсли;	
	
	ТаблицаЗаписи = Результат;
	Возврат Ложь;
		
КонецФункции

//Запись данных структуры в регистр
Процедура ЗаписатьВРегистр() Экспорт
	
	НаборЗаписейРегистраДДС.Очистить();
	
	Если ЗначениеЗаполнено(Расшифровка.Сумма) Тогда
		Запись = НаборЗаписейРегистраДДС.Добавить();
		ЗаполнитьЗначенияСвойств(Запись, Расшифровка);
		Запись.ТипОрганизации = Запись.Организация.ТипОрганизации;
		Запись.ДатаПоступления = Запись.Период;
	КонецЕсли;  
	
	НаборЗаписейРегистраДДС.Записать();
		
КонецПроцедуры



//////////////////////////////////Процедуры, вызываемые из модуля формы//////////////////////////////////

//Заполняет рассчетные счета получателя
Процедура ЗаполнитьДанныеПоСчетам() Экспорт

	РаспределениеПоСчетам.Очистить();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|    ВЫРАЗИТЬ(&СчетОрганизации КАК Справочник.БанковскиеСчета) КАК СчетОтправителя,
		|    БанковскиеСчета.Ссылка КАК СчетКонтрагента
		|ПОМЕСТИТЬ ВР_ДанныеЗаполнения
		|ИЗ
		|    Справочник.БанковскиеСчета КАК БанковскиеСчета
		|ГДЕ
		|    ВЫБОР
		|        КОГДА &Владелец = ЗНАЧЕНИЕ(Справочник.ПолучателиДДС.Перевод)
		|            ТОГДА БанковскиеСчета.Владелец = &Организация
		|            И БанковскиеСчета.Ссылка <> &СчетОрганизации
		|            И БанковскиеСчета.Валюта = ВЫРАЗИТЬ(&СчетОрганизации КАК Справочник.БанковскиеСчета).Валюта
		|        КОГДА &Владелец = ЗНАЧЕНИЕ(Справочник.ПолучателиДДС.Конвертация)
		|            ТОГДА БанковскиеСчета.Владелец = &Организация
		|            И БанковскиеСчета.Ссылка <> &СчетОрганизации
		|            И БанковскиеСчета.БИК = ВЫРАЗИТЬ(&СчетОрганизации КАК Справочник.БанковскиеСчета).БИК
		|            И БанковскиеСчета.Валюта <> ВЫРАЗИТЬ(&СчетОрганизации КАК Справочник.БанковскиеСчета).Валюта
		|        КОГДА &Владелец = ЗНАЧЕНИЕ(Справочник.ПолучателиДДС.Депозит)
		|            ТОГДА БанковскиеСчета.Ссылка = &СчетОрганизации
		|        КОГДА ТИПЗНАЧЕНИЯ(&Владелец) = ТИП(Справочник.Контрагенты)
		|            ТОГДА БанковскиеСчета.Владелец = &Владелец
		|            И БанковскиеСчета.Валюта = ВЫРАЗИТЬ(&СчетОрганизации КАК Справочник.БанковскиеСчета).Валюта
		|        ИНАЧЕ БанковскиеСчета.Ссылка = &СчетОрганизации
		|    КОНЕЦ
		|    И БанковскиеСчета.НеИспользуется = ЛОЖЬ
		|    И БанковскиеСчета.ПометкаУдаления = ЛОЖЬ
		|    И БанковскиеСчета.Родитель = ЗНАЧЕНИЕ(Справочник.БанковскиеСчета.ПустаяСсылка)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ ПЕРВЫЕ 1
		|    ДДССрезПоследних.ДоговорыКонтрагентов КАК ДоговорыКонтрагентов,
		|    ДДССрезПоследних.Сумма КАК Сумма,
		|    ДДССрезПоследних.Период КАК Период,
		|    ДДССрезПоследних.Организация КАК Организация,
		|    ДДССрезПоследних.Получатель КАК Получатель
		|ПОМЕСТИТЬ ВТ_Договор
		|ИЗ
		|    РегистрСведений.ДДС.СрезПоследних(&Период, Организация = &Организация
		|    И Получатель = &Владелец
		|    И НЕ ДоговорыКонтрагентов = ЗНАЧЕНИЕ(Справочник.ДоговорыКонтрагентов.ПустаяСсылка)
		|    И ТипДвижения = ЗНАЧЕНИЕ(Перечисление.ТипДвиженияДДС.Списание)) КАК ДДССрезПоследних
		|
		|УПОРЯДОЧИТЬ ПО
		|    Период УБЫВ,
		|    Сумма УБЫВ
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|    &Организация КАК Организация,
		|    &Владелец КАК Владелец,
		|    ВР_ДанныеЗаполнения.СчетКонтрагента КАК СчетКонтрагента,
		|    ВЫБОР
		|        КОГДА ДДС.Сумма <> 0
		|            ТОГДА ДДС.ДоговорыКонтрагентов
		|        ИНАЧЕ ВТ_Договор.ДоговорыКонтрагентов
		|    КОНЕЦ КАК ДоговорыКонтрагентов,
		|    ДДС.Сумма КАК Сумма,
		|    ВР_ДанныеЗаполнения.СчетКонтрагента.Валюта КАК Валюта,
		|    ВЫБОР
		|        КОГДА ДДС.Курс > 0
		|            ТОГДА ДДС.Курс
		|        ИНАЧЕ ВЫБОР
		|            КОГДА ВР_ДанныеЗаполнения.СчетОтправителя.Валюта.Код = ""643""
		|            ИЛИ ВР_ДанныеЗаполнения.СчетОтправителя.Валюта.Код = ""810""
		|                ТОГДА КурсыВалют.Курс / КурсыВалют.Кратность
		|            ИНАЧЕ КурсыВалютОтправитель.Курс / КурсыВалютОтправитель.Кратность / ВЫБОР
		|                КОГДА ВР_ДанныеЗаполнения.СчетКонтрагента.Валюта.Код = ""643""
		|                ИЛИ ВР_ДанныеЗаполнения.СчетКонтрагента.Валюта.Код = ""810""
		|                    ТОГДА 1
		|                ИНАЧЕ КурсыВалют.Курс / КурсыВалют.Кратность
		|            КОНЕЦ
		|        КОНЕЦ
		|    КОНЕЦ КАК Курс,
		|    ДДС.СконвертированнаяСумма КАК СконвертированнаяСумма,
		|    ВЫБОР
		|        КОГДА ДДС.Сумма <> 0
		|            ТОГДА ДДС.ДеньВДень
		|        ИНАЧЕ ВЫБОР
		|            КОГДА ВР_ДанныеЗаполнения.СчетОтправителя.БИК = ВР_ДанныеЗаполнения.СчетКонтрагента.БИК
		|                ТОГДА ИСТИНА
		|            ИНАЧЕ ЛОЖЬ
		|        КОНЕЦ
		|    КОНЕЦ КАК ДеньВДень,
		|    ДДС.НомерПлатежа КАК НомерПлатежа,
		|    ДДС.НомерВБухгалтерии КАК НомерВБухгалтерии,
		|    ДДС.ДатаПоступления КАК ДатаПоступления,
		|    ДДС.Комментарий КАК Комментарий
		|ИЗ
		|    ВР_ДанныеЗаполнения КАК ВР_ДанныеЗаполнения
		|        ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ДДС КАК ДДС
		|        ПО (&СчетОрганизации = ДДС.СчетОрганизации)
		|        И (ВЫБОР
		|            КОГДА &ТипДвижения = ЗНАЧЕНИЕ(Перечисление.ТипДвиженияДДС.Поступление)
		|                ТОГДА &Владелец = ДДС.Получатель
		|            ИНАЧЕ ВР_ДанныеЗаполнения.СчетКонтрагента = ДДС.СчетКонтрагента
		|        КОНЕЦ)
		|        И (&Период = ДДС.Период)
		|        И (&ТипДвижения = ДДС.ТипДвижения)
		|        И (&Владелец = ДДС.Получатель)
		|        ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КурсыВалют КАК КурсыВалют
		|        ПО ВР_ДанныеЗаполнения.СчетКонтрагента.Валюта = КурсыВалют.Валюта
		|        И (&Период = КурсыВалют.Период)
		|        ЛЕВОЕ СОЕДИНЕНИЕ ВТ_Договор КАК ВТ_Договор
		|        ПО (&Организация = ВТ_Договор.Организация)
		|        И (&Владелец = ВТ_Договор.Получатель)
		|        ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КурсыВалют КАК КурсыВалютОтправитель
		|        ПО ВР_ДанныеЗаполнения.СчетОтправителя.Валюта = КурсыВалютОтправитель.Валюта
		|        И (&Период = КурсыВалютОтправитель.Период)
		|
		|УПОРЯДОЧИТЬ ПО
		|    ВР_ДанныеЗаполнения.СчетКонтрагента.ПорядокПредставления";

	Запрос.УстановитьПараметр("Владелец", Расшифровка.Получатель);
	Запрос.УстановитьПараметр("Организация", Расшифровка.Организация);
	Запрос.УстановитьПараметр("СчетОрганизации", Расшифровка.СчетОрганизации);
	Запрос.УстановитьПараметр("Период", Расшифровка.Период);
	Запрос.УстановитьПараметр("ТипДвижения", Расшифровка.ТипДвижения);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		строка = РаспределениеПоСчетам.Добавить();
		ЗаполнитьЗначенияСвойств(строка, Выборка);
		строка.СсылкаНаЗапись = ПолучитьНавигационнуюСсылкуНаЗапись(Выборка);
	КонецЦикла;
	
	
	//=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>
	Если РаспределениеПоСчетам.Количество() = 0 Тогда
		ОбщийМодульСервер.ДобавитьСоообщениеВмассив(, "Нет счетов для операции: " + строка(Расшифровка.Получатель));
	КонецЕсли;	
	
КонецПроцедуры

Процедура РаспределитьПоСчетам(ОстатокНаКонец) Экспорт
	
	Таблица = РаспределениеПоСчетам.Выгрузить();
	Таблица.Колонки.Владелец.Имя = "Получатель";
		
	Таблица.Колонки.Добавить("СчетОрганизации", Новый ОписаниеТипов("СправочникСсылка.БанковскиеСчета"));
	Таблица.ЗаполнитьЗначения(Расшифровка.СчетОрганизации, "СчетОрганизации");
	
	Таблица.Колонки.Добавить("Период", Новый ОписаниеТипов("Дата", , ,
									   Новый КвалификаторыДаты(ЧастиДаты.Дата)));
	Таблица.ЗаполнитьЗначения(Расшифровка.Период, "Период");
	
	Таблица.Колонки.Добавить("ТипДвижения", Новый ОписаниеТипов("ПеречислениеСсылка.ТипДвиженияДДС"));
	Таблица.ЗаполнитьЗначения(Расшифровка.ТипДвижения, "ТипДвижения");
	
		
	ПоляУдаления = Новый Массив;
	ПоляУдаления.Добавить("Период");
	ПоляУдаления.Добавить("Организация");
	ПоляУдаления.Добавить("СчетОрганизации");
	ПоляУдаления.Добавить("Получатель");
	
		
	ЗаполнитьНаборДвижений(Таблица, ПоляУдаления);	
	
	
	//=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>
	////Дима 03.06.2015 11:31:13////Запишем плановый остаток на начало
	//Если НЕ ЗначениеЗаполнено(Расшифровка.ДатаОстаткаНаНачало) ИЛИ ОстатокНаКонец = 0 Тогда
	//	возврат;
	//Иначе
	//	Таблица.Очистить();
	//	
	//	Таблица.Колонки.Удалить(Таблица.Колонки.Получатель);
	//	
	//	запись = Таблица.Добавить();
	//	ЗаполнитьЗначенияСвойств(запись, Расшифровка, "Организация, СчетОрганизации");
	//	запись.Период = Расшифровка.ДатаОстаткаНаНачало;
	//	запись.ТипДвижения = Перечисления.ТипДвиженияДДС.ОстатокНаНачало;
	//	запись.Сумма = ОстатокНаКонец;
	//	
	//	ПоляУдаления.Удалить(3);
	//	ПоляУдаления.Добавить("ТипДвижения");
	//	
	//	ЗаполнитьНаборДвижений(Таблица, ПоляУдаления);

	//	
	//КонецЕсли;	
	//конец Дима
	//=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>
	
КонецПроцедуры

//////////////////////////////////////////////////////////////////////////////////////////////////////////


//////////////////////////////////Запись движений в регистр сведений ДДС//////////////////////////////////

Процедура ЗаполнитьНаборДвижений(Таблица, ПоляУдаления, ФормаВыводаСообщений = Неопределено) Экспорт

	
	Итоги = "";
	Для Каждого поле из ПоляУдаления Цикл
		Итоги = Итоги + поле + "," + Символы.ПС;
	КонецЦикла;	
	Итоги = Сред(Итоги, 1, СтрДлина(Итоги) - 2);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	*
		|ПОМЕСТИТЬ ВТ_Загрузка
		|ИЗ
		|	&ТЗ КАК ТЗ
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	*,
		|   Организация.ТипОрганизации КАК ТипОрганизации
		|ИЗ
		|	ВТ_Загрузка КАК ВТ_Загрузка
		|ИТОГИ ПО" + Символы.ПС +  
		Итоги;
				
		
	Запрос.УстановитьПараметр("ТЗ", Таблица);	
		
	Результат = Запрос.Выполнить();

	Выборка = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	НаборЗаписейРегистраДДС = РегистрыСведений.ДДС.СоздатьНаборЗаписей();
	ЗаписатьНаборДвижений(Выборка, 0, ПоляУдаления);
	
	
	//
	ОбщийМодульСервер.ДобавитьСоообщениеВмассив( , "Данные добавлены в регистр ДДС", ФормаВыводаСообщений);
	//

	
КонецПроцедуры

Процедура ЗаписатьНаборДвижений(Выборка,
	                            Итерация,
								ПоляУдаления)
	
	Пока Выборка.Следующий() Цикл
		
		Если Итерация < ПоляУдаления.Количество() Тогда
			
			ЗначениеОтбора = Выборка[ПоляУдаления[Итерация]];
			ПолеОтбора = НаборЗаписейРегистраДДС.Отбор[ПоляУдаления[Итерация]];
			
			ПолеОтбора.Установить(ЗначениеОтбора);
			Если ЗначениеОтбора = Неопределено Тогда
				ПолеОтбора.Значение = Неопределено;
			КонецЕсли;	
				
				
			ЗаписатьНаборДвижений(Выборка.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам), Итерация + 1, ПоляУдаления);
			
			#Область ЗаписьДанныхВРегистрДДС
			Если Итерация = ПоляУдаления.Количество() - 1 Тогда
				
				#Если Сервер Тогда
					НаборЗаписейРегистраДДС.Записать();
				#КонецЕсли
				
				#Если Клиент Тогда
					ирОбщий.ЗаписатьОбъектЛкс(НаборЗаписейРегистраДДС, Истина);
				#КонецЕсли
				
				
				НаборЗаписейРегистраДДС.Очистить();	
				
				
			КонецЕсли;
			#КонецОбласти
			
			
		Иначе 
			Если Выборка.Сумма <> 0 Тогда
				запись = НаборЗаписейРегистраДДС.Добавить();
				ЗаполнитьЗначенияСвойств(запись, Выборка);
			КонецЕсли;
			
			//ЗаполнитьЗначенияСвойств(Расшифровка, Выборка);
			//НомерСтроки = Выборка.НомерСтроки;
			
		КонецЕсли;	
		
	КонецЦикла;	
	
КонецПроцедуры	

//////////////////////////////////////////////////////////////////////////////////////////////////////////


Функция ПолучитьНавигационнуюСсылкуНаЗапись(Запись)

	Отбор = Новый Структура;
	ИзмеренияДДС = Метаданные.РегистрыСведений.ДДС.Измерения;
	
	Для Каждого измерение из ИзмеренияДДС Цикл
		
		Попытка
			Отбор.Вставить(измерение.Имя, запись[измерение.Имя]);
		Исключение
		КонецПопытки  
		
	КонецЦикла;	
	
	Отбор.Вставить("Получатель", запись.Владелец);
	Отбор.Вставить("СчетОрганизации", Расшифровка.СчетОрганизации);
	Отбор.Вставить("ТипДвижения", Расшифровка.ТипДвижения);
	Отбор.Вставить("Период", Расшифровка.Период);
	Отбор.Вставить("ТипОрганизации", Расшифровка.Организация.ТипОрганизации);
	
	//Для поступления
	Если Отбор.ТипДвижения = Перечисления.ТипДвиженияДДС.Поступление Тогда
		Отбор.Удалить("СчетКонтрагента");
	КонецЕсли;
	//
	
	КлючЗаписиДДС = РегистрыСведений.ДДС.СоздатьКлючЗаписи(Отбор);
	
	возврат ПолучитьНавигационнуюСсылку(КлючЗаписиДДС);
	
		
КонецФункции



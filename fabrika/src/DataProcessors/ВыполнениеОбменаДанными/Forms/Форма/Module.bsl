
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	АдресДляВосстановленияПароляУчетнойЗаписи = Параметры.АдресДляВосстановленияПароляУчетнойЗаписи;
	ЗакрытьПриУспешнойСинхронизации           = Параметры.ЗакрытьПриУспешнойСинхронизации;
	УзелИнформационнойБазы                    = Параметры.УзелИнформационнойБазы;
	ЗавершениеРаботыСистемы                   = Параметры.ЗавершениеРаботыСистемы;
	
	Если Не ЗначениеЗаполнено(УзелИнформационнойБазы) Тогда
		
		Если ОбменДаннымиСервер.ЭтоПодчиненныйУзелРИБ() Тогда
			
			УзелИнформационнойБазы = ОбменДаннымиСервер.ГлавныйУзел();
			
		Иначе
			
			ОбменДаннымиСервер.СообщитьОбОшибке(НСтр("ru = 'Не заданы параметры формы. Форма не может быть открыта.'"), Отказ);
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
	ЕстьОшибки = ((ОбменДаннымиСервер.ГлавныйУзел() = УзелИнформационнойБазы) И КонфигурацияИзменена());
	
	// устанавливаем заголовок формы
	Заголовок = НСтр("ru = 'Синхронизация данных с ""%1""'");
	Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Заголовок, Строка(УзелИнформационнойБазы));
	
	//
	
	ВидТранспортаСообщений = РегистрыСведений.НастройкиТранспортаОбмена.ВидТранспортаСообщенийОбменаПоУмолчанию(УзелИнформационнойБазы);
	
	// При обмене в распределенной информационной базе через веб-сервис всегда переопределяем параметры аутентификации
	// (пользователь и пароль), сохраненные в информационной базе.
	// При обмене через веб-сервис для не-РИБ обменов параметры аутентификации (пароль) переопределяем (запрашиваем) только,
	// если пароль не сохранен в информационной базе.
	ИспользоватьТекущегоПользователяДляАутентификации = ОбменДаннымиПовтИсп.ЭтоУзелРаспределеннойИнформационнойБазы(УзелИнформационнойБазы);
	ПарольСинхронизацииЗадан = ОбменДаннымиСервер.ПарольСинхронизацииДанныхЗадан(УзелИнформационнойБазы);
	ПарольСинхронизацииСохранен = РегистрыСведений.НастройкиТранспортаОбмена.НастройкиТранспортаWS(УзелИнформационнойБазы).WSЗапомнитьПароль;
	ИспользоватьСохраненныеПараметрыАутентификации = Не ОбменДаннымиПовтИсп.ЭтоУзелРаспределеннойИнформационнойБазы(УзелИнформационнойБазы) И ПарольСинхронизацииСохранен;
	
	РольДоступнаДобавлениеИзменениеОбменовДанными = Пользователи.РолиДоступны("НастройкаСинхронизацииДанных");
	РольДоступнаПолныеПрава = Пользователи.РолиДоступны("ПолныеПрава");
	
	Элементы.ПанельТребуетсяОбновление.ТекущаяСтраница = ?(РольДоступнаПолныеПрава, Элементы.ТребуетсяОбновлениеПолныеПрава, Элементы.ТребуетсяОбновлениеОграниченныеПрава);
	Элементы.ТекстТребуетсяОбновлениеПолныеПрава.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Элементы.ТекстТребуетсяОбновлениеПолныеПрава.Заголовок, УзелИнформационнойБазы);
	Элементы.ТекстТребуетсяОбновлениеОграниченныеПрава.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Элементы.ТекстТребуетсяОбновлениеОграниченныеПрава.Заголовок, УзелИнформационнойБазы);
	
	Элементы.ЗабылиПароль.Видимость = Не ПустаяСтрока(АдресДляВосстановленияПароляУчетнойЗаписи);
	
	СинхронизацияДанныхОтключена = Ложь;
	ВыполнитьОтправкуДанных = Ложь;
	
	// Устанавливаем текущий сценарий работы обмена
	Если ЕстьОшибки Тогда
		
		СценарийКогдаЕстьОшибкиПриНачалеРаботы();
		
	ИначеЕсли ВидТранспортаСообщений = Перечисления.ВидыТранспортаСообщенийОбмена.WS Тогда
		
		ВыполнитьОтправкуДанных = РегистрыСведений.ОбщиеНастройкиУзловИнформационныхБаз.ВыполнитьОтправкуДанных(УзелИнформационнойБазы);
		
		Если ИспользоватьСохраненныеПараметрыАутентификации Тогда
			
			Если ПарольСинхронизацииСохранен Тогда
				
				Если ВыполнитьОтправкуДанных Тогда
					
					СценарийОбменаЧерезВебСервис_ОтправкаПолучениеОтправка();
					
				Иначе
					
					СценарийОбменаЧерезВебСервис();
					
				КонецЕсли;
				
			Иначе
				
				Если ВыполнитьОтправкуДанных Тогда
					
					СценарийОбменаЧерезВебСервисСЗапросомПароля_ОтправкаПолучениеОтправка();
					
				Иначе
					
					СценарийОбменаЧерезВебСервисСЗапросомПароля();
					
				КонецЕсли;
				
			КонецЕсли;
			
		Иначе
			
			Если ПарольСинхронизацииЗадан Тогда
				
				Если ВыполнитьОтправкуДанных Тогда
					
					СценарийОбменаЧерезВебСервис_ОтправкаПолучениеОтправка();
					
				Иначе
					
					СценарийОбменаЧерезВебСервис();
					
					
				КонецЕсли;
				
			Иначе
				
				Если ВыполнитьОтправкуДанных Тогда
					
					СценарийОбменаЧерезВебСервисСЗапросомПароля_ОтправкаПолучениеОтправка();
					
				Иначе
					
					СценарийОбменаЧерезВебСервисСЗапросомПароля();
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
	Иначе
		
		СценарийОбменаОбычный();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьПорядковыйНомерПерехода(1);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ПерейтиВЖурналРегистрации(Команда)
	
	ПараметрыФормы = ПолучитьСтруктуруДанныхОтбораЖурналаРегистрации(УзелИнформационнойБазы);
	ОткрытьФорму("Обработка.ЖурналРегистрации.Форма", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОбновление(Команда)
	Закрыть();
	ОбменДаннымиКлиент.ВыполнитьОбновлениеИнформационнойБазы(ЗавершениеРаботыСистемы);
КонецПроцедуры

&НаКлиенте
Процедура ЗабылиПароль(Команда)
	
	ОбменДаннымиКлиент.ПриОткрытииИнструкцииКакИзменитьПарольСинхронизацииДанных(АдресДляВосстановленияПароляУчетнойЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОбмен(Команда)
	
	ВыполнитьПереходДалее();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПОСТАВЛЯЕМАЯ ЧАСТЬ
////////////////////////////////////////////////////////////////////////////////

&НаКлиенте
Процедура ВыполнитьПереходДалее()
	
	ИзменитьПорядковыйНомерПерехода(+1);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьПорядковыйНомерПерехода(Итератор)
	
	ОчиститьСообщения();
	
	УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода + Итератор);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПорядковыйНомерПерехода(Знач Значение)
	
	ЭтоПереходДалее = (Значение > ПорядковыйНомерПерехода);
	
	ПорядковыйНомерПерехода = Значение;
	
	Если ПорядковыйНомерПерехода < 0 Тогда
		
		ПорядковыйНомерПерехода = 0;
		
	КонецЕсли;
	
	ПорядковыйНомерПереходаПриИзменении(ЭтоПереходДалее);
	
КонецПроцедуры

&НаКлиенте
Процедура ПорядковыйНомерПереходаПриИзменении(Знач ЭтоПереходДалее)
	
	// Выполняем обработчики событий перехода
	ВыполнитьОбработчикиСобытийПерехода(ЭтоПереходДалее);
	
	// Устанавливаем отображение страниц
	СтрокиПереходаТекущие = ТаблицаПереходов.НайтиСтроки(Новый Структура("ПорядковыйНомерПерехода", ПорядковыйНомерПерехода));
	
	Если СтрокиПереходаТекущие.Количество() = 0 Тогда
		ВызватьИсключение НСтр("ru = 'Не определена страница для отображения.'");
	КонецЕсли;
	
	СтрокаПереходаТекущая = СтрокиПереходаТекущие[0];
	
	Элементы.ВыполнениеОбменаДанными.ТекущаяСтраница  = Элементы[СтрокаПереходаТекущая.ИмяОсновнойСтраницы];
	
	Если ЭтоПереходДалее И СтрокаПереходаТекущая.ДлительнаяОперация Тогда
		
		ПодключитьОбработчикОжидания("ВыполнитьОбработчикДлительнойОперации", 0.1, Истина);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОбработчикиСобытийПерехода(Знач ЭтоПереходДалее)
	
	// Обработчики событий переходов
	Если ЭтоПереходДалее Тогда
		
		СтрокиПерехода = ТаблицаПереходов.НайтиСтроки(Новый Структура("ПорядковыйНомерПерехода", ПорядковыйНомерПерехода - 1));
		
		Если СтрокиПерехода.Количество() > 0 Тогда
			
			СтрокаПерехода = СтрокиПерехода[0];
			
			// обработчик ПриПереходеДалее
			Если Не ПустаяСтрока(СтрокаПерехода.ИмяОбработчикаПриПереходеДалее)
				И Не СтрокаПерехода.ДлительнаяОперация Тогда
				
				ИмяПроцедуры = "Подключаемый_[ИмяОбработчика](Отказ)";
				ИмяПроцедуры = СтрЗаменить(ИмяПроцедуры, "[ИмяОбработчика]", СтрокаПерехода.ИмяОбработчикаПриПереходеДалее);
				
				Отказ = Ложь;
				
				А = Вычислить(ИмяПроцедуры);
				
				Если Отказ Тогда
					
					УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода - 1);
					
					Возврат;
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
	Иначе
		
		СтрокиПерехода = ТаблицаПереходов.НайтиСтроки(Новый Структура("ПорядковыйНомерПерехода", ПорядковыйНомерПерехода + 1));
		
		Если СтрокиПерехода.Количество() > 0 Тогда
			
			СтрокаПерехода = СтрокиПерехода[0];
			
			// обработчик ПриПереходеНазад
			Если Не ПустаяСтрока(СтрокаПерехода.ИмяОбработчикаПриПереходеНазад)
				И Не СтрокаПерехода.ДлительнаяОперация Тогда
				
				ИмяПроцедуры = "Подключаемый_[ИмяОбработчика](Отказ)";
				ИмяПроцедуры = СтрЗаменить(ИмяПроцедуры, "[ИмяОбработчика]", СтрокаПерехода.ИмяОбработчикаПриПереходеНазад);
				
				Отказ = Ложь;
				
				А = Вычислить(ИмяПроцедуры);
				
				Если Отказ Тогда
					
					УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода + 1);
					
					Возврат;
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	СтрокиПереходаТекущие = ТаблицаПереходов.НайтиСтроки(Новый Структура("ПорядковыйНомерПерехода", ПорядковыйНомерПерехода));
	
	Если СтрокиПереходаТекущие.Количество() = 0 Тогда
		ВызватьИсключение НСтр("ru = 'Не определена страница для отображения.'");
	КонецЕсли;
	
	СтрокаПереходаТекущая = СтрокиПереходаТекущие[0];
	
	Если СтрокаПереходаТекущая.ДлительнаяОперация И Не ЭтоПереходДалее Тогда
		
		УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода - 1);
		Возврат;
	КонецЕсли;
	
	// обработчик ПриОткрытии
	Если Не ПустаяСтрока(СтрокаПереходаТекущая.ИмяОбработчикаПриОткрытии) Тогда
		
		ИмяПроцедуры = "Подключаемый_[ИмяОбработчика](Отказ, ПропуститьСтраницу, ЭтоПереходДалее)";
		ИмяПроцедуры = СтрЗаменить(ИмяПроцедуры, "[ИмяОбработчика]", СтрокаПереходаТекущая.ИмяОбработчикаПриОткрытии);
		
		Отказ = Ложь;
		ПропуститьСтраницу = Ложь;
		
		А = Вычислить(ИмяПроцедуры);
		
		Если Отказ Тогда
			
			УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода - 1);
			
			Возврат;
			
		ИначеЕсли ПропуститьСтраницу Тогда
			
			Если ЭтоПереходДалее Тогда
				
				УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода + 1);
				
				Возврат;
				
			Иначе
				
				УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода - 1);
				
				Возврат;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОбработчикДлительнойОперации()
	
	СтрокиПереходаТекущие = ТаблицаПереходов.НайтиСтроки(Новый Структура("ПорядковыйНомерПерехода", ПорядковыйНомерПерехода));
	
	Если СтрокиПереходаТекущие.Количество() = 0 Тогда
		ВызватьИсключение НСтр("ru = 'Не определена страница для отображения.'");
	КонецЕсли;
	
	СтрокаПереходаТекущая = СтрокиПереходаТекущие[0];
	
	// обработчик ОбработкаДлительнойОперации
	Если Не ПустаяСтрока(СтрокаПереходаТекущая.ИмяОбработчикаДлительнойОперации) Тогда
		
		ИмяПроцедуры = "Подключаемый_[ИмяОбработчика](Отказ, ПерейтиДалее)";
		ИмяПроцедуры = СтрЗаменить(ИмяПроцедуры, "[ИмяОбработчика]", СтрокаПереходаТекущая.ИмяОбработчикаДлительнойОперации);
		
		Отказ = Ложь;
		ПерейтиДалее = Истина;
		
		А = Вычислить(ИмяПроцедуры);
		
		Если Отказ Тогда
			
			УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода - 1);
			
			Возврат;
			
		ИначеЕсли ПерейтиДалее Тогда
			
			УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода + 1);
			
			Возврат;
			
		КонецЕсли;
		
	Иначе
		
		УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода + 1);
		
		Возврат;
		
	КонецЕсли;
	
КонецПроцедуры

// Добавляет новую строку в конец текущей таблицы переходов
//
// Параметры:
//
//  ПорядковыйНомерПерехода (обязательный) – Число. Порядковый номер перехода, который соответствует текущему шагу перехода
//  ИмяОсновнойСтраницы (обязательный) – Строка. Имя страницы панели "ПанельОсновная", которая соответствует текущему номеру перехода
//  ИмяСтраницыНавигации (обязательный) – Строка. Имя страницы панели "ПанельНавигации", которая соответствует текущему номеру перехода
//  ИмяСтраницыДекорации (необязательный) – Строка. Имя страницы панели "ПанельДекорации", которая соответствует текущему номеру перехода
//  ИмяОбработчикаПриОткрытии (необязательный) – Строка. Имя функции-обработчика события открытия текущей страницы помощника
//  ИмяОбработчикаПриПереходеДалее (необязательный) – Строка. Имя функции-обработчика события перехода на следующую страницу помощника
//  ИмяОбработчикаПриПереходеНазад (необязательный) – Строка. Имя функции-обработчика события перехода на предыдущую страницу помощника
//  ДлительнаяОперация (необязательный) - Булево. Признак отображения страницы длительной операции.
//  Истина - отображается страница длительной операции; Ложь - отображается обычная страница. Значение по умолчанию - Ложь.
// 
&НаСервере
Процедура ТаблицаПереходовНоваяСтрока(
									ПорядковыйНомерПерехода,
									ИмяОсновнойСтраницы,
									ИмяСтраницыНавигации,
									ИмяСтраницыДекорации = "",
									ИмяОбработчикаПриОткрытии = "",
									ИмяОбработчикаПриПереходеДалее = "",
									ИмяОбработчикаПриПереходеНазад = "",
									ДлительнаяОперация = Ложь,
									ИмяОбработчикаДлительнойОперации = "")
	НоваяСтрока = ТаблицаПереходов.Добавить();
	
	НоваяСтрока.ПорядковыйНомерПерехода = ПорядковыйНомерПерехода;
	НоваяСтрока.ИмяОсновнойСтраницы     = ИмяОсновнойСтраницы;
	НоваяСтрока.ИмяСтраницыДекорации    = ИмяСтраницыДекорации;
	НоваяСтрока.ИмяСтраницыНавигации    = ИмяСтраницыНавигации;
	
	НоваяСтрока.ИмяОбработчикаПриПереходеДалее = ИмяОбработчикаПриПереходеДалее;
	НоваяСтрока.ИмяОбработчикаПриПереходеНазад = ИмяОбработчикаПриПереходеНазад;
	НоваяСтрока.ИмяОбработчикаПриОткрытии      = ИмяОбработчикаПриОткрытии;
	
	НоваяСтрока.ДлительнаяОперация = ДлительнаяОперация;
	НоваяСтрока.ИмяОбработчикаДлительнойОперации = ИмяОбработчикаДлительнойОперации;
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьКнопкуФормыПоИмениКоманды(ЭлементФормы, ИмяКоманды)
	
	Для Каждого Элемент Из ЭлементФормы.ПодчиненныеЭлементы Цикл
		
		Если ТипЗнч(Элемент) = Тип("ГруппаФормы") Тогда
			
			ЭлементФормыПоИмениКоманды = ПолучитьКнопкуФормыПоИмениКоманды(Элемент, ИмяКоманды);
			
			Если ЭлементФормыПоИмениКоманды <> Неопределено Тогда
				
				Возврат ЭлементФормыПоИмениКоманды;
				
			КонецЕсли;
			
		ИначеЕсли ТипЗнч(Элемент) = Тип("КнопкаФормы")
			И Найти(Элемент.ИмяКоманды, ИмяКоманды) > 0 Тогда
			
			Возврат Элемент;
			
		Иначе
			
			Продолжить;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Неопределено;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ПЕРЕОПРЕДЕЛЯЕМАЯ ЧАСТЬ
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура ОбработчикОжиданияДлительнойОперации()
	
	ДлительнаяОперацияЗавершенаСОшибкой = Ложь;
	СообщениеОбОшибке = "";
	
	ПараметрыАутентификации = ?(ИспользоватьСохраненныеПараметрыАутентификации,
		Неопределено,
		Новый Структура("ИспользоватьТекущегоПользователя", ИспользоватьТекущегоПользователяДляАутентификации));
	
	СостояниеОперации = ОбменДаннымиВызовСервера.СостояниеДлительнойОперацииДляУзлаИнформационнойБазы(
		ИдентификаторДлительнойОперации,
		УзелИнформационнойБазы,
		ПараметрыАутентификации,
		СообщениеОбОшибке);
	
	Если СостояниеОперации = "Active" Тогда
		
		ПодключитьОбработчикОжидания("ОбработчикОжиданияДлительнойОперации", 5, Истина);
		
	Иначе
		
		Если СостояниеОперации <> "Completed" Тогда
			
			ДлительнаяОперацияЗавершенаСОшибкой = Истина;
			
			ЕстьОшибки = Истина;
			
		КонецЕсли;
		
		ДлительнаяОперация = Ложь;
		ДлительнаяОперацияЗавершена = Истина;
		
		ВыполнитьПереходДалее();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьСтруктуруДанныхОтбораЖурналаРегистрации(УзелИнформационнойБазы)
	
	ОтбираемыеСобытия = Новый Массив;
	ОтбираемыеСобытия.Добавить(ОбменДаннымиСервер.ПолучитьКлючСообщенияЖурналаРегистрации(УзелИнформационнойБазы, Перечисления.ДействияПриОбмене.ЗагрузкаДанных));
	ОтбираемыеСобытия.Добавить(ОбменДаннымиСервер.ПолучитьКлючСообщенияЖурналаРегистрации(УзелИнформационнойБазы, Перечисления.ДействияПриОбмене.ВыгрузкаДанных));
	
	СостоянияОбменовДаннымиЗагрузка = ОбменДаннымиСервер.СостоянияОбменовДанными(УзелИнформационнойБазы, Перечисления.ДействияПриОбмене.ЗагрузкаДанных);
	СостоянияОбменовДаннымиВыгрузка = ОбменДаннымиСервер.СостоянияОбменовДанными(УзелИнформационнойБазы, Перечисления.ДействияПриОбмене.ВыгрузкаДанных);
	
	Результат = Новый Структура;
	Результат.Вставить("СобытиеЖурналаРегистрации", ОтбираемыеСобытия);
	Результат.Вставить("ДатаНачала",    Мин(СостоянияОбменовДаннымиЗагрузка.ДатаНачала, СостоянияОбменовДаннымиВыгрузка.ДатаНачала));
	Результат.Вставить("ДатаОкончания", Макс(СостоянияОбменовДаннымиЗагрузка.ДатаОкончания, СостоянияОбменовДаннымиВыгрузка.ДатаОкончания));
	
	Возврат Результат;
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// РАЗДЕЛ ОБРАБОТЧИКОВ СОБЫТИЙ ПЕРЕХОДОВ

// Обмен через обычные каналы связи

&НаКлиенте
Функция Подключаемый_ОбычнаяЗагрузкаДанных_ОбработкаДлительнойОперации(Отказ, ПерейтиДалее)
	
	ОбычнаяЗагрузкаДанных_ОбработкаДлительнойОперации(Отказ, УзелИнформационнойБазы, ВидТранспортаСообщений);
	
	ЕстьОшибки = ЕстьОшибки ИЛИ Отказ;
	
	Отказ = Ложь; // чтобы не выполнять перехода назад
	
КонецФункции

&НаСервереБезКонтекста
Процедура ОбычнаяЗагрузкаДанных_ОбработкаДлительнойОперации(Отказ, Знач УзелИнформационнойБазы, Знач ВидТранспортаСообщений)
	
	// запускаем выполнение обмена
	ОбменДаннымиСервер.ВыполнитьОбменДаннымиДляУзлаИнформационнойБазы(
											Отказ,
											УзелИнформационнойБазы,
											Истина,
											Ложь,
											ВидТранспортаСообщений);
	
КонецПроцедуры

&НаКлиенте
Функция Подключаемый_ОбычнаяВыгрузкаДанных_ОбработкаДлительнойОперации(Отказ, ПерейтиДалее)
	
	ОбычнаяВыгрузкаДанных_ОбработкаДлительнойОперации(Отказ, УзелИнформационнойБазы, ВидТранспортаСообщений);
	
	ЕстьОшибки = ЕстьОшибки ИЛИ Отказ;
	
	Отказ = Ложь;
	
КонецФункции

&НаСервереБезКонтекста
Процедура ОбычнаяВыгрузкаДанных_ОбработкаДлительнойОперации(Отказ, Знач УзелИнформационнойБазы, Знач ВидТранспортаСообщений)
	
	// запускаем выполнение обмена
	ОбменДаннымиСервер.ВыполнитьОбменДаннымиДляУзлаИнформационнойБазы(
											Отказ,
											УзелИнформационнойБазы,
											Ложь,
											Истина,
											ВидТранспортаСообщений);
	
КонецПроцедуры

// Обмен через Веб-сервис

&НаКлиенте
Функция Подключаемый_ЗапросПароляПользователя_ПриОткрытии(Отказ, ПропуститьСтраницу, ЭтоПереходДалее)
	
	Элементы.ВыполнитьОбмен.КнопкаПоУмолчанию = Истина;
	
КонецФункции

&НаКлиенте
Функция Подключаемый_ЗапросПароляПользователя_ПриПереходеДалее(Отказ)
	
	Если ПустаяСтрока(WSПароль) Тогда
		
		НСтрока = НСтр("ru = 'Не указан пароль.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтрока,, "WSПароль",, Отказ);
		
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Функция Подключаемый_ОжиданиеПроверкиПодключения_ОбработкаДлительнойОперации(Отказ, ПерейтиДалее)
	
	ПроверитьПодключение();
	
КонецФункции

&НаСервере
Процедура ПроверитьПодключение()
	
	УстановитьПривилегированныйРежим(Истина);
	
	ПараметрыАутентификации = ?(ИспользоватьСохраненныеПараметрыАутентификации,
		Неопределено,
		Новый Структура("ИспользоватьТекущегоПользователя, Пароль",
			ИспользоватьТекущегоПользователяДляАутентификации, ?(ПарольСинхронизацииЗадан, Неопределено, WSПароль)));
	
	WSПароль = ""; // Сбрасываем пароль после проверки подключения
	
	ПараметрыПодключения = РегистрыСведений.НастройкиТранспортаОбмена.НастройкиТранспортаWS(УзелИнформационнойБазы, ПараметрыАутентификации);
	
	Если Не ОбменДаннымиСервер.ЕстьПодключениеККорреспонденту(УзелИнформационнойБазы, ПараметрыПодключения, СообщениеОбОшибкеПользователю) Тогда
		СинхронизацияДанныхОтключена = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция Подключаемый_ЗагрузкаДанных_ОбработкаДлительнойОперации(Отказ, ПерейтиДалее)
	
	ДлительнаяОперация = Ложь;
	ДлительнаяОперацияЗавершена = Ложь;
	ИдентификаторФайлаСообщенияВСервисе = "";
	ИдентификаторДлительнойОперации = "";
	
	Если Не СинхронизацияДанныхОтключена Тогда
		
		ПараметрыАутентификации = ?(ИспользоватьСохраненныеПараметрыАутентификации,
			Неопределено,
			Новый Структура("ИспользоватьТекущегоПользователя", ИспользоватьТекущегоПользователяДляАутентификации));
		
		ЗагрузкаДанных_ОбработкаДлительнойОперации(
												Отказ,
												УзелИнформационнойБазы,
												ДлительнаяОперация,
												ИдентификаторДлительнойОперации,
												ИдентификаторФайлаСообщенияВСервисе,
												ДатаНачалаОперации,
												ПараметрыАутентификации);
		
	КонецЕсли;
	
	ЕстьОшибки = ЕстьОшибки ИЛИ Отказ;
	
	Отказ = Ложь;
	
КонецФункции

&НаСервереБезКонтекста
Процедура ЗагрузкаДанных_ОбработкаДлительнойОперации(
											Отказ,
											Знач УзелИнформационнойБазы,
											ДлительнаяОперация,
											ИдентификаторОперации,
											ИдентификаторФайла,
											ДатаНачалаОперации,
											Знач ПараметрыАутентификации)
	
	ДатаНачалаОперации = ТекущаяДатаСеанса();
	
	// запускаем выполнение обмена
	ОбменДаннымиСервер.ВыполнитьОбменДаннымиДляУзлаИнформационнойБазы(
											Отказ,
											УзелИнформационнойБазы,
											Истина,
											Ложь,
											Перечисления.ВидыТранспортаСообщенийОбмена.WS,
											ДлительнаяОперация,
											ИдентификаторОперации,
											ИдентификаторФайла,
											Истина,
											ПараметрыАутентификации);
	
КонецПроцедуры

&НаКлиенте
Функция Подключаемый_ЗагрузкаДанныхДлительнаяОперация_ОбработкаДлительнойОперации(Отказ, ПерейтиДалее)
	
	Если ДлительнаяОперация Тогда
		
		ПерейтиДалее = Ложь;
		
		ПодключитьОбработчикОжидания("ОбработчикОжиданияДлительнойОперации", 5, Истина);
		
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Функция Подключаемый_ЗагрузкаДанныхДлительнаяОперацияОкончание_ОбработкаДлительнойОперации(Отказ, ПерейтиДалее)
	
	Если ДлительнаяОперацияЗавершена Тогда
		
		Если ДлительнаяОперацияЗавершенаСОшибкой Тогда
			
			ОбменДаннымиВызовСервера.ЗафиксироватьЗавершениеОбменаСОшибкой(
											УзелИнформационнойБазы,
											"ЗагрузкаДанных",
											ДатаНачалаОперации,
											СообщениеОбОшибке);
			
		Иначе
			
			ПараметрыАутентификации = ?(ИспользоватьСохраненныеПараметрыАутентификации,
				Неопределено,
				Новый Структура("ИспользоватьТекущегоПользователя", ИспользоватьТекущегоПользователяДляАутентификации));
			
			ОбменДаннымиВызовСервера.ВыполнитьОбменДаннымиДляУзлаИнформационнойБазыЗавершениеДлительнойОперации(
											Ложь,
											УзелИнформационнойБазы,
											ИдентификаторФайлаСообщенияВСервисе,
											ДатаНачалаОперации,
											ПараметрыАутентификации);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Функция Подключаемый_ВыгрузкаДанных_ОбработкаДлительнойОперации(Отказ, ПерейтиДалее)
	
	ДлительнаяОперация = Ложь;
	ДлительнаяОперацияЗавершена = Ложь;
	ИдентификаторФайлаСообщенияВСервисе = "";
	ИдентификаторДлительнойОперации = "";
	
	Если Не СинхронизацияДанныхОтключена Тогда
		
		ПараметрыАутентификации = ?(ИспользоватьСохраненныеПараметрыАутентификации,
			Неопределено,
			Новый Структура("ИспользоватьТекущегоПользователя", ИспользоватьТекущегоПользователяДляАутентификации));
		
		ВыгрузкаДанных_ОбработкаДлительнойОперации(
												Отказ,
												УзелИнформационнойБазы,
												ДлительнаяОперация,
												ИдентификаторДлительнойОперации,
												ИдентификаторФайлаСообщенияВСервисе,
												ДатаНачалаОперации,
												ПараметрыАутентификации);
		
	КонецЕсли;
	
	ЕстьОшибки = ЕстьОшибки ИЛИ Отказ;
	
	Отказ = Ложь;
	
КонецФункции

&НаСервереБезКонтекста
Процедура ВыгрузкаДанных_ОбработкаДлительнойОперации(
											Отказ,
											Знач УзелИнформационнойБазы,
											ДлительнаяОперация,
											ИдентификаторОперации,
											ИдентификаторФайла,
											ДатаНачалаОперации,
											Знач ПараметрыАутентификации)
	
	ДатаНачалаОперации = ТекущаяДатаСеанса();
	
	// запускаем выполнение обмена
	ОбменДаннымиСервер.ВыполнитьОбменДаннымиДляУзлаИнформационнойБазы(
											Отказ,
											УзелИнформационнойБазы,
											Ложь,
											Истина,
											Перечисления.ВидыТранспортаСообщенийОбмена.WS,
											ДлительнаяОперация,
											ИдентификаторОперации,
											ИдентификаторФайла,
											Истина,
											ПараметрыАутентификации);
	
КонецПроцедуры

&НаКлиенте
Функция Подключаемый_ВыгрузкаДанныхДлительнаяОперация_ОбработкаДлительнойОперации(Отказ, ПерейтиДалее)
	
	Если ДлительнаяОперация Тогда
		
		ПерейтиДалее = Ложь;
		
		ПодключитьОбработчикОжидания("ОбработчикОжиданияДлительнойОперации", 5, Истина);
		
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Функция Подключаемый_ВыгрузкаДанныхДлительнаяОперацияОкончание_ОбработкаДлительнойОперации(Отказ, ПерейтиДалее)
	
	Если ДлительнаяОперацияЗавершена Тогда
		
		Если ДлительнаяОперацияЗавершенаСОшибкой Тогда
			
			ОбменДаннымиВызовСервера.ЗафиксироватьЗавершениеОбменаСОшибкой(
											УзелИнформационнойБазы,
											"ВыгрузкаДанных",
											ДатаНачалаОперации,
											СообщениеОбОшибке);
			
		Иначе
			
			ОбменДаннымиВызовСервера.ЗафиксироватьВыполнениеВыгрузкиДанныхВРежимеДлительнойОперации(
											УзелИнформационнойБазы,
											ДатаНачалаОперации);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецФункции

//

&НаКлиенте
Функция Подключаемый_ЗавершениеОбмена_ПриОткрытии(Отказ, ПропуститьСтраницу, ЭтоПереходДалее)
	
	Элементы.ПанельДействий.ТекущаяСтраница = Элементы.ДействияЗакрыть;
	Элементы.ФормаЗакрыть.КнопкаПоУмолчанию = Истина;
	
	СтраницаОбменЗавершенСОшибкой = ?(РольДоступнаДобавлениеИзменениеОбменовДанными,
				Элементы.ОбменЗавершенСОшибкойДляАдминистратора,
				Элементы.ОбменЗавершенСОшибкой);
	
	Если СинхронизацияДанныхОтключена Тогда
		
		Элементы.СтатусЗавершенияОбмена.ТекущаяСтраница = Элементы.ОбменЗавершенСОшибкойПодключения;
		
	ИначеЕсли ЕстьОшибки Тогда
		
		Если ТребуетсяОбновление Или ОбменДаннымиВызовСервера.ТребуетсяУстановкаОбновления() Тогда
			Если РольДоступнаПолныеПрава Тогда 
				Элементы.ПанельДействий.ТекущаяСтраница = Элементы.ДействияУстановитьЗакрыть;
				Элементы.УстановитьОбновление.КнопкаПоУмолчанию = Истина;
			КонецЕсли;
			Элементы.СтатусЗавершенияОбмена.ТекущаяСтраница = Элементы.ТребуетсяОбновление;
		Иначе
			Элементы.СтатусЗавершенияОбмена.ТекущаяСтраница = СтраницаОбменЗавершенСОшибкой;
		КонецЕсли;
		
	Иначе
		
		Элементы.СтатусЗавершенияОбмена.ТекущаяСтраница = Элементы.ОбменЗавершенУспешно;
		
	КонецЕсли;
	
	// Обновляем все открытые динамические списки
	ОбменДаннымиКлиент.ОбновитьВсеОткрытыеДинамическиеСписки();
	
КонецФункции

&НаКлиенте
Функция Подключаемый_ЗавершениеОбмена_ОбработкаДлительнойОперации(Отказ, ПерейтиДалее)
	
	ПерейтиДалее = Ложь;
	
	Оповестить("ВыполненОбменДанными");
	
	Если ЗакрытьПриУспешнойСинхронизации
		И Не СинхронизацияДанныхОтключена
		И Не ЕстьОшибки Тогда
		
		Закрыть();
	КонецЕсли;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// РАЗДЕЛ ИНИЦИАЛИЗАЦИИ ПЕРЕХОДОВ

&НаСервере
Процедура СценарийОбменаОбычный()
	
	ТаблицаПереходов.Очистить();
	
	ТаблицаПереходовНоваяСтрока(1, "ОжиданиеСинхронизацииДанных",,,,,, Истина, "ОбычнаяЗагрузкаДанных_ОбработкаДлительнойОперации");
	ТаблицаПереходовНоваяСтрока(2, "ОжиданиеСинхронизацииДанных",,,,,, Истина, "ОбычнаяВыгрузкаДанных_ОбработкаДлительнойОперации");
	ТаблицаПереходовНоваяСтрока(3, "ЗавершениеОбмена",,, "ЗавершениеОбмена_ПриОткрытии",,, Истина, "ЗавершениеОбмена_ОбработкаДлительнойОперации");
	
КонецПроцедуры

&НаСервере
Процедура СценарийОбменаЧерезВебСервис()
	
	ТаблицаПереходов.Очистить();
	
	ТаблицаПереходовНоваяСтрока(1, "ОжиданиеСинхронизацииДанных",,,,,, Истина, "ОжиданиеПроверкиПодключения_ОбработкаДлительнойОперации");
	ТаблицаПереходовНоваяСтрока(2, "ОжиданиеСинхронизацииДанных",,,,,, Истина, "ЗагрузкаДанных_ОбработкаДлительнойОперации");
	ТаблицаПереходовНоваяСтрока(3, "ОжиданиеСинхронизацииДанных",,,,,, Истина, "ЗагрузкаДанныхДлительнаяОперация_ОбработкаДлительнойОперации");
	ТаблицаПереходовНоваяСтрока(4, "ОжиданиеСинхронизацииДанных",,,,,, Истина, "ЗагрузкаДанныхДлительнаяОперацияОкончание_ОбработкаДлительнойОперации");
	ТаблицаПереходовНоваяСтрока(5, "ОжиданиеСинхронизацииДанных",,,,,, Истина, "ВыгрузкаДанных_ОбработкаДлительнойОперации");
	ТаблицаПереходовНоваяСтрока(6, "ОжиданиеСинхронизацииДанных",,,,,, Истина, "ВыгрузкаДанныхДлительнаяОперация_ОбработкаДлительнойОперации");
	ТаблицаПереходовНоваяСтрока(7, "ОжиданиеСинхронизацииДанных",,,,,, Истина, "ВыгрузкаДанныхДлительнаяОперацияОкончание_ОбработкаДлительнойОперации");
	ТаблицаПереходовНоваяСтрока(8, "ЗавершениеОбмена",,, "ЗавершениеОбмена_ПриОткрытии",,, Истина, "ЗавершениеОбмена_ОбработкаДлительнойОперации");
	
КонецПроцедуры

&НаСервере
Процедура СценарийОбменаЧерезВебСервис_ОтправкаПолучениеОтправка()
	
	ТаблицаПереходов.Очистить();
	
	ТаблицаПереходовНоваяСтрока(1, "ОжиданиеСинхронизацииДанных",,,,,, Истина, "ОжиданиеПроверкиПодключения_ОбработкаДлительнойОперации");
	
	// Отправка
	ТаблицаПереходовНоваяСтрока(2, "ОжиданиеСинхронизацииДанных",,,,,, Истина, "ВыгрузкаДанных_ОбработкаДлительнойОперации");
	ТаблицаПереходовНоваяСтрока(3, "ОжиданиеСинхронизацииДанных",,,,,, Истина, "ВыгрузкаДанныхДлительнаяОперация_ОбработкаДлительнойОперации");
	ТаблицаПереходовНоваяСтрока(4, "ОжиданиеСинхронизацииДанных",,,,,, Истина, "ВыгрузкаДанныхДлительнаяОперацияОкончание_ОбработкаДлительнойОперации");
	
	// Получение
	ТаблицаПереходовНоваяСтрока(5, "ОжиданиеСинхронизацииДанных",,,,,, Истина, "ЗагрузкаДанных_ОбработкаДлительнойОперации");
	ТаблицаПереходовНоваяСтрока(6, "ОжиданиеСинхронизацииДанных",,,,,, Истина, "ЗагрузкаДанныхДлительнаяОперация_ОбработкаДлительнойОперации");
	ТаблицаПереходовНоваяСтрока(7, "ОжиданиеСинхронизацииДанных",,,,,, Истина, "ЗагрузкаДанныхДлительнаяОперацияОкончание_ОбработкаДлительнойОперации");
	
	// Отправка
	ТаблицаПереходовНоваяСтрока(8,  "ОжиданиеСинхронизацииДанных",,,,,, Истина, "ВыгрузкаДанных_ОбработкаДлительнойОперации");
	ТаблицаПереходовНоваяСтрока(9,  "ОжиданиеСинхронизацииДанных",,,,,, Истина, "ВыгрузкаДанныхДлительнаяОперация_ОбработкаДлительнойОперации");
	ТаблицаПереходовНоваяСтрока(10, "ОжиданиеСинхронизацииДанных",,,,,, Истина, "ВыгрузкаДанныхДлительнаяОперацияОкончание_ОбработкаДлительнойОперации");
	
	ТаблицаПереходовНоваяСтрока(11, "ЗавершениеОбмена",,, "ЗавершениеОбмена_ПриОткрытии",,, Истина, "ЗавершениеОбмена_ОбработкаДлительнойОперации");
	
КонецПроцедуры

&НаСервере
Процедура СценарийОбменаЧерезВебСервисСЗапросомПароля()
	
	ТаблицаПереходов.Очистить();
	
	ТаблицаПереходовНоваяСтрока(1, "ЗапросПароляПользователя",,, "ЗапросПароляПользователя_ПриОткрытии", "ЗапросПароляПользователя_ПриПереходеДалее");
	ТаблицаПереходовНоваяСтрока(2, "ОжиданиеСинхронизацииДанных",,,,,, Истина, "ОжиданиеПроверкиПодключения_ОбработкаДлительнойОперации");
	ТаблицаПереходовНоваяСтрока(3, "ОжиданиеСинхронизацииДанных",,,,,, Истина, "ЗагрузкаДанных_ОбработкаДлительнойОперации");
	ТаблицаПереходовНоваяСтрока(4, "ОжиданиеСинхронизацииДанных",,,,,, Истина, "ЗагрузкаДанныхДлительнаяОперация_ОбработкаДлительнойОперации");
	ТаблицаПереходовНоваяСтрока(5, "ОжиданиеСинхронизацииДанных",,,,,, Истина, "ЗагрузкаДанныхДлительнаяОперацияОкончание_ОбработкаДлительнойОперации");
	ТаблицаПереходовНоваяСтрока(6, "ОжиданиеСинхронизацииДанных",,,,,, Истина, "ВыгрузкаДанных_ОбработкаДлительнойОперации");
	ТаблицаПереходовНоваяСтрока(7, "ОжиданиеСинхронизацииДанных",,,,,, Истина, "ВыгрузкаДанныхДлительнаяОперация_ОбработкаДлительнойОперации");
	ТаблицаПереходовНоваяСтрока(8, "ОжиданиеСинхронизацииДанных",,,,,, Истина, "ВыгрузкаДанныхДлительнаяОперацияОкончание_ОбработкаДлительнойОперации");
	ТаблицаПереходовНоваяСтрока(9, "ЗавершениеОбмена",,, "ЗавершениеОбмена_ПриОткрытии",,, Истина, "ЗавершениеОбмена_ОбработкаДлительнойОперации");
	
КонецПроцедуры

&НаСервере
Процедура СценарийОбменаЧерезВебСервисСЗапросомПароля_ОтправкаПолучениеОтправка()
	
	ТаблицаПереходов.Очистить();
	
	ТаблицаПереходовНоваяСтрока(1, "ЗапросПароляПользователя",,, "ЗапросПароляПользователя_ПриОткрытии", "ЗапросПароляПользователя_ПриПереходеДалее");
	ТаблицаПереходовНоваяСтрока(2, "ОжиданиеСинхронизацииДанных",,,,,, Истина, "ОжиданиеПроверкиПодключения_ОбработкаДлительнойОперации");
	
	// Отправка
	ТаблицаПереходовНоваяСтрока(3, "ОжиданиеСинхронизацииДанных",,,,,, Истина, "ВыгрузкаДанных_ОбработкаДлительнойОперации");
	ТаблицаПереходовНоваяСтрока(4, "ОжиданиеСинхронизацииДанных",,,,,, Истина, "ВыгрузкаДанныхДлительнаяОперация_ОбработкаДлительнойОперации");
	ТаблицаПереходовНоваяСтрока(5, "ОжиданиеСинхронизацииДанных",,,,,, Истина, "ВыгрузкаДанныхДлительнаяОперацияОкончание_ОбработкаДлительнойОперации");
	
	// Получение
	ТаблицаПереходовНоваяСтрока(6, "ОжиданиеСинхронизацииДанных",,,,,, Истина, "ЗагрузкаДанных_ОбработкаДлительнойОперации");
	ТаблицаПереходовНоваяСтрока(7, "ОжиданиеСинхронизацииДанных",,,,,, Истина, "ЗагрузкаДанныхДлительнаяОперация_ОбработкаДлительнойОперации");
	ТаблицаПереходовНоваяСтрока(8, "ОжиданиеСинхронизацииДанных",,,,,, Истина, "ЗагрузкаДанныхДлительнаяОперацияОкончание_ОбработкаДлительнойОперации");
	
	// Отправка
	ТаблицаПереходовНоваяСтрока(9,  "ОжиданиеСинхронизацииДанных",,,,,, Истина, "ВыгрузкаДанных_ОбработкаДлительнойОперации");
	ТаблицаПереходовНоваяСтрока(10, "ОжиданиеСинхронизацииДанных",,,,,, Истина, "ВыгрузкаДанныхДлительнаяОперация_ОбработкаДлительнойОперации");
	ТаблицаПереходовНоваяСтрока(11, "ОжиданиеСинхронизацииДанных",,,,,, Истина, "ВыгрузкаДанныхДлительнаяОперацияОкончание_ОбработкаДлительнойОперации");
	
	ТаблицаПереходовНоваяСтрока(12, "ЗавершениеОбмена",,, "ЗавершениеОбмена_ПриОткрытии",,, Истина, "ЗавершениеОбмена_ОбработкаДлительнойОперации");
	
КонецПроцедуры

&НаСервере
Процедура СценарийКогдаЕстьОшибкиПриНачалеРаботы()
	
	ТаблицаПереходов.Очистить();
	
	ТаблицаПереходовНоваяСтрока(1, "ЗавершениеОбмена",,, "ЗавершениеОбмена_ПриОткрытии");
	
КонецПроцедуры

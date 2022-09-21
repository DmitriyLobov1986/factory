///////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазыПереопределяемый.ПолучитьТекстПоясненияДляРезультатовОбновленияПрограммы(ТекстПодсказки);
	Если Не ПустаяСтрока(ТекстПодсказки) Тогда
		Элементы.ИнформацияПодсказка.Заголовок = ТекстПодсказки;
		Элементы.ПодсказкаГдеНайтиЭтуФорму.Заголовок = ТекстПодсказки;
		Элементы.ИнформацияПодсказка1.Заголовок = ТекстПодсказки;
	КонецЕсли;
	
	Если Не Пользователи.ЭтоПолноправныйПользователь(, Истина) Тогда
		
		Элементы.ГруппаПодсказкаПроПериодНаименьшейАктивностиПользователей.Видимость = Ложь;
		Элементы.ПодсказкаГдеНайтиЭтуФорму.Заголовок = 
			НСтр("ru = 'Ход обработки данных версии программы можно также проконтролировать из раздела
		               |""Информация"" на рабочем столе, команда ""Описание изменений программы"".'");
		
	КонецЕсли;
	
	// Зачитываем значение константы
	СведенияОбОбновлении = ОбновлениеИнформационнойБазы.СведенияОбОбновленииИнформационнойБазы();
	ВремяНачалаОбновления = СведенияОбОбновлении.ВремяНачалаОбновления;
	ВремяОкончанияОбновления = СведенияОбОбновлении.ВремяОкончанияОбновления;
	
	ИБФайловая = ОбщегоНазначения.ИнформационнаяБазаФайловая();
	
	Если ЗначениеЗаполнено(ВремяОкончанияОбновления) Тогда
		Элементы.ИнформацияОбновлениеЗавершено.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			Элементы.ИнформацияОбновлениеЗавершено.Заголовок,
			Метаданные.Версия,
			Формат(ВремяОкончанияОбновления, "ДЛФ=D"),
			Формат(ВремяОкончанияОбновления, "ДЛФ=T"),
			СведенияОбОбновлении.ПродолжительностьОбновления);
	Иначе
		ЗаголовокОбновлениеЗавершено = НСтр("ru = 'Версия программы успешно обновлена на версию %1'");
		Элементы.ИнформацияОбновлениеЗавершено.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ЗаголовокОбновлениеЗавершено,
			Метаданные.Версия);
	КонецЕсли;
	
	Если СведенияОбОбновлении.ВремяОкончаниеОтложенногоОбновления = Неопределено Тогда
		
		Если Не Пользователи.ЭтоПолноправныйПользователь(, Истина) Тогда
			Элементы.СтатусОбновления.ТекущаяСтраница = Элементы.СтатусОбновленияДляПользователя;
		Иначе
			
			Если Не ИБФайловая И СведенияОбОбновлении.ОтложенноеОбновлениеЗавершеноУспешно = Неопределено Тогда
				Элементы.СтатусОбновления.ТекущаяСтраница = Элементы.ОбновлениеВыполняется;
			Иначе
				Элементы.СтатусОбновления.ТекущаяСтраница = Элементы.ОбновлениеВФайловойБазе;
			КонецЕсли;
			
		КонецЕсли;
		
	Иначе
		ТекстСообщения = СообщениеОРезультатахОбновления(СведенияОбОбновлении);
		Элементы.СтатусОбновления.ТекущаяСтраница = Элементы.ОбновлениеЗавершено;
		
		СведенияОбОбновлении = ОбновлениеИнформационнойБазы.СведенияОбОбновленииИнформационнойБазы();
		ШаблонЗаголовка = НСтр("ru = 'Дополнительные процедуры обработки данных завершены %1 в %2'");
		Элементы.ИнформацияОтложенноеОбновлениеЗавершено1.Заголовок = 
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонЗаголовка, 
			Формат(СведенияОбОбновлении.ВремяОкончаниеОтложенногоОбновления, "ДЛФ=D"),
			Формат(СведенияОбОбновлении.ВремяОкончаниеОтложенногоОбновления, "ДЛФ=T"));
		
	КонецЕсли;
	
	Если Не ИБФайловая Тогда
		ОбновлениеЗавершено = Ложь;
		ОбновитьИнформациюОХодеОбновления(СведенияОбОбновлении, ОбновлениеЗавершено);
		
		Если ОбновлениеЗавершено Тогда
			ОбновитьСтраницуОбновлениеЗавершено(СведенияОбОбновлении);
			Элементы.СтатусОбновления.ТекущаяСтраница = Элементы.ОбновлениеЗавершено;
			Возврат;
		КонецЕсли;
		
	Иначе
		Элементы.ИнформацияСтатусОбновления.Видимость = Ложь;
		Элементы.ИзменитьРасписание.Видимость         = Ложь;
	КонецЕсли;
	
	Если Пользователи.ЭтоПолноправныйПользователь(, Истина) Тогда
		
		Если ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
			Элементы.ИзменитьРасписание.Видимость     = Ложь;
		Иначе
			Расписание = РегламентныеЗадания.НайтиПредопределенное(
				Метаданные.РегламентныеЗадания.ОтложенноеОбновлениеИБ).Расписание;
		КонецЕсли;
		
	КонецЕсли;
	
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
		Элементы.ГиперссылкаОсновноеОбновление.Видимость = Ложь;
	КонецЕсли;
	
	СкрытьЛишниеГруппыНаФорме(Параметры.ОткрытиеИзПанелиАдминистрирования);
	
	Элементы.ОткрытьСписокОтложенныхОбработчиков.Заголовок = ТекстСообщения;
	Элементы.ЗаголовокИнформации.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Выполняются дополнительные процедуры обработки данных на версию %1
			|Работа с этими данными временно ограничена'"), Метаданные.Версия);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ИБФайловая Тогда
		ПодключитьОбработчикОжидания("ПроверитьСтатусВыполненияОбработчиков", 15);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОтложенноеОбновление" Тогда
		
		Если Не ИБФайловая Тогда
			Элементы.СтатусОбновления.ТекущаяСтраница = Элементы.ОбновлениеВыполняется;
		КонецЕсли;
		
		ПодключитьОбработчикОжидания("ЗапуститьОтложенноеОбновление", 0.5, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИнформацияСтатусОбновленияНажатие(Элемент)
	ОткрытьФорму("Обработка.ОбновлениеИнформационнойБазы.Форма.ОтложенныеОбработчики");
КонецПроцедуры

&НаКлиенте
Процедура ГиперссылкаОсновноеОбновлениеНажатие(Элемент)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ДатаНачала", ВремяНачалаОбновления);
	ПараметрыФормы.Вставить("ДатаОкончания", ВремяОкончанияОбновления);
	
	ОткрытьФорму("Обработка.ЖурналРегистрации.Форма.ЖурналРегистрации", ПараметрыФормы);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ЗакрытьФорму(Команда)
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОбновление(Команда)
	
	Если Не ИБФайловая Тогда
		Элементы.СтатусОбновления.ТекущаяСтраница = Элементы.ОбновлениеВыполняется;
	КонецЕсли;
	
	ПодключитьОбработчикОжидания("ЗапуститьОтложенноеОбновление", 0.5, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСписокОтложенныхОбработчиков(Команда)
	ОткрытьФорму("Обработка.ОбновлениеИнформационнойБазы.Форма.ОтложенныеОбработчики");
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьРасписание(Команда)
	
	Диалог = Новый ДиалогРасписанияРегламентногоЗадания(Расписание);
	
	Если Диалог.ОткрытьМодально() Тогда
		Расписание = Диалог.Расписание;
		УстановитьРасписаниеОтложенногоОбновления(Расписание);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьБлокировкуРегламентныхЗаданий(Команда)
	
	Если ОбщегоНазначенияКлиентСервер.ПодсистемаСуществует("СтандартныеПодсистемы.ЗавершениеРаботыПользователей") Тогда
		ОткрытьФорму("Обработка.БлокировкаРаботыПользователей.Форма.Форма");
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура СкрытьЛишниеГруппыНаФорме(ОткрытиеИзПанелиАдминистрирования)
	
	ЭтоПолноправныйПользователь = Пользователи.ЭтоПолноправныйПользователь(, Истина);
	
	Если Не ЭтоПолноправныйПользователь Или ОткрытиеИзПанелиАдминистрирования Тогда
		ЭтаФорма.КлючСохраненияПоложенияОкна = "ФормаДляОбычногоПользователя";
		
		Элементы.Группа3.Видимость = Ложь;
		Элементы.ГруппаПодсказка.Видимость = Ложь;
		Элементы.ИнформацияПодсказка1.Видимость = Ложь;
		Элементы.Отступ1.Видимость = Ложь;
		
		Если Не ЭтоПолноправныйПользователь И Не РольДоступна("ПросмотрЖурналаРегистрации")Тогда
			Элементы.ГиперссылкаОсновноеОбновление.Видимость = Ложь;
		КонецЕсли;
		
	Иначе
		ЭтаФорма.КлючСохраненияПоложенияОкна = "ФормаДляАдминистратора";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапуститьОтложенноеОбновление()
	
	ВыполнитьОбновлениеНаСервере();
	Если Не ИБФайловая Тогда
		ПодключитьОбработчикОжидания("ПроверитьСтатусВыполненияОбработчиков", 15);
		Возврат;
	КонецЕсли;
	
	Элементы.СтатусОбновления.ТекущаяСтраница = Элементы.ОбновлениеЗавершено;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьСтатусВыполненияОбработчиков()
	
	ОбновлениеЗавершено = Ложь;
	ПроверитьСтатусВыполненияОбработчиковНаСервере(ОбновлениеЗавершено);
	Если ОбновлениеЗавершено Тогда
		Элементы.СтатусОбновления.ТекущаяСтраница = Элементы.ОбновлениеЗавершено;
		ОтключитьОбработчикОжидания("ПроверитьСтатусВыполненияОбработчиков")
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьСтатусВыполненияОбработчиковНаСервере(ОбновлениеЗавершено)
	
	СведенияОбОбновлении = ОбновлениеИнформационнойБазы.СведенияОбОбновленииИнформационнойБазы();
	Если СведенияОбОбновлении.ВремяОкончаниеОтложенногоОбновления <> Неопределено Тогда
		ОбновлениеЗавершено = Истина;
	Иначе
		ОбновитьИнформациюОХодеОбновления(СведенияОбОбновлении, ОбновлениеЗавершено);
	КонецЕсли;
	
	Если ОбновлениеЗавершено = Истина Тогда
		ОбновитьСтраницуОбновлениеЗавершено(СведенияОбОбновлении);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ВыполнитьОбновлениеНаСервере()
	
	СведенияОбОбновлении = ОбновлениеИнформационнойБазы.СведенияОбОбновленииИнформационнойБазы();
	
	СведенияОбОбновлении.ОтложенноеОбновлениеЗавершеноУспешно = Неопределено;
	СведенияОбОбновлении.ВремяОкончаниеОтложенногоОбновления = Неопределено;
	Для Каждого СтрокаДереваБиблиотека Из СведенияОбОбновлении.ДеревоОбработчиков.Строки Цикл
		Для Каждого СтрокаДереваВерсия Из СтрокаДереваБиблиотека.Строки Цикл
			Для Каждого Обработчик Из СтрокаДереваВерсия.Строки Цикл
				Обработчик.ЧислоПопыток = 0;
			КонецЦикла;
		КонецЦикла;
	КонецЦикла;
	ОбновлениеИнформационнойБазы.ЗаписатьСведенияОбОбновленииИнформационнойБазы(СведенияОбОбновлении);
	
	Если Не ИБФайловая Тогда
		
		Если ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
			ОбновлениеИнформационнойБазы.ПриВключенииОтложенногоОбновления(Истина);
		Иначе
			РегламентноеЗадание = РегламентныеЗадания.НайтиПредопределенное(Метаданные.РегламентныеЗадания.ОтложенноеОбновлениеИБ);
			РегламентноеЗадание.Использование = Истина;
			РегламентноеЗадание.Записать();
		КонецЕсли;
		Возврат;
		
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ВыполнитьОтложенноеОбновлениеСейчас();
	
	СведенияОбОбновлении = ОбновлениеИнформационнойБазы.СведенияОбОбновленииИнформационнойБазы();
	ОбновитьСтраницуОбновлениеЗавершено(СведенияОбОбновлении);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСтраницуОбновлениеЗавершено(СведенияОбОбновлении)
	
	ШаблонЗаголовка = НСтр("ru = 'Дополнительные процедуры обработки данных завершены %1 в %2'");
	ТекстСообщения = СообщениеОРезультатахОбновления(СведенияОбОбновлении);
	
	Элементы.ИнформацияОтложенноеОбновлениеЗавершено1.Заголовок = 
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонЗаголовка, 
			Формат(СведенияОбОбновлении.ВремяОкончаниеОтложенногоОбновления, "ДЛФ=D"),
			Формат(СведенияОбОбновлении.ВремяОкончаниеОтложенногоОбновления, "ДЛФ=T"));
	
	Элементы.ОткрытьСписокОтложенныхОбработчиков.Заголовок = ТекстСообщения;
	
КонецПроцедуры

&НаСервере
Функция СообщениеОРезультатахОбновления(СведенияОбОбновлении)
	
	СписокОбработчиков = СведенияОбОбновлении.ДеревоОбработчиков;
	УспешноВыполненоОбработчиков = 0;
	ВсегоОбработчиков            = 0;
	Для Каждого СтрокаДереваБиблиотека Из СведенияОбОбновлении.ДеревоОбработчиков.Строки Цикл
		Для Каждого СтрокаДереваВерсия Из СтрокаДереваБиблиотека.Строки Цикл
			ВсегоОбработчиков = ВсегоОбработчиков + СтрокаДереваВерсия.Строки.Количество();
			Для Каждого Обработчик Из СтрокаДереваВерсия.Строки Цикл
				
				Если Обработчик.Статус = "Выполнено" Тогда
					УспешноВыполненоОбработчиков = УспешноВыполненоОбработчиков + 1;
				КонецЕсли;
				
			КонецЦикла;
		КонецЦикла;
	КонецЦикла;
	
	Если ВсегоОбработчиков = УспешноВыполненоОбработчиков Тогда
		
		Если ВсегоОбработчиков = 0 Тогда
			Элементы.ИнформацияОтложенныеОбработчикиОтсутствуют.Видимость = Истина;
			Элементы.ГруппаПереходКСпискуОтложенныхОбработчиков.Видимость = Ложь;
		Иначе
			ТекстСообщения = НСтр("ru = 'Все процедуры обновления выполнены успешно (%1)'");
		КонецЕсли;
		Элементы.КартинкаИнформация1.Картинка = БиблиотекаКартинок.Успешно;
	Иначе
		ТекстСообщения = НСтр("ru = 'Не все процедуры удалось выполнить (выполнено %1 из %2)'");
		Элементы.КартинкаИнформация1.Картинка = БиблиотекаКартинок.Остановить;
	КонецЕсли;
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		ТекстСообщения, УспешноВыполненоОбработчиков, ВсегоОбработчиков);
	
КонецФункции

&НаСервере
Процедура ОбновитьИнформациюОХодеОбновления(СведенияОбОбновлении, ОбновлениеЗавершено = Ложь)
	
	ВыполненоОбработчиков = 0;
	ВсегоОбработчиков     = 0;
	Для Каждого СтрокаДереваБиблиотека Из СведенияОбОбновлении.ДеревоОбработчиков.Строки Цикл
		Для Каждого СтрокаДереваВерсия Из СтрокаДереваБиблиотека.Строки Цикл
			ВсегоОбработчиков = ВсегоОбработчиков + СтрокаДереваВерсия.Строки.Количество();
			Для Каждого Обработчик Из СтрокаДереваВерсия.Строки Цикл
				
				Если Обработчик.Статус = "Выполнено" Тогда
					ВыполненоОбработчиков = ВыполненоОбработчиков + 1;
				КонецЕсли;
				
			КонецЦикла;
		КонецЦикла;
	КонецЦикла;
	
	Если ВсегоОбработчиков = 0 Тогда
		ОбновлениеЗавершено = Истина;
	КонецЕсли;
	
	Элементы.ИнформацияСтатусОбновления.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Выполнено: %1 из %2'"),
		ВыполненоОбработчиков,
		ВсегоОбработчиков);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьРасписаниеОтложенногоОбновления(Расписание)
	
	РегламентноеЗадание = РегламентныеЗадания.НайтиПредопределенное(Метаданные.РегламентныеЗадания.ОтложенноеОбновлениеИБ);
	РегламентноеЗадание.Расписание = Расписание;
	РегламентноеЗадание.Записать();
	
КонецПроцедуры

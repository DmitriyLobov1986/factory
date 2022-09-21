///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если НЕ Параметры.Свойство("ДатаСогласия", ДатаСогласия) Тогда
		ДатаСогласия = ТекущаяДатаСеанса();
	КонецЕсли;
	
	Если Параметры.Свойство("Организация", Организация) Тогда
		ЗаполнитьДанныеОрганизации();
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.Субъекты) Тогда
		ВариантПечатиСогласия = "ВыводитьПоСубъектам";
		Для Каждого Субъект Из Параметры.Субъекты Цикл
			НоваяСтрока = СубъектыПерсональныхДанных.Добавить();
			НоваяСтрока.Субъект = Субъект;
		КонецЦикла;
		ЗаполнитьДанныеСубъектовПерсональныхДанных();
	Иначе
		ВариантПечатиСогласия = "ВыводитьБланк";
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЭтоLinuxКлиент() Тогда
		Элементы.ФормаПечатьMSWord.Видимость = Ложь;
		Элементы.ФормаПечатьOOWritter.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьДоступностьСпискаВыбораСубъектов();
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

&НаКлиенте
Процедура ВариантПечатиСогласияПриИзменении(Элемент)
	
	УстановитьДоступностьСпискаВыбораСубъектов();
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ЗаполнитьДанныеОрганизации();
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД

&НаКлиенте
Процедура Печать(Команда)
	
	ПараметрКоманды = Новый Массив;
	Если СубъектыПерсональныхДанных.Количество() > 0 И ЗначениеЗаполнено(СубъектыПерсональныхДанных[0].Субъект) Тогда
		ПараметрКоманды.Добавить(СубъектыПерсональныхДанных[0].Субъект);
	Иначе
		ПараметрКоманды.Добавить(ПредопределенноеЗначение("Справочник.Пользователи.ПустаяСсылка"));
	КонецЕсли;
	
	УправлениеПечатьюКлиент.ВыполнитьКомандуПечати("Обработка.СогласиеНаОбработкуПерсональныхДанных", "СогласиеНаОбработкуПерсональныхДанных",
		ПараметрКоманды, ЭтаФорма, Новый Структура("ДанныеПечатиСогласия", ДанныеПечатиСогласия()));
	
КонецПроцедуры

&НаКлиенте
Процедура ПечатьMSWord(Команда)
	
	ПечатьСогласияНаОбработкуПерсональныхДанных("Обработка.СогласиеНаОбработкуПерсональныхДанных", "СогласиеНаОбработкуПерсональныхДанных(MSWord)", ДанныеПечатиСогласия(), ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПечатьOOWritter(Команда)
	
	ПечатьСогласияНаОбработкуПерсональныхДанных("Обработка.СогласиеНаОбработкуПерсональныхДанных", "СогласиеНаОбработкуПерсональныхДанных(ODT)", ДанныеПечатиСогласия(), ЭтаФорма);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура УстановитьДоступностьСпискаВыбораСубъектов()
	
	Элементы.ГруппаДанныеПечатиСогласия.ТекущаяСтраница = Элементы[ВариантПечатиСогласия];
	
КонецПроцедуры

&НаКлиенте
Функция ДанныеПечатиСогласия()
	
	ОбщиеДанные = Новый Структура;
	ОбщиеДанные.Вставить("ДатаСогласия", 		?(ЗначениеЗаполнено(ДатаСогласия), Формат(ДатаСогласия, "ДЛФ=DD"), "«____»_______________20___г."));
	ОбщиеДанные.Вставить("Организация", 		?(ЗначениеЗаполнено(Организация), Организация, "<Организация>"));
	ОбщиеДанные.Вставить("АдресОрганизации", 	?(ЗначениеЗаполнено(АдресОрганизации), АдресОрганизации, "<Адрес организации>"));
	ОбщиеДанные.Вставить("ОтветственныйЗаОбработкуПерсональныхДанных", ?(ЗначениеЗаполнено(ОтветственныйЗаОбработкуПерсональныхДанных), ОтветственныйЗаОбработкуПерсональныхДанных, "<ФИО ответственного лица>"));
	
	Субъекты = Новый Массив;
	Если ВариантПечатиСогласия = "ВыводитьБланк" Тогда
		Субъекты.Добавить(Новый Структура("ФИО, Адрес, ПаспортныеДанные", "<ФИО субъекта>", "<Адрес субъекта>", "<Паспортные данные субъекта>"));
	Иначе
		Для Каждого Субъект Из СубъектыПерсональныхДанных Цикл
			ДанныеСубъекта = Новый Структура("ФИО, Адрес, ПаспортныеДанные");
			ЗаполнитьЗначенияСвойств(ДанныеСубъекта, Субъект);
			Субъекты.Добавить(ДанныеСубъекта);
		КонецЦикла;
	КонецЕсли;
	
	// Структура по каждому субъекту дополняется общими данными
	Для Каждого Субъект Из Субъекты Цикл
		Для Каждого КлючИЗначение Из ОбщиеДанные Цикл
			Субъект.Вставить(КлючИЗначение.Ключ, КлючИЗначение.Значение);
		КонецЦикла;
	КонецЦикла;
	
	Возврат Субъекты;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьДанныеОрганизации()
	
	ДанныеОрганизацииОператора = Новый Структура("АдресОрганизации, ОтветственныйЗаОбработкуПерсональныхДанных");
	
	ЗащитаПерсональныхДанныхПереопределяемый.ДополнитьДанныеОрганизацииОператораПерсональныхДанных(Организация, ДанныеОрганизацииОператора, ДатаСогласия);
	
	ЗаполнитьЗначенияСвойств(ЭтаФорма, ДанныеОрганизацииОператора);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДанныеСубъектовПерсональныхДанных()
	
	// заполнение данных субъектов
	ЗащитаПерсональныхДанныхПереопределяемый.ДополнитьДанныеСубъектовПерсональныхДанных(СубъектыПерсональныхДанных, ДатаСогласия);
	
КонецПроцедуры

&НаКлиенте
Процедура ПечатьСогласияНаОбработкуПерсональныхДанных(ИмяМенеджераПечати, ИмяМакета, Субъекты, ФормаИсточник)
	
	// Проверим количество объектов
	Если Субъекты.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ТекстСообщения = ?(Субъекты.Количество() > 1, 
		НСтр("ru = 'Выполняется формирование печатных форм...'"),
		НСтр("ru = 'Выполняется формирование печатной формы...'"));
	Состояние(ТекстСообщения);
	
	МакетИДанныеОбъекта = УправлениеПечатьюВызовСервера.ПолучитьМакетыИДанныеОбъектов(ИмяМенеджераПечати, ИмяМакета, Субъекты);
	
	Для Каждого Субъект Из Субъекты Цикл
		НапечататьСогласиеНаОбработкуПерсональныхДанныхСубъекта(Строка(Субъект.ФИО) + Строка(Субъект.Адрес) + Строка(Субъект.ПаспортныеДанные), МакетИДанныеОбъекта, ИмяМакета, МакетИДанныеОбъекта.ЛокальныйКаталогФайловПечати);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура НапечататьСогласиеНаОбработкуПерсональныхДанныхСубъекта(СубъектКлюч, МакетИДанныеОбъекта, ИмяМакета, ЛокальныйКаталогФайловПечати)
	
	ТипМакета				= МакетИДанныеОбъекта.Макеты.ТипыМакетов[ИмяМакета];
	ДвоичныеДанныеМакетов	= МакетИДанныеОбъекта.Макеты.ДвоичныеДанныеМакетов;
	Области					= МакетИДанныеОбъекта.Макеты.ОписаниеОбластей;
	ДанныеОбъекта = МакетИДанныеОбъекта.Данные[СубъектКлюч][ИмяМакета];
	Попытка
		Макет = УправлениеПечатьюКлиент.ИнициализироватьМакет(ДвоичныеДанныеМакетов[ИмяМакета], ТипМакета, ЛокальныйКаталогФайловПечати, ИмяМакета);
		Если Макет = Неопределено Тогда
			Возврат;
		КонецЕсли;
		ПечатнаяФорма = УправлениеПечатьюКлиент.ИнициализироватьПечатнуюФорму(ТипМакета, Макет.НастройкиСтраницыМакета);
		Если ПечатнаяФорма = Неопределено Тогда
			УправлениеПечатьюКлиент.ОчиститьСсылки(Макет);
			Возврат;
		КонецЕсли;
		
		// Вывод обычных областей с параметрами
		Область = УправлениеПечатьюКлиент.ПолучитьОбласть(Макет, Области[ИмяМакета]["Заголовок"]);
		УправлениеПечатьюКлиент.ПрисоединитьОбластьИЗаполнитьПараметры(ПечатнаяФорма, Область, ДанныеОбъекта, Ложь);
		
		Область = УправлениеПечатьюКлиент.ПолучитьОбласть(Макет, Области[ИмяМакета]["НомерДата"]);
		УправлениеПечатьюКлиент.ПрисоединитьОбластьИЗаполнитьПараметры(ПечатнаяФорма, Область, ДанныеОбъекта, Ложь);
		
		Область = УправлениеПечатьюКлиент.ПолучитьОбласть(Макет, Области[ИмяМакета]["Преамбула"]);
		УправлениеПечатьюКлиент.ПрисоединитьОбластьИЗаполнитьПараметры(ПечатнаяФорма, Область, ДанныеОбъекта, Ложь);
		
		Область = УправлениеПечатьюКлиент.ПолучитьОбласть(Макет, Области[ИмяМакета]["ОсновнойТекст"]);
		УправлениеПечатьюКлиент.ПрисоединитьОбластьИЗаполнитьПараметры(ПечатнаяФорма, Область, ДанныеОбъекта, Ложь);
		
		Область = УправлениеПечатьюКлиент.ПолучитьОбласть(Макет, Области[ИмяМакета]["РеквизитыОператора"]);
		УправлениеПечатьюКлиент.ПрисоединитьОбластьИЗаполнитьПараметры(ПечатнаяФорма, Область, ДанныеОбъекта, Ложь);
		
		Область = УправлениеПечатьюКлиент.ПолучитьОбласть(Макет, Области[ИмяМакета]["РеквизитыСубъекта"]);
		УправлениеПечатьюКлиент.ПрисоединитьОбластьИЗаполнитьПараметры(ПечатнаяФорма, Область, ДанныеОбъекта, Ложь);
		
		Область = УправлениеПечатьюКлиент.ПолучитьОбласть(Макет, Области[ИмяМакета]["Подпись"]);
		УправлениеПечатьюКлиент.ПрисоединитьОбластьИЗаполнитьПараметры(ПечатнаяФорма, Область, ДанныеОбъекта, Ложь);
		
		УправлениеПечатьюКлиент.ПоказатьДокумент(ПечатнаяФорма);
	Исключение
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		УправлениеПечатьюКлиент.ОчиститьСсылки(ПечатнаяФорма);
		УправлениеПечатьюКлиент.ОчиститьСсылки(Макет);
		Возврат;
	КонецПопытки;
	
	УправлениеПечатьюКлиент.ОчиститьСсылки(ПечатнаяФорма, Ложь);
	УправлениеПечатьюКлиент.ОчиститьСсылки(Макет);
	
КонецПроцедуры

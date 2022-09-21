////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Перем КоллекцияПечатныхФорм;
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	// поддержка обратной совместимости с 2.1.3
	ПараметрыПечати = Параметры.ПараметрыПечати;
	Если Параметры.ПараметрыПечати = Неопределено Тогда
		ПараметрыПечати = Новый Структура;
	КонецЕсли;
	Если Не ПараметрыПечати.Свойство("ДополнительныеПараметры") Тогда
		Параметры.ПараметрыПечати = Новый Структура("ДополнительныеПараметры", ПараметрыПечати);
		Для Каждого ПараметрПечати Из ПараметрыПечати Цикл
			Параметры.ПараметрыПечати.Вставить(ПараметрПечати.Ключ, ПараметрПечати.Значение);
		КонецЦикла;
	КонецЕсли;
	
	СформироватьПечатныеФормы(КоллекцияПечатныхФорм, Параметры.ИменаМакетов, Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	СоздатьРеквизитыИЭлементыФормыДляПечатныхФорм(КоллекцияПечатныхФорм);
	СохранитьНастройкиКомплектаПоУмолчанию();
	ЗагрузитьНастройкиКоличестваКопий();
	ЕстьРазрешенныйВывод = ЕстьРазрешенныйВывод();
	НастроитьВидимостьЭлементовФормы(ЕстьРазрешенныйВывод);
	УстановитьПризнакДоступностиВыводаВПредставленияхПечатныхФорм(ЕстьРазрешенныйВывод);
	УстановитьИмяПринтераВПодсказкеКнопкиПечать();
	УстановитьЗаголовокФормы();
	Если ЭтоПечатьКомплекта() Тогда
		Элементы.Копий.Заголовок = НСтр("ru = 'Копий комплекта'");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если ЗначениеЗаполнено(НастройкиФорматаСохранения) Тогда
		Отказ = Истина; // отказ от открытия формы
		СохранитьПечатнуюФормуВФайл();
	КонецЕсли;
	УстановитьТекущуюСтраницу();
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ВРег(ИсточникВыбора.ИмяФормы) = ВРег("ОбщаяФорма.СохранениеПечатнойФормы") Тогда
		
		Если ВыбранноеЗначение <> Неопределено И ВыбранноеЗначение <> КодВозвратаДиалога.Отмена Тогда
			ФайлыВоВременномХранилище = ПоместитьТабличныеДокументыВоВременноеХранилище(ВыбранноеЗначение);
			Если ВыбранноеЗначение.ВариантСохранения = "СохранитьВПапку" Тогда
				СохранитьПечатныеФормыВПапку(ФайлыВоВременномХранилище, ВыбранноеЗначение.ПапкаДляСохранения);
			Иначе
				ПрисоединитьПечатныеФормыКОбъекту(ФайлыВоВременномХранилище, ВыбранноеЗначение.ОбъектДляПрикрепления);
				Состояние(НСтр("ru = 'Сохранение успешно завершено.'"));
			КонецЕсли;
		КонецЕсли;
		
	ИначеЕсли ВРег(ИсточникВыбора.ИмяФормы) = ВРег("ОбщаяФорма.ВыборФорматаВложений")
		Или ВРег(ИсточникВыбора.ИмяФормы) = ВРег("ОбщаяФорма.ПодготовкаНовогоПисьма") Тогда
		
		Если ВыбранноеЗначение <> Неопределено И ВыбранноеЗначение <> КодВозвратаДиалога.Отмена Тогда
			СписокВложений = ПоместитьТабличныеДокументыВоВременноеХранилище(ВыбранноеЗначение);
			ПараметрыОтправки = ПараметрыВывода.ПараметрыОтправки;
			Получатели = ПараметрыОтправки.Получатель;
			Если ВыбранноеЗначение.Свойство("Получатели") Тогда
				Получатели = ВыбранноеЗначение.Получатели;
			КонецЕсли;
			РаботаСПочтовымиСообщениямиКлиент.ОткрытьФормуОтправкиПочтовогоСообщения( , Получатели, ПараметрыОтправки.Тема, ПараметрыОтправки.Текст, СписокВложений, Истина);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	Если Не ПустаяСтрока(КлючНастроек) Тогда
		СохраняемыеНастройкиПечатныхФорм = Новый Массив;
		Для Каждого НастройкаПечатнойФормы Из НастройкиПечатныхФорм Цикл
			СохраняемаяНастройка = Новый Структура;
			СохраняемаяНастройка.Вставить("ИмяМакета", НастройкаПечатнойФормы.ИмяМакета);
			СохраняемаяНастройка.Вставить("Количество", ?(НастройкаПечатнойФормы.Печатать,НастройкаПечатнойФормы.Количество, 0));
			СохраняемаяНастройка.Вставить("ПозицияПоУмолчанию", НастройкаПечатнойФормы.ПозицияПоУмолчанию);
			
			СохраняемыеНастройкиПечатныхФорм.Добавить(СохраняемаяНастройка);
		КонецЦикла;
		
		СохранитьНастройкиПечатныхФорм(КлючНастроек, СохраняемыеНастройкиПечатныхФорм);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	НастройкаПечатнойФормы = ТекущаяНастройкаПечатнойФормы();
	
	Если ИмяСобытия = "Запись_ПользовательскиеМакетыПечати" 
		И Источник.ВладелецФормы = ЭтаФорма
		И Параметр.ИмяОбъектаМетаданныхМакета = НастройкаПечатнойФормы.ПутьКМакету Тогда
			ПодключитьОбработчикОжидания("ОбновитьТекущуюПечатнуюФорму",0.1,Истина);
	ИначеЕсли (ИмяСобытия = "ОтказОтИзмененияМакета"
		Или Имясобытия = "ОтменаРедактированияТабличногоДокумента"
		И Параметр.ИмяОбъектаМетаданныхМакета = НастройкаПечатнойФормы.ПутьКМакету)
		И Источник.ВладелецФормы = ЭтаФорма Тогда
			ОтобразитьСостояниеТекущейПечатнойФормы();
	ИначеЕсли ИмяСобытия = "Запись_ТабличныйДокумент" 
		И Параметр.ИмяОбъектаМетаданныхМакета = НастройкаПечатнойФормы.ПутьКМакету 
		И Источник.ВладелецФормы = ЭтаФорма Тогда
			Макет = Параметр.ТабличныйДокумент;
			АдресМакетаВоВременномХранилище = ПоместитьВоВременноеХранилище(Макет);
			ЗаписатьМакет(Параметр.ИмяОбъектаМетаданныхМакета, АдресМакетаВоВременномХранилище);
			ПодключитьОбработчикОжидания("ОбновитьТекущуюПечатнуюФорму",0.1,Истина);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура КопийПриИзменении(Элемент)
	Если НастройкиПечатныхФорм.Количество() = 1 Тогда
		НастройкиПечатныхФорм[0].Количество = Копий;
		ЭтаФорма[НастройкиПечатныхФорм[0].ИмяРеквизита].КоличествоЭкземпляров = НастройкиПечатныхФорм[0].Количество;
	КонецЕсли;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ НастройкиПечатныхФорм

&НаКлиенте
Процедура НастройкиПечатныхФормПриИзменении(Элемент)
	
	МожноПечатать = Ложь;
	МожноСохранять = Ложь;
	
	Для Каждого НастройкаПечатнойФормы Из НастройкиПечатныхФорм Цикл
		ПечатнаяФорма = ЭтаФорма[НастройкаПечатнойФормы.ИмяРеквизита];
		ПолеТабличногоДокумента = Элементы[НастройкаПечатнойФормы.ИмяРеквизита];
		
		МожноПечатать = МожноПечатать Или НастройкаПечатнойФормы.Печатать И ПечатнаяФорма.ВысотаТаблицы > 0
			И ПолеТабличногоДокумента.Вывод = ИспользованиеВывода.Разрешить;
		
		МожноСохранять = МожноСохранять Или НастройкаПечатнойФормы.Печатать И ПечатнаяФорма.ВысотаТаблицы > 0
			И ПолеТабличногоДокумента.Вывод = ИспользованиеВывода.Разрешить И Не ПолеТабличногоДокумента.Защита;
	КонецЦикла;
	
	Элементы.КнопкаПечатьКоманднаяПанель.Доступность = МожноПечатать;
	Элементы.КнопкаПечатьВсеДействия.Доступность = МожноПечатать;
	Элементы.КнопкаСохранить.Доступность = МожноСохранять;
	Элементы.КнопкаОтправить.Доступность = МожноСохранять;
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкиПечатныхФормПриАктивизацииСтроки(Элемент)
	УстановитьТекущуюСтраницу();
КонецПроцедуры

&НаКлиенте
Процедура НастройкиПечатныхФормКоличествоПриИзменении(Элемент)
	НастройкаПечатнойФормы = ТекущаяНастройкаПечатнойФормы();
	ЭтаФорма[НастройкаПечатнойФормы.ИмяРеквизита].КоличествоЭкземпляров = НастройкаПечатнойФормы.Количество;
КонецПроцедуры

&НаКлиенте
Процедура НастройкиПечатныхФормКоличествоРегулирование(Элемент, Направление, СтандартнаяОбработка)
	НастройкаПечатнойФормы = ТекущаяНастройкаПечатнойФормы();
	НастройкаПечатнойФормы.Печатать = НастройкаПечатнойФормы.Количество + Направление > 0;
КонецПроцедуры

&НаКлиенте
Процедура НастройкиПечатныхФормПечататьПриИзменении(Элемент)
	НастройкаПечатнойФормы = ТекущаяНастройкаПечатнойФормы();
	Если НастройкаПечатнойФормы.Печатать И НастройкаПечатнойФормы.Количество = 0 Тогда
		НастройкаПечатнойФормы.Количество = 1;
	КонецЕсли;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура Сохранить(Команда)
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ОбъектыПечати", ОбъектыПечати);
	ОткрытьФорму("ОбщаяФорма.СохранениеПечатнойФормы", ПараметрыФормы, ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура Отправить(Команда)
	
	ПараметрыФормы = Новый Структура;
	ИмяОткрываемойФормы = "ОбщаяФорма.ВыборФорматаВложений";
	Если ПолучателейБольшеОдного(ПараметрыВывода.ПараметрыОтправки.Получатель) Тогда
		ПараметрыФормы.Вставить("Получатели", ПараметрыВывода.ПараметрыОтправки.Получатель);
		ИмяОткрываемойФормы = "ОбщаяФорма.ПодготовкаНовогоПисьма";
	КонецЕсли;
	
	ОткрытьФорму(ИмяОткрываемойФормы, ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиКДокументу(Команда)
	
	СписокВыбора = Новый СписокЗначений;
	Для Каждого ОбъектПечати Из ОбъектыПечати Цикл
		СписокВыбора.Добавить(ОбъектПечати.Представление, Строка(ОбъектПечати.Значение));
	КонецЦикла;
	
	ВыбранныйЭлемент = СписокВыбора.ВыбратьЭлемент(НСтр("ru = 'Перейти к печатной форме'"));
	Если ВыбранныйЭлемент = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого НастройкаПечатнойФормы Из НастройкиПечатныхФорм Цикл
		ПолеТабличногоДокумента = Элементы[НастройкаПечатнойФормы.ИмяРеквизита];
		ТабличныйДокумент = ЭтаФорма[НастройкаПечатнойФормы.ИмяРеквизита];
		ОбластьВыбранногоДокумента = ТабличныйДокумент.Области.Найти(ВыбранныйЭлемент.Значение);
		
		ПолеТабличногоДокумента.ТекущаяОбласть = ТабличныйДокумент.Область("R1C1"); // переход к началу
		
		Если ОбластьВыбранногоДокумента <> Неопределено Тогда
			ПолеТабличногоДокумента.ТекущаяОбласть = ТабличныйДокумент.Область(ОбластьВыбранногоДокумента.Верх,,ОбластьВыбранногоДокумента.Низ,);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиКУправлениюМакетами(Команда)
	ОткрытьФорму("РегистрСведений.ПользовательскиеМакетыПечати.Форма.МакетыПечатныхФорм");
КонецПроцедуры

&НаКлиенте
Процедура Печать(Команда)
	
	ТабличныеДокументы = Новый СписокЗначений;
	
	Для Каждого НастройкаПечатнойФормы Из НастройкиПечатныхФорм Цикл
		Если Элементы[НастройкаПечатнойФормы.ИмяРеквизита].Вывод = ИспользованиеВывода.Разрешить И НастройкаПечатнойФормы.Печатать Тогда
			ТабличныеДокументы.Добавить(ЭтаФорма[НастройкаПечатнойФормы.ИмяРеквизита], НастройкаПечатнойФормы.Представление);
		КонецЕсли;
	КонецЦикла;
	
	УправлениеПечатьюКлиент.РаспечататьТабличныеДокументы(ТабличныеДокументы, ОбъектыПечати,
		ПараметрыВывода.ДоступнаПечатьПоКомплектно, ?(НастройкиПечатныхФорм.Количество() > 1, Копий, 1));
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьСкрытьНастройкуКоличестваКопий(Команда)
	УстановитьВидимостьНастройкиКоличестваКопий();
КонецПроцедуры

&НаКлиенте
Процедура УстановитьФлажки(Команда)
	УстановитьСнятьФлажки(Истина);
КонецПроцедуры

&НаКлиенте
Процедура СнятьФлажки(Команда)
	УстановитьСнятьФлажки(Ложь);
КонецПроцедуры

&НаКлиенте
Процедура СброситьНастройки(Команда)
	ВосстановитьНастройкиПечатныхФорм();
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьМакет(Команда)
	ОткрытьМакетДляРедактирования();
КонецПроцедуры

&НаКлиенте
Процедура ПереключитьРедактирование(Команда)
	ПереключитьРедактированиеТекущейПечатнойФормы();
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура СформироватьПечатныеФормы(КоллекцияПечатныхФорм, ИменаМакетов, Отказ)
	
	// формирование табличных документов
	Если ЗначениеЗаполнено(Параметры.ИсточникДанных) Тогда
		Если ОбщегоНазначенияКлиентСервер.ПодсистемаСуществует("СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки") Тогда
			МодульДополнительныеОтчетыИОбработки = ОбщегоНазначенияКлиентСервер.ОбщийМодуль("ДополнительныеОтчетыИОбработки");
			МодульДополнительныеОтчетыИОбработки.ПечатьПоВнешнемуИсточнику(Параметры.ИсточникДанных,
				Параметры.ПараметрыИсточника, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода);
		Иначе
			Отказ = Истина;
		КонецЕсли;
	Иначе
		УправлениеПечатью.СформироватьПечатныеФормы(Параметры.ИмяМенеджераПечати, ИменаМакетов,
			Параметры.ПараметрКоманды, Параметры.ПараметрыПечати.ДополнительныеПараметры, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода);
	КонецЕсли;
	
	// установка признака сохранения печатной формы в файл (не открывать форму, сразу сохранять в файл)
	Если ТипЗнч(Параметры.ПараметрыПечати) = Тип("Структура") И Параметры.ПараметрыПечати.Свойство("ФорматСохранения") Тогда
		НайденныйФормат = УправлениеПечатью.НастройкиФорматовСохраненияТабличногоДокумента().Найти(Параметры.ПараметрыПечати.ФорматСохранения, "ТипФайлаТабличногоДокумента");
		Если НайденныйФормат <> Неопределено Тогда
			НастройкиФорматаСохранения = Новый Структура("ТипФайлаТабличногоДокумента,Представление,Расширение,Фильтр");
			ЗаполнитьЗначенияСвойств(НастройкиФорматаСохранения, НайденныйФормат);
			НастройкиФорматаСохранения.Фильтр = НастройкиФорматаСохранения.Представление + "|*." + НастройкиФорматаСохранения.Расширение;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьНастройкиКоличестваКопий()
	
	СохраненныеНастройкиПечатныхФорм = Новый Массив;
	
	ИспользоватьСохраненныеНастройки = Истина;
	Если ТипЗнч(Параметры.ПараметрыПечати) = Тип("Структура") И Параметры.ПараметрыПечати.Свойство("ПереопределитьПользовательскиеНастройкиКоличества") Тогда
		ИспользоватьСохраненныеНастройки = Не Параметры.ПараметрыПечати.ПереопределитьПользовательскиеНастройкиКоличества;
	КонецЕсли;
	
	Если ИспользоватьСохраненныеНастройки И Не ЗначениеЗаполнено(Параметры.ИсточникДанных) Тогда
		ИменаМакетов = Параметры.ИменаМакетов;
		Если ТипЗнч(ИменаМакетов) = Тип("Массив") Тогда
			ИменаМакетов = СтроковыеФункцииКлиентСервер.ПолучитьСтрокуИзМассиваПодстрок(ИменаМакетов);
		КонецЕсли;
			
		КлючНастроек = Параметры.ИмяМенеджераПечати + "-" + ИменаМакетов;
		Если СтрДлина(КлючНастроек) > 128 Тогда // ключ более 128 символов вызовет исключение при обращении к хранилищу настроек
			КлючНастроек = Параметры.ИмяМенеджераПечати + "-" + СтроковыеФункцииКлиентСервер.ВычислитьХешСтрокиПоАлгоритмуMD5(ИменаМакетов);
		КонецЕсли;
		СохраненныеНастройкиПечатныхФорм = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("НастройкиПечатныхФорм", КлючНастроек, Новый Массив);
	КонецЕсли;
	
	ВосстановитьНастройкиПечатныхФорм(СохраненныеНастройкиПечатныхФорм);
	
	Если ЭтоПечатьКомплекта() Тогда
		Копий = 1;
	Иначе
		Если НастройкиПечатныхФорм.Количество() > 0 Тогда
			Копий = НастройкиПечатныхФорм[0].Количество;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СоздатьРеквизитыИЭлементыФормыДляПечатныхФорм(КоллекцияПечатныхФорм)
	
	// создание реквизитов для табличных документов
	НовыеРеквизитыФормы = Новый Массив;
	Для НомерПечатнойФормы = 1 По КоллекцияПечатныхФорм.Количество() Цикл
		ИмяРеквизита = "ПечатнаяФорма" + Формат(НомерПечатнойФормы,"ЧГ=0");
		РеквизитФормы = Новый РеквизитФормы(ИмяРеквизита, Новый ОписаниеТипов("ТабличныйДокумент"),,КоллекцияПечатныхФорм[НомерПечатнойФормы - 1].СинонимМакета);
		НовыеРеквизитыФормы.Добавить(РеквизитФормы);
	КонецЦикла;
	ИзменитьРеквизиты(НовыеРеквизитыФормы);
	
	// Создание страниц с табличными документами на форме
	НомерПечатнойФормы = 0;
	ДобавленныеНастройкиПечатныхФорм = Новый Соответствие;
	Для Каждого РеквизитФормы Из НовыеРеквизитыФормы Цикл
		ОписаниеПечатнойФормы = КоллекцияПечатныхФорм[НомерПечатнойФормы];
		
		// таблица настроек печатных форм (начало)
		НоваяНастройкаПечатнойФормы = НастройкиПечатныхФорм.Добавить();
		НоваяНастройкаПечатнойФормы.Представление = ОписаниеПечатнойФормы.СинонимМакета;
		НоваяНастройкаПечатнойФормы.Печатать = Истина;
		НоваяНастройкаПечатнойФормы.Количество = ОписаниеПечатнойФормы.Экземпляров;
		НоваяНастройкаПечатнойФормы.ИмяМакета = ОписаниеПечатнойФормы.ИмяМакета;
		НоваяНастройкаПечатнойФормы.ПозицияПоУмолчанию = НомерПечатнойФормы;
		НоваяНастройкаПечатнойФормы.Название = ОписаниеПечатнойФормы.СинонимМакета;
		НоваяНастройкаПечатнойФормы.ПутьКМакету = ОписаниеПечатнойФормы.ПолныйПутьКМакету;
		
		РанееДобавленнаяНастройкаПечатнойФормы = ДобавленныеНастройкиПечатныхФорм[ОписаниеПечатнойФормы.ИмяМакета];
		Если РанееДобавленнаяНастройкаПечатнойФормы = Неопределено Тогда
			// копирование табличного документа в реквизит формы
			ИмяРеквизита = РеквизитФормы.Имя;
			ЭтаФорма[ИмяРеквизита] = ОписаниеПечатнойФормы.ТабличныйДокумент;
			
			// создание страниц для табличных документов
			ИмяСтраницы = "Страница" + ИмяРеквизита;
			Страница = Элементы.Добавить(ИмяСтраницы, Тип("ГруппаФормы"), Элементы.Страницы);
			Страница.Вид = ВидГруппыФормы.Страница;
			Страница.Картинка = БиблиотекаКартинок.ТабличныйДокументВставитьРазрывСтраницы;
			Страница.Заголовок = ОписаниеПечатнойФормы.СинонимМакета;
			Страница.Подсказка = ОписаниеПечатнойФормы.СинонимМакета;
			Страница.Видимость = ЭтаФорма[ИмяРеквизита].ВысотаТаблицы > 0;
			
			// создание элементов под табличные документы
			НовыйЭлемент = Элементы.Добавить(ИмяРеквизита, Тип("ПолеФормы"), Страница);
			НовыйЭлемент.Вид = ВидПоляФормы.ПолеТабличногоДокумента;
			НовыйЭлемент.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Нет;
			НовыйЭлемент.ПутьКДанным = ИмяРеквизита;
			НовыйЭлемент.Вывод = ВычислитьИспользованиеВывода(ОписаниеПечатнойФормы.ТабличныйДокумент);
			НовыйЭлемент.Редактирование = НовыйЭлемент.Вывод = ИспользованиеВывода.Разрешить;
			НовыйЭлемент.Защита = ОписаниеПечатнойФормы.ТабличныйДокумент.Защита;
			
			// таблица настроек печатных форм (продолжение)
			НоваяНастройкаПечатнойФормы.ИмяСтраницы = ИмяСтраницы;
			НоваяНастройкаПечатнойФормы.ИмяРеквизита = ИмяРеквизита;
			
			ДобавленныеНастройкиПечатныхФорм.Вставить(НоваяНастройкаПечатнойФормы.ИмяМакета, НоваяНастройкаПечатнойФормы);
		Иначе
			НоваяНастройкаПечатнойФормы.ИмяСтраницы = РанееДобавленнаяНастройкаПечатнойФормы.ИмяСтраницы;
			НоваяНастройкаПечатнойФормы.ИмяРеквизита = РанееДобавленнаяНастройкаПечатнойФормы.ИмяРеквизита;
		КонецЕсли;
		
		НомерПечатнойФормы = НомерПечатнойФормы + 1;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция СохранитьНастройкиКомплектаПоУмолчанию()
	Для Каждого НастройкаПечатнойФормы Из НастройкиПечатныхФорм Цикл
		ЗаполнитьЗначенияСвойств(НастройкиКомплектаПоУмолчанию.Добавить(), НастройкаПечатнойФормы);
	КонецЦикла;
КонецФункции

&НаСервере
Процедура НастроитьВидимостьЭлементовФормы(Знач ЕстьРазрешенныйВывод)
	
	ЕстьРазрешенноеРедактирование = ЕстьРазрешенноеРедактирование();
	
	ВозможнаОтправкаПоПочте = ЕстьРазрешенныйВывод И РаботаСПочтовымиСообщениями.ПолучитьДоступныеУчетныеЗаписи(Истина).Количество() > 0;
	ЕстьДанныеДляПечати = ЕстьДанныеДляПечати();
	
	Элементы.КнопкаПерейтиКДокументу.Видимость = ОбъектыПечати.Количество() > 1;
	Элементы.КнопкаСохранить.Видимость = ЕстьДанныеДляПечати и ЕстьРазрешенныйВывод И ЕстьРазрешенноеРедактирование;
	Элементы.КнопкаОтправить.Видимость = ВозможнаОтправкаПоПочте и ЕстьДанныеДляПечати И ЕстьРазрешенноеРедактирование;
	Элементы.КнопкаПечатьКоманднаяПанель.Видимость = ЕстьРазрешенныйВывод И ЕстьДанныеДляПечати;
	Элементы.КнопкаПечатьВсеДействия.Видимость = ЕстьРазрешенныйВывод И ЕстьДанныеДляПечати;
	Элементы.Копий.Видимость = ЕстьРазрешенныйВывод И ЕстьДанныеДляПечати;
	Элементы.КнопкаРедактирование.Видимость = ЕстьРазрешенныйВывод И ЕстьДанныеДляПечати И ЕстьРазрешенноеРедактирование;
	
	Элементы.КнопкаПоказатьСкрытьНастройкуКомплекта.Видимость = ЭтоПечатьКомплекта();
	Элементы.НастройкиПечатныхФорм.Видимость = ЭтоПечатьКомплекта();
	Элементы.ГруппаНастройкаКомплектаПодменю.Видимость = ЭтоПечатьКомплекта();
	
	ДоступнаНастройкаКомплекта = Истина;
	Если ТипЗнч(Параметры.ПараметрыПечати) = Тип("Структура") И Параметры.ПараметрыПечати.Свойство("ФиксированныйКомплект") Тогда
		ДоступнаНастройкаКомплекта = Не Параметры.ПараметрыПечати.ФиксированныйКомплект;
	КонецЕсли;
	
	Элементы.ГруппаНастройкаКомплектаКонтекстноеМеню.Видимость = ДоступнаНастройкаКомплекта;
	Элементы.ГруппаНастройкаКомплектаПодменю.Видимость = ЭтоПечатьКомплекта() И ДоступнаНастройкаКомплекта;
	Элементы.НастройкиПечатныхФормПечатать.Видимость = ДоступнаНастройкаКомплекта;
	Элементы.НастройкиПечатныхФормКоличество.Видимость = ДоступнаНастройкаКомплекта;
	Элементы.НастройкиПечатныхФорм.Шапка = ДоступнаНастройкаКомплекта;
	Элементы.НастройкиПечатныхФорм.ГоризонтальныеЛинии = ДоступнаНастройкаКомплекта;
	
	Если Не ДоступнаНастройкаКомплекта Тогда
		ДобавитьКоличествоЭкземпляровВПредставленияхПечатныхФорм();
	КонецЕсли;
	
	ДоступноИзменениеМакетов = Пользователи.РолиДоступны("ИзменениеМакетовПечатныхФорм") И ЕстьРедактируемыеМакеты();
	Элементы.КнопкаИзменитьМакет.Видимость = ДоступноИзменениеМакетов И ЕстьДанныеДляПечати;
	
	// отключение "технологической" страницы, которая нужна только в конфигураторе для дизайна формы
	Элементы.СтраницаПечатнаяФормаОбразец.Видимость = Ложь;

КонецПроцедуры

&НаСервере
Процедура ДобавитьКоличествоЭкземпляровВПредставленияхПечатныхФорм()
	Для Каждого НастройкаПечатнойФормы Из НастройкиПечатныхФорм Цикл
		Если НастройкаПечатнойФормы.Количество <> 1 Тогда
			НастройкаПечатнойФормы.Представление = НастройкаПечатнойФормы.Представление 
				+ " (" + НастройкаПечатнойФормы.Количество + " " + НСтр("ru = 'экз.'") + ")";
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура УстановитьПризнакДоступностиВыводаВПредставленияхПечатныхФорм(ЕстьРазрешенныйВывод)
	Если ЕстьРазрешенныйВывод Тогда
		Для Каждого НастройкаПечатнойФормы Из НастройкиПечатныхФорм Цикл
			ПолеТабличногоДокумента = Элементы[НастройкаПечатнойФормы.ИмяРеквизита];
			Если ПолеТабличногоДокумента.Вывод = ИспользованиеВывода.Запретить Тогда
				НастройкаПечатнойФормы.Представление = НастройкаПечатнойФормы.Представление + " (" + НСтр("ru = 'вывод не доступен'") + ")";
			ИначеЕсли ПолеТабличногоДокумента.Защита Тогда
				НастройкаПечатнойФормы.Представление = НастройкаПечатнойФормы.Представление + " (" + НСтр("ru = 'только печать'") + ")";
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВидимостьНастройкиКоличестваКопий(Знач Видимость = Неопределено)
	Если Видимость = Неопределено Тогда
		Видимость = Не Элементы.НастройкиПечатныхФорм.Видимость;
	КонецЕсли;
	
	Элементы.НастройкиПечатныхФорм.Видимость = Видимость;
	Элементы.ГруппаНастройкаКомплектаПодменю.Видимость = Видимость И ДоступнаНастройкаКомплекта;
КонецПроцедуры

&НаСервере
Процедура УстановитьИмяПринтераВПодсказкеКнопкиПечать()
	Если НастройкиПечатныхФорм.Количество() > 0 Тогда
		ИмяПринтера = ЭтаФорма[НастройкиПечатныхФорм[0].ИмяРеквизита].ИмяПринтера;
		Если Не ПустаяСтрока(ИмяПринтера) Тогда
			ЭтаФорма.Команды["Печать"].Подсказка = НСтр("ru = 'Напечатать на принтере'") + " (" + ИмяПринтера + ")";
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура УстановитьЗаголовокФормы()
	Перем ЗаголовокФормы;
	
	Если ТипЗнч(Параметры.ПараметрыПечати) = Тип("Структура") Тогда
		Параметры.ПараметрыПечати.Свойство("ЗаголовокФормы", ЗаголовокФормы);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ЗаголовокФормы) Тогда
		Заголовок = ЗаголовокФормы;
	Иначе
		Если ЭтоПечатьКомплекта() Тогда
			Заголовок = НСтр("ru = 'Печать комплекта'");
		ИначеЕсли ТипЗнч(Параметры.ПараметрКоманды) <> Тип("Массив") Или Параметры.ПараметрКоманды.Количество() > 1 Тогда
			Заголовок = НСтр("ru = 'Печать документов'");
		Иначе
			Заголовок = НСтр("ru = 'Печать документа'");
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура УстановитьТекущуюСтраницу()
	
	НастройкаПечатнойФормы = ТекущаяНастройкаПечатнойФормы();
	
	ТекущаяСтраница = Элементы.СтраницаПечатнаяФормаНедоступна;
	Если НастройкаПечатнойФормы <> Неопределено И ЭтаФорма[НастройкаПечатнойФормы.ИмяРеквизита].ВысотаТаблицы > 0 Тогда
		ТекущаяСтраница = Элементы[НастройкаПечатнойФормы.ИмяСтраницы];
	КонецЕсли;
	
	Элементы.Страницы.ТекущаяСтраница = ТекущаяСтраница;
	
	ПереключитьПометкуКнопкиРедактирование();
	УстановитьДоступностьИзмененияМакета();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСнятьФлажки(Пометка)
	Для Каждого НастройкаПечатнойФормы Из НастройкиПечатныхФорм Цикл
		НастройкаПечатнойФормы.Печатать = Пометка;
		Если Пометка И НастройкаПечатнойФормы.Количество = 0 Тогда
			НастройкаПечатнойФормы.Количество = 1;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Функция ВычислитьИспользованиеВывода(ТабличныйДокумент)
	Если ТабличныйДокумент.Вывод = ИспользованиеВывода.Авто Тогда
		Возврат ?(ПравоДоступа("Вывод", Метаданные), ИспользованиеВывода.Разрешить, ИспользованиеВывода.Запретить);
	Иначе
		Возврат ТабличныйДокумент.Вывод;
	КонецЕсли;
КонецФункции

&НаСервереБезКонтекста
Процедура СохранитьНастройкиПечатныхФорм(КлючНастроек, СохраняемыеНастройкиПечатныхФорм)
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("НастройкиПечатныхФорм", КлючНастроек, СохраняемыеНастройкиПечатныхФорм);
КонецПроцедуры

&НаСервере
Процедура ВосстановитьНастройкиПечатныхФорм(СохраненныеНастройкиПечатныхФорм = Неопределено)
	Если СохраненныеНастройкиПечатныхФорм = Неопределено Тогда
		СохраненныеНастройкиПечатныхФорм = НастройкиКомплектаПоУмолчанию;
	КонецЕсли;
	
	Если СохраненныеНастройкиПечатныхФорм = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого СохраненнаяНастройка Из СохраненныеНастройкиПечатныхФорм Цикл
		НайденныеНастройки = НастройкиПечатныхФорм.НайтиСтроки(Новый Структура("ПозицияПоУмолчанию", СохраненнаяНастройка.ПозицияПоУмолчанию));
		Для Каждого НастройкаПечатнойФормы Из НайденныеНастройки Цикл
			ИндексСтроки = НастройкиПечатныхФорм.Индекс(НастройкаПечатнойФормы);
			НастройкиПечатныхФорм.Сдвинуть(ИндексСтроки, НастройкиПечатныхФорм.Количество()-1 - ИндексСтроки); // сдвиг в конец
			НастройкаПечатнойФормы.Количество = СохраненнаяНастройка.Количество;
			ЭтаФорма[НастройкаПечатнойФормы.ИмяРеквизита].КоличествоЭкземпляров = НастройкаПечатнойФормы.Количество;
			НастройкаПечатнойФормы.Печатать = НастройкаПечатнойФормы.Количество > 0;
		КонецЦикла;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Функция ПоместитьТабличныеДокументыВоВременноеХранилище(НастройкиСохранения)
	Перем ЗаписьZipФайла, ИмяАрхива;
	
	Результат = Новый СписокЗначений;
	
	// подготовка архива
	Если НастройкиСохранения.УпаковатьВАрхив Тогда
		ИмяАрхива = ПолучитьИмяВременногоФайла("zip");
		ЗаписьZipФайла = Новый ЗаписьZipФайла(ИмяАрхива);
	КонецЕсли;
	
	// подготовка временной папки
	ИмяВременнойПапки = ПолучитьИмяВременногоФайла();
	СоздатьКаталог(ИмяВременнойПапки);
	ИспользованныеИменаФайлов = Новый Соответствие;
	
	ВыбранныеФорматыСохранения = НастройкиСохранения.ФорматыСохранения;
	ТаблицаФорматов = УправлениеПечатью.НастройкиФорматовСохраненияТабличногоДокумента();
	
	// сохранение печатных форм
	ОбработанныеПечатныеФормы = Новый Массив;
	Для Каждого НастройкаПечатнойФормы Из НастройкиПечатныхФорм Цикл
		
		Если Не НастройкаПечатнойФормы.Печатать Тогда
			Продолжить;
		КонецЕсли;
		
		ПечатнаяФорма = ЭтаФорма[НастройкаПечатнойФормы.ИмяРеквизита];
		Если ОбработанныеПечатныеФормы.Найти(ПечатнаяФорма) = Неопределено Тогда
			ОбработанныеПечатныеФормы.Добавить(ПечатнаяФорма);
		Иначе
			Продолжить;
		КонецЕсли;
		
		Если ВычислитьИспользованиеВывода(ПечатнаяФорма) = ИспользованиеВывода.Запретить Тогда
			Продолжить;
		КонецЕсли;
		
		Если ПечатнаяФорма.Защита Тогда
			Продолжить;
		КонецЕсли;
		
		Если ПечатнаяФорма.ВысотаТаблицы = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		Для Каждого ТипФайла Из ВыбранныеФорматыСохранения Цикл
			НастройкиФормата = ТаблицаФорматов.НайтиСтроки(Новый Структура("ТипФайлаТабличногоДокумента", ТипФайла))[0];
			
			ИмяФайла = ПолучитьИмяВременногоФайлаДляПечатнойФормы(НастройкаПечатнойФормы.Название,НастройкиФормата.Расширение,ИспользованныеИменаФайлов);
			ПолноеИмяФайла = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(ИмяВременнойПапки) + ИмяФайла;
			
			ПечатнаяФорма.Записать(ПолноеИмяФайла, ТипФайла);
			
			Если ТипФайла = ТипФайлаТабличногоДокумента.HTML Тогда
				ВставитьКартинкиВHTML(ПолноеИмяФайла);
			КонецЕсли;
			
			Если ЗаписьZipФайла <> Неопределено Тогда 
				ЗаписьZipФайла.Добавить(ПолноеИмяФайла);
			Иначе
				ДвоичныеДанные = Новый ДвоичныеДанные(ПолноеИмяФайла);
				ПутьВоВременномХранилище = ПоместитьВоВременноеХранилище(ДвоичныеДанные, ЭтаФорма.УникальныйИдентификатор);
				Результат.Добавить(ПутьВоВременномХранилище, ИмяФайла);
			КонецЕсли;
		КонецЦикла;
		
	КонецЦикла;
	
	// если архив подготовлен, записываем и помещаем его во временное хранилище
	Если ЗаписьZipФайла <> Неопределено Тогда 
		ЗаписьZipФайла.Записать();
		ФайлАрхива = Новый Файл(ИмяАрхива);
		ДвоичныеДанные = Новый ДвоичныеДанные(ИмяАрхива);
		ПутьВоВременномХранилище = ПоместитьВоВременноеХранилище(ДвоичныеДанные, ЭтаФорма.УникальныйИдентификатор);
		Результат.Добавить(ПутьВоВременномХранилище, ПолучитьИмяФайлаДляАрхива());
	КонецЕсли;
	
	УдалитьФайлы(ИмяВременнойПапки);
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура ВставитьКартинкиВHTML(ИмяФайлаHTML)
	
	ТекстовыйДокумент = Новый ТекстовыйДокумент();
	ТекстовыйДокумент.Прочитать(ИмяФайлаHTML, КодировкаТекста.UTF8);
	ТекстHTML = ТекстовыйДокумент.ПолучитьТекст();
	
	ФайлHTML = Новый Файл(ИмяФайлаHTML);
	
	ИмяПапкиКартинок = ФайлHTML.ИмяБезРасширения + "_files";
	ПутьКПапкеКартинок = СтрЗаменить(ФайлHTML.ПолноеИмя, ФайлHTML.Имя, ИмяПапкиКартинок);
	
	// ожидается, что в папке будут только картинки
	ФайлыКартинок = НайтиФайлы(ПутьКПапкеКартинок, "*");
	
	Для Каждого ФайлКартинки Из ФайлыКартинок Цикл
		КартинкаТекстом = Base64Строка(Новый ДвоичныеДанные(ФайлКартинки.ПолноеИмя));
		КартинкаТекстом = "data:image/" + Сред(ФайлКартинки.Расширение,2) + ";base64," + Символы.ПС + КартинкаТекстом;
		
		ТекстHTML = СтрЗаменить(ТекстHTML, ИмяПапкиКартинок + "\" + ФайлКартинки.Имя, КартинкаТекстом);
	КонецЦикла;
		
	ТекстовыйДокумент.УстановитьТекст(ТекстHTML);
	ТекстовыйДокумент.Записать(ИмяФайлаHTML, КодировкаТекста.UTF8);
	
КонецПроцедуры

&НаСервере
Функция ПолучитьИмяВременногоФайлаДляПечатнойФормы(ИмяМакета, Расширение, ИспользованныеИменаФайлов)
	
	ШаблонИмениФайла = "%1%2.%3";
	
	ИмяВременногоФайла = ОбщегоНазначенияКлиентСервер.ЗаменитьНедопустимыеСимволыВИмениФайла(
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонИмениФайла, ИмяМакета, "", Расширение));
		
	НомерИспользования = ?(ИспользованныеИменаФайлов[ИмяВременногоФайла] <> Неопределено,
							ИспользованныеИменаФайлов[ИмяВременногоФайла] + 1,
							1);
	
	ИспользованныеИменаФайлов.Вставить(ИмяВременногоФайла, НомерИспользования);
	
	// если имя уже было ранее использовано, прибавляем счетчик в конце имени
	Если НомерИспользования > 1 Тогда
		ИмяВременногоФайла = ОбщегоНазначенияКлиентСервер.ЗаменитьНедопустимыеСимволыВИмениФайла(
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				ШаблонИмениФайла,
				ИмяМакета,
				" (" + НомерИспользования + ")",
				Расширение));
	КонецЕсли;
	
	Возврат ИмяВременногоФайла;
	
КонецФункции

&НаСервере
Функция ПолучитьИмяФайлаДляАрхива()
	
	Результат = "";
	
	Для Каждого НастройкаПечатнойФормы Из НастройкиПечатныхФорм Цикл
		
		Если Не НастройкаПечатнойФормы.Печатать Тогда
			Продолжить;
		КонецЕсли;
		
		ПечатнаяФорма = ЭтаФорма[НастройкаПечатнойФормы.ИмяРеквизита];
		
		Если ВычислитьИспользованиеВывода(ПечатнаяФорма) = ИспользованиеВывода.Запретить Тогда
			Продолжить;
		КонецЕсли;
		
		Если ПустаяСтрока(Результат) Тогда
			Результат = НастройкаПечатнойФормы.Название;
		Иначе
			Результат = НСтр("ru = 'Документы'");
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат + ".zip";
	
КонецФункции

&НаКлиенте
Процедура СохранитьПечатнуюФормуВФайл()
	
	ФорматыСохранения = Новый Массив;
	ФорматыСохранения.Добавить(НастройкиФорматаСохранения.ТипФайлаТабличногоДокумента);
	НастройкиСохранения = Новый Структура("ФорматыСохранения,УпаковатьВАрхив", ФорматыСохранения, Ложь);
	ФайлыВоВременномХранилище = ПоместитьТабличныеДокументыВоВременноеХранилище(НастройкиСохранения);
	
	Для Каждого ФайлДляЗаписи Из ФайлыВоВременномХранилище Цикл
		#Если ВебКлиент Тогда
		ПолучитьФайл(ФайлДляЗаписи.Значение, ФайлДляЗаписи.Представление);
		#Иначе
		ИмяВременногоФайла = ПолучитьИмяВременногоФайла(НастройкиФорматаСохранения.Расширение);
		ДвоичныеДанные = ПолучитьИзВременногоХранилища(ФайлДляЗаписи.Значение);
		ДвоичныеДанные.Записать(ИмяВременногоФайла);
		ЗапуститьПриложение(ИмяВременногоФайла);
		#КонецЕсли
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьПечатныеФормыВПапку(СписокФайловВоВременномХранилище, Папка = "")
	
	#Если ВебКлиент Тогда
		Для Каждого ФайлДляЗаписи Из СписокФайловВоВременномХранилище Цикл
			ПолучитьФайл(ФайлДляЗаписи.Значение, ФайлДляЗаписи.Представление);
		КонецЦикла;
		Возврат;
	#КонецЕсли
	
	Если НайтиФайлы(Папка,"*").Количество() > 0 Тогда
		ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Папка ""%1"" не пустая.
				|Перезаписывать файлы при совпадении имен?'"),
			Папка);
		Кнопки = Новый СписокЗначений;
		Кнопки.Добавить(КодВозвратаДиалога.Да, НСтр("ru = 'Перезаписывать'"));
		Кнопки.Добавить(КодВозвратаДиалога.Отмена);
		Если Вопрос(ТекстВопроса, Кнопки, , КодВозвратаДиалога.Отмена, НСтр("ru = 'Сохранение печатной формы'")) = КодВозвратаДиалога.Отмена Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Для Каждого ФайлДляЗаписи Из СписокФайловВоВременномХранилище Цикл
		ПолноеИмяФайла = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(Папка) + ФайлДляЗаписи.Представление;
		
		ДвоичныеДанные = ПолучитьИзВременногоХранилища(ФайлДляЗаписи.Значение);
		ДвоичныеДанные.Записать(ПолноеИмяФайла);
	КонецЦикла;

	Состояние(НСтр("ru = 'Сохранение успешно завершено'"), , НСтр("ru = 'в папку:'") + " " + Папка);
	
КонецПроцедуры

&НаСервере
Процедура ПрисоединитьПечатныеФормыКОбъекту(ФайлыВоВременномХранилище, ОбъектДляПрисоединения)
	Для Каждого Файл Из ФайлыВоВременномХранилище Цикл
		УправлениеПечатью.ПриПрисоединенииПечатнойФормыКОбъекту(ОбъектДляПрисоединения, Файл.Представление, Файл.Значение);
	КонецЦикла;
КонецПроцедуры

&НаСервере
Функция ЭтоПечатьКомплекта()
	Возврат НастройкиПечатныхФорм.Количество() > 1;
КонецФункции

&НаСервере
Функция ЕстьРазрешенныйВывод()
	
	Для Каждого НастройкаПечатнойФормы Из НастройкиПечатныхФорм Цикл
		Если Элементы[НастройкаПечатнойФормы.ИмяРеквизита].Вывод = ИспользованиеВывода.Разрешить Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

&НаСервере
Функция ЕстьРазрешенноеРедактирование()
	
	Для Каждого НастройкаПечатнойФормы Из НастройкиПечатныхФорм Цикл
		Если Элементы[НастройкаПечатнойФормы.ИмяРеквизита].Защита = Ложь Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

&НаКлиенте
Функция ПолучателейБольшеОдного(Получатель)
	Если ТипЗнч(Получатель) = Тип("Массив") Или ТипЗнч(Получатель) = Тип("СписокЗначений") Тогда
		Возврат Получатель.Количество() > 1;
	Иначе
		Возврат ОбщегоНазначенияКлиентСервер.АдресаЭлектроннойПочтыИзСтроки(Получатель).Количество() > 1;
	КонецЕсли;
КонецФункции

&НаСервере
Функция ЕстьДанныеДляПечати()
	Результат = Ложь;
	Для Каждого НастройкаПечатнойФормы Из НастройкиПечатныхФорм Цикл
		Результат = Результат Или ЭтаФорма[НастройкаПечатнойФормы.ИмяРеквизита].ВысотаТаблицы > 0;
	КонецЦикла;
	Возврат Результат;
КонецФункции

&НаСервере
Функция ЕстьРедактируемыеМакеты()
	Результат = Ложь;
	Для Каждого НастройкаПечатнойФормы Из НастройкиПечатныхФорм Цикл
		Результат = Результат Или Не ПустаяСтрока(НастройкаПечатнойФормы.ПутьКМакету);
	КонецЦикла;
	Возврат Результат;
КонецФункции

&НаКлиенте
Процедура ОткрытьМакетДляРедактирования()
	
	НастройкаПечатнойФормы = ТекущаяНастройкаПечатнойФормы();
	
	ОтобразитьСостояниеТекущейПечатнойФормы(НСтр("ru = 'Макет редактируется'"));
	
	ИмяОбъектаМетаданныхМакета = НастройкаПечатнойФормы.ПутьКМакету;
	
	#Если ВебКлиент Тогда
		ПараметрыОткрытия = Новый Структура;
		ПараметрыОткрытия.Вставить("ИмяОбъектаМетаданныхМакета", ИмяОбъектаМетаданныхМакета);
		ПараметрыОткрытия.Вставить("ТипМакета", "MXL");
		ПараметрыОткрытия.Вставить("ЭтоВебКлиент", Истина);
		
		ОткрытьФорму("РегистрСведений.ПользовательскиеМакетыПечати.Форма.РедактированиеМакета", ПараметрыОткрытия, ЭтаФорма);
		
	#Иначе
		ПараметрыОткрытия = Новый Структура;
		ПараметрыОткрытия.Вставить("ИмяОбъектаМетаданныхМакета", ИмяОбъектаМетаданныхМакета);
		ПараметрыОткрытия.Вставить("РежимОткрытияОкна", РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		ПараметрыОткрытия.Вставить("ИмяДокумента", НастройкаПечатнойФормы.Представление);
		ПараметрыОткрытия.Вставить("Редактирование", Истина);
		
		ОткрытьФорму("ОбщаяФорма.РедактированиеТабличногоДокумента", ПараметрыОткрытия, ЭтаФорма);
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ОтобразитьСостояниеТекущейПечатнойФормы(ТекстСостояния = "")
	
	ОтображатьСостояние = Не ПустаяСтрока(ТекстСостояния);
	
	НастройкаПечатнойФормы = ТекущаяНастройкаПечатнойФормы();
	Если НастройкаПечатнойФормы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПолеТабличногоДокумента = Элементы[НастройкаПечатнойФормы.ИмяРеквизита];
	
	ОтображениеСостояния = ПолеТабличногоДокумента.ОтображениеСостояния;
	ОтображениеСостояния.Текст = ТекстСостояния;
	ОтображениеСостояния.Видимость = ОтображатьСостояние;
	ОтображениеСостояния.ДополнительныйРежимОтображения = 
		?(ОтображатьСостояние, ДополнительныйРежимОтображения.Неактуальность, ДополнительныйРежимОтображения.НеИспользовать);
		
	ПолеТабличногоДокумента.ТолькоПросмотр = ОтображатьСостояние Или ПолеТабличногоДокумента.Вывод = ИспользованиеВывода.Запретить;
	
КонецПроцедуры

&НаКлиенте
Процедура ПереключитьРедактированиеТекущейПечатнойФормы()
	НастройкаПечатнойФормы = ТекущаяНастройкаПечатнойФормы();
	Если НастройкаПечатнойФормы <> Неопределено Тогда
		ПолеТабличногоДокумента = Элементы[НастройкаПечатнойФормы.ИмяРеквизита];
		ПолеТабличногоДокумента.Редактирование = Не ПолеТабличногоДокумента.Редактирование;
		ПереключитьПометкуКнопкиРедактирование();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПереключитьПометкуКнопкиРедактирование()
	
	ПечатнаяФормаДоступна = Элементы.Страницы.ТекущаяСтраница <> Элементы.СтраницаПечатнаяФормаНедоступна;
	
	РедактированиеВозможно = Ложь;
	Пометка = Ложь;
	
	НастройкаПечатнойФормы = ТекущаяНастройкаПечатнойФормы();
	Если НастройкаПечатнойФормы <> Неопределено Тогда
		ПолеТабличногоДокумента = Элементы[НастройкаПечатнойФормы.ИмяРеквизита];
		РедактированиеВозможно = ПечатнаяФормаДоступна И Не ПолеТабличногоДокумента.Защита;
		Пометка = ПолеТабличногоДокумента.Редактирование И РедактированиеВозможно;
	КонецЕсли;
	
	Элементы.КнопкаРедактирование.Пометка = Пометка;
	Элементы.КнопкаРедактирование.Доступность = РедактированиеВозможно;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьИзмененияМакета()
	ПечатнаяФормаДоступна = Элементы.Страницы.ТекущаяСтраница <> Элементы.СтраницаПечатнаяФормаНедоступна;
	НастройкаПечатнойФормы = ТекущаяНастройкаПечатнойФормы();
	Элементы.КнопкаИзменитьМакет.Доступность = ПечатнаяФормаДоступна И Не ПустаяСтрока(НастройкаПечатнойФормы.ПутьКМакету);
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьТекущуюПечатнуюФорму()
	
	НастройкаПечатнойФормы = ТекущаяНастройкаПечатнойФормы();
	Если НастройкаПечатнойФормы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПереформироватьПечатнуюФорму(НастройкаПечатнойФормы.ИмяМакета, НастройкаПечатнойФормы.ИмяРеквизита);
	ОтобразитьСостояниеТекущейПечатнойФормы();
	
КонецПроцедуры

&НаСервере
Процедура ПереформироватьПечатнуюФорму(ИмяМакета, ИмяРеквизита)
	Перем КоллекцияПечатныхФорм;
	
	Отказ = Ложь;
	
	СформироватьПечатныеФормы(КоллекцияПечатныхФорм, ИмяМакета, Отказ);
	Если Отказ Тогда
		ВызватьИсключение НСтр("ru = 'Печатная форма не была переформирована.'");
	КонецЕсли;
	
	Для Каждого ПечатнаяФорма Из КоллекцияПечатныхФорм Цикл
		Если ПечатнаяФорма.ИмяМакета = ИмяМакета Тогда
			ЭтаФорма[ИмяРеквизита] = ПечатнаяФорма.ТабличныйДокумент;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Функция ТекущаяНастройкаПечатнойФормы()
	Результат = Элементы.НастройкиПечатныхФорм.ТекущиеДанные;
	Если Результат = Неопределено И НастройкиПечатныхФорм.Количество() > 0 Тогда
		Результат = НастройкиПечатныхФорм[0];
	КонецЕсли;
	Возврат Результат;
КонецФункции

&НаСервереБезКонтекста
Процедура ЗаписатьМакет(ИмяОбъектаМетаданныхМакета, АдресМакетаВоВременномХранилище)
	УправлениеПечатью.ЗаписатьМакет(ИмяОбъектаМетаданныхМакета, АдресМакетаВоВременномХранилище);
КонецПроцедуры

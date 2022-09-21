////////////////////////////////////////////////////////////////////////////////
// Подсистема "Настройка порядка элементов".
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Обработчик команды "Переместить вверх" формы списка.
//
// Параметры:
//  РеквизитФормыСписок - ДинамическийСписок - реквизит формы, содержащий список;
//  ЭлементФормыСписок  - ТаблицаФормы       - элемент формы, содержащий список.
//
Процедура ПереместитьЭлементВверхВыполнить(РеквизитФормыСписок, ЭлементФормыСписок) Экспорт
	
	ПереместитьЭлемент(РеквизитФормыСписок, ЭлементФормыСписок, "Вверх");
	
КонецПроцедуры

// Обработчик команды "Переместить вниз" формы списка.
//
// Параметры:
//  РеквизитФормыСписок - ДинамическийСписок - реквизит формы, содержащий список;
//  ЭлементФормыСписок  - ТаблицаФормы       - элемент формы, содержащий список.
//
Процедура ПереместитьЭлементВнизВыполнить(РеквизитФормыСписок, ЭлементФормыСписок) Экспорт
	
	ПереместитьЭлемент(РеквизитФормыСписок, ЭлементФормыСписок, "Вниз");
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Процедура ПереместитьЭлемент(СписокРеквизит, СписокЭлемент, Направление)
	
	Если СписокЭлемент.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ПроверитьСписокПередОперацией(СписокРеквизит) Тогда
		Возврат;
	КонецЕсли;
	
	ОтображениеСписком = (СписокЭлемент.Отображение = ОтображениеТаблицы.Список);
	
	ТекстОшибки = НастройкаПорядкаЭлементовСлужебныйВызовСервера.ИзменитьПорядокЭлементов(
		СписокЭлемент.ТекущиеДанные.Ссылка, СписокРеквизит, ОтображениеСписком, Направление);
		
	Если Не ПустаяСтрока(ТекстОшибки) Тогда
		Предупреждение(ТекстОшибки);
	КонецЕсли;
	
	СписокЭлемент.Обновить();
	
КонецПроцедуры

Функция ПроверитьСписокПередОперацией(СписокРеквизит)
	
	Если Не СортировкаВСпискеУстановленаПравильно(СписокРеквизит) Тогда
		Предупреждение(НСтр("ru = 'Для изменения порядка элементов необходимо настроить сортировку
								  |списка таким образом, чтобы поле ""Порядок"" находилось на первой
								  |позиции, и вид сортировки был установлен ""По возрастанию"".'"));
		Возврат Ложь;
	КонецЕсли;
	
	Если СписокСодержитГруппуОтборов(СписокРеквизит) Тогда
		Предупреждение(НСтр("ru = 'Для изменения порядка элементов у списка необходимо отключить группы отборов.'"));
		Возврат Ложь;
	КонецЕсли;
	
	Для Каждого ЭлементГруппировки Из СписокРеквизит.Группировка.Элементы Цикл
		Если ЭлементГруппировки.Использование Тогда
			Предупреждение(НСтр("ru = 'Для изменения порядка элементов необходимо отключить все группировки.'"));
			Возврат Ложь;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции

Функция СортировкаВСпискеУстановленаПравильно(СписокРеквизит)
	
	ЭлементыПорядка = СписокРеквизит.Порядок.Элементы;
	
	// Найдем первый используемый элемент порядка
	Элемент = Неопределено;
	Для Каждого ЭлементПорядка Из ЭлементыПорядка Цикл
		Если ЭлементПорядка.Использование Тогда
			Элемент = ЭлементПорядка;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если Элемент = Неопределено Тогда
		// Не установлена никакая сортировка
		Возврат Ложь;
	КонецЕсли;
	
	Если ТипЗнч(Элемент) = Тип("ЭлементПорядкаКомпоновкиДанных") Тогда
		Если Элемент.ТипУпорядочивания = НаправлениеСортировкиКомпоновкиДанных.Возр Тогда
			ПолеРеквизита = Новый ПолеКомпоновкиДанных("РеквизитДопУпорядочивания");
			Если Элемент.Поле = ПолеРеквизита Тогда
				Возврат Истина;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

Функция СписокСодержитГруппуОтборов(Список)
	Для Каждого Отбор Из Список.Отбор.Элементы Цикл
		Если Не Отбор.Использование Тогда
			Продолжить;
		ИначеЕсли ТипЗнч(Отбор) <> Тип("ЭлементОтбораКомпоновкиДанных") Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;
	Возврат Ложь;
КонецФункции

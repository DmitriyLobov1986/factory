////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
		
	ИнициализироватьЭлементыВФорме(Параметры.Предупреждения);
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

// Обработчик нажатия на гиперссылку.
//
&НаКлиенте
Процедура НажатиеНаГиперСсылку(Элемент)
	Для каждого СтрокаВопроса из МассивСоотношенияЭлементовИПараметров Цикл
		Если Элемент.Имя = СтрокаВопроса.Значение.Имя Тогда 
			Форма = Неопределено;
			Если СтрокаВопроса.Значение.Свойство("Форма", Форма) Тогда 
				ПараметрыФормы = Неопределено;
				Если СтрокаВопроса.Значение.Свойство("ПараметрыФормы", ПараметрыФормы) Тогда 
				КонецЕсли;
				ОткрытьФорму(Форма, ПараметрыФормы, ЭтаФорма);
			КонецЕсли;
			Прервать;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

// Инициализирует массив будущих задач, которые необходимо выполнить при закрытии.
//
&НаКлиенте 
Процедура ИзменитьМассивБудущихЗадач(Элемент)
	ИмяЭлемента 		= Элемент.Имя;
	НайденныйЭлемент 	= Элементы.Найти(ИмяЭлемента);
	
	Если НайденныйЭлемент = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ЗначениеЭлемента = ЭтаФорма[ИмяЭлемента];
	Если ТипЗнч(ЗначениеЭлемента) <> Тип("Булево") Тогда
		Возврат;
	КонецЕсли;
		

	ИдентификаторМассива = ИдентификаторМассиваЗадачПоИмени(ИмяЭлемента);
	Если ИдентификаторМассива = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	ЭлементМассива = МассивЗадачНаВыполнениеПослеЗакрытия.НайтиПоИдентификатору(ИдентификаторМассива);
	Использование = Неопределено;
	Если ЭлементМассива.Значение.Свойство("Использование", Использование) Тогда 
		Если ТипЗнч(Использование) = Тип("Булево") Тогда 
			ЭлементМассива.Значение.Использование = ЗначениеЭлемента;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры	


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура Завершить(Команда)
	
	ВыполнениеЗадачПриЗакрытии();
	Закрыть(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть(Истина);
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Создает элементы формы по передаваемым вопросам пользователю.
//
// Параметры:
//	Вопросы - список значений вопросов.
//
&НаСервере
Процедура ИнициализироватьЭлементыВФорме(Предупреждения)
	
	ТаблицаПредупреждений = Новый ТаблицаЗначений;
	
	ПреобразоватьМассивСтруктурВТаблицуЗначений(Предупреждения, ТаблицаПредупреждений);
	
	Для каждого ТекущееПредупреждение из ТаблицаПредупреждений Цикл 
		// Пропускаем чтение текущей структуры, если имеется текст для флага и для структуры одновременно.
		ТекстФлажка 		= "";
		ТекстГиперСсылки 	= "";
		Если ТекущееПредупреждение.ТекстФлажка <> Неопределено
			И ТекущееПредупреждение.ТекстГиперСсылки <> Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		// Формирование гиперссылки на форме.
		Если ТекущееПредупреждение.ТекстГиперСсылки <> Неопределено Тогда
			Если Не ПустаяСтрока(ТекущееПредупреждение.ТекстГиперСсылки) Тогда 
				СоздатьГиперссылкуНаФорме(ТекущееПредупреждение);
			КонецЕсли;
		КонецЕсли;
		
		// Формирование флажка на форме.
		Если ТекущееПредупреждение.ТекстФлажка <> Неопределено Тогда
			Если Не ПустаяСтрока(ТекущееПредупреждение.ТекстФлажка) Тогда 
				СоздатьФлажокНаФорме(ТекущееПредупреждение);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	// Формирование окончательного вопроса на форме.
	СоздатьОкончательныйВопрос();
КонецПроцедуры

&НаСервере
Процедура ПреобразоватьМассивСтруктурВТаблицуЗначений(Предупреждения, ТаблицаПредупреждений)
	
	ОчищаемыеПредупреждения = Новый Массив;
	ТаблицаПредупреждений.Колонки.Добавить("ТекстФлажка");
	ТаблицаПредупреждений.Колонки.Добавить("ПоясняющийТекст");
	ТаблицаПредупреждений.Колонки.Добавить("ТекстГиперссылки");
	ТаблицаПредупреждений.Колонки.Добавить("ДействиеПриУстановленномФлажке");
	ТаблицаПредупреждений.Колонки.Добавить("ДействиеПриНажатииГиперссылки");
	ТаблицаПредупреждений.Колонки.Добавить("Приоритет");
	ТаблицаПредупреждений.Колонки.Добавить("ВывестиОдноПредупреждение");
	
	Для Каждого ЭлементПредупреждения Из Предупреждения Цикл
		СтрокаТаблицы = ТаблицаПредупреждений.Добавить();
		ЭлементПредупреждения.Свойство("ТекстФлажка", СтрокаТаблицы.ТекстФлажка);
		ЭлементПредупреждения.Свойство("ПоясняющийТекст", СтрокаТаблицы.ПоясняющийТекст);
		ЭлементПредупреждения.Свойство("ТекстГиперссылки", СтрокаТаблицы.ТекстГиперссылки);
		ЭлементПредупреждения.Свойство("ДействиеПриУстановленномФлажке", СтрокаТаблицы.ДействиеПриУстановленномФлажке);
		ЭлементПредупреждения.Свойство("ДействиеПриНажатииГиперссылки", СтрокаТаблицы.ДействиеПриНажатииГиперссылки);
		ЭлементПредупреждения.Свойство("Приоритет", СтрокаТаблицы.Приоритет);
		ЭлементПредупреждения.Свойство("ВывестиОдноПредупреждение", СтрокаТаблицы.ВывестиОдноПредупреждение);
		
		Если СтрокаТаблицы.ВывестиОдноПредупреждение <> Истина Тогда
			ОчищаемыеПредупреждения.Добавить(СтрокаТаблицы);
		КонецЕсли;
		
	КонецЦикла;
	
	// Поиск обработчиков, которые требуют очистки предупреждений.
	Отбор = Новый Структура("ВывестиОдноПредупреждение", Истина);
	НайденныеПредупреждения = ТаблицаПредупреждений.НайтиСтроки(Отбор);
	Если НайденныеПредупреждения.Количество() <> 0 Тогда
		Для Каждого ОчищаемоеПредупреждения Из ОчищаемыеПредупреждения Цикл
			ТаблицаПредупреждений.Удалить(ОчищаемоеПредупреждения);
		КонецЦикла;
	КонецЕсли;
	
	ТаблицаПредупреждений.Сортировать("Приоритет убыв");
	
КонецПроцедуры

// Формирует на форме группу и возвращает её.
// Является дочерней группой для "ОсновнойГруппы".
//
&НаСервере
Функция СформироватьГруппуЭлементовФормы()
	ИмяГруппы 		= ОпределитьИмяНадписиВФорме("ГруппаВФорме");
	ТипГруппы 		= Тип("ГруппаФормы");
	РодительГруппы 	= Элементы.ОсновнаяГруппа;
	
	Группа 						= Элементы.Добавить(ИмяГруппы, ТипГруппы, РодительГруппы);
	Группа.Вид					= ВидГруппыФормы.ОбычнаяГруппа;
	Группа.Отображение			= ОтображениеОбычнойГруппы.Нет;
	Группа.ОтображатьЗаголовок  = Ложь;
	Группа.РастягиватьПоГоризонтали = Истина;
	
	Возврат Группа; 
КонецФункции

// Формирует на форме гиперссылку с поясняющим текстом.
//
// Параметры:
//	СтруктураВопроса - структура передаваемого вопроса.
//
&НаСервере
Процедура СоздатьГиперСсылкуНаФорме(СтруктураВопроса)
	Группа = СформироватьГруппуЭлементовФормы();
	
	Если СтруктураВопроса.ПоясняющийТекст <> Неопределено Тогда
		Если Не ПустаяСтрока(СтруктураВопроса.ПоясняющийТекст) Тогда 
			ИмяНадписи 		= ОпределитьИмяНадписиВФорме("НадписьВопроса");
			ТипНадписи		= Тип("ДекорацияФормы");
			РодительНадписи	= Группа;
			
			ЭлементПоясняющегоТекста = Элементы.Добавить(ИмяНадписи, ТипНадписи, РодительНадписи);
			ЭлементПоясняющегоТекста.Заголовок = СтруктураВопроса.ПоясняющийТекст;
		КонецЕсли;
	КонецЕсли;
	
	Если СтруктураВопроса.ТекстГиперСсылки <> Неопределено Тогда
		Если Не ПустаяСтрока(СтруктураВопроса.ТекстГиперСсылки) Тогда
			ИмяГиперСсылки		= ОпределитьИмяНадписиВФорме("НадписьВопроса");
			ТипГиперСсылки		= Тип("ДекорацияФормы");
			РодительГиперСсылки	= Группа;

			ЭлементГиперСсылки = Элементы.Добавить(ИмяГиперСсылки, ТипГиперСсылки, РодительГиперСсылки);
			ЭлементГиперСсылки.Гиперссылка 	= Истина;
			ЭлементГиперСсылки.Заголовок 	= СтруктураВопроса.ТекстГиперСсылки;
			ЭлементГиперСсылки.УстановитьДействие("Нажатие", "НажатиеНаГиперСсылку");
			
			ФормаГиперСсылки 	= Неопределено;
			ДействиеГиперСсылки = Неопределено;
			Если СтруктураВопроса.ДействиеПриНажатииГиперссылки <> Неопределено Тогда
				СтруктураОбработки = СтруктураВопроса.ДействиеПриНажатииГиперссылки;
				Если СтруктураОбработки.Свойство("Форма", ФормаГиперСсылки) Тогда 
					СтруктураМассива = Новый Структура;
					СтруктураМассива.Вставить("Имя", 	ИмяГиперСсылки);
					СтруктураМассива.Вставить("Форма", 	ФормаГиперСсылки);
					
					ПараметрыФормы = Неопределено;
					Если СтруктураОбработки.Свойство("ПараметрыФормы", ПараметрыФормы) Тогда
						Если ТипЗнч(ПараметрыФормы) = Тип("Структура") Тогда 
							ПараметрыФормы.Вставить("ЗавершениеРаботыПрограммы", Истина);
						ИначеЕсли ПараметрыФормы = Неопределено Тогда 
							ПараметрыФормы = Новый Структура;
							ПараметрыФормы.Вставить("ЗавершениеРаботыПрограммы", Истина);
						КонецЕсли;
						СтруктураМассива.Вставить("ПараметрыФормы", ПараметрыФормы);
					КонецЕсли;
					
					МассивСоотношенияЭлементовИПараметров.Добавить(СтруктураМассива);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

// Формирует на форме флажок с поясняющим текстом.
//
// Параметры:
//	СтруктураВопроса - структура передаваемого вопроса.
//
&НаСервере
Процедура СоздатьФлажокНаФорме(СтруктураВопроса)
	ЗначениеПоУмолчанию = Истина;
	Группа 				= СформироватьГруппуЭлементовФормы();
	
	Если СтруктураВопроса.ПоясняющийТекст <> Неопределено Тогда
		Если Не ПустаяСтрока(СтруктураВопроса.ПоясняющийТекст) Тогда
			ИмяНадписи 		= ОпределитьИмяНадписиВФорме("НадписьВопроса");
			ТипНадписи		= Тип("ДекорацияФормы");
			РодительНадписи	= Группа;
			
			ЭлементПоясняющегоТекста = Элементы.Добавить(ИмяНадписи, ТипНадписи, РодительНадписи);
			ЭлементПоясняющегоТекста.Заголовок = СтруктураВопроса.ПоясняющийТекст;
		КонецЕсли;
	КонецЕсли;
	
	Если СтруктураВопроса.ТекстФлажка <> Неопределено Тогда
		Если Не ПустаяСтрока(СтруктураВопроса.ТекстФлажка) Тогда 
			// Добавление реквизита в форму.
			ИмяФлажка 		= ОпределитьИмяНадписиВФорме("НадписьВопроса");
			ТипФлажка		= Тип("ПолеФормы");
			РодительФлажка	= Группа;
			
			МассивТипов = Новый Массив;
			МассивТипов.Добавить(Тип("Булево"));
			Описание = Новый ОписаниеТипов(МассивТипов);
			
			ДобавляемыеРеквизиты = Новый Массив;
			НовыйРеквизит 	= Новый РеквизитФормы(ИмяФлажка, Описание, , ИмяФлажка, Ложь);
			ДобавляемыеРеквизиты.Добавить(НовыйРеквизит);
			ИзменитьРеквизиты(ДобавляемыеРеквизиты);
			ЭтаФорма[ИмяФлажка] = ЗначениеПоУмолчанию;
			
			НовоеПолеФормы 						= Элементы.Добавить(ИмяФлажка, ТипФлажка, РодительФлажка);
			НовоеПолеФормы.ПутьКДанным			= ИмяФлажка;
			НовоеПолеФормы.Заголовок   			= СтруктураВопроса.ТекстФлажка;
			НовоеПолеФормы.Вид					= ВидПоляФормы.ПолеФлажка;
			НовоеПолеФормы.ПоложениеЗаголовка	= ПоложениеЗаголовкаЭлементаФормы.Право;
			
			// Инициализация элемента в массиве.
			ФормаЭлемента 		= Неопределено;
			СтруктураДействия 	= Неопределено;
			Если СтруктураВопроса.ДействиеПриУстановленномФлажке <> Неопределено Тогда
				СтруктураДействия = СтруктураВопроса.ДействиеПриУстановленномФлажке;
				Если СтруктураДействия.Свойство("Форма", ФормаЭлемента) Тогда
					НовоеПолеФормы.УстановитьДействие("ПриИзменении", "ИзменитьМассивБудущихЗадач");
					
					СтруктураМассива = Новый Структура;
					СтруктураМассива.Вставить("Имя", 			ИмяФлажка);
					СтруктураМассива.Вставить("Форма", 			ФормаЭлемента);
					СтруктураМассива.Вставить("Использование", 	ЗначениеПоУмолчанию);
					
					ПараметрыФормы = Неопределено;
					Если СтруктураДействия.Свойство("ПараметрыФормы", ПараметрыФормы) Тогда
						СтруктураМассива.Вставить("ПараметрыФормы", ПараметрыФормы);
					КонецЕсли;
					
					МассивЗадачНаВыполнениеПослеЗакрытия.Добавить(СтруктураМассива);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры	

&НаСервере
Процедура СоздатьОкончательныйВопрос()
	Группа 				= СформироватьГруппуЭлементовФормы();
	ОкончательныйВопрос = НСтр("ru = 'Завершить работу с программой?'");
	
	ИмяНадписи 		= ОпределитьИмяНадписиВФорме("НадписьВопроса");
	ТипНадписи		= Тип("ДекорацияФормы");
	РодительНадписи	= Группа;
	
	ЭлементПоясняющегоТекста = Элементы.Добавить(ИмяНадписи, ТипНадписи, РодительНадписи);
	ЭлементПоясняющегоТекста.Заголовок = ОкончательныйВопрос;
	ЭлементПоясняющегоТекста.Высота = 2;
	ЭлементПоясняющегоТекста.ВертикальноеПоложение = ВертикальноеПоложениеЭлемента.Низ;
КонецПроцедуры	

// Формирует имя надписи в форме по заголовку.
// 
// Параметры:
//	ЗаголовокЭлемента - заголовок.
//
&НаСервере
Функция ОпределитьИмяНадписиВФорме(ЗаголовокЭлемента)
	Индекс = 0;
	ФлагПоиска = Истина;
	
	Пока ФлагПоиска Цикл 
		ИндексСтрока = Строка(Формат(Индекс, "ЧН=-"));
		ИндексСтрока = СтрЗаменить(ИндексСтрока, "-", "");
		Имя = ЗаголовокЭлемента + ИндексСтрока;
		
		НайденныйЭлемент = Элементы.Найти(Имя);
		Если НайденныйЭлемент = Неопределено Тогда 
			Возврат Имя;
		КонецЕсли;
		
		Индекс = Индекс + 1;
	КонецЦикла;
КонецФункции	

&НаКлиенте
Функция ИдентификаторМассиваЗадачПоИмени(ИмяЭлемента)
	Для каждого ЭлементМассива из МассивЗадачНаВыполнениеПослеЗакрытия цикл
		Наименование = "";
		Если ЭлементМассива.Значение.Свойство("Имя", Наименование) Тогда 
			Если Не ПустаяСтрока(Наименование) и Наименование = ИмяЭлемента тогда
				Возврат ЭлементМассива.ПолучитьИдентификатор();
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Неопределено;
КонецФункции

// Выполняет необходимые задачи.
//
&НаКлиенте
Процедура ВыполнениеЗадачПриЗакрытии()
	
	Для каждого ЭлементМассива из МассивЗадачНаВыполнениеПослеЗакрытия цикл
		
		Использование = Неопределено;
		Если Не ЭлементМассива.Значение.Свойство("Использование", Использование) Тогда 
			Продолжить;
		КонецЕсли;
		Если ТипЗнч(Использование) <> Тип("Булево") Тогда 
			Продолжить;
		КонецЕсли;
		Если Использование <> Истина Тогда 
			Продолжить;
		КонецЕсли;
		
		Форма = Неопределено;
		Если ЭлементМассива.Значение.Свойство("Форма", Форма) Тогда 
			ПараметрыФормы = Неопределено;
			Если ЭлементМассива.Значение.Свойство("ПараметрыФормы", ПараметрыФормы) Тогда 
				ОткрытьФормуМодально(Форма, СтруктураИзФиксированнойСтруктуры(ПараметрыФормы));
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры	

&НаКлиенте
Функция СтруктураИзФиксированнойСтруктуры(Источник)
	
	Результат = Новый Структура;
	
	Для Каждого Элемент Из Источник Цикл
		Результат.Вставить(Элемент.Ключ, Элемент.Значение);
	КонецЦикла;
	
	Возврат Результат;
КонецФункции


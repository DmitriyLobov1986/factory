////////////////////////////////////////////////////////////////////////////////
// Подсистема "Оценка производительности".
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Метод завершающий замер времени на клиенте
//
Процедура ЗакончитьЗамерВремениАвтоНеГлобальный() Экспорт
	
	ЗакончитьЗамерВремени();
		
КонецПроцедуры

// Произвести запись накопленных замеров времени выполнения ключевых операций на сервере
//
// Параметры:
//  ПередЗавершением - Булево - Истина, если метод вызывается перед закрытием приложения
//
Процедура ЗаписатьРезультатыАвтоНеГлобальный(ПередЗавершением = Ложь) Экспорт
	Если НЕ ОценкаПроизводительностиЗамерВремени = Неопределено Тогда
		
		Если ОценкаПроизводительностиЗамерВремени["Замеры"].Количество() = 0 Тогда 
			
			НовыйПериодЗаписи = ОценкаПроизводительностиЗамерВремени["ПериодЗаписи"];
		Иначе		
			Замеры = ОценкаПроизводительностиЗамерВремени["Замеры"];
			НовыйПериодЗаписи = ОценкаПроизводительностиВызовСервераПолныеПрава.ЗафиксироватьДлительностьКлючевыхОпераций(Замеры);		 
			ОценкаПроизводительностиЗамерВремени["ПериодЗаписи"] = НовыйПериодЗаписи;
			Если ПередЗавершением Тогда 
				Возврат;
			КонецЕсли;
						
			Для Каждого КлючеваяОперацияДатаДанные Из Замеры Цикл
				Буфер = КлючеваяОперацияДатаДанные.Значение;
				НаУдаление = Новый Массив;
				Для Каждого ДатаДанные Из Буфер Цикл
					Дата = ДатаДанные.Ключ;
					Данные = ДатаДанные.Значение;
					Длительность = Данные.Получить("Длительность");
					// Это означает, что операция уже закончилась, удалять ее из буфера нужно.
					Если Длительность <> Неопределено Тогда
						НаУдаление.Добавить(Дата); 
					КонецЕсли;
				КонецЦикла;
				Для Каждого Дата Из НаУдаление Цикл
					ОценкаПроизводительностиЗамерВремени["Замеры"][КлючеваяОперацияДатаДанные.Ключ].Удалить(Дата);
				КонецЦикла;	
			КонецЦикла;			
		КонецЕсли;
		ПодключитьОбработчикОжидания("ЗаписатьРезультатыАвто", НовыйПериодЗаписи, Истина);

	КонецЕсли;
	
КонецПроцедуры	

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Процедура завершает замер времени на клиенте
// Параметры:
//  АвтоЗамер - Булево, закончен ли замер по обработчику 
//  ожидания или же нет.
Процедура ЗакончитьЗамерВремени(АвтоЗамер = Истина)
							  	
	ВремяОкончания = ОценкаПроизводительностиКлиентСервер.ЗначениеТаймера();
		
	Если АвтоЗамер И ТипЗнч(ВремяОкончания) = Тип("Число") Тогда
		ВремяОкончания = ВремяОкончания - 0.100;					
	КонецЕсли;	
    ДатаОкончания = ОценкаПроизводительностиКлиентСервер.ЗначениеТаймера(Ложь);	
	Замеры = ОценкаПроизводительностиЗамерВремени["Замеры"];
	Для Каждого КлючеваяОперацияБуферы Из Замеры Цикл
		Для Каждого ДатаДанные Из КлючеваяОперацияБуферы.Значение Цикл
			Буфер = ДатаДанные.Значение;
			ВремяНачала = Буфер["ВремяНачала"];
			Длительность = Буфер.Получить("Длительность");
			Если Длительность = Неопределено Тогда
        		Буфер.Вставить("Длительность", ВремяОкончания - ВремяНачала);
				Буфер.Вставить("ВремяОкончания", ВремяОкончания);
				Буфер.Вставить("ДатаОкончания", ДатаОкончания);
			КонецЕсли;
		КонецЦикла;	
	КонецЦикла;	
	
КонецПроцедуры	

// Выполняет работу с ДиалогРаботыСФайлами с учетом веб-клиента.
//
// Параметры:
//  РежимДиалога - РежимДиалогаВыбораФайла, режим, в котором следует открыть диалог
//  РезультатВыбора - 
//  	Строка, результат выбора
//  	Неопределено, пользователь не выбрал каталог, но и не отказался от выполнения действий
//  МестоХранения - Строка, если действие выполняется в веб-клиенте необходим для запроса разрешения на действие
//  Расширение - Строка, расширение сохраняемого/загружаемого файла 
//
// Возвращаемое значение:
//  Булево - 
//  	Истина, диалог был вызван и пользователь выполнил необходимые действия
//  	Ложь, пользователь отказался от выполнения каких-либо действий
//
Функция ВызватьДиалогРаботыСФайлами(Знач РежимДиалога, РезультатВыбора, Знач МестоХранения = "", Знач Расширение = "") Экспорт
	
	РасширениеПодключено = Ложь;
	Результат = ОбработатьРасширениеРаботыСФайлами(РасширениеПодключено);
	
	Если РасширениеПодключено Тогда
		
		ДиалогВыбора = Новый ДиалогВыбораФайла(РежимДиалога);
		Если Не ПустаяСтрока(Расширение) Тогда
			ДиалогВыбора.Фильтр = "*." + Расширение + "| *." + Расширение;
			ДиалогВыбора.Расширение = Расширение;
		КонецЕсли;
		
		Если ДиалогВыбора.Выбрать() Тогда
			Если РежимДиалога = РежимДиалогаВыбораФайла.ВыборКаталога Тогда
				РезультатВыбора = ДиалогВыбора.Каталог;
			Иначе
				РезультатВыбора = ДиалогВыбора.ПолноеИмяФайла;
			КонецЕсли;
		Иначе
			Результат = Ложь;
		КонецЕсли;
		
	Иначе
		РезультатВыбора = Неопределено;
	КонецЕсли;
	
	#Если ВебКлиент Тогда
		Если РасширениеПодключено И Результат Тогда
			Если РежимДиалога = РежимДиалогаВыбораФайла.Сохранение Тогда
				Результат = ЗапроситьРазрешениеНаПолучениеФайла(МестоХранения, РезультатВыбора);
			ИначеЕсли РежимДиалога = РежимДиалогаВыбораФайла.Открытие Тогда
				
			КонецЕсли;
		КонецЕсли;
	#КонецЕсли
	
	Возврат Результат;
	
КонецФункции

// Выполняет попытку подключения расширения работы с файлами
//
// Параметры:
//  РасширениеПодключено - Булево:
//  	Истина, расширение подключено
//  	Ложь, расширение не подключено
//
// Возвращаемое значение:
//  Булево - 
//  	Истина, расширение было или не было подключено, пользователь не отказался от выполнения операции
//  	Ложь, пользователь отказался от выполнения операции
//
Функция ОбработатьРасширениеРаботыСФайлами(РасширениеПодключено)
	
	РасширениеПодключено = ПодключитьРасширениеРаботыСФайлами();
	Результат = РасширениеПодключено;
	
	Если Не РасширениеПодключено Тогда
		
		КодВозврата = Вопрос(НСтр("ru = 'Расширение работы с файлами не установлено, установить?
			|""Да"" - Выполнить попытку установки расширения
			|""Нет"" - Экспорт будет выполнен стандартными средствами браузера
			|""Отмена"" - Отменить экспорт'"), РежимДиалогаВопрос.ДаНетОтмена);
							
		Если КодВозврата = КодВозвратаДиалога.Да Тогда
			
			УстановитьРасширениеРаботыСФайлами();
			Если Не ПодключитьРасширениеРаботыСФайлами() Тогда
				
				КодВозврата = Вопрос(НСтр("ru = 'Выполнить стандартными средствами браузера?'"), РежимДиалогаВопрос.ДаНет);
				Если КодВозврата = КодВозвратаДиалога.Да Тогда
					РасширениеПодключено = Ложь;
					Результат = Истина;
				ИначеЕсли КодВозврата = КодВозвратаДиалога.Нет Тогда
					РасширениеПодключено = Ложь;
					Результат = Ложь;
				КонецЕсли;
				
			Иначе
				РасширениеПодключено = Истина;
				Результат = Истина;
			КонецЕсли;
			
		ИначеЕсли КодВозврата = КодВозвратаДиалога.Нет Тогда
			РасширениеПодключено = Ложь;
			Результат = Истина;
		ИначеЕсли КодВозврата = КодВозвратаДиалога.Отмена Тогда
			РасширениеПодключено = Ложь;
			Результат = Ложь;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Запрашивает разрешение у пользователя на получение файла
//
// Параметры:
//  Хранение - Строка, содержит положение файла на сервере
//  Имя - Строка, содержит положение файла на клиенте
//
// Возвращаемое значение:
//  Булево - 
//  	Истина, разрешение получено
//  	Ложь, разрешение не получено
//
Функция ЗапроситьРазрешениеНаПолучениеФайла(Хранение, Имя)
	
	ОписаниеПередаваемогоФайла = Новый ОписаниеПередаваемогоФайла;
	ОписаниеПередаваемогоФайла.Хранение = Хранение;
	ОписаниеПередаваемогоФайла.Имя = Имя;
	
	МассивФайлов = Новый Массив;
	МассивФайлов.Добавить(ОписаниеПередаваемогоФайла);
	
	ОписаниеВызова = Новый Массив;
	ОписаниеВызова.Добавить("ПолучитьФайлы");
	ОписаниеВызова.Добавить(МассивФайлов);
	ОписаниеВызова.Добавить("");
	ОписаниеВызова.Добавить("");
	ОписаниеВызова.Добавить(Ложь);
	
	Вызовы = Новый Массив;
	Вызовы.Добавить(ОписаниеВызова);
	
	
	Возврат ЗапроситьРазрешениеПользователя(Вызовы);
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий подсистем БСП

// Вызывается перед интерактивным завершением работы пользователя с областью данных.
// Соответствует событию ПередЗавершениемРаботыСистемы модулей приложения.
//
// Параметры:
//  Отказ - Булево - отказ в от начала работы. Если параметр установить
//          Истина, тогда начало работы с областью данных будет прервано.
//
Процедура ПередЗавершениемРаботыСистемы(Отказ) Экспорт
	
	ЗаписатьРезультатыАвтоНеГлобальный(Истина);
	
КонецПроцедуры

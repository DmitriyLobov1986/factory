//ирПортативный Перем ирПортативный Экспорт;
//ирПортативный Перем ирОбщий Экспорт;
//ирПортативный Перем ирСервер Экспорт;
//ирПортативный Перем ирКэш Экспорт;
//ирПортативный Перем ирПривилегированный Экспорт;

#Если Клиент Тогда

// Открывает объект в исследователе объектов.
//
// Параметры:
//  Объект       – Произвольный.
//
// Возвращаемое значение:
//  Не используется.
//
Функция ИсследоватьОбъект(Объект, Модально = Истина) Экспорт 
	
	ФормаИсследователя = ирОбщий.ПолучитьФормуЛкс(Метаданные().ПолноеИмя() + ".Форма.ИсследовательОбъектов", , , Объект);
	ФормаИсследователя.УстановитьИсследуемоеЗначение(Объект);
	Если Модально Тогда 
		Результат = ФормаИсследователя.ОткрытьМодально();
	Иначе
		Результат = Неопределено;
		ФормаИсследователя.Открыть();
	КонецЕсли;
	Возврат Результат;

КонецФункции // ИсследоватьОбъект()

// Открывает объект в исследователе объектов.
//
// Параметры:
//  Объект       – Произвольный.
//
// Возвращаемое значение:
//  Не используется.
//
Функция ИсследоватьКоллекцию(Коллекция, Модально = Истина, БезСлужебныхКолонок = Истина) Экспорт 
	
	ФормаИсследователя = ирОбщий.ПолучитьФормуЛкс(Метаданные().ПолноеИмя() + ".Форма.ИсследовательКоллекций", , , Коллекция);
	ФормаИсследователя.УстановитьИсследуемоеЗначение(Коллекция, , , БезСлужебныхКолонок);
	Если Модально Тогда 
		Результат = ФормаИсследователя.ОткрытьМодально();
	Иначе
		Результат = Неопределено;
		ФормаИсследователя.Открыть();
	КонецЕсли;
	Возврат Результат;

КонецФункции // ИсследоватьКоллекцию()

//ирПортативный лФайл = Новый Файл(ИспользуемоеИмяФайла);
//ирПортативный ПолноеИмяФайлаБазовогоМодуля = Лев(лФайл.Путь, СтрДлина(лФайл.Путь) - СтрДлина("Модули\")) + "ирПортативный.epf";
//ирПортативный #Если Клиент Тогда
//ирПортативный 	Контейнер = Новый Структура();
//ирПортативный 	Оповестить("ирПолучитьБазовуюФорму", Контейнер);
//ирПортативный 	Если Не Контейнер.Свойство("ирПортативный", ирПортативный) Тогда
//ирПортативный 		ирПортативный = ВнешниеОбработки.ПолучитьФорму(ПолноеИмяФайлаБазовогоМодуля);
//ирПортативный 		ирПортативный.Открыть();
//ирПортативный 	КонецЕсли; 
//ирПортативный #Иначе
//ирПортативный 	ирПортативный = ВнешниеОбработки.Создать(ПолноеИмяФайлаБазовогоМодуля, Ложь); // Это будет второй экземпляр объекта
//ирПортативный #КонецЕсли
//ирПортативный ирОбщий = ирПортативный.ПолучитьОбщийМодульЛкс("ирОбщий");
//ирПортативный ирКэш = ирПортативный.ПолучитьОбщийМодульЛкс("ирКэш");
//ирПортативный ирСервер = ирПортативный.ПолучитьОбщийМодульЛкс("ирСервер");
//ирПортативный ирПривилегированный = ирПортативный.ПолучитьОбщийМодульЛкс("ирПривилегированный");

ирКэш.Получить().ИнициализацияОписанияМетодовИСвойств();

#КонецЕсли

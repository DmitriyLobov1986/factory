&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
    Список.Параметры.УстановитьЗначениеПараметра("СтартоваяДата", Дата("19700101030000"));
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СписокПриПолученииДанныхНаСервере(ИмяЭлемента, Настройки, Строки)

    ТаблицаДС = ПолучитьТЗДинамическогоСписка(Строки);
    УстановитьДатуИВремя(Строки);
    ОпределитьПользователя(ТаблицаДС, Строки);

КонецПроцедуры






//////////////////////////////////////ДОПОЛНИТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ//////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
&НаСервереБезКонтекста
Функция ПолучитьТЗДинамическогоСписка(Строки)

    ТЗ = Новый ТаблицаЗначений;
    ТЗ.Колонки.Добавить("ИндексСтроки", Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(15, 2, ДопустимыйЗнак.Любой)));
    ТЗ.Колонки.Добавить("Ключ");
    ТЗ.Колонки.Добавить("Id_стр", Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(50, ДопустимаяДлина.Переменная)));
    ТЗ.Колонки.Добавить("Id", Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(15, 0, ДопустимыйЗнак.Любой)));
    ИндексСтроки = 0;
    Для Каждого Строка Из Строки Цикл
        НоваяЗапись = ТЗ.Добавить();
        НоваяЗапись.ИндексСтроки = ИндексСтроки;
        НоваяЗапись.Ключ = Строка.Ключ;
        НоваяЗапись.Id_стр = Формат(Строка.Значение.Данные.chat_id, "ЧГ=");
        НоваяЗапись.Id = Строка.Значение.Данные.chat_id;
		//
        ИндексСтроки = ИндексСтроки + 1;
		//
    КонецЦикла;
    Возврат ТЗ;
КонецФункции

&НаСервереБезКонтекста
Процедура ОпределитьПользователя(ТаблицаДС, СтрокиДС)
          
  //Получим коды чатов Битрикс
    НастройкиTelegram = ХранилищеНастроекДанныхФорм.Загрузить("Telegram", , , "ЛобовДМ");
    Если НастройкиTelegram.Свойство("КодыЧатовБитрикс") Тогда
        КодыЧатовБитрикс = НастройкиTelegram.КодыЧатовБитрикс;
    Иначе
        КодыЧатовБитрикс = Новый ТаблицаЗначений;
        КодыЧатовБитрикс.Колонки.Добавить("Объект", Новый ОписаниеТипов("ПеречислениеСсылка.ТипОрганизации, СправочникСсылка.Организации"));
        КодыЧатовБитрикс.Колонки.Добавить("КодЧатаБитрикс", Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(15, 0,
            ДопустимыйЗнак.Любой)));
    КонецЕсли;
    Запрос = Новый Запрос;
    Запрос.Текст = "ВЫБРАТЬ
                   | ТаблицаДС.ИндексСтроки КАК ИндексСтроки,
                   | ТаблицаДС.Id_стр КАК Id_стр,
                   | ТаблицаДС.Id КАК Id
                   |ПОМЕСТИТЬ ТаблицаДС
                   |ИЗ
                   | &ТаблицаДС КАК ТаблицаДС
                   |
                   |ИНДЕКСИРОВАТЬ ПО
                   | Id_стр,
                   | Id
                   |;
                   |
                   |////////////////////////////////////////////////////////////////////////////////
                   |ВЫБРАТЬ
                   | КодыЧатовБитрикс.Объект КАК Объект,
                   | КодыЧатовБитрикс.КодЧатаБитрикс КАК КодЧатаБитрикс
                   |ПОМЕСТИТЬ ВТ_КодыЧатовБитрикс
                   |ИЗ
                   | &КодыЧатовБитрикс КАК КодыЧатовБитрикс
                   |
                   |ИНДЕКСИРОВАТЬ ПО
                   | КодЧатаБитрикс
                   |;
                   |
                   |////////////////////////////////////////////////////////////////////////////////
                   |ВЫБРАТЬ
                   | ТаблицаДС.ИндексСтроки КАК ИндексСтроки,
                   | ПРЕДСТАВЛЕНИЕ(ЕСТЬNULL(ПользователиКонтактнаяИнформация.Ссылка, ВТ_КодыЧатовБитрикс.Объект)) КАК Пользователь
                   |ИЗ
                   | ТаблицаДС КАК ТаблицаДС
                   |     ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Пользователи.КонтактнаяИнформация КАК ПользователиКонтактнаяИнформация
                   |     ПО (ПользователиКонтактнаяИнформация.Вид.Наименование = ""TelegramID"")
                   |         И ТаблицаДС.Id_стр = ПользователиКонтактнаяИнформация.Представление
                   |     ЛЕВОЕ СОЕДИНЕНИЕ ВТ_КодыЧатовБитрикс КАК ВТ_КодыЧатовБитрикс
                   |     ПО ТаблицаДС.Id = ВТ_КодыЧатовБитрикс.КодЧатаБитрикс
                   |ГДЕ
                   | (НЕ ВТ_КодыЧатовБитрикс.Объект ЕСТЬ NULL
                   |         ИЛИ НЕ ПользователиКонтактнаяИнформация.Ссылка ЕСТЬ NULL)";

    Запрос.УстановитьПараметр("ТаблицаДС", ТаблицаДС);
    Запрос.УстановитьПараметр("КодыЧатовБитрикс", КодыЧатовБитрикс);

    Выборка = Запрос.Выполнить().Выбрать();
    Пока Выборка.Следующий() Цикл
        СтрокиДС[ТаблицаДС[Выборка.ИндексСтроки].Ключ].Данные["Пользователь"] = Выборка.Пользователь;
    КонецЦикла;

КонецПроцедуры

&НаСервереБезКонтекста
Процедура УстановитьДатуИВремя(СтрокиДС)

    Для Каждого Строка Из СтрокиДС Цикл
        ДанныеСтроки = Строка.Значение.Данные;
        ДанныеСтроки.Время = ДанныеСтроки.Время + ДанныеСтроки.date;
    КонецЦикла;
    
КонецПроцедуры



//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////

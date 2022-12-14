
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
    УстановитьВидимостьЭлементов();    
КонецПроцедуры



#КонецОбласти 

#Область ВспомогательныеПроцедуры

&НаСервере
Процедура УстановитьВидимостьЭлементов()
    
    Http = Запись.ТипСоединения = Перечисления.ТипСоединения.Http;
    Заголовок1 = ?(Http, "Путь до сервиса", "Строка подключения");
    Заголовок2 = ?(Http, "Http сервер", "Сервер COM Объекта");
    
    Элементы.СтрокаПодключения.Заголовок = Заголовок1;
    Элементы.СерверCOMОбъекта.Заголовок = Заголовок2;
    Элементы.ТипПлатформы1С.Видимость = НЕ Http;
    
КонецПроцедуры

&НаКлиенте
Процедура ТипСоединенияПриИзменении(Элемент)
    УстановитьВидимостьЭлементов();
КонецПроцедуры


#КонецОбласти



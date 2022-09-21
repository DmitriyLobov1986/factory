//Возвращает структуру записи регистра сведений
Функция ПолучитьСтруктуруЗаписи() Экспорт
    
    СтруктураЗаписи = Новый Структура;
    ИзмеренияДДС = Метаданные.РегистрыСведений.ДДС.Измерения;
    РеквизитыДДС = Метаданные.РегистрыСведений.ДДС.Реквизиты;
    РесурсыДДС = Метаданные.РегистрыСведений.ДДС.Ресурсы;
    СтандартныеРеквизитыДДС = Метаданные.РегистрыСведений.ДДС.СтандартныеРеквизиты;
    
    Для Каждого Измерение из ИзмеренияДДС Цикл 
        СтруктураЗаписи.Вставить(Измерение.Имя);
    КонецЦикла;	
    
    Для Каждого Реквизит из РеквизитыДДС Цикл 
        СтруктураЗаписи.Вставить(Реквизит.Имя);                                                   
    КонецЦикла;	
    
    Для Каждого Ресурс из РесурсыДДС Цикл 
        СтруктураЗаписи.Вставить(Ресурс.Имя);
    КонецЦикла;	
    
    Для Каждого СтандартныйРеквизит из СтандартныеРеквизитыДДС Цикл 
        СтруктураЗаписи.Вставить(СтандартныйРеквизит.Имя);
    КонецЦикла;	        
    
    Возврат СтруктураЗаписи;    
    
КонецФункции   



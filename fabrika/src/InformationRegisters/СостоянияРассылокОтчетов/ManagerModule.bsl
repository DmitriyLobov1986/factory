#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Для внутреннего использования.
Процедура ЗафиксироватьЗапускРассылки(Рассылка) Экспорт
	УстановитьПривилегированныйРежим(Истина);
	
	МенеджерЗаписи = СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Рассылка = Рассылка;
	МенеджерЗаписи.ПоследнийЗапуск = ТекущаяДатаСеанса();
	МенеджерЗаписи.Выполнена = Ложь;
	МенеджерЗаписи.СОшибками = Истина;
	МенеджерЗаписи.Записать(Истина);
КонецПроцедуры

// Для внутреннего использования.
Процедура ЗафиксироватьРезультатВыполненияРассылки(Рассылка, РезультатВыполнения) Экспорт
	УстановитьПривилегированныйРежим(Истина);
	
	МенеджерЗаписи = СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Рассылка = Рассылка;
	МенеджерЗаписи.Прочитать();
	
	МенеджерЗаписи.Выполнена = (
		РезультатВыполнения.ВыполненаВПапку
		Или РезультатВыполнения.ВыполненаВСетевойКаталог
		Или РезультатВыполнения.ВыполненаНаFTP
		Или РезультатВыполнения.ВыполненаПоЭлектроннойПочте);
	
	МенеджерЗаписи.СОшибками = РезультатВыполнения.БылиОшибки Или РезультатВыполнения.БылиПредупреждения;
	
	МенеджерЗаписи.Записать(Истина);
КонецПроцедуры


#КонецЕсли

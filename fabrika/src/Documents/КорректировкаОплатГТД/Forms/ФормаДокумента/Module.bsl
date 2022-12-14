
&НаКлиенте
Процедура ГТДНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыВыбора = Новый Структура;
	ПараметрыВыбора.Вставить("Владелец", "КорректировкаОплатГТД");
	ПараметрыВыбора.Вставить("Документ", Объект.Ссылка);
	ПараметрыВыбора.Вставить("ДатаСреза", КонецДня(Объект.Дата));
	ПараметрыВыбора.Вставить("ДатаДокумента" , Объект.Дата);
			
	ОткрытьФорму("Документ.ТаможняРассчёты.Форма.ФормаВыбораГТД", ПараметрыВыбора, ЭтаФорма, , , , ,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры


//=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Организация = Объект.ГТД.Организация;
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Объект.ГТД = ВыбранноеЗначение.ГТД;
	Объект.ПодИнвойсНомер = ВыбранноеЗначение.ПодинвойсНомер;
	Объект.Остаток = ВыбранноеЗначение.Доступно;
	Организация = ВыбранноеЗначение.ГТД.Организация;	
	
КонецПроцедуры
//=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>=>



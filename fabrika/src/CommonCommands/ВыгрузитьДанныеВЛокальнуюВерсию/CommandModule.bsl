
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ 

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ОткрытьФормуМодально("ОбщаяФорма.ВыгрузкаДанных", , ПараметрыВыполненияКоманды.Источник);
	
КонецПроцедуры

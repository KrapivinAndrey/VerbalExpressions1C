﻿Перем КонтекстЯдра;
Перем Ожидаем;
Перем Утверждения;
Перем СтроковыеУтилиты;

Перем ПроверяемаяОбработка;

Функция ПолучитьПутьКФайлуОтносительноКаталогаFeatures(ИмяФайлаСРасширением)
	ПутьКТекущемуFeatureФайлу=ИспользуемоеИмяФайла;
	ПутьКФайлу = Лев(ПутьКТекущемуFeatureФайлу, Найти(ПутьКТекущемуFeatureФайлу, "features") - 1) + ИмяФайлаСРасширением;
	
	Возврат ПутьКФайлу;
КонецФункции

// { интерфейс тестирования

Процедура Инициализация(КонтекстЯдраПараметр) Экспорт
	КонтекстЯдра		= КонтекстЯдраПараметр;
	Утверждения			= КонтекстЯдра.Плагин("БазовыеУтверждения");
	Ожидаем				= КонтекстЯдра.Плагин("УтвержденияBDD");
	СтроковыеУтилиты	= КонтекстЯдра.Плагин("СтроковыеУтилиты");
	
	ФайлОбработки		= ПолучитьПутьКФайлуОтносительноКаталогаFeatures("ВербальныеВыражения.epf");
	ПроверяемаяОбработка = ВнешниеОбработки.Создать(ФайлОбработки).ПолучитьФорму("ВербальныеВыражения82");
КонецПроцедуры

Процедура ЗаполнитьНаборТестов(НаборТестов) Экспорт
	
	НаборТестов.НачатьГруппу("Вспомогательные процедуры и функции", Ложь);	
	НаборТестов.Добавить("ТестДолжен_ПроверитьВхожениеПодстрокиВСтроку", НаборТестов.ПараметрыТеста("Привет, Мир!", "Привет", 1), "Проверка Привет, Мир!");
	НаборТестов.Добавить("ТестДолжен_ПроверитьВхожениеПодстрокиВСтроку", НаборТестов.ПараметрыТеста("Привет, Мир!", "ДавайДосвидения", 0), "Проверка отсутствия вхождений");
	НаборТестов.Добавить("ТестДолжен_ПроверитьВхожениеПодстрокиВСтроку", НаборТестов.ПараметрыТеста("ФильмФильмФильм", "Фильм", 3), "Проверка нескольких вхождений");
	НаборТестов.Добавить("ТестДолжен_ПроверитьВхожениеПодстрокиВСтроку", НаборТестов.ПараметрыТеста("Обороноспособность", "способ", 1), "Проверка частичного вхождения");
	
	НаборТестов.НачатьГруппу("Поиск в начале/конце строки", Ложь);
	НаборТестов.Добавить("ТестДолжен_ПроверитьПоискВНачалеСтроки", НаборТестов.ПараметрыТеста("Привет, Мир", "Привет", Истина), "Поиск в начале строки работает");
	НаборТестов.Добавить("ТестДолжен_ПроверитьПоискВНачалеСтроки", НаборТестов.ПараметрыТеста("Привет, Мир", "Мир", Ложь), "Поиск в начале строки не работает");
	НаборТестов.Добавить("ТестДолжен_ПроверитьПоискВКонцеСтроки", НаборТестов.ПараметрыТеста("Привет, Мир", "Мир", Истина), "Поиск в конце строки работает");
	НаборТестов.Добавить("ТестДолжен_ПроверитьПоискВКонцеСтроки", НаборТестов.ПараметрыТеста("Привет, Мир", "Привет", Ложь), "Поиск в конце строки не работает");
	
	НаборТестов.НачатьГруппу("Проверка разбора реальных примеров", Ложь);
	НаборТестов.Добавить("ТестДолжен_ПроверитьФорматEMail", НаборТестов.ПараметрыТеста("a.krapivin@kontur.ru", Истина), "Строка эта адрес е-мейл");	
	НаборТестов.Добавить("ТестДолжен_ПроверитьФорматEMail", НаборТестов.ПараметрыТеста("krapivin", Ложь), "Строка эта не адрес е-мейл");
КонецПроцедуры

// } интерфейс тестирования


// { блок юнит-тестов - сами тесты

// { Тесты функций парсинга текста и подстановки параметров

Процедура ТестДолжен_ПроверитьВхожениеПодстрокиВСтроку(ИсхСтрока, Подстрока, КонтрольноеЧисло) Экспорт
	Расчет = ПроверяемаяОбработка.ЧислоВхождений(ИсхСтрока, Подстрока);
	
	Ожидаем.Что(Расчет).Равно(КонтрольноеЧисло);
	
КонецПроцедуры

Процедура ТестДолжен_ПроверитьПоискВНачалеСтроки(ИсхСтрока, Подстрока, ПроходитПроверку) Экспорт 
	РВ = ПроверяемаяОбработка.regexp().ВНачалеСтроки().Найди(Подстрока);
	Ожидаем.Что(РВ.СоответствуетШаблону(Подстрока) = ПроходитПроверку);
КонецПроцедуры

Процедура ТестДолжен_ПроверитьПоискВКонцеСтроки(ИсхСтрока, Подстрока, ПроходитПроверку) Экспорт 
	РВ = ПроверяемаяОбработка.regexp().ВКонцеСтроки().Найди(Подстрока);
	Ожидаем.Что(РВ.СоответствуетШаблону(Подстрока) = ПроходитПроверку);
КонецПроцедуры

Процедура ТестДолжен_ПроверитьФорматEMail(ИсхСтрока, ПроходитПроверку) Экспорт
	РВ = ПроверяемаяОбработка.regexp().ЧтоНибудьКроме("@").Потом("@").ЧтоНибудьКроме("@").Затем("\.").ЧтоНибудьКроме("@\.");
	Ожидаем.Что(РВ.СоответствуетШаблону(ИсхСтрока) = ПроходитПроверку);
КонецПроцедуры
// } блок юнит-тестов - сами тесты
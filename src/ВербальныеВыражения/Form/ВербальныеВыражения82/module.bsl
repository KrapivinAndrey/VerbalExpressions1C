﻿Перем Префикс;
Перем ИсходныйТекст;
Перем Суффикс;

Перем ШаблонРВ;

Перем RegExp;
Перем RegExpДоступны;

Перем ИгнорироватьРегистр;
Перем МногострочныйПоиск;
Перем ДоПервогоСовпадения;

//ВСПОМОГАТЕЛЬНЫЕ ОБРАБОТКИ

// Рассчитывает сколько раз Подстрока встречается в ИсхСтроке
//
// Параметры
//  ИсхСтрока  - Строка - строка в которой ищем вхождения подстроки
//  Подстрока  - Строка - какие вхождения ищем
//
// Возвращаемое значение:
//   Число   - число вхождений
//
Функция ЧислоВхождений(ИсхСтрока, Подстрока) Экспорт
	ДлинаИсхСтрока	= СтрДлина(ИсхСтрока);
	ДлинаПодстрока	= СтрДлина(Подстрока);
	ДлинаСокрСтрока	= СтрДлина(СтрЗаменить(ИсхСтрока, Подстрока, ""));
	
	Возврат (ДлинаИсхСтрока - ДлинаСокрСтрока) / ДлинаПодстрока;
КонецФункции // ЧислоВхождений()

Функция НадоЭкранировать(ТекСимвол)
	Возврат ТекСимвол = "[" Или
			ТекСимвол = "]" Или
			ТекСимвол = "\" Или
			ТекСимвол = "/" Или
			ТекСимвол = "^" Или
			ТекСимвол = "$" Или
			ТекСимвол = "." Или
			ТекСимвол = "|" Или
			ТекСимвол = "?" Или
			ТекСимвол = "*" Или
			ТекСимвол = "+" Или
			ТекСимвол = "(" Или
			ТекСимвол = ")" Или
			ТекСимвол = "{" Или
			ТекСимвол = "}";
КонецФункции

Функция Экранировать(ТекСимвол)
	Если НадоЭкранировать(ТекСимвол) Тогда
		Возврат "\" + ТекСимвол;
	Иначе
		Возврат ТекСимвол;
	КонецЕсли;
КонецФункции

Функция АвтоматическоеЭкранирование(ВхСтрока)
	Рез = "";
	Для Сч = 1 По СтрДлина(ВхСтрока) Цикл
		ТекСимвол = Сред(ВхСтрока, Сч, 1);
		Рез = Рез + Экранировать(ТекСимвол);
	КонецЦикла;
	
	Возврат Рез
КонецФункции

//РАБОТА С СУФФИКСАМИ И ПРЕФИКСАМИ

// Устанавливает/снимает признак работы выражения в начале строки
//
// Параметры:
//  Флаг  - Булево - признак установить или снять признак поиска
//
// Возвращаемое значение:
//   Форма   - эта же форма
//
Функция ВНачалеСтроки(Флаг = Истина) Экспорт

	Если Флаг Тогда
		Префикс = Префикс + "^";
	Иначе
		Префикс = СтрЗаменить(Префикс, "^", "");
	КонецЕсли;
	
	Возврат ЭтаФорма;

КонецФункции // НачалоСтроки()

// Устанавливает/снимает признак работы выражения в конце строки
//
// Параметры:
//  Флаг  - Булево - признак установить или снять признак поиска
//
// Возвращаемое значение:
//   Форма   - эта же форма
//
Функция ВКонцеСтроки(Флаг = Истина) Экспорт

	Если Флаг Тогда
		Суффикс = Суффикс + "$";
	Иначе
		Суффикс = СтрЗаменить(Суффикс, "$", "");
	КонецЕсли;
	
	Возврат ЭтаФорма;

КонецФункции // ИскатьСКонца()


//ОСНОВНЫЕ ПРОЦЕДУРЫ ДОБАВЛЕНИЯ ДАННЫХ

// Добавляет очередной кусок регулярного выражения
//
// Параметры:
//  Параметр  - Строка, Форма - строка поиска или готовое вербальное выражение
//
// Возвращаемое значение:
//   Форма   - эта форма
//
Функция Добавить(Параметр) Экспорт 

	Если ТипЗнч(Параметр) = Тип("Строка") Тогда
		Возврат ДобавитьСтроку(Параметр);
	ИначеЕсли ТипЗнч(Параметр) = Тип("Форма") Тогда
		Возврат ДобавитьВербВыражение(Параметр);
	КонецЕсли;
	
	Возврат ЭтаФорма;

КонецФункции // Добавить()

// Добавляет очередной кусок регулярного выражения
//
// Параметры:
//  ВхСтрока  - Строка - строка поиска
//
// Возвращаемое значение:
//   Форма   - эта форма
//
Функция ДобавитьСтроку(ВхСтрока)
	ДобавляемаяСтрока = "";
	Если Прав(Суффикс, 1) = "?" Тогда
		ДобавляемаяСтрока = "?";
		Суффикс = Лев(Суффикс, СтрДлина(Суффикс) - 1);
	КонецЕсли;
	
	ИсходныйТекст = ИсходныйТекст + ВхСтрока + ДобавляемаяСтрока;
	
	Возврат ЭтаФорма;

КонецФункции // ДобавитьСтроку()

// Добавить уже подготовленное вербальное выражение
//
// Параметры:
//  ВербВыражение  - Форма - подготовленое вербальное выражение
//
// Возвращаемое значение:
//   Форма   - эта форма
//
Функция ДобавитьВербВыражение(ВербВыражение)

	Возврат ЭтаФорма.НачатьГруппу().Добавить(ВербВыражение.ПолучитьСтроку()).ЗакончитьГруппу();

КонецФункции // ДобавитьВербВыражение()

// Аналог Добавить для удобной записи
//
// Параметры:
//  ВхСтрока  - Строка - Строка поиска
//
// Возвращаемое значение:
//   Форма   - эта форма
//
Функция Затем(Параметр) Экспорт
	Если ТипЗнч(Параметр) = Тип("Строка") Тогда
		Возврат ЭтаФорма.Добавить("(?:" + АвтоматическоеЭкранирование(Параметр) + ")");
	Иначе
		Возврат ЭтаФорма.Добавить("(?:" + Параметр.ПолучитьСтроку() + ")"); //группировка без обратной связи
															// группа используется только для связи		
	КонецЕсли;

КонецФункции // Затем()

// Аналог Добавить для удобной записи
//
// Параметры:
//  ВхСтрока  - Строка - Строка поиска
//
// Возвращаемое значение:
//   Форма   - эта форма
//
Функция Потом(Параметр) Экспорт

	Возврат Затем(Параметр);

КонецФункции // Потом()

// Аналог Добавить для удобной записи
// Использовать в начале выражения
//
// Параметры:
//  Параметр  - Строка, Форма - строка поиска или готовое вербальное выражение
//
// Возвращаемое значение:
//   Форма   - эта форма
//
Функция Найди(Параметр) Экспорт
	Если ТипЗнч(Параметр) = Тип("Строка") Тогда
		Возврат ЭтаФорма.Добавить(АвтоматическоеЭкранирование(Параметр));
	ИначеЕсли ТипЗнч(Параметр) = Тип("Форма") Тогда
		Возврат ЭтаФорма.Добавить(Параметр);
	КонецЕсли;

КонецФункции // Найди()

// Проверка строки/выражения которого может не быть
//
// Параметры:
//  Параметр  - Строка, Форма - строка поиска или готовое вербальное выражение
//                 
// Возвращаемое значение:
//   ЭтаФорма   - эта форма
//
Функция МожетБыть(Параметр) Экспорт

	Возврат ЭтаФорма.Возможно(Параметр);

КонецФункции // МожетБыть()

// Проверка строки/выражения которого может не быть
//
// Параметры:
//  Параметр  - Строка, Форма - строка поиска или готовое вербальное выражение
//                 
// Возвращаемое значение:
//   ЭтаФорма   - эта форма
//
Функция Возможно(Параметр) Экспорт

	Если ТипЗнч(Параметр) = Тип("Строка") Тогда
		Возврат ВозможноСтрока(Параметр);
	ИначеЕсли ТипЗнч(Параметр) = Тип("Форма") Тогда
		Возврат ВозможноВербВыражение(Параметр);
	КонецЕсли;
	
	Возврат ЭтаФорма;

КонецФункции // МожетБыть()

// Проверка строки, которой может не быть
//
// Параметры:
//  ВхСтрока  - Строка - строка поиска
//
// Возвращаемое значение:
//   Форма   - эта форма
//
Функция ВозможноСтрока(ВхСтрока)

	Возврат ЭтаФорма.Затем(ВхСтрока).Добавить("?");

КонецФункции // ВозможноСтрока()

// Проверка вербального выражения, которого может не быть
//
// Параметры:
//  ВербВыражение  - Форма - подготовленое вербальное выражение
//
// Возвращаемое значение:
//   Форма   - эта форма
//
Функция ВозможноВербВыражение(ВербВыражение)

	Возврат ЭтаФорма.НачатьГруппу().Добавить(ВербВыражение).ЗакончитьГруппу().Добавить("?");

КонецФункции // ВозможноВербВыражение()

// Объявляет начало установки признака, что дальнейшее выражение возможно отсутствует
//
// Возвращаемое значение:
//   Форма   - эта форма
//
Функция ДальшеМожетБыть() Экспорт

	Суффикс = Суффикс + "?";
	
	Возврат ЭтаФорма;

КонецФункции // ДальшеМожетБыть()


//МОДИФИАКТОРЫ ПОИСКА
//БольшеОдного, Все кроме и прочие

// Выражение совпадает с любой, даже пустой строкой
//
// Возвращаемое значение:
//   Форма   - эта форма
//
Функция ЧтоУгодно() Экспорт

	Возврат ЭтаФорма.Добавить("(?:.*)");

КонецФункции // ЧтоУгодно()

// Выражение совпадает с любой строкой кроме указанной
//
// Параметры:
//  СтрокаИсключение  - Строка - строка которую надо исключить
//
// Возвращаемое значение:
//   Форма   - эта форма
//
Функция ЧтоУгодноКроме(СтрокаИсключение) Экспорт

	Возврат ЭтаФорма.Добавить("(?:[^" + СтрокаИсключение + "]*)");							

КонецФункции // ВсеКроме()

// Выражение совпадает с любой строкой, кроме пустой
//
// Возвращаемое значение:
//   Форма   - эта форма
//
Функция ЧтоНибудь() Экспорт

	Возврат ЭтаФорма.Добавить("(?.+)");

КонецФункции // ЧтоНибудь()

// Выражение совпадает с любой непустой строкой, кроме указаной
//
// Параметры:
//  СтрокаИсключение  - Строка - строка которую надо исключить
//
// Возвращаемое значение:
//   Форма   - эта форма
//
Функция ЧтоНибудьКроме(СтрокаИсключения) Экспорт 

	Возврат ЭтаФорма.Добавить("(?:[^" + СтрокаИсключения + "]+)");

КонецФункции // ЧтоНибудьКроме()

// Дальше любой из перечисленных символов
//
// Параметры:
//  Символы  - строка - строка с перечислением символов
//
// Возвращаемое значение:
//   Форма   - эта форма
//
Функция ЛюбойИз(Символы) Экспорт

	Возврат ЭтаФорма.Добавить("[" + Символы + "]");

КонецФункции // ЛюбойИз()

Функция Любой(Символы) Экспорт

	Возврат ЛюбойИз(Символы);

КонецФункции // Любой()

// Символы из указанного диапазона (10 вариантов диапазонов)
//
// Параметры:
//  С  - Строка - первый символ диапазона
//  По  - Строка - последний символ диапазона
//
// Возвращаемое значение:
//   Форма   - эта форма
//
Функция Диапазон(С0, По0,
					С1 = "", По1 = "",
					С2 = "", По2 = "",
					С3 = "", По3 = "",
					С4 = "", По4 = "",
					С5 = "", По5 = "",
					С6 = "", По6 = "",
					С7 = "", По7 = "",
					С8 = "", По8 = "",
					С9 = "", По9 = "") Экспорт
	Врем = "[" + С0 + "-" + По0;
	Если Не (ПустаяСтрока(С1) или ПустаяСтрока(По1)) Тогда
		Врем = Врем + С1 + "-" + По1;
	КонецЕсли;
	Если Не (ПустаяСтрока(С2) или ПустаяСтрока(По2)) Тогда
		Врем = Врем + С2 + "-" + По2;
	КонецЕсли;
	Если Не (ПустаяСтрока(С3) или ПустаяСтрока(По3)) Тогда
		Врем = Врем + С3 + "-" + По3;
	КонецЕсли;
	Если Не (ПустаяСтрока(С4) или ПустаяСтрока(По4)) Тогда
		Врем = Врем + С4 + "-" + По4;
	КонецЕсли;
	Если Не (ПустаяСтрока(С5) или ПустаяСтрока(По5)) Тогда
		Врем = Врем + С5 + "-" + По5;
	КонецЕсли;
	Если Не (ПустаяСтрока(С6) или ПустаяСтрока(По6)) Тогда
		Врем = Врем + С6 + "-" + По6;
	КонецЕсли;
	Если Не (ПустаяСтрока(С7) или ПустаяСтрока(По7)) Тогда
		Врем = Врем + С7 + "-" + По7;
	КонецЕсли;
	Если Не (ПустаяСтрока(С8) или ПустаяСтрока(По8)) Тогда
		Врем = Врем + С8 + "-" + По8;
	КонецЕсли;
	Если Не (ПустаяСтрока(С9) или ПустаяСтрока(По9)) Тогда
		Врем = Врем + С9 + "-" + По9;
	КонецЕсли;
	Врем = Врем + "]";
	
	Возврат ЭтаФорма.Добавить(Врем);
	
КонецФункции // Диапазон()

// Строка встречается один раз или больше
//
// Возвращаемое значение:
//   Форма   - эта форма
//
Функция ОдинРазИлиБольше() Экспорт

	Возврат ЭтаФорма.Добавить("+");

КонецФункции // ОдинРазИлиБольше()

// Строка встречается любое число раз, даже отсутствует
//
// Возвращаемое значение:
//   Форма   - Эта форма
//
Функция ЛюбоеЧислоРаз() Экспорт

	Возврат ЭтаФорма.Добавить("*");

КонецФункции // ЛюбоеЧислоРаз()

// Строка встречается N раз
//
// Параметры:
//  Количество  - Число - скольк раз точно должна встретится строка
//
// Возвращаемое значение:
//   Форма   - эта форма
//
Функция Раз(Количество) Экспорт
	
	ИсходныйТекст = ИсходныйТекст + "{" +
					Формат(Количество, "ЧДЦ=; ЧН=; ЧГ=") + 
					"}";
	Возврат ЭтаФорма;
КонецФункции // Раз()

// Строка встречается от N до M раз
//
// Параметры:
//  От  - Число - минимальное количество вхождений
//  По  - Число - маскимальное количество вхождений
//
// Возвращаемое значение:
//   Форма   - эта форма
//
Функция ОтДо(От, До) Экспорт

	ИсходныйТекст = ИсходныйТекст + "{" +
					Формат(От, "ЧДЦ=; ЧН=; ЧГ=") + 
					"," +
					Формат(До, "ЧДЦ=; ЧН=; ЧГ=") + 
					"}";
	Возврат ЭтаФорма;	

КонецФункции // ОтДо()

// Строка встречается хотя N раз
//
// Параметры:
//  Количество  - Число - минимальное количество вхождений
//
// Возвращаемое значение:
//   Форма   - эта форма
//
Функция ХотяБы(Количество) Экспорт

	ИсходныйТекст = ИсходныйТекст + "{" +
					Формат(Количество, "ЧДЦ=; ЧН=; ЧГ=") + 
					"," +
					"" + 
					"}";
	Возврат ЭтаФорма;

КонецФункции // ХотяБы()

// Строка встречается не больше чем N раз
//
// Параметры:
//  Количество  - Число - максимальное количество вхождений
//                 
// Возвращаемое значение:
//   Форма   - эта форма
//
Функция НеБольшеЧем(Количество)

	ИсходныйТекст = ИсходныйТекст + "{" +
					""
					"," +
					Формат(Количество, "ЧДЦ=; ЧН=; ЧГ=") + 
					"}";
	Возврат ЭтаФорма;

КонецФункции // НеБольшеЧем()


//УСЛОВИЯ ПОИСКА

// Условие выбора строки
//
// Параметры:
//  Строка  - строка - строка поиска
//
// Возвращаемое значение:
//   Форма   - эта форма
//
Функция Либо(Строка) Экспорт

	Префикс = Префикс + "(?:";
	ОткрытыхСкобок = ЧислоВхождений(Префикс, "(");
	ЗакрытыхСкобок = ЧислоВхождений(Префикс, ")");
	
	Если ОткрытыхСкобок >= ЗакрытыхСкобок Тогда
		Суффикс = ")" + Суффикс;
	КонецЕсли;
	
	ЭтаФорма.Добавить(")|(?:" + Строка);
	
	Возврат ЭтаФорма;

КонецФункции // Либо()

// Совпадает с одной указанных строк
//
// Параметры:
//  Параметр0..9  - Строка - строки поиска
//
// Возвращаемое значение:
//   Форма   - эта форма
//
Функция ОдинИз(Параметр0,
				Параметр1 = Неопределено, Параметр2 = Неопределено, Параметр3 = Неопределено,
				Параметр4 = Неопределено, Параметр5 = Неопределено, Параметр6 = Неопределено,
				Параметр7 = Неопределено, Параметр8 = Неопределено, Параметр9 = Неопределено) Экспорт
	Врем = "(?:";
	Врем = Врем + "(?:" +
					Параметр0 + 
					")";
	
	Если Параметр1 <> Неопределено Тогда
		Врем = Врем + "|(?:" +
				Параметр1 + 
				")";
	КонецЕсли;
	Если Параметр2 <> Неопределено Тогда
		Врем = Врем + "|(?:" +
				Параметр2 + 
				")";
	КонецЕсли;
	Если Параметр3 <> Неопределено Тогда
		Врем = Врем + "|(?:" +
				Параметр3 + 
				")";
	КонецЕсли;		
	Если Параметр4 <> Неопределено Тогда
		Врем = Врем + "|(?:" +
				Параметр4 + 
				")";
	КонецЕсли;
	Если Параметр5 <> Неопределено Тогда
		Врем = Врем + "|(?:" +
				Параметр5 + 
				")";
	КонецЕсли;
	Если Параметр6 <> Неопределено Тогда
		Врем = Врем + "|(?:" +
				Параметр6 + 
				")";
	КонецЕсли;
	Если Параметр7 <> Неопределено Тогда
		Врем = Врем + "|(?:" +
				Параметр7 + 
				")";
	КонецЕсли;
	Если Параметр8 <> Неопределено Тогда
		Врем = Врем + "|(?:" +
				Параметр8 + 
				")";
	КонецЕсли;
	Если Параметр9 <> Неопределено Тогда
		Врем = Врем + "|(?:" +
				Параметр9 + 
				")";
	КонецЕсли;
	Врем = Врем + ")";
	
	Возврат ЭтаФорма.Добавить(Врем);	

КонецФункции // ОдинИз()


//РАБОТА С ГРУППИРОВКАМИ

// Начало формирования группировки
//
// Возвращаемое значение:
//   Форма   - эта форма
//
Функция Захватить() Экспорт

	Суффикс = Суффикс + ")";
	Возврат ЭтаФорма.Добавить("(");

КонецФункции // Захватить()

// Начало формирования группировки без сохранения результата
//
// Возвращаемое значение:
//   Форма   - эта форма
//
Функция НачатьГруппу() Экспорт

	Суффикс = Суффикс + ")";
	Возврат ЭтаФорма.Добавить("(?:");

КонецФункции // НачатьГруппу()


// Заканчивает группировку
//
// Возвращаемое значение:
//   Форма   - эта форма
//
Функция ЗакончитьЗахват() Экспорт

	Если Прав(Суффикс, 1) = ")" Тогда
		ДобавляемаяСтрока = ")";
		Суффикс = Лев(Суффикс, СтрДлина(Суффикс) - 1);
		Если Прав(Суффикс, 1) = "?" Тогда
			ДобавляемаяСтрока = ДобавляемаяСтрока + "?";
			Суффикс = Лев(Суффикс, СтрДлина(Суффикс) - 1);
		КонецЕсли;
		Возврат ЭтаФорма.Добавить(ДобавляемаяСтрока);
	Иначе
		ВызватьИсключение "Не могу закончить группировку, так как группировка не начиналась";
	КонецЕсли;
	
КонецФункции // ЗакончитьЗахват()

// Заканчивает группировку
//
// Возвращаемое значение:
//   Форма   - эта форма
//
Функция ЗакончитьГруппу() Экспорт

	ЭтаФорма.ЗакончитьЗахват();

	Возврат ЭтаФорма;
КонецФункции // ЗакончитьГруппу()


//КРАСИВЫЕ ОБЕРТКИ

Функция КонецСтроки() Экспорт
	Возврат ЭтаФорма.Добавить("(?:\n|(?:\r\n)|(?:\r\r))");
КонецФункции

Функция КС() Экспорт
	Возврат ЭтаФорма.КонецСтроки();
КонецФункции

Функция Табуляция() Экспорт
	Возврат ЭтаФорма.Добавить("(?:\t)");
КонецФункции

Функция Таб() Экспорт
	Возврат ЭтаФорма.Табуляция();
КонецФункции

// Признак того, что дальше идет слово на английском
//
// Возвращаемое значение:
//   Форма   - эта форма
//
Функция СловоАнгл() Экспорт 

	Возврат ЭтаФорма.Добавить("(?:\w+)");

КонецФункции // СловоАнгл()

// Признак того, что дальше идет слово на русском
//
// Возвращаемое значение:
//   Форма   - эта форма
//
Функция СловоРус() Экспорт

	Возврат ЭтаФорма.Добавить("[а-яА-ЯёЁ_0-9]+");

КонецФункции // СловоРус()

// Признак того, что дальше идет слово на любом языке
//
// Возвращаемое значение:
//   Форма   - эта форма
//
Функция Слово() Экспорт

	Возврат ЭтаФорма.Добавить("[\wа-яА-ЯёЁ0-9]+");

КонецФункции // Слово()

// Буква английского алфавита
//
// Возвращаемое значение:
//   Форма   - Эта форма
//
Функция БукваАнгл() Экспорт

	Возврат ЭтаФорма.Добавить("(?:\w)");

КонецФункции // БукваАнгл()

// Буква русского алфавита
//
// Возвращаемое значение:
//   Форма   - Эта форма
//
Функция БукваРус() Экспорт

	Возврат ЭтаФорма.Добавить("(?:[а-яА-ЯёЁ_0-9])");

КонецФункции // БукваАнгл()

// Буква любого алфавита
//
// Возвращаемое значение:
//   Форма   - Эта форма
//
Функция Буква() Экспорт

	Возврат ЭтаФорма.Добавить("(?:[\wа-яА-ЯёЁ_0-9])");

КонецФункции // БукваАнгл()

// Нн буква английского алфавита
//
// Возвращаемое значение:
//   Форма   - Эта форма
//
Функция НеБукваАнгл() Экспорт

	Возврат ЭтаФорма.Добавить("(?:\W)");

КонецФункции // БукваАнгл()

// Не буква русского алфавита
//
// Возвращаемое значение:
//   Форма   - Эта форма
//
Функция НеБукваРус() Экспорт

	Возврат ЭтаФорма.Добавить("(?:[^а-яА-ЯёЁ_0-9])");

КонецФункции // БукваАнгл()

// Не буква любого алфавита
//
// Возвращаемое значение:
//   Форма   - Эта форма
//
Функция НеБуква() Экспорт

	Возврат ЭтаФорма.Добавить("(?:[^\wа-яА-ЯёЁ_0-9])");

КонецФункции // БукваАнгл()

// Это любая цифра от 0 - 9
//
// Возвращаемое значение:
//   Форма   - эта форма
//
Функция Цифра() Экспорт

	Возврат ЭтаФорма.Добавить("(?:\d)");

КонецФункции // Цифра()

Функция НеЦифра() Экспорт
	
	Возврат ЭтаФорма.Добавить("(?:\D)");
	
КонецФункции

// Любой пробельный символ: пробел, неразрывный пробел
//
// Возвращаемое значение:
//   Форма   - эта форма
//
Функция Пробел() Экспорт

	Возврат ЭтаФорма.Добавить("(?:\s");

КонецФункции // Пробел()

// Любой непробельный символ: пробел, неразрывный пробел
//
// Возвращаемое значение:
//   Форма   - эта форма
//
Функция НеПробел()

	Возврат ЭтаФорма.Добавить("(?:\S");

КонецФункции // НеПробел()


//МОДИФИКАТОРЫ ПОИСКА

Функция ИгнорироватьРегистр() Экспорт
	ИгнорироватьРегистр = Истина;
	Возврат ЭтаФорма;
КонецФункции

Функция СУчетомРегистра() Экспорт
	ИгнорироватьРегистр = Ложь;
	Возврат ЭтаФорма
КонецФункции

Функция ДоПервогоСовпадения() Экспорт
	ДоПервогоСовпадения = Истина;
	Возврат ЭтаФорма;
КонецФункции

Функция ГлобальныйПоиск() Экспорт
	ДоПервогоСовпадения = Ложь;
	Возврат ЭтаФорма;
КонецФункции

Функция ТолькоВОднойСтроке() Экспорт
	МногострочныйПоиск = Ложь;
	Возврат ЭтаФорма
КонецФункции

Функция ВоВсехСтроках() Экспорт
	МногострочныйПоиск = Истина;
	Возврат ЭтаФорма;
КонецФункции


//КВАНТИФИКАТОРЫ

Функция МожноПрименятьКвантификатор()
	ПоследнийСимвол = Прав(ИсходныйТекст, 1);
	
	Возврат ПоследнийСимвол = "*" Или 
			ПоследнийСимвол = "+" Или
			ПоследнийСимвол = "}" Или
			ПоследнийСимвол = "?";
	
КонецФункции

Функция Ленивый() Экспорт
	Если Не МожноПрименятьКвантификатор() Тогда
		ВызватьИсключение "Нельзя применить квантификатор поиска";
	КонецЕсли;
	Возврат ЭтаФорма.Добавить("?");
КонецФункции

Функция Сверхжадный() Экспорт
	Если Не МожноПрименятьКвантификатор() Тогда
		ВызватьИсключение "Нельзя применить квантификатор поиска";
	КонецЕсли;
	
	Возврат ЭтаФорма.Добавить("+");
КонецФункции

//RegExp --------------------------------------------------------

Функция regexp_init() Экспорт
	Если RegExp = Неопределено Тогда //Нужна инициализация
		Попытка
        	RegExp = Новый COMОбъект("VBScript.RegExp");    // создаем объект для работы с регулярными выражениями
		Исключение
			RegExp = Неопределено;
			ВызватьИсключение "Не удалось использовать Регулярные выражения";			
		КонецПопытки;
	КонецЕсли;
	Префикс			= "";
	ИсходныйТекст	= "";
	Суффикс			= "";
	ШаблонРВ		= "";
	
	Возврат ЭтаФорма;
КонецФункции

Функция РегулярныеВыражения_Выполнить(АнализируемыйТекст)

    РезультатАнализаСтроки = RegExp.Execute(АнализируемыйТекст);

    МассивВыражений = Новый Массив;

    Для Каждого Выражение Из РезультатАнализаСтроки Цикл
        СтруктураВыражение = Новый Структура ("Начало, Длина, Значение, ПодВыражения", 
												Выражение.FirstIndex, 
												Выражение.Length, 
												Выражение.Value);

        //Обработка подвыражений
        МассивПодВыражений = Новый Массив;
        Для Каждого ПодВыражение Из Выражение.SubMatches Цикл
            МассивПодВыражений.Добавить(ПодВыражение);
        КонецЦикла;
        СтруктураВыражение.ПодВыражения = МассивПодВыражений;

        МассивВыражений.Добавить (СтруктураВыражение);

    КонецЦикла;

    Возврат МассивВыражений;

КонецФункции

Функция РегулярныеВыражения_Проверка(ПроверяемыйТекст)

    Возврат RegExp.Test(ПроверяемыйТекст);

КонецФункции

Процедура РегулярныеВыражения_Инициализация ()

	Если RegExp = Неопределено Тогда //Нужна инициализация
		Возврат;
	КонецЕсли;

    //Заполняем данные
    RegExp.MultiLine	= МногострочныйПоиск;                  // истина — текст многострочный, ложь — одна строка
    RegExp.Global		= Не ДоПервогоСовпадения;   // истина — поиск по всей строке, ложь — до первого совпадения
    RegExp.IgnoreCase	= ИгнорироватьРегистр;        // истина — игнорировать регистр строки при поиске
    RegExp.Pattern		= ШаблонРВ;                        // шаблон (регулярное выражение)

КонецПроцедуры

//RegExp --------------------------------------------------------


// Ключевая функция. Возвращает подготовленное регулярное выражение как строку
//
// Возвращаемое значение:
//   Строка   - регулярное выражение на основе вербального
//
Функция ПолучитьСтроку() Экспорт
	
	ШаблонРВ = Префикс + ИсходныйТекст + Суффикс;
	Возврат ШаблонРВ;

КонецФункции // ПолучитьСтроку()

// Ключевая функция. Возвращает подготовленное регулярное выражение как объект
// для дальнейшего использования
//
// Возвращаемое значение:
//   Форма   - эта форма
//
Функция Создать() Экспорт

	ШаблонРВ = Префикс + ИсходныйТекст + Суффикс;
	РегулярныеВыражения_Инициализация();
	Возврат ЭтаФорма;

КонецФункции // Создать()


//Функции работы с регулярными выражениями

Функция СоответствуетШаблону(ПроверяемыйТекст) Экспорт 
	Возврат РегулярныеВыражения_Проверка(ПроверяемыйТекст);
КонецФункции

Функция РазобратьСтрокуПоШаблону(ПроверяемыйТекст) Экспорт
	Возврат РегулярныеВыражения_Выполнить(ПроверяемыйТекст);
КонецФункции


Префикс			= "";
ИсходныйТекст	= "";
Суффикс			= "";

ИгнорироватьРегистр	= Истина;
МногострочныйПоиск	= Ложь;
ДоПервогоСовпадения = Ложь;

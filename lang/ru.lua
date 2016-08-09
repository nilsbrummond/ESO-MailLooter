-- RU support by ForgottenLight

-- Add support for unoffical Russian languages to MailLooter.
-- Compatible with RuESO 10.0

local CORE = MailLooter.Core
-- General
ZO_CreateStringId("SI_MAILLOOTER_ADDON_NAME", "MailLooter (Сборщик почты)")
ZO_CreateStringId("SI_MAILLOOTER_TITLE", "MailLooter (Сборщик почты)")

-- There may be up to 6 strings for the defaults.
MailLooter.defaultAutoReturnSubjects = 
  { "return", "bounce", "rts", "return to sender", "вернуть" }

-- These must match the titles of offical mails.
MailLooter.unofficalLang = {
  ["lang"] = "ru",        -- The language code

  ["titlesAvA"]  = {       -- Offical AvA Mails
  },

  ["titlesHirelings"] = { -- Offical Hireling Mails
    ["Сырье для кузнеца"]       = { true, CRAFTING_TYPE_BLACKSMITHING},
    ["Сырье для портного"]      = { true, CRAFTING_TYPE_WOODWORKING},
    ["Сырье для столяра"]       = { true, CRAFTING_TYPE_CLOTHIER},
    ["Сырье для зачарователя"]  = { true, CRAFTING_TYPE_ENCHANTING},
    ["Сырье для снабженца"]     = { true, CRAFTING_TYPE_PROVISIONING},
  },

  ["titlesStores"] = {    -- Offical Guild Store Mails
    ["Срок продажи предмета истек"]   = { true, CORE.SUBTYPE_STORE_EXPIRED },
    ["Предмет приобретен"]            = { true, CORE.SUBTYPE_STORE_PURCHASED },
    ["Продажа предмета отменена"]     = { true, CORE.SUBTYPE_STORE_CANCELLED },
    ["Предмет продан"]                = { true, CORE.SUBTYPE_STORE_SOLD },
  },
}
--
-- Addon Translated strings below:
--
-- Keybingings:
ZO_CreateStringId("SI_BINDING_NAME_MAILLOOTER_OPEN",								"Открыть")
ZO_CreateStringId("SI_BINDING_NAME_MAILLOOTER_QUICK_LOOT_ALL",			"Открыть и собрать все")
ZO_CreateStringId("SI_BINDING_NAME_MAILLOOTER_QUICK_LOOT_FILTERED",	"Открыть и собрать выбранное")

-- Keybind Strip
ZO_CreateStringId("SI_MAILLOOTER_STRIP_LOOT_MAIN",	"Собрать почту")
ZO_CreateStringId("SI_MAILLOOTER_STRIP_CANCEL",			"Отменить")
ZO_CreateStringId("SI_MAILLOOTER_STRIP_CLEAR",			"Очистить")

-- Summary Bar
ZO_CreateStringId("SI_MAILLOOTER_SUMMARY_INBOX",		"ВХОДЯЩИЕ:")
ZO_CreateStringId("SI_MAILLOOTER_SUMMARY_ALL",			"Вся почта:")
ZO_CreateStringId("SI_MAILLOOTER_SUMMARY_UNREAD",		"Нечитан.:")
ZO_CreateStringId("SI_MAILLOOTER_SUMMARY_LOOTABLE",	"Собираемые:")
--ZO_CreateStringId("SI_MAILLOOTER_SUMMARY_AVA",			"AvA:")
ZO_CreateStringId("SI_MAILLOOTER_SUMMARY_HIRELING",	"Наемники:")
ZO_CreateStringId("SI_MAILLOOTER_SUMMARY_STORE",		"Продажи:")
--ZO_CreateStringId("SI_MAILLOOTER_SUMMARY_COD",			"CoD:")
ZO_CreateStringId("SI_MAILLOOTER_SUMMARY_OTHER",		"Прочие:")

ZO_CreateStringId("SI_MAILLOOTER_SUMMERY_DONE",			"Выполнено.")
ZO_CreateStringId("SI_MAILLOOTER_SUMMERY_LOOTING",	"Сбор почты...")

-- Filter Bar Tool Tips
ZO_CreateStringId("SI_MAILLOOTER_FILTER_ALL",					"Все письма, которые можно собрать")
ZO_CreateStringId("SI_MAILLOOTER_FILTER_AVA",					"Письма связанные с Войной Альянсов")
ZO_CreateStringId("SI_MAILLOOTER_FILTER_HIRELING",		"Письма от Ремесленных Наемников")
ZO_CreateStringId("SI_MAILLOOTER_FILTER_STORE",				"Письма из Гильд.Магазина")
ZO_CreateStringId("SI_MAILLOOTER_FILTER_COD",					"COD Письма\n(требующие оплату при получении)")
ZO_CreateStringId("SI_MAILLOOTER_FILTER_RETURNED",		"Возвращенные письма")
ZO_CreateStringId("SI_MAILLOOTER_FILTER_SIMPLE",			"Простые письма")
ZO_CreateStringId("SI_MAILLOOTER_FILTER_COD_RECEIPT",	"Пришедшая оплата за отправленные вами COD письма")

ZO_CreateStringId("SI_MAILLOOTER_FILTER_HIRELING_SMITH",			"Письма от Наемника-Кузнеца")
ZO_CreateStringId("SI_MAILLOOTER_FILTER_HIRELING_CLOTH",			"Письма от Наемника-Портного")
ZO_CreateStringId("SI_MAILLOOTER_FILTER_HIRELING_ENCHANT",		"Письма от Наемника-Зачарователя")
ZO_CreateStringId("SI_MAILLOOTER_FILTER_HIRELING_PROVISION",	"Письма от Наемника-Снабженца")
ZO_CreateStringId("SI_MAILLOOTER_FILTER_HIRELING_WOOD",				"Письма от Наемника-Столяра")
-- Filter Bar Label

ZO_CreateStringId("SI_MAILLOOTER_FILTER_LABEL_ALL",					"ВСЕ")
ZO_CreateStringId("SI_MAILLOOTER_FILTER_LABEL_AVA",					"Война Альянсов")
ZO_CreateStringId("SI_MAILLOOTER_FILTER_LABEL_HIRELING",		"Наемники")
ZO_CreateStringId("SI_MAILLOOTER_FILTER_LABEL_STORE",				"Гильд.Магазин")
ZO_CreateStringId("SI_MAILLOOTER_FILTER_LABEL_COD",					"COD")
ZO_CreateStringId("SI_MAILLOOTER_FILTER_LABEL_RETURNED",		"Возвращенные")
ZO_CreateStringId("SI_MAILLOOTER_FILTER_LABEL_SIMPLE",			"Простые")
ZO_CreateStringId("SI_MAILLOOTER_FILTER_LABEL_COD_RECEIPT",	"Оплата за COD")

ZO_CreateStringId("SI_MAILLOOTER_FILTER_LABEL_SMITH",			"Кузнец")
ZO_CreateStringId("SI_MAILLOOTER_FILTER_LABEL_CLOTH",			"Портной")
ZO_CreateStringId("SI_MAILLOOTER_FILTER_LABEL_ENCHANT",		"Зачарователь")
ZO_CreateStringId("SI_MAILLOOTER_FILTER_LABEL_PROVISION",	"Снабженц")
ZO_CreateStringId("SI_MAILLOOTER_FILTER_LABEL_WOOD",			"Столяр")

ZO_CreateStringId("SI_MAILLOOTER_FILTER_LABEL_COMPLEX","Несколько фильтров")
--ZO_CreateStringId("SI_MAILLOOTER_FILTER_LABEL_NOTHING","NONE")

-- Overview
ZO_CreateStringId("SI_MAILLOOTER_OVERVIEW", "Обзор")

ZO_CreateStringId("SI_MAILLOOTER_OVERVIEW_TOTAL", "ВСЕГО Писем")

ZO_CreateStringId("SI_MAILLOOTER_OVERVIEW_ALL", "Собрано:")
ZO_CreateStringId("SI_MAILLOOTER_OVERVIEW_AVA", "AvA:")
ZO_CreateStringId("SI_MAILLOOTER_OVERVIEW_HIRELING", "Наемники:")
ZO_CreateStringId("SI_MAILLOOTER_OVERVIEW_STORE", "Магазин:")
ZO_CreateStringId("SI_MAILLOOTER_OVERVIEW_COD", "COD:")
ZO_CreateStringId("SI_MAILLOOTER_OVERVIEW_RETURNED", "Возвращенные:")
ZO_CreateStringId("SI_MAILLOOTER_OVERVIEW_SIMPLE", "Простые:")
ZO_CreateStringId("SI_MAILLOOTER_OVERVIEW_COD_RTN", "Оплата за COD:")
ZO_CreateStringId("SI_MAILLOOTER_OVERVIEW_AUTO_RTN", "Авто-возврат:")

ZO_CreateStringId("SI_MAILLOOTER_OVERVIEW_COD_PAID", "Выплачено за COD:")

-- Alerts
ZO_CreateStringId("SI_MAILLOOTER_NOTHING_TO_LOOT",	"Не найдено писем для сбора")
ZO_CreateStringId("SI_MAILLOOTER_TIMEOUT",					"Превышено время ожидания письма")

-- Settings
ZO_CreateStringId("SI_MAILLOOTER_SETTINGS_AWO", "Настройки общиe нa aккaунт")

ZO_CreateStringId("SI_MAILLOOTER_SETTINGS_AWO_DESC", 
"Все параметры на этой странице сохраняются как общие на аккаунт и будут применяться для всех Ваших персонажей.  Только фильтры сбора на закладке Сборцик Почты (не на этой странице) сохраняются отдельно для каждого персонажа.")

ZO_CreateStringId("SI_MAILLOOTER_SETTINGS_GO", "Основные настройки")

ZO_CreateStringId("SI_MAILLOOTER_SETTINGS_RES_IS",		"Зарезервировать (4) места в инвентаре")
ZO_CreateStringId("SI_MAILLOOTER_SETTINGS_RES_IS_TT",	"Зарезервировать места в инвентаре необходимые для деконструкции предметов на ремесленном станке.")
ZO_CreateStringId("SI_MAILLOOTER_SETTINGS_RES_CUS",		"Настроить кол-во зарезервированных мест")

ZO_CreateStringId("SI_MAILLOOTER_SETTINGS_COD_OPTIONS",	"Настройки COD")
ZO_CreateStringId("SI_MAILLOOTER_SETTINGS_COD_ENABLE",	"Оплачивать и собирать COD письма")
ZO_CreateStringId("SI_MAILLOOTER_SETTINGS_COD_LIMITS",	"Лимиты для COD писем")
ZO_CreateStringId("SI_MAILLOOTER_SETTINGS_COD_L_DESC", 
"У Сборщика Почты есть два ограничения для COD писем:\n - максимальная стоимость одного письма\n - максимальная стоимость всех писем.\nЗначение |cFF0000НОЛЬ|r отключает ограничение.")
ZO_CreateStringId("SI_MAILLOOTER_SETTINGS_COD_MAX_PRICE","Макс.стоимость COD письма")
ZO_CreateStringId("SI_MAILLOOTER_SETTINGS_COD_MAX_COMB_PRICE","Макс.стоимость всех COD писем")

ZO_CreateStringId("SI_MAILLOOTER_SETTINGS_SIMPLE", "Простые письма")
ZO_CreateStringId("SI_MAILLOOTER_SETTINGS_SIM_DESC", 
"Настройки сбора писем от игроков, содержащих предметы или деньги. Письмо определяется как простое основываясь на его теме и тексте сообщения.")
ZO_CreateStringId("SI_MAILLOOTER_SETTINGS_SIM_ENABLE",	"Включить сбор простых писем")
ZO_CreateStringId("SI_MAILLOOTER_SETTINGS_SIM_DELETE",	"Удалять простое письмо после сбора")
ZO_CreateStringId("SI_MAILLOOTER_SETTINGS_SIM_SUB_T",		"Условия для темы письма")
ZO_CreateStringId("SI_MAILLOOTER_SETTINGS_SIM_SUB_DESC", 
"Считать письмо простым, если кол-во слов в теме меньше либо равно N.  Письма, содержащие в теме слова из списка авто-возврата, указанные ниже, простыми не считаются.")
ZO_CreateStringId("SI_MAILLOOTER_SETTINGS_SIM_SUB_COUNT",	"Кол-во слов в теме")
ZO_CreateStringId("SI_MAILLOOTER_SETTINGS_SIM_BODY_T",		"Условия для текста письма")
ZO_CreateStringId("SI_MAILLOOTER_SETTINGS_SIM_BODY_DESC", 
"Считать письмо простым, если кол-во слов в тексте письма меньше либо равно N.")
ZO_CreateStringId("SI_MAILLOOTER_SETTINGS_SIM_BODY_COUNT","Кол-во слов в тексте письма")

ZO_CreateStringId("SI_MAILLOOTER_SETTINGS_AR_TITLE","Авто-возврат отправителю")
ZO_CreateStringId("SI_MAILLOOTER_SETTINGS_AR_DECT",	"Определение писем для Авто-Возврата")
ZO_CreateStringId("SI_MAILLOOTER_SETTINGS_AR_DECT_DESC",
"Можно задать до 6 разных слов или фраз.  Если какое(ие) нидудь из них присутствуют в теме письма MailLooter будет считать, что такое письмо надо автоматически вернуть отправителю.  Во время сравнения с заголовком письма: Заглавные и прописные буквы не различаются, пунктуация игнорируется и лишние пробелы также игнорируются.  Оставьте поле 'Тема N' пустым чтобы отключить его.  Аддон будет либо игнорировать, либо автоматически возвращать соответствующие письма.")
ZO_CreateStringId("SI_MAILLOOTER_SETTINGS_AR_EXAMPLES","Примеры:")
ZO_CreateStringId("SI_MAILLOOTER_SETTINGS_AR_EX1_T","1. Использовать другой аддон для Авто-Возврата")
ZO_CreateStringId("SI_MAILLOOTER_SETTINGS_AR_EX1_DESC",
"Убедитесь, что 'Разрешить Авто-Возврат писем' ОТКЛЮЧЕНО.  Заполните 6 полей 'Тема N' словами, по которым другой аддон определяет Авто-Возвращаемые письма.  MailLooter проигнорирует эти письма, чтобы не мешать работе другого аддона.")
ZO_CreateStringId("SI_MAILLOOTER_SETTINGS_AR_EX2_T","2. Использовать этот аддон для Авто-Возврата")
ZO_CreateStringId("SI_MAILLOOTER_SETTINGS_AR_EX2_DESC",
"Убедитесь, что 'Разрешить Авто-Возврат писем' ВКЛЮЧЕНО.  Заполните 6 полей 'Тема N' словами, по которым вы хотите определять Авто-Возвращаемые письма.  MailLooter автоматически вернет отправителю эти письма во время выполнения сбора почты.")
ZO_CreateStringId("SI_MAILLOOTER_SETTINGS_AR_EX3_T","3. Не выполнять Авто-Возврат писем")
ZO_CreateStringId("SI_MAILLOOTER_SETTINGS_AR_EX3_DESC",
"Убедитесь, что 'Разрешить Авто-Возврат писем' ОТКЛЮЧЕНО.  Оставьте 6 полей 'Тема N' пустыми.  MailLooter не будет автоматически возвращать какие-либо письма, также никакие письма не будут считаться подлежащими авто-возврату.")
ZO_CreateStringId("SI_MAILLOOTER_SETTINGS_AR_SUBJECT","Тема <<1>>:")
ZO_CreateStringId("SI_MAILLOOTER_SETTINGS_AR_ENABLE","Разрешить Авто-Возврат писем")

-- Loot Fragment
ZO_CreateStringId("SI_MAILLOOTER_LOOT_HEADER_TYPE",     "Тип")
ZO_CreateStringId("SI_MAILLOOTER_LOOT_HEADER_NAME",     "Название")
ZO_CreateStringId("SI_MAILLOOTER_LOOT_HEADER_VALUE",    "Цена")

ZO_CreateStringId("SI_MAILLOOTER_LOOT_MT_UNKNOWN",			"Письма неизвесного типа")
ZO_CreateStringId("SI_MAILLOOTER_LOOT_MT_AVA",					"AvA письма")
ZO_CreateStringId("SI_MAILLOOTER_LOOT_MT_HIRELING",			"Письма от Наемников")
ZO_CreateStringId("SI_MAILLOOTER_LOOT_MT_STORE",				"Письма из Гильд.Магазина")
ZO_CreateStringId("SI_MAILLOOTER_LOOT_MT_COD",					"COD письма")
ZO_CreateStringId("SI_MAILLOOTER_LOOT_MT_RETURNED",			"Возвращенные письма")
ZO_CreateStringId("SI_MAILLOOTER_LOOT_MT_SIMPLE",				"Письма игроков")
ZO_CreateStringId("SI_MAILLOOTER_LOOT_MT_COD_RECEIPT",	"Оплаченные COD письма")

ZO_CreateStringId("SI_MAILLOOTER_LOOT_MN_MONEY",				"Деньги")
ZO_CreateStringId("SI_MAILLOOTER_LOOT_MN_COD_PAYMENT",	"COD Payment")
ZO_CreateStringId("SI_MAILLOOTER_LOOT_MN_RETURNED",			"Возврат денег")
ZO_CreateStringId("SI_MAILLOOTER_LOOT_MN_SIMPLE",				"Простое письмо")

ZO_CreateStringId("SI_MAILLOOTER_LOOT_EXTRA_FROM",			"От: ")
ZO_CreateStringId("SI_MAILLOOTER_LOOT_EXTRA_RETURNED_FROM","|cFF0000Возврат|r от: ")
ZO_CreateStringId("SI_MAILLOOTER_LOOT_EXTRA_EXPIRED",		"|cFF0000Просрочено|r")
ZO_CreateStringId("SI_MAILLOOTER_LOOT_EXTRA_CANCELED",	"|cFF0000Отменено|r")

ZO_CreateStringId("SI_MAILLOOTER_LOOT_FOOTER_LOOTED",		"Собрано")
ZO_CreateStringId("SI_MAILLOOTER_LOOT_FOOTER_INV_SPACE","Место в инвентаре: ")

ZO_CreateStringId("SI_MAILLOOTER_LOOT_FOOTER_INV_RES4",	"(%d зарезервировано)")
-- END OF FILE --

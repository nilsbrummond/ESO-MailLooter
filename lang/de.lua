--
-- Thank you to DarkRuler2500 on esoui.com for the German translation.
--


-- General ( May be used multiple places )

ZO_CreateStringId("SI_MAILLOOTER_ADDON_NAME", "Mail Looter Deutsch")
ZO_CreateStringId("SI_MAILLOOTER_TITLE", "Mail Looter Deutsch")

-- There may be up to 6 strings for the defaults.
MailLooter.defaultAutoReturnSubjects = 
  { "return", "bounce", "rts", "return to sender" }


-- Keybingings:
ZO_CreateStringId(
  "SI_BINDING_NAME_MAILLOOTER_OPEN", 
  "Öffnen")
ZO_CreateStringId(
  "SI_BINDING_NAME_MAILLOOTER_QUICK_LOOT_ALL", 
  "Öffnen und Nachrichtenanhänge entnehmen")
ZO_CreateStringId(
  "SI_BINDING_NAME_MAILLOOTER_QUICK_LOOT_FILTERED",
  "Öffnen und ausgewählte Nachrichtenanhänge entnehmen")


-- Keybind Strip
ZO_CreateStringId(
  "SI_MAILLOOTER_STRIP_LOOT_MAIN", 
  "Anhänge aus Nachricht(en) entnehmen")

ZO_CreateStringId(
  "SI_MAILLOOTER_STRIP_CANCEL", 
  "Abbrechen")

ZO_CreateStringId(
  "SI_MAILLOOTER_STRIP_CLEAR", 
  "Ansicht zurücksetzen")


-- Summary Bar
ZO_CreateStringId("SI_MAILLOOTER_SUMMARY_INBOX", "Posteingang:")
ZO_CreateStringId("SI_MAILLOOTER_SUMMARY_ALL", "Alles:")
ZO_CreateStringId("SI_MAILLOOTER_SUMMARY_UNREAD", "Ungelesen:")
ZO_CreateStringId("SI_MAILLOOTER_SUMMARY_LOOTABLE", "Mit Anhängen:")
ZO_CreateStringId("SI_MAILLOOTER_SUMMARY_AVA", "Allianzkrieg:")
ZO_CreateStringId("SI_MAILLOOTER_SUMMARY_HIRELING", "Lieferanten:")
ZO_CreateStringId("SI_MAILLOOTER_SUMMARY_STORE", "Läden:")
ZO_CreateStringId("SI_MAILLOOTER_SUMMARY_COD", "Nachnahme:")
ZO_CreateStringId("SI_MAILLOOTER_SUMMARY_OTHER", "Rest:")
ZO_CreateStrindId("SI_MAILLOOTER_SUMMERY_DONE", "Entnahme abgeschlossen")
ZO_CreateStrindId("SI_MAILLOOTER_SUMMERY_LOOTING", "Anhänge werden entnommen...")


-- Filter Bar Tool Tips
ZO_CreateStringId(
  "SI_MAILLOOTER_FILTER_ALL", 
  "Alle Nachrichten mit entnehmbaren Inhalten")
ZO_CreateStringId(
  "SI_MAILLOOTER_FILTER_AVA", 
  "Allianzkriegnachrichten")
ZO_CreateStringId(
  "SI_MAILLOOTER_FILTER_HIRELING", 
  "Alle Lieferantennachrichten")
ZO_CreateStringId(
  "SI_MAILLOOTER_FILTER_STORE", 
  "Alle Gildenlädennachrichten")
ZO_CreateStringId(
  "SI_MAILLOOTER_FILTER_COD", 
  "Alle Nachrichten mit Nachnahme")
ZO_CreateStringId(
  "SI_MAILLOOTER_FILTER_RETURNED", 
  "Zurückgesendete Nachrichten")
ZO_CreateStringId(
  "SI_MAILLOOTER_FILTER_SIMPLE", 
  "Einfache Nachrichten")
ZO_CreateStringId(
  "SI_MAILLOOTER_FILTER_COD_RECEIPT", 
  "Nachnahmezahlungen")
ZO_CreateStringId(
  "SI_MAILLOOTER_FILTER_HIRELING_SMITH", 
  "Lieferantennachrichten - Schmiedekunst")
ZO_CreateStringId(
  "SI_MAILLOOTER_FILTER_HIRELING_CLOTH", 
  "Lieferantennachrichten - Schneiderei")
ZO_CreateStringId(
  "SI_MAILLOOTER_FILTER_HIRELING_ENCHANT", 
  "Lieferantennachrichten - Verzauberung")
ZO_CreateStringId(
  "SI_MAILLOOTER_FILTER_HIRELING_PROVISION", 
  "Lieferantennachrichten - Versorgung")
ZO_CreateStringId(
  "SI_MAILLOOTER_FILTER_HIRELING_WOOD", 
  "Lieferantennachrichten - Schreinerei")

-- Filter Bar Label

ZO_CreateStringId(
  "SI_MAILLOOTER_FILTER_LABEL_ALL", 
  "ALLES")
ZO_CreateStringId(
  "SI_MAILLOOTER_FILTER_LABEL_AVA", 
  "Allianzkrieg")
ZO_CreateStringId(
  "SI_MAILLOOTER_FILTER_LABEL_HIRELING", 
  "Lieferanten")
ZO_CreateStringId(
  "SI_MAILLOOTER_FILTER_LABEL_STORE", 
  "Gildenladen")
ZO_CreateStringId(
  "SI_MAILLOOTER_FILTER_LABEL_COD", 
  "Nachnahme")
ZO_CreateStringId(
  "SI_MAILLOOTER_FILTER_LABEL_RETURNED", 
  "Rücksendung")
ZO_CreateStringId(
  "SI_MAILLOOTER_FILTER_LABEL_SIMPLE", 
  "Einfach")
ZO_CreateStringId(
  "SI_MAILLOOTER_FILTER_LABEL_COD_RECEIPT", 
  "Nachnahmezahlung")

ZO_CreateStringId(
  "SI_MAILLOOTER_FILTER_LABEL_SMITH", 
  "Schmiedekunst")
ZO_CreateStringId(
  "SI_MAILLOOTER_FILTER_LABEL_CLOTH", 
  "Schneiderei")
ZO_CreateStringId(
  "SI_MAILLOOTER_FILTER_LABEL_ENCHANT", 
  "Verzauberung")
ZO_CreateStringId(
  "SI_MAILLOOTER_FILTER_LABEL_PROVISION", 
  "Versorgung")
ZO_CreateStringId(
  "SI_MAILLOOTER_FILTER_LABEL_WOOD", 
  "Schreinerei")

ZO_CreateStringId(
  "SI_MAILLOOTER_FILTER_LABEL_COMPLEX", 
  "Mehrere Filter")

ZO_CreateStringId(
  "SI_MAILLOOTER_FILTER_LABEL_NOTHING", 
  "NICHTS")


-- Overview

ZO_CreateStringId(
  "SI_MAILLOOTER_OVERVIEW", 
  "Übersicht")

ZO_CreateStringId( "SI_MAILLOOTER_OVERVIEW_TOTAL", "Alle Nachrichten")

ZO_CreateStringId( "SI_MAILLOOTER_OVERVIEW_ALL", "Insgesamt:")
ZO_CreateStringId( "SI_MAILLOOTER_OVERVIEW_AVA", "Allianzkrieg:")
ZO_CreateStringId( "SI_MAILLOOTER_OVERVIEW_HIRELING", "Lieferanten:")
ZO_CreateStringId( "SI_MAILLOOTER_OVERVIEW_STORE", "Gildenläden:")
ZO_CreateStringId( "SI_MAILLOOTER_OVERVIEW_COD", "Nachnahme:")
ZO_CreateStringId( "SI_MAILLOOTER_OVERVIEW_RETURNED", "Rücksendung:")
ZO_CreateStringId( "SI_MAILLOOTER_OVERVIEW_SIMPLE", "Einfach:")
ZO_CreateStringId( "SI_MAILLOOTER_OVERVIEW_COD_RTN", "Nachnahmegeld:")
ZO_CreateStringId( "SI_MAILLOOTER_OVERVIEW_AUTO_RTN", "Auto-Rücksendung:")

ZO_CreateStringId( "SI_MAILLOOTER_OVERVIEW_COD_PAID", "Nachnahmezahlung:")

-- Alerts


ZO_CreateStringId(
  "SI_MAILLOOTER_NOTHING_TO_LOOT",
  "Mail Looter hat nichts zum Entnehmen gefunden")

ZO_CreateStringId(
  "SI_MAILLOOTER_TIMEOUT",
  "Zeit abgelaufen, in der auf neue Nachrichten gewartet wurde.")

-- Settings

ZO_CreateStringId( "SI_MAILLOOTER_SETTINGS_AWO", 
"Accountweite Einstellungen" )

ZO_CreateStringId( "SI_MAILLOOTER_SETTINGS_AWO_DESC", 
"Alle Optionen auf dieser Seite werden accountweit gespeichert und werden auf allen Charakteren gleich sein. Lediglich die Filter von Mail Looter sind charakterinvidiuell gespeichert." )

ZO_CreateStringId( "SI_MAILLOOTER_SETTINGS_GO", "Allgemeine Einstellungen" )

ZO_CreateStringId( "SI_MAILLOOTER_SETTINGS_RES_IS", 
"Reserviere (4) Inventarplätze" )
ZO_CreateStringId( "SI_MAILLOOTER_SETTINGS_RES_IS_TT", 
"Reserviert Inventarplatz, um künftiges Zerlegen/Verwerten von Gegenständen zu ermöglichen." )
ZO_CreateStringId( "SI_MAILLOOTER_SETTINGS_RES_CUS",
"Ändert die Zahl der reservierten Inventarplätze" )

ZO_CreateStringId( "SI_MAILLOOTER_SETTINGS_COD_OPTIONS", 
"Nachnahme-Einstellungen" )
ZO_CreateStringId( "SI_MAILLOOTER_SETTINGS_COD_ENABLE", 
"Nachrichten/Anhänge mit Nachnahme akzeptieren" )
ZO_CreateStringId( "SI_MAILLOOTER_SETTINGS_COD_LIMITS", 
"Höchstgrenzen für Nachnahme-Nachrichten")
ZO_CreateStringId( "SI_MAILLOOTER_SETTINGS_COD_L_DESC", 
"Mail Looters automatisches Entnehmen von Inhalten aus Nachnahme-Nachrichten kann auf einen Höchstpreis pro Nachricht oder einen kombinierten Höchstpreis festgelegt werden. Ein Wert von |cFF0000NULL|r bedeutet, dass keine Höchstgrenze festgelegt ist." )
ZO_CreateStringId( "SI_MAILLOOTER_SETTINGS_COD_MAX_PRICE", 
"Höchstgrenze pro Nachnahme-Nachricht" )
ZO_CreateStringId( "SI_MAILLOOTER_SETTINGS_COD_MAX_COMB_PRICE", 
"Höchstgrenze aller Nachnahme-Nachrichten" )

ZO_CreateStringId( "SI_MAILLOOTER_SETTINGS_SIMPLE", "Einfache Nachrichten" )
ZO_CreateStringId( "SI_MAILLOOTER_SETTINGS_SIM_DESC", 
"Einstellungen für Nachrichten mit Gegenstands- und Geldanhängen. Nachrichten können basierend auf Titel und Inhalt als Einfache Nachrichten definiert werden." )
ZO_CreateStringId( "SI_MAILLOOTER_SETTINGS_SIM_ENABLE", 
"Automatisches Verwerten einfacher Nachrichten" )
ZO_CreateStringId( "SI_MAILLOOTER_SETTINGS_SIM_DELETE", 
"Einfache Nachrichten anschließend löschen" )
ZO_CreateStringId( "SI_MAILLOOTER_SETTINGS_SIM_SUB_T", 
"Bedingungen des Titels" )
ZO_CreateStringId( "SI_MAILLOOTER_SETTINGS_SIM_SUB_DESC", 
"Damit eine Nachricht als einfache Nachricht definiert werden kann, darf die Buchstabenzahl des Nachrichtentitels N nicht überschreiten. Nachrichten, die Rücksende-Schlüsselworte beinhalten, sind davon nicht betroffen." )
ZO_CreateStringId( "SI_MAILLOOTER_SETTINGS_SIM_SUB_COUNT", 
"Buchstabenzahl des Titels" )
ZO_CreateStringId( "SI_MAILLOOTER_SETTINGS_SIM_BODY_T", 
"Bedingungen im Textfeld" )
ZO_CreateStringId( "SI_MAILLOOTER_SETTINGS_SIM_BODY_DESC", 
"Damit eine Nachricht als einfache Nachricht definiert werden kann, darf die Buchstabenzahl des Textfelds N nicht überschreiten." )
ZO_CreateStringId( "SI_MAILLOOTER_SETTINGS_SIM_BODY_COUNT", 
"Buchstabenzahl des Textfelds" )

ZO_CreateStringId( "SI_MAILLOOTER_SETTINGS_AR_TITLE",
"Automatisches Zurücksenden von Nachrichten" )
ZO_CreateStringId( "SI_MAILLOOTER_SETTINGS_AR_DECT",
"Einstellungen der Erkennung des automatischen Zurücksendens" )
ZO_CreateStringId( "SI_MAILLOOTER_SETTINGS_AR_DECT_DESC",
"Es gibt bis zu 6 verschiedene Wörter und Wortfolgen, die das automatische Zurücksenden auslösen können. Falls mindestens ein solches Wort oder eine solche Wortfolge im Nachrichtentitel enthalten ist, wird die Nachricht automatisch zurückgeschickt. Groß- und Kleinschreibung, Zeichensetzung und Leerzeichen werden dabei ignoriert. Wird das Feld leer gelassen, werden die Schlüsselworte darin ignoriert." )
ZO_CreateStringId( "SI_MAILLOOTER_SETTINGS_AR_EXAMPLES",
"Beispiele:" )
ZO_CreateStringId( "SI_MAILLOOTER_SETTINGS_AR_EX1_T",
"Falls ein anderes AddOn für automatische Nachrichtenrücksendung aktiv ist:" )
ZO_CreateStringId( "SI_MAILLOOTER_SETTINGS_AR_EX1_DESC",
"Stelle sicher, dass 'Aktiviere automatisches Nachrichtenzurücksenden' NICHT aktiv ist. Stelle die 6 'Betreff N'-Felder so ein wie bei deinem anderen AddOn. MailLooter wird dann entsprechende Mails ignorieren!" )
ZO_CreateStringId( "SI_MAILLOOTER_SETTINGS_AR_EX2_T",
"Die Nutzung von MailLooter für automatisches Nachrichtenzurücksenden" )
ZO_CreateStringId( "SI_MAILLOOTER_SETTINGS_AR_EX2_DESC",
"Stelle sicher, dass 'Aktiviere automatisches Nachrichtenzurücksenden' aktiv ist.  Stelle die 6 'Betreff N'-Felder so ein, dass unerwünschte Titel dort stehen. MailLooter wird dann entsprechende Nachrichten automatisch zurücksenden." )
ZO_CreateStringId( "SI_MAILLOOTER_SETTINGS_AR_EX3_T",
"Keine Nachrichtenrücksendung durchführen." )
ZO_CreateStringId( "SI_MAILLOOTER_SETTINGS_AR_EX3_DESC",
"Stelle sicher, dass 'Aktiviere automatisches Nachrichtenzurücksenden' NICHT aktiv ist. Leere die Felder aller 'Betreff N'-Einträge. MailLooter wird keine Nachrichten mehr zurücksenden!" )
ZO_CreateStringId( "SI_MAILLOOTER_SETTINGS_AR_SUBJECT",
"Betreff <<1>>:" )
ZO_CreateStringId( "SI_MAILLOOTER_SETTINGS_AR_ENABLE",
"Aktiviere automatisches Nachrichtenzurücksenden" )

-- Loot Fragment


ZO_CreateStringId( "SI_MAILLOOTER_LOOT_HEADER_TYPE",     "Typ" )
ZO_CreateStringId( "SI_MAILLOOTER_LOOT_HEADER_NAME",     "Name" )
ZO_CreateStringId( "SI_MAILLOOTER_LOOT_HEADER_VALUE",    "Wert" )

ZO_CreateStringId( "SI_MAILLOOTER_LOOT_MT_UNKNOWN",     "Unbekannte Nachrichtenart" )
ZO_CreateStringId( "SI_MAILLOOTER_LOOT_MT_AVA",         "Allianzkrieg-Nachricht" )
ZO_CreateStringId( "SI_MAILLOOTER_LOOT_MT_HIRELING",    "Lieferantennachricht" )
ZO_CreateStringId( "SI_MAILLOOTER_LOOT_MT_STORE",       "Gildenladennachricht" )
ZO_CreateStringId( "SI_MAILLOOTER_LOOT_MT_COD",         "Nachnahme-Nachricht" )
ZO_CreateStringId( "SI_MAILLOOTER_LOOT_MT_RETURNED",    "Zurückgesendete Nachricht" )
ZO_CreateStringId( "SI_MAILLOOTER_LOOT_MT_SIMPLE",      "Spielernachricht" )
ZO_CreateStringId( "SI_MAILLOOTER_LOOT_MT_COD_RECEIPT", "Nachnahme-Empfangsnachricht" )

ZO_CreateStringId( "SI_MAILLOOTER_LOOT_MN_MONEY", "Geld" )
ZO_CreateStringId( "SI_MAILLOOTER_LOOT_MN_COD_PAYMENT", "Nachnahmezahlung" )
ZO_CreateStringId( "SI_MAILLOOTER_LOOT_MN_RETURNED", "Zurückgesendetes Geld" )
ZO_CreateStringId( "SI_MAILLOOTER_LOOT_MN_SIMPLE", "Einfache Nachricht" )

ZO_CreateStringId( "SI_MAILLOOTER_LOOT_EXTRA_FROM", "Von: " )
ZO_CreateStringId( "SI_MAILLOOTER_LOOT_EXTRA_RETURNED_FROM", 
"|cFF0000Zurückerhalten|r von: " )
ZO_CreateStringId( "SI_MAILLOOTER_LOOT_EXTRA_EXPIRED", "|cFF0000Ausgelaufen|r" )
ZO_CreateStringId( "SI_MAILLOOTER_LOOT_EXTRA_CANCELED", "|cFF0000Abgebrochen|r" )

ZO_CreateStringId( "SI_MAILLOOTER_LOOT_FOOTER_LOOTED", "entnommen" )
ZO_CreateStringId( "SI_MAILLOOTER_LOOT_FOOTER_INV_SPACE", "Inventarplatz: " )

ZO_CreateStringId( "SI_MAILLOOTER_LOOT_FOOTER_INV_RES4", "(%d reserviert)" )




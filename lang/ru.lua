
-- There may be up to 6 strings for the defaults.
MailLooter.defaultAutoReturnSubjects = 
  { "return", "bounce", "rts", "return to sender", "Áoçápaûeîo" }

-- Add support for unoffical languages to MailLooter.
-- These must match the titles of offical mails.
MailLooter.unofficalLang = {
  ["lang"] = "ru",        -- The language code

  ["titlesAvA"]  = {       -- Offical AvA Mails
  },

  ["titlesHirelings"] = { -- Offical Hireling Mails
    ["Cÿpöe äìü êóçîeœa"]       = { true, CRAFTING_TYPE_BLACKSMITHING},
    ["Cÿpöe äìü ïopòîoâo"]      = { true, CRAFTING_TYPE_WOODWORKING},
    ["Cÿpöe äìü còoìüpa"]       = { true, CRAFTING_TYPE_CLOTHIER},
    ["Cÿpöe äìü çaùapoáaòeìü"]  = { true, CRAFTING_TYPE_ENCHANTING},
    ["Cÿpöe äìü cîaàæeîœa"]     = { true, CRAFTING_TYPE_PROVISIONING},
  },

  ["titlesStores"] = {    -- Offical Guild Store Mails
    ["Cpoê ïpoäaæè ïpeäíeòa ècòeê"]   = { true, SUBTYPE_STORE_EXPIRED },
    ["Ïpeäíeò ïpèoàpeòeî"]            = { true, SUBTYPE_STORE_PURCHASED },
    ["Ïpoäaæa ïpeäíeòa oòíeîeîa"]     = { true, SUBTYPE_STORE_CANCELLED },
    ["Ïpeäíeò ïpoäaî"]                = { true, SUBTYPE_STORE_SOLD },
  },
}

--
-- Addon Translated strings below:
--


-- General ( May be used multiple places )

ZO_CreateStringId("SI_MAILLOOTER_ADDON_NAME", "[ru] MailLooter")
ZO_CreateStringId("SI_MAILLOOTER_TITLE", "[ru] Mail Looter")




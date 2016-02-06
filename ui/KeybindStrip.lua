
MailLooter = MailLooter or {}
local ADDON = MailLooter
ADDON.UI = ADDON.UI or {}
local UI = ADDON.UI

UI.mailLooterButtonGroup = {
    {
        name = GetString(SI_MAILLOOTER_STRIP_LOOT_MAIN),
        keybind = "UI_SHORTCUT_PRIMARY",
        visible = function() 
            return ADDON.Core.IsActionReady() and 
            (not UI.IsLootShown()) end,
        callback = function() UI.StartLooting() end,
    },
    {
        name = GetString(SI_MAILLOOTER_STRIP_CANCEL),
        keybind = "UI_SHORTCUT_NEGATIVE",
        visible = function() return not ADDON.Core.IsIdle() end,
        callback = function() ADDON.Core.CancelClean() end,
    },
    {
        name = GetString(SI_MAILLOOTER_STRIP_CLEAR),
        keybind = "UI_SHORTCUT_SECONDARY",
        visible = function() 
            return ADDON.Core.IsIdle() and UI.IsLootShown() end,
        callback = function() UI.ClearLoot() end,
    },
    alignment = KEYBIND_STRIP_ALIGN_CENTER,
}


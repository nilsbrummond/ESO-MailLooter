
MailLooter = MailLooter or {}
local ADDON = MailLooter
ADDON.UI = ADDON.UI or {}
local UI = ADDON.UI

UI.mailLooterButtonGroup = {
    {
        name = "Loot Mail",
        keybind = "UI_SHORTCUT_PRIMARY",
        visible = function() 
            return ADDON.Core.IsActionReady() and 
            (not UI.IsLootShown()) end,
        callback = function() 
            UI.lootFragment:Clear()
            ADDON.Core.ProcessMailAll()
          end,
    },
    {
        name = "Cancel",
        keybind = "UI_SHORTCUT_NEGATIVE",
        visible = function() return not ADDON.Core.IsIdle() end,
        callback = function() ADDON.Core.CancelClean() end,
    },
    {
        name = "Clear",
        keybind = "UI_SHORTCUT_SECONDARY",
        visible = function() 
            return ADDON.Core.IsIdle() and UI.IsLootShown() end,
        callback = function() UI.ClearLoot() end,
    },
    alignment = KEYBIND_STRIP_ALIGN_CENTER,
}


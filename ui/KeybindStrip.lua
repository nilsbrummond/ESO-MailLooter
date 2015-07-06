
eso_addon_MailLooter = eso_addon_MailLooter or {}
local ADDON = eso_addon_MailLooter
ADDON.UI = ADDON.UI or {}
local UI = ADDON.UI

UI.mailLooterButtonGroup = {
    {
        name = "Loot Mail",
        keybind = "UI_SHORTCUT_PRIMARY",
        visible = function() return ADDON.Core.IsIdle() end,
        callback = function() ADDON.Core.ProcessMailAll() end,
    },
    {
        name = "Cancel",
        keybind = "UI_SHORTCUT_NEGATIVE",
        visible = function() return not ADDON.Core.IsIdle() end,
        callback = function() ADDON.Core.Reset() end,
    },
    alignment = KEYBIND_STRIP_ALIGN_CENTER,
}


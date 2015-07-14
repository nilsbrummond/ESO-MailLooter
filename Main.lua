
eso_addon_MailLooter = eso_addon_MailLooter or {}
local ADDON = eso_addon_MailLooter
ADDON.initialized = false

ADDON.settingsDefaults = {
  ["saveDeconSpace"] = true,
  ["debug"]          = false,
}


local function Initialize( eventCode, addOnName )

  if addOnName ~= ADDON.NAME then return end

  ADDON.settings = ZO_SavedVars:NewAccountWide(
    "MailLooter_Settings", 
    (ADDON.VERSION * 100), 
    "general", 
    ADDON.settingsDefaults)

  ADDON.SetDebug(ADDON.settings.debug)

  ADDON.Core.Initialize(ADDON.settings.saveDeconSpace)
  ADDON.UI.InitUserInterface()

  ADDON.initialized = true

end

function ADDON.GetSetting_saveDeconSpace()
  return (ADDON.settings.saveDeconSpace == true)
end

function ADDON.SetSetting_saveDeconSpace(val)
  ADDON.settings.saveDeconSpace = val
  ADDON.Core.SetSaveDeconSpace(val)
end

function ADDON.SetSetting_debug(val)
  ADDON.settings.debug = val
  ADDON.Core.SetDebug(val)
end 

function ADDON.SetDebug(on)
  ADDON.debug = on
  ADDON.Core.debug = on
  ADDON.UI.debug = on
end

-- Init Hook --
EVENT_MANAGER:RegisterForEvent(
  ADDON.NAME, EVENT_ADD_ON_LOADED, Initialize )


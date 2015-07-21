
eso_addon_MailLooter = eso_addon_MailLooter or {}
local ADDON = eso_addon_MailLooter
ADDON.initialized = false

ADDON.settingsDefaults = {
  ["saveDeconSpace"] = true,
  ["debug"]          = false,
  ["history"]        = {},
}


local function Initialize( eventCode, addOnName )

  if addOnName ~= ADDON.NAME then return end

  ADDON.settings = ZO_SavedVars:NewAccountWide(
    "MailLooter_Settings", 
    (ADDON.VERSION * 100), 
    "general", 
    ADDON.settingsDefaults)

  ADDON.SetDebug(ADDON.settings.debug)

  -- Clear the history table.
  ADDON.settings.history = {}

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
  ADDON.SetDebug(val)
end 

function ADDON.SetSetting_SaveHistory(loot)
  -- Only store the history for debugging...
  if ADDON.debug then
    table.insert( ADDON.settings.history, loot)
  end
end

function ADDON.SetDebug(on)
  ADDON.debug = on
  ADDON.Core.debug = on
  ADDON.UI.debug = on
end

-- Init Hook --
EVENT_MANAGER:RegisterForEvent(
  ADDON.NAME, EVENT_ADD_ON_LOADED, Initialize )


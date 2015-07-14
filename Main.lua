
eso_addon_MailLooter = eso_addon_MailLooter or {}
local ADDON = eso_addon_MailLooter
ADDON.initialized = false

ADDON.settingsDefaults = {
  ["saveDeconSpace"] = true,
}


local function Initialize( eventCode, addOnName )

  if addOnName ~= ADDON.NAME then return end

  ADDON.settings = ZO_SavedVars:NewAccountWide(
    "MailLooter_Settings", (ADDON.VERSION * 100), "general", ADDON.settingsDefaults)

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

-- Init Hook --
EVENT_MANAGER:RegisterForEvent(
  ADDON.NAME, EVENT_ADD_ON_LOADED, Initialize )


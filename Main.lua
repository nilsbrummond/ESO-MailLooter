
local ADDON = eso_addon_MailLooter
ADDON.initialized = false


local function Initialize( eventCode, addOnName )

  if addOnName ~= ADDON.NAME then return end

  local settingsDefaults = {
    saveDeconSpace = true,
  }

  ADDON.settings = ZO_SavedVars:New("MailLooter_Settings", 1, nil, settingDefaults)

  ADDON.Core.Initialize(ADDON.settings.saveDeconSpace)
  ADDON.UI.InitUserInterface()

  ADDON.initialized = true

end

function ADDON.GetSettting_saveDeconSpace()
  return ADDON.settings.saveDeconSpace
end

function ADDON.SetSetting_saveDeconSpace(val)
  ADDON.settings.saveDeconSpace = val
  ADDON.Core.SetSAveDeconSpace(val)
end

-- Init Hook --
EVENT_MANAGER:RegisterForEvent(
  ADDON.NAME, EVENT_ADD_ON_LOADED, Initialize )


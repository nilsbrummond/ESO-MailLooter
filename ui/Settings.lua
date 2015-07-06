
eso_addon_MailLooter = eso_addon_MailLooter or {}
local ADDON = eso_addon_MailLooter
ADDON.UI = ADDON.UI or {}
local UI = ADDON.UI

local panelData = {
  type = "panel",
  name = "MailLooter",
}


local optionsData = {
  [1] = {
    type = "checkbox",
    name = "Reserve (4) inventory spaces",
    tooltip = "Reserves inventory spaces need to do crafting deconstructions.",
    getFunc = function() return ADDON.GetSetting_saveDeconSpace() end,
    setFunc = function(value) ADDON.SetSetting_saveDeconSpace(value) end,
  }
}

local LAM = LibStub("LibAddonMenu-2.0")

function ADDON.UI.InitSettings()

  LAM:RegisterAddonPanel("MailLooterOptions", panelData)
  LAM:RegisterOptionControls("MailLooterOptions", optionsData)

end


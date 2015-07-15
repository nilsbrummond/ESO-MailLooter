
eso_addon_MailLooter = eso_addon_MailLooter or {}
local ADDON = eso_addon_MailLooter
ADDON.UI = ADDON.UI or {}
local UI = ADDON.UI



function ADDON.UI.InitSettings()

  local panelData = {
    type = "panel",
    name = "MailLooter",
    displayName = "|cC0C0A0" .. GetString(SI_MAIL_LOOTER) .. "|r",
    author = "Lodur (github.com/nilsbrummond)",
    version = tostring(ADDON.VERSION),
  }

  local optionsData = {
    {
      type = "header",
      name = "General Options"
    },
    {
      type = "checkbox",
      name = "Reserve (4) inventory spaces",
      tooltip = "Reserves inventory spaces needed to do crafting deconstructions.",
      getFunc = ADDON.GetSetting_saveDeconSpace,
      setFunc = ADDON.SetSetting_saveDeconSpace,
    },
  }

  local LAM = LibStub("LibAddonMenu-2.0")

  LAM:RegisterAddonPanel("MailLooterOptions", panelData)
  LAM:RegisterOptionControls("MailLooterOptions", optionsData)

end


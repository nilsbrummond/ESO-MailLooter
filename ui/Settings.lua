
MailLooter = MailLooter or {}
local ADDON = MailLooter
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
    {
      type = "header",
      name = "COD Options"
    },
    {
      type = "checkbox",
      name = "Accept and loot COD mails",
      getFunc = ADDON.GetSetting_lootCODMails,
      setFunc = ADDON.SetSetting_lootCODMails,
    },
    {
      type = "description",
      title = "COD Limits",
      text = "MailLooter looting of COD mails may be limited on a per mail price and a combined COD price.  A value of |cFF0000ZERO|r means no limit is enforced.",
    },
    {
      type = "slider",
      name = "Maximum price per COD",
      min = 0,
      max = 100000,
      step = 100,
      getFunc = ADDON.GetSetting_singleCODPriceMax,
      setFunc = ADDON.SetSetting_singleCODPriceMax,
    },
    {
      type = "slider",
      name = "Maximum combined COD price",
      min = 0,
      max = 1000000,
      step = 1000,
      getFunc = ADDON.GetSetting_combinedCODSpentMax,
      setFunc = ADDON.SetSetting_combinedCODSpentMax,
    },
  }

  local LAM = LibStub("LibAddonMenu-2.0")

  LAM:RegisterAddonPanel("MailLooterOptions", panelData)
  LAM:RegisterOptionControls("MailLooterOptions", optionsData)

end


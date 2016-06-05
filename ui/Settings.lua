
MailLooter = MailLooter or {}
local ADDON = MailLooter
ADDON.UI = ADDON.UI or {}
local UI = ADDON.UI



function ADDON.UI.InitSettings()

  local panelData = {
    type = "panel",
    name = GetString(SI_MAILLOOTER_ADDON_NAME),
    displayName = "|cC0C0A0" .. GetString(SI_MAILLOOTER_TITLE) .. "|r",
    author = "Lodur (github.com/nilsbrummond)",
    version = tostring(ADDON.VERSION),
  }

  local optionsData = {
    {
      type = "description",
      title = GetString(SI_MAILLOOTER_SETTINGS_AWO),
      text = GetString(SI_MAILLOOTER_SETTINGS_AWO_DESC),
    },
    {
      type = "header",
      name = GetString(SI_MAILLOOTER_SETTINGS_GO),
    },
    {
      type = "checkbox",
      name = GetString(SI_MAILLOOTER_SETTINGS_RES_IS),
      tooltip = GetString(SI_MAILLOOTER_SETTINGS_RES_IS_TT),
      getFunc = ADDON.GetSetting_saveDeconSpace,
      setFunc = ADDON.SetSetting_saveDeconSpace,
    },
    {
      type = "slider",
      name = GetString(SI_MAILLOOTER_SETTINGS_RES_CUS),
      min = 4,
      max = 30,
      step = 1,
      getFunc = ADDON.GetSetting_customDeconSpace,
      setFunc = ADDON.SetSetting_customDeconSpace,
    },
    {
      type = "header",
      name = GetString(SI_MAILLOOTER_SETTINGS_COD_OPTIONS)
    },
    {
      type = "checkbox",
      name = GetString(SI_MAILLOOTER_SETTINGS_COD_ENABLE),
      getFunc = ADDON.GetSetting_lootCODMails,
      setFunc = ADDON.SetSetting_lootCODMails,
    },
    {
      type = "description",
      title = GetString(SI_MAILLOOTER_SETTINGS_COD_LIMITS),
      text = GetString(SI_MAILLOOTER_SETTINGS_COD_L_DESC),
    },
    {
      type = "slider",
      name = GetString(SI_MAILLOOTER_SETTINGS_COD_MAX_PRICE),
      min = 0,
      max = 100000,
      step = 100,
      getFunc = ADDON.GetSetting_singleCODPriceMax,
      setFunc = ADDON.SetSetting_singleCODPriceMax,
    },
    {
      type = "slider",
      name = GetString(SI_MAILLOOTER_SETTINGS_COD_MAX_COMB_PRICE),
      min = 0,
      max = 1000000,
      step = 1000,
      getFunc = ADDON.GetSetting_combinedCODSpentMax,
      setFunc = ADDON.SetSetting_combinedCODSpentMax,
    },

    {
      type = "header",
      name = GetString(SI_MAILLOOTER_SETTINGS_SIMPLE),
    },
    {
      type = "description",
      title = "",
      text = GetString(SI_MAILLOOTER_SETTINGS_SIM_DESC),
    },
    {
      type = "checkbox",
      name = GetString(SI_MAILLOOTER_SETTINGS_SIM_ENABLE),
      getFunc = ADDON.GetSetting_enableSimple,
      setFunc = ADDON.SetSetting_enableSimple,
    },
    {
      type = "checkbox",
      name = GetString(SI_MAILLOOTER_SETTINGS_SIM_DELETE),
      getFunc = ADDON.GetSetting_deleteSimple,
      setFunc = ADDON.SetSetting_deleteSimple,
    },
    {
      type = "description",
      title = GetString(SI_MAILLOOTER_SETTINGS_SIM_SUB_T),
      text = GetString(SI_MAILLOOTER_SETTINGS_SIM_SUB_DESC),
    },
    {
      type = "slider",
      name = GetString(SI_MAILLOOTER_SETTINGS_SIM_SUB_COUNT),
      min = 0,
      max = 10,
      step = 1,
      getFunc = ADDON.GetSetting_simpleSubjectWC,
      setFunc = ADDON.SetSetting_simpleSubjectWC,
    },
    {
      type = "description",
      title = GetString(SI_MAILLOOTER_SETTINGS_SIM_BODY_T),
      text = GetString(SI_MAILLOOTER_SETTINGS_SIM_BODY_DESC),
    },
    {
      type = "slider",
      name = GetString(SI_MAILLOOTER_SETTINGS_SIM_BODY_COUNT),
      min = 0,
      max = 20,
      step = 1,
      getFunc = ADDON.GetSetting_simpleBodyWC,
      setFunc = ADDON.SetSetting_simpleBodyWC,
    },
    {
      type = "header",
      name = GetString(SI_MAILLOOTER_SETTINGS_AR_TITLE),
    },
    {
      type = "description",
      title = GetString(SI_MAILLOOTER_SETTINGS_AR_DECT),
      text = GetString(SI_MAILLOOTER_SETTINGS_AR_DECT_DESC),
    },
    {
      type = "description",
    },
    {
      type = "description",
      title = GetString(SI_MAILLOOTER_SETTINGS_AR_EXAMPLES),
    },
    {
      type = "description",
      title = GetString(SI_MAILLOOTER_SETTINGS_AR_EX1_T),
      text = GetString(SI_MAILLOOTER_SETTINGS_AR_EX1_DESC),
    },
    {
      type = "description",
      title = GetString(SI_MAILLOOTER_SETTINGS_AR_EX2_T),
      text = GetString(SI_MAILLOOTER_SETTINGS_AR_EX2_DESC),
    },
    {
      type = "description",
      title = GetString(SI_MAILLOOTER_SETTINGS_AR_EX3_T),
      text = GetString(SI_MAILLOOTER_SETTINGS_AR_EX3_DESC),
    },
    {
      type="editbox",
      name= zo_strformat( GetString(SI_MAILLOOTER_SETTINGS_AR_SUBJECT), "1" ),
      getFunc = function() return ADDON.GetSetting_autoReturnSubject(1) end,
      setFunc = function(v) ADDON.SetSetting_autoReturnSubject(v, 1) end,
      isMultiline = false,
    },
    {
      type="editbox",
      name= zo_strformat( GetString(SI_MAILLOOTER_SETTINGS_AR_SUBJECT), "2" ),
      getFunc = function() return ADDON.GetSetting_autoReturnSubject(2) end,
      setFunc = function(v) ADDON.SetSetting_autoReturnSubject(v, 2) end,
      isMultiline = false,
    },
    {
      type="editbox",
      name= zo_strformat( GetString(SI_MAILLOOTER_SETTINGS_AR_SUBJECT), "3" ),
      getFunc = function() return ADDON.GetSetting_autoReturnSubject(3) end,
      setFunc = function(v) ADDON.SetSetting_autoReturnSubject(v, 3) end,
      isMultiline = false,
    },
    {
      type="editbox",
      name= zo_strformat( GetString(SI_MAILLOOTER_SETTINGS_AR_SUBJECT), "4" ),
      getFunc = function() return ADDON.GetSetting_autoReturnSubject(4) end,
      setFunc = function(v) ADDON.SetSetting_autoReturnSubject(v, 4) end,
      isMultiline = false,
    },
    {
      type="editbox",
      name= zo_strformat( GetString(SI_MAILLOOTER_SETTINGS_AR_SUBJECT), "5" ),
      getFunc = function() return ADDON.GetSetting_autoReturnSubject(5) end,
      setFunc = function(v) ADDON.SetSetting_autoReturnSubject(v, 5) end,
      isMultiline = false,
    },
    {
      type="editbox",
      name= zo_strformat( GetString(SI_MAILLOOTER_SETTINGS_AR_SUBJECT), "6" ),
      getFunc = function() return ADDON.GetSetting_autoReturnSubject(6) end,
      setFunc = function(v) ADDON.SetSetting_autoReturnSubject(v, 6) end,
      isMultiline = false,
    },
    {
      type = "checkbox",
      name = GetString(SI_MAILLOOTER_SETTINGS_AR_ENABLE),
      getFunc = ADDON.GetSetting_enableBounce,
      setFunc = ADDON.SetSetting_enableBounce,
    },
  }

  local LAM = LibStub("LibAddonMenu-2.0")

  LAM:RegisterAddonPanel("MailLooterOptions", panelData)
  LAM:RegisterOptionControls("MailLooterOptions", optionsData)

end


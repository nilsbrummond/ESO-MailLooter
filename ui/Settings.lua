
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
      name = "Reserve (4) Inventory Spaces",
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
      name = "Accept and Loot COD Mails",
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
      name = "Maximum Price per COD",
      min = 0,
      max = 100000,
      step = 100,
      getFunc = ADDON.GetSetting_singleCODPriceMax,
      setFunc = ADDON.SetSetting_singleCODPriceMax,
    },
    {
      type = "slider",
      name = "Maximum Combined COD Price",
      min = 0,
      max = 1000000,
      step = 1000,
      getFunc = ADDON.GetSetting_combinedCODSpentMax,
      setFunc = ADDON.SetSetting_combinedCODSpentMax,
    },
    {
      type = "header",
      name = "Simple Mails"
    },
    {
      type = "description",
      title = "",
      text = "Looting options for player mails containing loot and money.  Mails may be defined as simple based on the subject and text.",
    },
    {
      type = "checkbox",
      name = "Enable Simple Mail Looting",
      getFunc = ADDON.GetSetting_enableSimple,
      setFunc = ADDON.SetSetting_enableSimple,
    },
    {
      type = "checkbox",
      name = "Delete Simple Mails After",
      getFunc = ADDON.GetSetting_deleteSimple,
      setFunc = ADDON.SetSetting_deleteSimple,
    },
    {
      type = "description",
      title = "Subject Conditions",
      text = "For a mail to be defined as a simple mail the subject word count must be less than or equal to N.  Mails with auto-return key words define below will not be defined as a simple mail.",
    },
    {
      type = "slider",
      name = "Subject Word Count",
      min = 0,
      max = 10,
      step = 1,
      getFunc = ADDON.GetSetting_simpleSubjectWC,
      setFunc = ADDON.SetSetting_simpleSubjectWC,
    },
    {
      type = "description",
      title = "Body Conditions",
      text = "For a mail to be defined as simple the mail body word count must be less than or equal to N.",
    },
    {
      type = "slider",
      name = "Body Word Count",
      min = 0,
      max = 20,
      step = 1,
      getFunc = ADDON.GetSetting_simpleBodyWC,
      setFunc = ADDON.SetSetting_simpleBodyWC,
    },
    {
      type = "header",
      name = "Auto Return Mailers"
    },
    {
      type = "description",
      title = "MailLooter Auto-return Mail Detection",
      text = "There may be up to 6 different Auto-return words or phases.  If any of the them match the subject of a mail then MailLooter considers the mail as Auto-return mail.  When matching a mail's subject: Capitalization is ignored, punctuation is ignored, and extra spaces are ignored.  Setting the 'Subject N' field to blank to disable that field.  MailLooter will either ignore or auto-return matching mails.",
    },
    {
      type = "description",
    },
    {
      type = "description",
      title = "Examples:",
    },
    {
      type = "description",
      title = "Using another Addon for Mail Auto-Returning",
      text = "Make sure 'Enable Mail Auto-Returning' is NOT checked.  Set the 6 'Subject N' fields to match the auto-return detection used by your other Addon.  MailLooter will ignore the detected auto-return mails so not to interfer with the other mail auto-return addon.",
    },
    {
      type = "description",
      title = "Using MailLooter for Mail Auto-Returning",
      text = "Make sure 'Enable Mail Auto-Returning' is checked.  Set the 6 'Subject N' fields to the subjects that you want to have auto-returned.  MailLooter will now auto-return detected mails during the looting procedure.",
    },
    {
      type = "description",
      title = "Don't Do Any Mail Auto-Returning",
      text = "Make sure 'Enable Mail Auto-Returning' is NOT checked.  Set the 6 'Subject N' fields to be blank.  MailLooter will not auto-return any mail, and no mail will be assumed to be for auto-returning.",
    },
    {
      type="editbox",
      name="Subject 1:",
      getFunc = function() return ADDON.GetSetting_autoReturnSubject(1) end,
      setFunc = function(v) ADDON.SetSetting_autoReturnSubject(v, 1) end,
      isMultiline = false,
    },
    {
      type="editbox",
      name="Subject 2:",
      getFunc = function() return ADDON.GetSetting_autoReturnSubject(2) end,
      setFunc = function(v) ADDON.SetSetting_autoReturnSubject(v, 2) end,
      isMultiline = false,
    },
    {
      type="editbox",
      name="Subject 3:",
      getFunc = function() return ADDON.GetSetting_autoReturnSubject(3) end,
      setFunc = function(v) ADDON.SetSetting_autoReturnSubject(v, 3) end,
      isMultiline = false,
    },
    {
      type="editbox",
      name="Subject 4:",
      getFunc = function() return ADDON.GetSetting_autoReturnSubject(4) end,
      setFunc = function(v) ADDON.SetSetting_autoReturnSubject(v, 4) end,
      isMultiline = false,
    },
    {
      type="editbox",
      name="Subject 5:",
      getFunc = function() return ADDON.GetSetting_autoReturnSubject(5) end,
      setFunc = function(v) ADDON.SetSetting_autoReturnSubject(v, 5) end,
      isMultiline = false,
    },
    {
      type="editbox",
      name="Subject 6:",
      getFunc = function() return ADDON.GetSetting_autoReturnSubject(6) end,
      setFunc = function(v) ADDON.SetSetting_autoReturnSubject(v, 6) end,
      isMultiline = false,
    },
    {
      type = "checkbox",
      name = "Enable Mail Auto-Returning",
      getFunc = ADDON.GetSetting_enableBounce,
      setFunc = ADDON.SetSetting_enableBounce,
    },
  }

  local LAM = LibStub("LibAddonMenu-2.0")

  LAM:RegisterAddonPanel("MailLooterOptions", panelData)
  LAM:RegisterOptionControls("MailLooterOptions", optionsData)

end


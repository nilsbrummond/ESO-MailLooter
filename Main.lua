
eso_addon_MailLooter = eso_addon_MailLooter or {}
local ADDON = eso_addon_MailLooter
ADDON.initialized = false

ADDON.settingsDefaults = {
  ["saveDeconSpace"]      = true,
  ["lootCODMails"]        = false,
  ["singleCODPriceMax"]   = 1000,
  ["combinedCODSpentMax"] = 5000,
  ["debug"]               = false,
  ["history"]             = {},
  ["scan"]                = {},
}

ADDON.debug = false
ADDON.debugMsgWin = false

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
  ADDON.settings.scan = {}

  local function DoCODTest(codAmount, codTotal)
    if not ADDON.settings.lootCODMails then return false end

    if (ADDON.settings.singleCODPriceMax > 0) and
       (codAmount > ADDON.settings.singleCODPriceMax) then 
      return false 
    end

    if (ADDON.settings.combinedCODSpentMax > 0) and
       ((codAmount + codTotal) > ADDON.settings.combinedCODSpentMax) then
      return false
    end

    return true
  end

  ADDON.Core.Initialize(
    ADDON.settings.saveDeconSpace, ADDON.DebugMsg, DoCODTest)
  ADDON.UI.InitUserInterface(ADDON.DebugMsg)

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

function ADDON.GetSetting_lootCODMails()
  return ADDON.settings.lootCODMails
end

function ADDON.SetSetting_lootCODMails(loot)
  ADDON.settings.lootCODMails = loot
end

function ADDON.GetSetting_singleCODPriceMax()
  return ADDON.settings.singleCODPriceMax
end

function ADDON.SetSetting_singleCODPriceMax(value)
  if type(value) ~= 'number' then return end
  ADDON.settings.singleCODPriceMax = value
end

function ADDON.GetSetting_combinedCODSpentMax()
  return ADDON.settings.combinedCODSpentMax
end

function ADDON.SetSetting_combinedCODSpentMax(value)
  if type(value) ~= 'number' then return end
  ADDON.settings.combinedCODSpentMax = value
end

function ADDON.SetSetting_SaveHistory(loot)
  -- Only store the history for debugging...
  if ADDON.debug then
    table.insert( ADDON.settings.history, loot)
  end
end

function ADDON.SetDebug(on)
  ADDON.debug = on

  if on then
    if ADDON.debugMsgWin then
      ADDON.debugMsgWin:SetHidden(false)
    else

      -- Create the window first time debug is turned on..
      local LIBMW = LibStub:GetLibrary("LibMsgWin-1.0")
      ADDON.debugMsgWin = LIBMW:CreateMsgWindow(
        "MailLooterDebugWindow", "MailLooter Debug")

    end
  elseif ADDON.debugMsgWin then
    ADDON.debugMsgWin:SetHidden(true)
  end
end

function ADDON.DebugMsg(msg)
  if ADDON.debug then
    ADDON.debugMsgWin:AddText(msg, 1, 1, 0)
  end
  return ADDON.debug
end

-- Init Hook --
EVENT_MANAGER:RegisterForEvent(
  ADDON.NAME, EVENT_ADD_ON_LOADED, Initialize )


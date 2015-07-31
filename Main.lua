
MailLooter = MailLooter or {}
local ADDON = MailLooter
ADDON.initialized = false

ADDON.settingsDefaults = {
  ["saveDeconSpace"]      = true,
  ["lootCODMails"]        = false,
  ["singleCODPriceMax"]   = 1000,
  ["combinedCODSpentMax"] = 5000,
  ["enableSimple"]        = true,
  ["deleteSimple"]        = true,
  ["simpleSubjectWC"]     = 0,
  ["simpleBodyWC"]        = 0,
  ["autoReturnSubjects"]  = { "return", "bounce", "rts", "return to sender" },
  ["enableBounce"]        = false,

  -- debug
  ["debug"]               = false,
  ["history"]             = {},
  ["scan"]                = {},
}

ADDON.debug = false
ADDON.debugMsgWin = false

local DEBUG = function(msg) return false end

local function Initialize( eventCode, addOnName )

  if addOnName ~= ADDON.NAME then return end

  DEBUG = function(msg) ADDON.DebugMsg("MAIN: " .. msg) end

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
    if not ADDON.settings.lootCODMails then 
      DEBUG("COD DENY - All")
      return false
    end

    if (ADDON.settings.singleCODPriceMax > 0) and
       (codAmount > ADDON.settings.singleCODPriceMax) then 
      DEBUG("COD DENY - Per COD price")
      return false 
    end

    if (ADDON.settings.combinedCODSpentMax > 0) and
       ((codAmount + codTotal) > ADDON.settings.combinedCODSpentMax) then
      DEBUG("COD DENY - Total COD price")
      return false
    end

    return true
  end

  local function DoSimplePreTest(subject, attachments, money)
    -- simple mail enabled?
    if not ADDON.GetSetting_enableSimple() then return false end

    -- Must have stuff...
    if (attachments + money) == 0 then return false end
   
    -- Subject word count test
    local _, n = subject:gsub("%S+","")
    if n <= ADDON.GetSetting_simpleSubjectWC() then return true end

    return false
  end

  local function DoSimplePostTest(body)
    -- body word count test
    local _, n = body:gsub("%S+","")
    return (n <= ADDON.GetSetting_simpleBodyWC())
  end

  ADDON.Core.Initialize(
    ADDON.settings.saveDeconSpace, ADDON.DebugMsg,
    DoCODTest, DoSimplePreTest, DoSimplePostTest,
    ADDON.GetSetting_deleteSimple,
    ADDON.GetSetting_enableBounce)

  ADDON.Core.SetAutoReturnStrings(ADDON.settings.autoReturnSubjects)

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

function ADDON.GetSetting_enableSimple()
  return ADDON.settings.enableSimple
end

function ADDON.SetSetting_enableSimple(val)
  ADDON.settings.enableSimple = val
end

function ADDON.GetSetting_deleteSimple()
  return ADDON.settings.deleteSimple
end

function ADDON.SetSetting_deleteSimple(val)
  ADDON.settings.deleteSimple = val
end

function ADDON.GetSetting_simpleSubjectWC()
  return ADDON.settings.simpleSubjectWC
end

function ADDON.SetSetting_simpleSubjectWC(val)
  ADDON.settings.simpleSubjectWC = val
end

function ADDON.GetSetting_simpleBodyWC()
  return ADDON.settings.simpleBodyWC
end

function ADDON.SetSetting_simpleBodyWC(val)
  ADDON.settings.simpleBodyWC = val
end

function ADDON.GetSetting_autoReturnSubject(index)
  return ADDON.settings.autoReturnSubjects[index]
end

function ADDON.SetSetting_autoReturnSubject(val, index)
  ADDON.settings.autoReturnSubjects[index] = val
  ADDON.Core.SetAutoReturnStrings(ADDON.settings.autoReturnSubjects)
end


function ADDON.GetSetting_enableBounce()
  return ADDON.settings.enableBounce
end

function ADDON.SetSetting_enableBounce(val)
  ADDON.settings.enableBounce = val
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



MailLooter = MailLooter or {}
local ADDON = MailLooter

local function CommandHandler(text)
  if text == "" then
    d( ADDON.NAME .. " version " .. ADDON.VERSION )
    d( "Commands:" )
    d( "debug [on/off]  -  Turns debug messages on and off" )
    d( "reset  -  Reset the maillooter in case it is stuck." )
    d( "test  -  Test looting..." )
    d( "scan  -  scan the inbox" )

    return
  elseif text == "debug off" then
    ADDON.SetSetting_debug(false)
  elseif text == "debug on" then
    ADDON.SetSetting_debug(true)
  elseif text == "debug hide" then
    if ADDON.debugMsgWin then 
      ADDON.debugMsgWin:SetHidden(true) 
    end
  elseif text == "debug show" then
    if ADDON.debugMsgWin then 
      ADDON.debugMsgWin:SetHidden(false) 
    end
  elseif text == "reset" then
    ADDON.Core.Reset()
  elseif text == "test" then
    ADDON.Core.TestLoot()
  elseif text == "scan" then
    ADDON.settings.scan = ADDON.Core.Scan()
  end
end

-- Slash Commands --
SLASH_COMMANDS["/maillooter"] = CommandHandler


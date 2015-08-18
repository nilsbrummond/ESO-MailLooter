
MailLooter = MailLooter or {}
local ADDON = MailLooter

local function CommandHandler(text)
  if text == "" then
    d( ADDON.NAME .. " version " .. ADDON.VERSION )
    d( "Commands:" )
    d( "open  -  Open MailLooter" )
    d( "loot  -  Open MailLooter and begin looting" )
    d( "loot-all  -  Open MailLooter and begin looting all (ignore filter)" )

    d( "debug [on/off]  -  Turns debug messages on and off." )

    -- Only tell people that are debugging about these...
    if ADDON.debug then
      d( "debug [hide/show]  -  Hide and Shows the debug msg window." )
      d( "reset  -  Reset the maillooter in case it is stuck." )
      d( "test  -  Do a fake looting for UI testing." )
      d( "scan  -  scan the inbox." )
    end

    return
  elseif text == "open" then
    ADDON.QuickLaunch()
  elseif text == "loot" then
    ADDON.QuickLaunchFiltered()
  elseif text == "loot-all" then
    ADDON.QuickLaunchAll()
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


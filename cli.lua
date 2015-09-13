
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
  end

  local cmd, arg1, arg2 = zo_strsplit(' ', text)

  if cmd == "open" then
    ADDON.QuickLaunch()
  elseif cmd == "loot" then
    ADDON.QuickLaunchFiltered()
  elseif cmd == "loot-all" then
    ADDON.QuickLaunchAll()
  elseif cmd == "debug" then
    if (arg1 == nil) or (arg1 == "") then
      -- Noithing...
    elseif arg1 == "off" then
      ADDON.SetSetting_debug(false)
    elseif arg1 == "on" then
      ADDON.SetSetting_debug(true)
    elseif arg1 == "hide" then
      if ADDON.debugMsgWin then 
        ADDON.debugMsgWin:SetHidden(true) 
      end
    elseif arg1 == "show" then
      if ADDON.debugMsgWin then 
        ADDON.debugMsgWin:SetHidden(false) 
      end
    else
      -- Nothing...
    end
  elseif cmd == "reset" then
    ADDON.Core.Reset()
  elseif cmd == "test" then
    ADDON.Core.TestLoot(arg1)
  elseif cmd == "scan" then
    ADDON.settings.scan = ADDON.Core.Scan()
  end
end

-- Slash Commands --
SLASH_COMMANDS["/maillooter"] = CommandHandler


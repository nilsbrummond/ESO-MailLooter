
eso_addon_MailLooter = eso_addon_MailLooter or {}
local ADDON = eso_addon_MailLooter

local function CommandHandler(text)
  if text == "" then
    d( ADDON.NAME .. " version " .. ADDON.VERSION )
    d( "Commands:" )
    d( "debug [on/off]  -  Turns debug messages on and off" )
    d( "reset  -  Reset the maillooter in case it is stuck." )
    d( "test  -  Test looting..." )

    return
  elseif text == "debug off" then
    ADDON.SetSetting_debug(false)
  elseif text == "debug on" then
    ADDON.SetSetting_debug(true)
  elseif text == "reset" then
    ADDON.Core.Reset()
  elseif text == "test" then
    ADDON.Core.TestLoot()
  end
end

-- Slash Commands --
SLASH_COMMANDS["/maillooter"] = CommandHandler


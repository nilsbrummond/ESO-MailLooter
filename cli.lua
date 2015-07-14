
eso_addon_MailLooter = eso_addon_MailLooter or {}
local ADDON = eso_addon_MailLooter

local function CommandHandler(text)
  if text == "" then
    d( ADDON.NAME .. " version " .. ADDON.VERSION )
    d( "Commands:" )
    d( "ava         - loot AvA mails" )
    d( "hireling  - loot hireling mails" )
    d( "store      - loot guild store mails" )
    d( "all          - loot all mails but don't delete" )
    d( "show      - show the window" )
    d( "reset      - reset if it got stuck" )
    return
  elseif text == "ava" then
    ADDON.Core.ProcessMailAvA()
  elseif text == "hireling" then
    ADDON.Core.ProcessMailHireling()
  elseif text == "store" then
    ADDON.Core.ProcessMailStore()
  elseif text == "all" then
    ADDON.Core.ProcessMailAll()
  elseif text == "reset" then
    ADDON.Core.Reset()
  end
end

-- Slash Commands --
SLASH_COMMANDS["/maillooter"] = CommandHandler


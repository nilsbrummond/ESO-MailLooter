
local ADDON = eso_addon_MailLooter
ADDON.initialized = false

local function Initialize( eventCode, addOnName )

  if addOnName ~= ADDON.NAME then return end

  ADDON.UI.InitUserInterface()

  ADDON.Core.InitCore(
    ADDON.UI.ListUpdateCB,
    ADDON.UI.StatusUpdateCB,
    ADDON.UI.ScanUpdateCB)

  ADDON.initialized = true
end

local function CommandHandler(text)
  if text == "" then
    d( ADDON.NAME .. " version " .. ADDON.VERSION )
    d( "Commands:" )
    d( "ava         - loot AvA mails" )
    d( "hireling  - loot hireling mails" )
    d( "all          - loot all mails but don't delete" )
    d( "show      - show the window" )
    d( "reset      - reset if it got stuck" )
    return
  elseif text == "ava" then
    ADDON.Core.ProccessMailAvA()
  elseif text == "hireling" then
    ADDON.Core.ProccessMailHireling()
  elseif text == "all" then
    ADDON.Core.ProccessMailAll()
  elseif text == "show" then
    ADDON.UI.ShowDisplay()
  elseif text == "reset" then
    ADDON.Core.Reset()
  end
end

-- Init Hook --
EVENT_MANAGER:RegisterForEvent(
  ADDON.NAME, EVENT_ADD_ON_LOADED, Initialize )

-- Key bindings names --
ZO_CreateStringId("SI_BINDING_NAME_TOGGLE_MAILLOOTER", 
  "Toggle MailLooter Display")

-- Slash Commands --
SLASH_COMMANDS["/maillooter"] = CommandHandler

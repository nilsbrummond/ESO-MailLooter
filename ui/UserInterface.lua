
eso_addon_MailLooter = eso_addon_MailLooter or {}
local ADDON = eso_addon_MailLooter
ADDON.UI = ADDON.UI or {}
local UI = ADDON.UI

UI.debug = true

--
-- Functions
--

local function DEBUG(str)
  if UI.debug then
    d("UI: " .. str)
  end
end

function UI.CoreListUpdateCB(list, complete, itemLink)
  DEBUG("ListUpdateCB")

  if not complete then return end

  d("Gold looted: " .. ADDON.Core.money)

  d("Items looted:")
  for i1,v1 in pairs(list) do
    for i2,v2 in ipairs(v1) do
      d("  " .. GetItemLinkName(v2.link) .. " " .. v2.stack .. " " .. v2.icon )
    end
  end

end

function UI.CoreStatusUpdateCB(inProgess, success, msg)
  DEBUG("StatusUpdateCB")
end

function UI.CoreScanUpdateCB(summary)
  DEBUG("ScanUpdateCB")

  d( "Mail type counts" )
  d( "AvA Mails:      " .. summary.countAvA )
  d( "Hireling Mails: " .. summary.countHireling )
  d( "Store Mails:    " .. summary.countStore )
  d( "COD Mails:      " .. summary.countCOD )
  d( "Other Mails:    " .. summary.countOther )
  d( "More Mail:      " .. tostring(summary.more) )

  -- UI.SummaryFragment.

end

function UI.SceneStateChange(_, newState)
  DEBUG("SceneStateChange " .. newState)

  if newState == SCENE_SHOWING then
    KEYBIND_STRIP:AddKeybindButtonGroup(UI.mailLooterButtonGroup)
    ADDON.Core.OpenMailLooter()
  elseif newState == SCENE_HIDDEN then
    KEYBIND_STRIP:RemoveKeybindButtonGroup(UI.mailLooterButtonGroup)
    ADDON.Core.CloseMailLooter()
  end
end


function UI.InitUserInterface()

  UI.InitSettings()
  UI.SummaryFragment = UI.CreateSummaryFragment()
  UI.LootFragment = UI.CreateLootFragment()
  UI.CreateScene()

  ADDON.Core.NewCallbacks(
    UI.CoreListUpdateCB,
    UI.CoreStatusUpdateCB,
    UI.CoreScanUpdateCB)

end


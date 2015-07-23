
MailLooter = MailLooter or {}
local ADDON = MailLooter
ADDON.UI = ADDON.UI or {}
local UI = ADDON.UI

--
-- Functions
--

-- placeholder
local function DEBUG(str) end

function UI.CoreListUpdateCB(loot, complete, itemLink, isNewItemType)
  local debugOn = DEBUG("ListUpdateCB")

  if complete and debugOn then

    DEBUG("Mails looted: " .. loot.mails)
    DEBUG("Gold looted: " .. loot.money)

    DEBUG("Items looted:")
    for i1,v1 in pairs(loot.items) do
      DEBUG("  " .. GetItemLinkName(v1.link) .. " (" .. v1.stack .. ")" )
    end
  end 

  UI.LootFragUpdateMoney(loot.money)

  if complete then
    
    -- Done...
    UI.summaryLabel:SetText("Done.")
    ADDON.SetSetting_SaveHistory(loot)

  elseif itemLink ~= nil then
    UI.LootFragAddLooted(loot.items[itemLink], isNewItemType)

    UI.LootFragUpdateInv(
      GetNumBagUsedSlots(BAG_BACKPACK),
      GetBagSize(BAG_BACKPACK),
      ADDON.Core.GetSaveDeconSpace())
  end

end

function UI.CoreStatusUpdateCB(inProgress, success, msg)
  DEBUG("StatusUpdateCB")

  KEYBIND_STRIP:UpdateKeybindButtonGroup(UI.mailLooterButtonGroup)

  if inProgress then
    UI.summaryLabel:SetText("Looting...")
  end

end

function UI.CoreScanUpdateCB(summary)
  local debugOn = DEBUG("ScanUpdateCB")

  if debugOn then
    DEBUG( "Mail type counts" )
    DEBUG( "AvA Mails:      " .. summary.countAvA )
    DEBUG( "Hireling Mails: " .. summary.countHireling )
    DEBUG( "Store Mails:    " .. summary.countStore )
    DEBUG( "COD Mails:      " .. summary.countCOD )
    DEBUG( "Other Mails:    " .. summary.countOther )
    DEBUG( "More Mail:      " .. tostring(summary.more) )
    DEBUG( "Total Items:    " .. summary.countItems )
    DEBUG( "Total Money:    " .. summary.countMoney )
  end

  UI.UpdateSummary(summary)

  UI.LootFragUpdateInv(
    GetNumBagUsedSlots(BAG_BACKPACK),
    GetBagSize(BAG_BACKPACK),
    ADDON.Core.GetSaveDeconSpace())

end

function UI.SceneStateChange(_, newState)
  DEBUG("SceneStateChange " .. newState)

  if newState == SCENE_SHOWING then
    KEYBIND_STRIP:AddKeybindButtonGroup(UI.mailLooterButtonGroup)
    UI.LootFragClear()
    ADDON.Core.OpenMailLooter()

    -- NOTE: HACK
    -- Pretty sure there is a better way this is supposed to be handled.
    -- But there is not enough documentation on this stuff...
    -- This is only an issue if you have MailLooter open then switch to 
    -- another non-mail UI screen (notifications, skills, etc) and 
    -- back again.
    ZO_SharedTitleLabel:SetText( GetString(SI_MAIN_MENU_MAIL) )

  elseif newState == SCENE_HIDDEN then
    KEYBIND_STRIP:RemoveKeybindButtonGroup(UI.mailLooterButtonGroup)
    ADDON.Core.CloseMailLooter()
  end
end


function UI.InitUserInterface(debugFunction)

  if debugFunction then
    DEBUG = function(msg) debugFunction("UI: " .. msg) end
  end

  UI.InitSettings()
  UI.SummaryFragment = UI.CreateSummaryFragment()
  UI.LootFragment = UI.CreateLootFragment()
  UI.CreateScene()

  ADDON.Core.NewCallbacks(
    UI.CoreListUpdateCB,
    UI.CoreStatusUpdateCB,
    UI.CoreScanUpdateCB)

end



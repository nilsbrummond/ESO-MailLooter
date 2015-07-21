
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

function UI.CoreListUpdateCB(loot, complete, itemLink, isNewItemType)
  DEBUG("ListUpdateCB")

  if UI.debug and complete then

    d("Mails looted: " .. loot.mails)
    d("Gold looted: " .. loot.money)

    d("Items looted:")
    for i1,v1 in pairs(loot.items) do
      d("  " .. GetItemLinkName(v1.link) .. " (" .. v1.stack .. ")" )
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
  DEBUG("ScanUpdateCB")

  if UI.debug then
    d( "Mail type counts" )
    d( "AvA Mails:      " .. summary.countAvA )
    d( "Hireling Mails: " .. summary.countHireling )
    d( "Store Mails:    " .. summary.countStore )
    d( "COD Mails:      " .. summary.countCOD )
    d( "Other Mails:    " .. summary.countOther )
    d( "More Mail:      " .. tostring(summary.more) )
    d( "Total Items:    " .. summary.countItems )
    d( "Total Money:    " .. summary.countMoney )
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



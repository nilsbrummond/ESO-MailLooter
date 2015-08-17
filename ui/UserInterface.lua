
MailLooter = MailLooter or {}
local ADDON = MailLooter
ADDON.UI = ADDON.UI or {}
local UI = ADDON.UI

--
-- Functions
--

-- placeholder
local function DEBUG(str) end

function UI.CoreListUpdateCB(loot, complete, 
                             item, isNewItemType,
                             moneyMail, isNewMoneyStack)
  local debugOn = DEBUG("ListUpdateCB")

  if complete and debugOn then

    DEBUG("Mails looted: " .. loot.mailCount)
    DEBUG("Gold looted: " .. loot.moneyTotal)

    DEBUG("Items looted:")
    for i1,v1 in ipairs(loot.items) do
      DEBUG("index: " .. i1)
      -- some lists are arrays and some are link keyed.  Don't ipairs().
      for i2,v2 in pairs(loot.items[i1]) do
        DEBUG("  " .. GetItemLinkName(v2.link) .. " (" .. v2.stack .. ")" )
      end
    end

    if loot.moneyTotal > 0 then
      DEBUG("Moneys looted:")
      for i1,v1 in ipairs(loot.moneys) do
        DEBUG("  mt=" .. v1.mailType .. " money (" .. v1.money .. ")") 
      end
    end
  end 

  UI.lootFragment:UpdateMoney(loot.moneyTotal)

  if complete then

    -- Done...
    UI.summaryFragment:UpdateSummarySimple("Done.")
    ADDON.SetSetting_SaveHistory(loot)

  else

    if item ~= nil then
      UI.lootFragment:AddLooted(item, isNewItemType)

      UI.lootFragment:UpdateInv(
        GetNumBagUsedSlots(BAG_BACKPACK),
        GetBagSize(BAG_BACKPACK),
        ADDON.Core.GetSaveDeconSpace())
    end

    if moneyMail ~= nil then
      UI.lootFragment:AddLootedMoney(moneyMail, isNewMoneyStack)
    end

  end

end

function UI.CoreStatusUpdateCB(inProgress, success, msg)
  DEBUG("StatusUpdateCB")

  KEYBIND_STRIP:UpdateKeybindButtonGroup(UI.mailLooterButtonGroup)

  if inProgress then
    UI.summaryFragment:UpdateSummarySimple("Looting...")
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
    DEBUG( "Bounce Mails:   " .. summary.countBounce )
    DEBUG( "More Mail:      " .. tostring(summary.more) )
    DEBUG( "Total Items:    " .. summary.countItems )
    DEBUG( "Total Money:    " .. summary.countMoney )
  end

  UI.summaryFragment:UpdateSummary(summary)

  UI.lootFragment:UpdateInv(
    GetNumBagUsedSlots(BAG_BACKPACK),
    GetBagSize(BAG_BACKPACK),
    ADDON.Core.GetSaveDeconSpace())

end

function UI.SceneStateChange(_, newState)
  DEBUG("SceneStateChange " .. newState)

  if newState == SCENE_SHOWING then
    KEYBIND_STRIP:AddKeybindButtonGroup(UI.mailLooterButtonGroup)
    UI.lootFragment:Clear()
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
    DEBUG = function(msg) return debugFunction("UI: " .. msg) end
  end
  UI.DEBUG = DEBUG

  UI.InitSettings()
  UI.summaryFragment = UI.SummaryFragmentClass:New()
  UI.lootFragment = UI.LootFragmentClass:New()
  UI.CreateScene(UI.summaryFragment, UI.lootFragment)

  ADDON.Core.NewCallbacks(
    UI.CoreListUpdateCB,
    UI.CoreStatusUpdateCB,
    UI.CoreScanUpdateCB)

end



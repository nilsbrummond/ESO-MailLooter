
MailLooter = MailLooter or {}
local ADDON = MailLooter
ADDON.UI = ADDON.UI or {}
local UI = ADDON.UI

UI.currentLoot = false

--
-- Local functions
--

-- placeholder
local function DEBUG(str) end

local function QuickLaunchCmd()
  DEBUG("QuickLaunchCmd cmd=" .. tostring(UI.queuedCommand))

  local mode = UI.queuedCommand

  if mode ~= nil then
    UI.queuedCommand = nil

    if mode == "all" then

      if ADDON.Core.IsIdle() then
        UI.ClearLoot()
        ADDON.Core.ProcessMailAll()
      end

    elseif mode == "filtered" then
      -- TODO: start filtered.
    end
  end
end

--
-- Functions
--

function UI.CoreListUpdateCB(loot, complete, 
                             item, isNewItemType,
                             moneyMail, isNewMoneyStack)
  local debugOn = DEBUG("ListUpdateCB")

  UI.currentLoot = true

  if complete and debugOn then

    DEBUG("Mails looted: " .. loot.mailCount.all)
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

    if loot.mailCount.all == 0 then
      -- Nothing looted: don't require the user to clear.
      UI.ClearLoot()
    end

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

  UI.overviewFragment:Update(loot)

end

function UI.CoreStatusUpdateCB(inProgress, success, msg)
  DEBUG("StatusUpdateCB")

  KEYBIND_STRIP:UpdateKeybindButtonGroup(UI.mailLooterButtonGroup)

  UI.overviewFragment:SetLooting(inProgress)

  if inProgress then
    UI.summaryFragment:UpdateSummarySimple("Looting...")
    UI.filterFragment:SetLocked(true)
  else
    if msg == "Inventory Full" then
      ZO_AlertEvent(EVENT_INVENTORY_IS_FULL, 1, 0)
    end
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

  KEYBIND_STRIP:UpdateKeybindButtonGroup(UI.mailLooterButtonGroup)

  QuickLaunchCmd()

end

function UI.SceneStateChange(_, newState)
  DEBUG("SceneStateChange " .. newState)

  if newState == SCENE_SHOWING then
    KEYBIND_STRIP:AddKeybindButtonGroup(UI.mailLooterButtonGroup)
    ADDON.Core.OpenMailLooter()
    UI.overviewFragment:Showing()

    -- NOTE: HACK
    -- Pretty sure there is a better way this is supposed to be handled.
    -- But there is not enough documentation on this stuff...
    -- This is only an issue if you have MailLooter open then switch to 
    -- another non-mail UI screen (notifications, skills, etc) and 
    -- back again.
    ZO_SharedTitleLabel:SetText( GetString(SI_MAIN_MENU_MAIL) )

  elseif newState == SCENE_SHOWN then
    KEYBIND_STRIP:UpdateKeybindButtonGroup(UI.mailLooterButtonGroup)
  elseif newState == SCENE_HIDDEN then
    KEYBIND_STRIP:RemoveKeybindButtonGroup(UI.mailLooterButtonGroup)
    ADDON.Core.CloseMailLooter()
  end
end

function UI.IsLootShown()
  return UI.currentLoot
end

function UI.ClearLoot()
  UI.currentLoot = false
  UI.lootFragment:Clear()
  UI.overviewFragment:Clear()
  UI.filterFragment:SetLocked(false)

  KEYBIND_STRIP:UpdateKeybindButtonGroup(UI.mailLooterButtonGroup)
end

--
-- Public interface
--

function UI.InitUserInterface(debugFunction)

  if debugFunction then
    DEBUG = function(msg) return debugFunction("UI: " .. msg) end
  end
  UI.DEBUG = DEBUG

  UI.InitSettings()
  UI.summaryFragment = UI.SummaryFragmentClass:New()
  UI.overviewFragment = UI.OverviewFragmentClass:New()
  UI.filterFragment = UI.FilterFragmentClass:New()
  UI.lootFragment = UI.LootFragmentClass:New()
  UI.CreateScene(
    UI.summaryFragment, UI.overviewFragment, 
    UI.filterFragment, UI.lootFragment)

  ADDON.Core.NewCallbacks(
    UI.CoreListUpdateCB,
    UI.CoreStatusUpdateCB,
    UI.CoreScanUpdateCB)

end

-- Open MailLooter and optionally start a command.
function UI.QuickLaunch(mode)

  -- validate mode
  if mode ~= nil then
    if not ((mode == "all") or (mode == "filtered")) then
      mode = nil
    end
  end

  UI.queuedCommand = mode
  if not SCENE_MANAGER:IsShowing("mailLooter") then
    MAIN_MENU:ShowScene("mailLooter")
  else
    QuickLaunchCmd()
  end

end

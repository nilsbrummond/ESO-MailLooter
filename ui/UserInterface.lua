
MailLooter = MailLooter or {}
local ADDON = MailLooter
ADDON.UI = ADDON.UI or {}
local UI = ADDON.UI

UI.currentLoot = false

local filterConvertion = {
  ['ava']         = {1, ADDON.Core.MAILTYPE_AVA},
  ['hireling']    = {1, ADDON.Core.MAILTYPE_HIRELING},
  ['store']       = {1, ADDON.Core.MAILTYPE_STORE},
  ['cod']         = {1, ADDON.Core.MAILTYPE_COD},
  ['returned']    = {1, ADDON.Core.MAILTYPE_RETURNED},
  ['simple']      = {1, ADDON.Core.MAILTYPE_SIMPLE},
  ['codReceipt']  = {1, ADDON.Core.MAILTYPE_COD_RECEIPT},
  
  ['smith']         = {2, CRAFTING_TYPE_BLACKSMITHING},
  ['clothing']      = {2, CRAFTING_TYPE_CLOTHIER},
  ['enchanting']    = {2, CRAFTING_TYPE_ENCHANTING},
  ['provisioning']  = {2, CRAFTING_TYPE_PROVISIONING},
  ['woodworking']   = {2, CRAFTING_TYPE_WOODWORKING},
}

--
-- Local functions
--

local function ConvertFilter(filter)
  local coreFilter = {}
  local coreFilterHirelings = {}

  -- Unused placeholders...
  coreFilter[ADDON.Core.MAILTYPE_UNKNOWN] = false
  coreFilter[ADDON.Core.MAILTYPE_BOUNCE] = false

  -- Default to false
  coreFilter[ADDON.Core.MAILTYPE_AVA] = false
  coreFilter[ADDON.Core.MAILTYPE_HIRELING] = false
  coreFilter[ADDON.Core.MAILTYPE_STORE] = false
  coreFilter[ADDON.Core.MAILTYPE_RETURNED] = false
  coreFilter[ADDON.Core.MAILTYPE_SIMPLE] = false 
  coreFilter[ADDON.Core.MAILTYPE_COD_RECEIPT] = false 
  coreFilter[ADDON.Core.MAILTYPE_COD] = false

  for i,k in ipairs(filter) do

    if k == 'all' then
      coreFilter[ADDON.Core.MAILTYPE_AVA] = true
      coreFilter[ADDON.Core.MAILTYPE_HIRELING] = true
      coreFilter[ADDON.Core.MAILTYPE_STORE] = true
      coreFilter[ADDON.Core.MAILTYPE_RETURNED] = true
      coreFilter[ADDON.Core.MAILTYPE_SIMPLE] = true 
      coreFilter[ADDON.Core.MAILTYPE_COD_RECEIPT] = true 
      coreFilter[ADDON.Core.MAILTYPE_COD] = true
    else
      local con = filterConvertion[k]
      if con[1] == 1 then
        coreFilter[con[2]] = true
      elseif con[1] == 2 then
        coreFilterHirelings[con[2]] = true
      end
    end
  end

  coreFilter.hirelings = coreFilterHirelings

  return coreFilter
end

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
        UI.filterFragment:SetFilter({'all'}, false)
        UI.filterOverride = true
        ADDON.Core.ProcessMailAll()
      end

    elseif mode == "filtered" then
        UI.ClearLoot()
        UI.StartLooting(true)
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


  if complete then

    -- Done...
    UI.summaryFragment:UpdateSummarySimple("Done.")
    ADDON.SetSetting_SaveHistory(loot)

    if loot.mailCount.all == 0 then
      -- Nothing looted: don't require the user to clear.
      UI.ClearLoot()
      
      ZO_Alert(UI_ALERT_CATEGAORY_ALERT, SOUNDS.NEGATIVE_CLICK, 
        GetString(SI_MAILLOOTER_NOTHING_TO_LOOT))

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

    if not UI.currentLoot then
      -- Initialize filter to saved.
      UI.filterFragment:SetFilter(ADDON.GetSetting_filter(), true)
    end

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

  if UI.filterOverride then
    UI.filterOverride = false
    UI.filterFragment:SetFilter(ADDON.GetSetting_filter(), false)
  end

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

function UI.StartLooting(quickLaunch)
  UI.DEBUG("StartLooting")

  local filter = UI.filterFragment:GetFilter()

  if not quickLaunch then 
    ADDON.SetSetting_filter(filter.selected)
  end

  ADDON.Core.ProcessMail(ConvertFilter(filter.selected))
end


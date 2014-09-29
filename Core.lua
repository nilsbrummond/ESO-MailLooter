
local ADDON = eso_addon_MailLooter
ADDON.Core = {}
local CORE = ADDON.Core
CORE.deconSpace = false

local TitlesAvA = { 
  ["Rewards for the Worthy!"] = true,
  ["For the Covenant!"] = true
  -- TODO: Add titles in other languages
}

local TitlesHirelings = {
  ["Raw Materials"] = true, 
  ["Getting Groceries"] = true 
  -- TODO: Add titles in other languages
}

-- TODO: item sold. item expired, item bought, etc...
local TitlesStores = {
  ["Item Expired"] = true,
  ["Item Purchased"] = true,
  ["Item Canceled"] = true,
  ["Item Sold"] = true
  -- TODO: Add titles in other languages
}

local _

CORE.debug = true
CORE.state = nil
CORE.titles = {}
CORE.items = {}
CORE.money = 0
CORE.mails = {}
CORE.currentMail = {}
CORE.currentItems = {}

-- Control modes
CORE.lootItems = true
CORE.lootMoney = true
CORE.deleteAfter = true


local mailboxOpen = false

-- Processing States
local STATE_IDLE   = 0
local STATE_OPEN   = 1
local STATE_UPDATE = 11
local STATE_SCAN   = 2
local STATE_LOOT   = 3
local STATE_ITEMS  = 4
local STATE_MONEY  = 5
local STATE_DELETE = 6
local STATE_CLOSE  = 7

CORE.state = STATE_IDLE


--
-- Functions
--

local function DEBUG(str)
  if CORE.debug then
    d("CORE: " .. str)
  end
end

function CORE.InitCore(listUpdateCB, statusUpdateCB, scanUpdateCB)

  CORE.ListUpdateCB = listUpdateCB
  CORE.StatusUpdateCB = statusUpdateCB
  CORE.ScanUpdateCB = scanUpdateCB

  --if CORE.ListUpdateCB == nil then CORE.ListUpdateCB = function(...) end end
  --if CORE.StatusUpdateCB == nil then CORE.StatusUpdateCB = function(...) end end
  --if CORE.ScanUpdateCB == nil then CORE.ScanUpdateCB = function(...) end end

  --CALLBACK_MANAGER:RegisterCallback(
  --  "MailLooterInteralMailDeleteCmd", DoDeleteCmd)

  EVENT_MANAGER:RegisterForEvent(
    ADDON.NAME, EVENT_MAIL_OPEN_MAILBOX, ADDON.OpenMailboxEvt )
  EVENT_MANAGER:RegisterForEvent(
    ADDON.NAME, EVENT_MAIL_CLOSE_MAILBOX, ADDON.CloseMailboxEvt )
  EVENT_MANAGER:RegisterForEvent(
    ADDON.NAME, EVENT_MAIL_INBOX_UPDATE, ADDON.InboxUpdateEvt )

  EVENT_MANAGER:RegisterForEvent(
    ADDON.NAME, EVENT_MAIL_REMOVED, ADDON.MailRemovedEvt )

  EVENT_MANAGER:RegisterForEvent(
    ADDON.NAME, EVENT_MAIL_TAKE_ATTACHED_ITEM_SUCCESS, ADDON.TakeItemsEvt )
  EVENT_MANAGER:RegisterForEvent(
    ADDON.NAME, EVENT_MAIL_TAKE_ATTACHED_MONEY_SUCCESS, ADDON.TakeMoneyEvt )

  -- What if inventory is full?  some other event?
end

local function AddItemsToHistory()

  for ind,item in ipairs(CORE.currentItems) do

    local name = GetItemLinkName(item.link)

    if CORE.items[name] == nil then
      CORE.items[name] = {}
    end

    table.insert(CORE.items[name], item )
    DEBUG( "MailLooter: " .. tostring(item.link))
    CORE.ListUpdateCB(CORE.items, false, item.link)
  end

  CORE.currentItems = {}

end

local function GetFreeLootSpace()
  local space = GetNumBagFreeSlots(BAG_BACKPACK)

  if CORE.deconSpace then
    if space > 4 then space=space-4 else space=0 end
  end

  return space
end

local function DoDeleteCmd()
  DEBUG( "DoDeleteCmd" )

  if CORE.state ~= STATE_DELETE then return end

  DeleteMail(CORE.currentMail.id, true)
end

local function LootMails()
  DEBUG( "LootMails" )

  CORE.state = STATE_LOOT

  if #CORE.mails == 0 then
    d( "MailLooter complete" )
    CORE.ListUpdateCB(CORE.items, true, nil)
    CORE.StatusUpdateCB(false, true, nil)
    CORE.state = STATE_CLOSE
    CloseMailbox()
    return
  end

  local space = GetFreeLootSpace()

  -- TODO: should call GetMailAttachmentInfo again for up to date info...

  for i,v in ipairs(CORE.mails) do
    if CORE.lootItems and (v.att <= space) then
      CORE.currentMail = v
      table.remove(CORE.mails, i)

      local mailId = CORE.currentMail.id
      CORE.currentItems = {}

      if v.att > 0 then
        for i=1,CORE.currentMail.att do
          local icon, stack, creator = GetAttachedItemInfo(mailId, i)
          local link = GetAttachedItemLink(mailId, i, LINK_STYLE_BRACKETS)

          table.insert(
            CORE.currentItems,
            { icon=icon, stack=stack, creator=creator, link=link })
        end

        DEBUG("items id=" .. Id64ToString(v.id))
        CORE.state = STATE_ITEMS
        TakeMailAttachedItems(v.id)
        return
      elseif CORE.lootMoney and (v.money ~= nil) and (v.money > 0) then
        DEBUG("money id=" .. Id64ToString(v.id))
        CORE.state = STATE_MONEY
        TakeMailAttachedMoney(v.id)
        return
      elseif CORE.deleteAfter then
        DEBUG("delete id=" .. Id64ToString(v.id))
        CORE.state = STATE_DELETE
        DeleteMail(v.id, true)
        return
      else
        -- NOOP
      end
    end
  end

  d ( "No room left in inventory" )
  CORE.ListUpdateCB(CORE.items, true, nil)
  CORE.StatusUpdateCB(false, true, nil)
  CORE.state = STATE_CLOSE
  CloseMailbox()
end

local function ScanMail()

  DEBUG( "ScanMail" )

  CORE.state = STATE_SCAN

  local id = GetNextMailId(nil)

  while id ~= nil do
   
    local _, _, subject, icon, unread, fromSystem, fromCustomerService, returned, numAttachments, attachedMoney, codAmount, expiresInDays, secsSinceReceived = GetMailItemInfo(id)

    if (codAmount == 0) and ((CORE.titles == nil) or (CORE.titles[subject] ~= nil)) then
      -- Loot this Mail
      DEBUG( "found mail: " .. Id64ToString(id) .. " '" .. 
             subject .. "' " .. numAttachments .. " " .. (secsSinceReceived/60))
      table.insert(
        CORE.mails, 
        { id=id, att=numAttachments, money=attachedMoney } )
    end

    id = GetNextMailId(id)
  end

  if #CORE.mails == 0 then
    d( "MailLooter sees no mails to loot" )
    CORE.ListUpdateCB(CORE.items, true, nil)
    CORE.StatusUpdateCB(false, true, nil)
    CORE.state = STATE_CLOSE
    CloseMailbox()
  else
    LootMails()
  end

end

local function SummaryScanMail()

  DEBUG( "SummaryScanMail" )

  local countAvA = 0
  local countHireling = 0
  local countCOD = 0
  local countStore = 0
  local countOther = 0

  local id = GetNextMailId(nil)
  while id ~= nil do
    local _, _, subject, icon, unread, fromSystem, fromCustomerService, returned, numAttachments, attachedMoney, codAmount, expiresInDays, secsSinceReceived = GetMailItemInfo(id)

    if codAmount > 0 then
      countCOD = countCOD + 1
    elseif TitlesAvA[subject] then
      countAvA = countAvA + 1
    elseif TitlesHirelings[subject] then
      countHireling = countHireling + 1
    elseif TitlesStores[subject] then
      countStore = countStore + 1
    else
      countOther = countOther + 1
    end

    id = GetNextMailId(id)
  end

  local result = { countAvA = countAvA, countHireling=countHireling, 
                   countCOD = countCOD, countStore = countStore,
                   countOther = countOther, more = IsLocalMailboxFull() }

  CORE.ScanUpdateCB(result)

end

local function Start()
  DEBUG( "Start" )

  CORE.items = {}
  CORE.money = 0
  CORE.mails = {}
  CORE.currentMail = {}
  CORE.state = STATE_OPEN

  if CORE.lootItems and (GetFreeLootSpace() == 0) then
    d( "No free space in inventory" )
    CORE.ListUpdateCB(CORE.items, true, nil)
    CORE.StatusUpdateCB(false, false, "No free space in inventory")
    CORE.state = STATE_IDLE
    return
  end

  CORE.StatusUpdateCB(true, true, nil)

  if not mailboxOpen then
    RequestOpenMailbox()
  else
    ScanMail()
  end
end

function ADDON.OpenMailboxEvt( eventCode )

  DEBUG( "OpenMailbox" )
  mailboxOpen = true

  if CORE.state == STATE_OPEN then
    CORE.state = STATE_UPDATE
  end

end

function ADDON.CloseMailboxEvt( eventCode )
  DEBUG( "CloseMailbox state=" .. CORE.state)
  mailboxOpen = false

  if CORE.state == STATE_CLOSE then
    CORE.state = STATE_IDLE
    d( "MailLooter closed" )
  elseif CORE.state ~= STATE_IDLE then
    -- FIXME - Error!!
    CORE.state = STATE_IDLE
    d("MailLooter error!  Mailbox closed.")
  end

end

function ADDON.InboxUpdateEvt( eventCode )
  DEBUG( "InboxUpdate state=" .. CORE.state )

  SummaryScanMail()

  if CORE.state == STATE_UPDATE then
    ScanMail()
  end
end

function ADDON.MailRemovedEvt( eventCode, mailId )
  DEBUG( "MailRemoved state=" .. CORE.state )

  if CORE.state ~= STATE_DELETE then return end

  if (CORE.currentMail.id == mailId) then
    CORE.currentMail = nil
    LootMails()
  end

end

function ADDON.TakeItemsEvt( eventCode, mailId )
  DEBUG( "TakeItems state=" .. CORE.state )

  if CORE.state ~= STATE_ITEMS then return end

  if CORE.currentMail.id == mailId then
    AddItemsToHistory()

    if CORE.lootMoney and (CORE.currentMail.money ~= nil) and (CORE.currentMail.money > 0) then
      CORE.state = STATE_MONEY
      TakeMailAttachedMoney(CORE.currentMail.id)
    elseif CORE.deleteAfter then
      CORE.state = STATE_DELETE
      DeleteMail(CORE.currentMail.id, true)
    else
      CORE.currentMail = nil
      LootMails()
    end
  end

end

function ADDON.TakeMoneyEvt( eventCode, mailId )
  DEBUG( "TakeMoney state=" .. CORE.state )

  if CORE.state ~= STATE_MONEY then return end

  if (CORE.currentMail.id == mailId) then
    CORE.money = CORE.money + CORE.currentMail.money

    if CORE.deleteAfter then
      CORE.state = STATE_DELETE
      zo_callLater(DoDeleteCmd(), 1)
      --CALLBACK_MANAGER:FireCallbacks("MailLooterInteralMailDeleteCmd", mailId)
      --DeleteMail(CORE.currentMail.id, true)
    else
        CORE.currentMail = nil
        LootMails()
    end
  end

  DEBUG( "TakeMoney end" )
end


function CORE.ProccessMailAvA()

  if CORE.state ~= STATE_IDLE then 
    d( "MailLooter is currently running" )
    return
  end

  d( "MailLooter starting AvA loot" )

  CORE.titles = TitlesAvA
  CORE.lootItems = true
  CORE.lootMoney = true
  CORE.deleteAfter = true
  Start()
  
end

function CORE.ProccessMailHireling()

  if CORE.state ~= STATE_IDLE then 
    d( "MailLooter is currently running" )
    return
  end
  
  d( "MailLooter starting Hireling loot" )

  CORE.titles = TitlesHirelings
  CORE.lootItems = true
  CORE.lootMoney = true
  CORE.deleteAfter = true
  Start()

end

function CORE.ProccessMailStore()

  if CORE.state ~= STATE_IDLE then 
    d( "MailLooter is currently running" )
    return
  end

  d( "MailLooter starting store loot" )

  CORE.titles = TitlesStores
  CORE.lootItems = true
  CORE.lootMoney = true
  CORE.deleteAfter = true
  Start()

end

function CORE.ProccessMailAll()

  if CORE.state ~= STATE_IDLE then 
    d( "MailLooter is currently running" )
    return
  end
  
  d( "MailLooter starting all loot" )

  CORE.titles = nil
  CORE.lootItems = true
  CORE.lootMoney = true
  CORE.deleteAfter = true
  Start()

end

function CORE.Reset()
  d( "MailLooter reset" )
  CORE.state = STATE_IDLE
end

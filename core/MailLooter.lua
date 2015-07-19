

eso_addon_MailLooter = eso_addon_MailLooter or {}
local ADDON = eso_addon_MailLooter
ADDON.Core = ADDON.Core or {}
local CORE = ADDON.Core


local TitlesAvA = { 
  ["Rewards for the Worthy!"] = true,
  ["For the Covenant!"] = true  -- TODO: Need AD and EP versions too

  -- TODO: Add titles in other languages
}

local TitlesHirelings = {
  ["Raw Blacksmith Materials"] = true, 
  ["Raw Woodworker Materials"] = true, 
  ["Raw Clothier Materials"] = true, 
  ["Raw Enchanter Materials"] = true, 
  ["Raw Provisioner Materials"] = true,
  ["Getting Groceries"] = true   -- TODO: is this one obsolete?

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

CORE.deconSpace = false

CORE.initialized = false
CORE.debug = true
CORE.state = nil
CORE.loot = {items={}, money=0, mails=0}
CORE.currentMail = {}
CORE.currentItems = {}

CORE.callbacks = nil


local mailboxOpen = false
local mailLooterOpen = false

-- Processing States
local STATE_IDLE   = 0
local STATE_OPEN   = 1
local STATE_UPDATE = 11
local STATE_SCAN   = 2
local STATE_READ   = 3
local STATE_LOOT   = 4
local STATE_ITEMS  = 5
local STATE_MONEY  = 6
local STATE_DELETE = 7
local STATE_CLOSE  = 8

CORE.state = STATE_IDLE

-- MAIL_TYPE
local MAILTYPE_UNKNOWN  = 0
local MAILTYPE_AVA      = 1
local MAILTYPE_HIRELING = 2
local MAILTYPE_STORE    = 3
local MAILTYPE_COD      = 4

CORE.filters = {}
CORE.filters[MAILTYPE_UNKNOWN] = false
CORE.filters[MAILTYPE_AVA] = true
CORE.filters[MAILTYPE_HIRELING] = true
CORE.filters[MAILTYPE_STORE] = true
CORE.filters[MAILTYPE_COD] = true

--
-- Local Functions
--

local function DEBUG(str)
  if CORE.debug then
    d("MailLooter: " .. str)
  end
end

-- Detect the type of a mail message.
local function GetMailType(subject, fromSystem, codAmount)

  if fromSystem then
    if TitlesAvA[subject] then
      return MAILTYPE_AVA
    elseif TitlesHirelings[subject] then
      return MAILTYPE_HIRELING
    elseif TitlesStores[subject] then
      return MAILTYPE_STORE
    end
  else
    if codAmount > 0 then
      return MAILTYPE_COD
    end
  end

  return MAILTYPE_UNKNOWN
end

-- Return based on mailType and type filter.
local function LootThisMail(mailType)
 
  return CORE.filters[mailType]

end

local function GetFreeLootSpace()
  local space = GetNumBagFreeSlots(BAG_BACKPACK)

  if CORE.deconSpace then
    if space > 4 then space=space-4 else space=0 end
  end

  return space
end


local function IsRoomToLoot(mailId, numAtt)

  -- NOTE: Testing seems to show that you can not loot items that will
  --       stack unless at least one inventory space is open.
  if GetNumBagFreeSlots(BAG_BACKPACK) == 0 then return false end


  local space = GetFreeLootSpace()

  -- Easy case: there is room
  DEBUG("   numAtt: " .. numAtt .. " space: " .. space)
  if (numAtt <= space) then return true end

  -- harder case: see if items will stack
  local roomNeeded = 0

  for i=1,numAtt do
    local link = GetAttachedItemLink(mailId, i, LINK_STYLE_BRACKETS)

    if IsItemLinkStackable(link) then
      -- Stackable Item
      local _, stack = GetAttachedItemInfo(mailId, i)
      local stackCountBackpack = GetItemLinkStacks(link)

      if (stackCountBackpack == 0) then
        -- No item in backpack to stack with.
        DEBUG("No stacks for: " .. link)
        roomNeeded = roomNeeded + 1
      else
        -- We now might be able to stack.  To do this right we need to search 
        -- the backpack for the matching link?  And use:
        -- stack, maxStack = GetSlotStackSize(BAG_BACKPACK, slotIndex)
        -- to get the max stack size.
        --
        -- HACK: for now assume a max stack size of 200.
        --
        stackCountBackpack = stackCountBackpack % 200
        if (stackCountBackpack == 0) or 
           ((stack + stackCountBackpack) > 200) then

          DEBUG("Can not stack with: " .. link)
          roomNeeded = roomNeeded + 1

        else
          DEBUG("Will stack: " .. link .. 
                " s: " .. stack .. 
                " i: " .. stackCountBackpack)
        end
      end
    else
      -- NOT Stackable Item
      DEBUG("Not stackable: " .. link)
      roomNeeded = roomNeeded + 1
    end
  end

  DEBUG("   roomNeeded: " .. roomNeeded .. " space: " .. space)
  return (roomNeeded <= space)

end

local function AddItemsToHistory()

  for ind,item in ipairs(CORE.currentItems) do

    local name = GetItemLinkName(item.link)

    if CORE.loot.items[item.link] == nil then
      CORE.loot.items[item.link] = item
    else
      CORE.loot.items[item.link].stack = CORE.loot.items[item.link].stack + item.stack
    end

    DEBUG( "MailLooter: " .. tostring(item.link))
    CORE.callbacks.ListUpdateCB(CORE.loot, false, item.link)
  end

  CORE.currentItems = {}

end

local function DoDeleteCmd()
  DEBUG( "DoDeleteCmd" )

  if CORE.state ~= STATE_DELETE then return end
  DeleteMail(CORE.currentMail.id, true)
end

local function SummaryScanMail()

  DEBUG( "SummaryScanMail" )

  local countAvA = 0
  local countHireling = 0
  local countCOD = 0
  local countStore = 0
  local countOther = 0
  local countItems = 0
  local countMoney = 0

  local id = GetNextMailId(nil)
  while id ~= nil do
    local sdn, scn, subject, icon, unread, fromSystem, fromCustomerService, returned, numAttachments, attachedMoney, codAmount, expiresInDays, secsSinceReceived = GetMailItemInfo(id)

    -- DEBUG(" -- Mail:" .. Id64ToString(id) .. " " .. subject .. " from:"..sdn.."/"..scn .. " sys:" .. tostring(fromSystem) .. " cs:"..tostring(fromCustomerService))

    countItems = countItems + numAttachments
    countMoney = countMoney + attachedMoney

    if codAmount > 0 then
      countCOD = countCOD + 1
      countMoney = countMoney + codAmount
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

  CORE.callbacks.ScanUpdateCB(result)

end

-- This function will loot zero to one mails.  Zero if there is no
-- room or no mail.  If there is a valid mail to loot then it will
-- be the loot process.
local function LootMails()
  DEBUG( "LootMails" )

  CORE.state = STATE_LOOT

  local failedNoSpace = false
  local id = GetNextMailId(nil)

  while id ~= nil do

    local _, _, subject, icon, unread, fromSystem, fromCustomerService, returned, numAttachments, attachedMoney, codAmount, expiresInDays, secsSinceReceived = GetMailItemInfo(id)

    local mailType = GetMailType(subject, fromSystem, codAmount)

    if LootThisMail(mailType) then

      -- Loot this Mail
      DEBUG( "found mail: " .. Id64ToString(id) .. " '" .. 
             subject .. "' " .. numAttachments .. " " .. (secsSinceReceived/60))

      CORE.currentMail = { id=id, att=numAttachments, money=attachedMoney }
      local v = CORE.currentMail

      local doItemLoot = false
      if (v.att > 0) then
        if IsRoomToLoot(id, v.att) then
          doItemLoot = true
        else
          failedNoSpace = true
        end
      end

      if doItemLoot then
        CORE.loot.mails = CORE.loot.mails + 1

        CORE.currentItems = {}

        for i=1,CORE.currentMail.att do
          local icon, stack, creator = GetAttachedItemInfo(id, i)
          local link = GetAttachedItemLink(id, i, LINK_STYLE_BRACKETS)

          table.insert(
            CORE.currentItems,
            { icon=icon, stack=stack, creator=creator, link=link })
        end

        DEBUG("items id=" .. Id64ToString(id))
        CORE.state = STATE_READ
        -- NOTE: Seems reading the mail help with getting items more reliably.
        RequestReadMail(id)
        return
      elseif (v.money ~= nil) and (v.money > 0) then
        DEBUG("money id=" .. Id64ToString(id))
        CORE.loot.mails = CORE.loot.mails + 1
        CORE.state = STATE_MONEY
        TakeMailAttachedMoney(id)
        return
      elseif v.att == 0 then 
        -- DELETE
        -- player may have manually looted and not deleted it.
        DEBUG("delete id=" .. Id64ToString(id))
        CORE.loot.mails = CORE.loot.mails + 1
        CORE.state = STATE_DELETE
        DeleteMail(id, true)
        return
      else
        -- NOOP
      end
    end

    CORE.currentMail = nil
    id = GetNextMailId(id)

  end

  if failedNoSpace then
    DEBUG ( "No room left in inventory" )
    CORE.callbacks.ListUpdateCB(CORE.loot, true, nil)
    CORE.state = STATE_IDLE
    CORE.callbacks.StatusUpdateCB(false, false, "Inventory Full")
    SummaryScanMail()
  else
    DEBUG ( "Done" )
    CORE.callbacks.ListUpdateCB(CORE.loot, true, nil)
    CORE.state = STATE_IDLE
    CORE.callbacks.StatusUpdateCB(false, true, nil)
    SummaryScanMail()
  end
end

local function LootMailsCont()
  DEBUG( "LootMailsCont" )

  CORE.state = STATE_ITEMS
  -- BUG: Why does this sometimes fail???
  -- Work around: load the mail to be read first.
  TakeMailAttachedItems(CORE.currentMail.id)

end

local function Start(filter)
  DEBUG( "Start" )

  if CORE.state ~= STATE_IDLE then
    CORE.callbacks.StatusUpdateCB(false, false, "Core Not Ready")
    return
  end

  CORE.filters = filter

  CORE.loot = { items = {}, money = 0, mails = 0 }
  CORE.currentMail = {}

  CORE.callbacks.StatusUpdateCB(true, true, nil)

  LootMails()

end

--
-- Event Handler Functions
--

function CORE.OpenMailboxEvt( eventCode )

  DEBUG( "OpenMailbox" )
  mailboxOpen = true
  
  if mailLooterOpen then
    if CORE.state == STATE_OPEN then
      CORE.state = STATE_UPDATE
    end
  end

end

function CORE.CloseMailboxEvt( eventCode )

  DEBUG( "CloseMailbox state=" .. CORE.state)
  mailboxOpen = false

  if CORE.state == STATE_CLOSE then
    CORE.state = STATE_IDLE
    DEBUG( "MailLooter closed" )
  elseif mailLooterOpen then
    if CORE.state ~= STATE_IDLE then
      -- FIXME - Error!!
      CORE.state = STATE_IDLE
      DEBUG("MailLooter error!  Mailbox closed.")
      CORE.callbacks.StatusUpdateCB(false, false, "Mailbox Closed")
    end
  end

end

function CORE.InboxUpdateEvt( eventCode )
  DEBUG( "InboxUpdate state=" .. CORE.state )

  if mailLooterOpen then
    if (CORE.state == STATE_IDLE) or
       (CORE.state == STATE_UPDATE) then
      
      CORE.state = STATE_IDLE
      SummaryScanMail()
    end
  end
end

function CORE.MailReadableEvt( eventCode, mailId)
  DEBUG( "MailReadable state=" .. CORE.state .. " id=" .. Id64ToString(mailId) )

  if mailLooterOpen then
    if (CORE.state == STATE_READ) and (CORE.currentMail.id == mailId) then
        LootMailsCont()
    end
  end

end

function CORE.MailRemovedEvt( eventCode, mailId )
  DEBUG( "MailRemoved state=" .. CORE.state .. " id=" .. Id64ToString(mailId) )

  if mailLooterOpen then
    if CORE.state ~= STATE_DELETE then return end

    if (CORE.currentMail.id == mailId) then
      CORE.currentMail = nil
      LootMails()
    end
  end

  DEBUG( "MailRemoved end" )
end

function CORE.TakeItemsEvt( eventCode, mailId )
  DEBUG( "TakeItems state=" .. CORE.state )

  if mailLooterOpen then
    if CORE.state ~= STATE_ITEMS then return end

    if CORE.currentMail.id == mailId then
      AddItemsToHistory()

      if (CORE.currentMail.money ~= nil) and (CORE.currentMail.money > 0) then
        CORE.state = STATE_MONEY
        TakeMailAttachedMoney(CORE.currentMail.id)
      else
        CORE.state = STATE_DELETE
        DeleteMail(CORE.currentMail.id, true)
      end
    end
  end

  DEBUG( "TakeItems end" )
end

function CORE.TakeMoneyEvt( eventCode, mailId )
  DEBUG( "TakeMoney state=" .. CORE.state )

  if mailLooterOpen then
    if CORE.state ~= STATE_MONEY then return end

    if (CORE.currentMail.id == mailId) then
      CORE.loot.money = CORE.loot.money + CORE.currentMail.money

      CORE.state = STATE_DELETE
      zo_callLater(DoDeleteCmd, 1)
      --DeleteMail(CORE.currentMail.id, true)
    end
  end

  DEBUG( "TakeMoney end" )
end

function CORE.InventoryFullEvt( eventCode, numSlotsReq, numSlotFree )
  DEBUG( "InventoryFull state=" .. CORE.state )

  if mailLooterOpen then
    if CORE.state ~= STATE_ITEMS then return end

    -- Must match the number of items we are looting.
    if numSlotReq ~= CORE.currentMail.att then return end

    -- This is now PROBABLY in response to our take item request.

    -- Need to fail.  Trying again will lead to an infinite loop.
    DEBUG( "Inventory full ERROR!" )
    CORE.state = STATE_IDLE
    CORE.callbacks.StatusUpdateCB(false, false, "Inventory Full")
    SummaryScanMail()
  end

  DEBUG( "InventoryFull end" )
end

--
-- Public Functions
--

-- This function must be called from the client ADDON's 
-- EVENT_ADD_ON_LOADED handler.
function CORE.Initialize(saveDeconSpace)

  if CORE.initialized then return end -- exit if already init'd.

  CORE.initialized = true

  CORE.deconSpace = saveDeconSpace

  EVENT_MANAGER:RegisterForEvent(
    ADDON.NAME, EVENT_MAIL_OPEN_MAILBOX, CORE.OpenMailboxEvt )
  EVENT_MANAGER:RegisterForEvent(
    ADDON.NAME, EVENT_MAIL_CLOSE_MAILBOX, CORE.CloseMailboxEvt )
  EVENT_MANAGER:RegisterForEvent(
    ADDON.NAME, EVENT_MAIL_INBOX_UPDATE, CORE.InboxUpdateEvt )
  EVENT_MANAGER:RegisterForEvent(
    ADDON.NAME, EVENT_MAIL_READABLE, CORE.MailReadableEvt )

  EVENT_MANAGER:RegisterForEvent(
    ADDON.NAME, EVENT_MAIL_REMOVED, CORE.MailRemovedEvt )

  EVENT_MANAGER:RegisterForEvent(
    ADDON.NAME, EVENT_MAIL_TAKE_ATTACHED_ITEM_SUCCESS, CORE.TakeItemsEvt )
  EVENT_MANAGER:RegisterForEvent(
    ADDON.NAME, EVENT_MAIL_TAKE_ATTACHED_MONEY_SUCCESS, CORE.TakeMoneyEvt )

  EVENT_MANAGER:RegisterForEvent(
    ADDON.NAME, EVENT_INVENTORY_IS_FULL, CORE.InventoryFullEvt )

end

-- Call to start a MailLooter session.
function CORE.OpenMailLooter()

  mailLooterOpen = true

  if not mailboxOpen then
    CORE.state = STATE_OPEN
    RequestOpenMailbox()
  else
    CORE.state = STATE_IDLE
    SummaryScanMail()
  end
end

-- Call to end a MailLooter session.
function CORE.CloseMailLooter()
  if mailLooterOpen then
    mailLooterOpen = false
    CORE.state = STATE_CLOSE
    CloseMailbox()
  else
    CORE.state = STATE_CLOSE
  end
end

-- Set to true to reserve 4 inventory spaces that are needed to do deconstucts.
function CORE.SetSaveDeconSpace(val)
  CORE.deconSpace = val
end

-- Register callbacks with the Core.
--
-- listUpdateCB
--   This callback informs the upper layer of the items looted from 
--   the mailbox.  It is call for each item looted from mail, and then
--   once when the looting is complete.  The last time will have 
--   isDone=true and itemLink=nil.
--
--   function listUpdateCB(itemTable = {items ={[link] -> {icon, stack, creator, link}}, money, mails}, isDone, itemLink)
--
-- statusUpdateCB
--
--   function statusUpdateCB(inProgress, success, msg)
--
-- scanUpdateCB
--
--   function scanUpdateCB(summary = {countAVA, countHireling, countStore, countCOD, countOther, more})
--
function CORE.NewCallbacks(listUpdateCB, statusUpdateCB, scanUpdateCB)

  local s = {}
  s.ListUpdateCB = listUpdateCB
  s.StatusUpdateCB = statusUpdateCB
  s.ScanUpdateCB = scanUpdateCB

  CORE.callbacks = s

end


-- Start looting the mailbox.
function CORE.ProcessMailAll()

  if CORE.state ~= STATE_IDLE then 
    DEBUG( "MailLooter is currently running" )
    return
  end
 
  local filter = {}
  filter[MAILTYPE_UNKNOWN] = false
  filter[MAILTYPE_AVA] = true
  filter[MAILTYPE_HIRELING] = true
  filter[MAILTYPE_STORE] = true
  filter[MAILTYPE_COD] = true

  DEBUG( "MailLooter starting all loot" )
  Start(filter)

end

-- New Version
-- Start looting the mailbox.
-- Allows filtering on mail type.
function CORE.ProcessMail(filter)
end

-- Attempt to recover from a failure, or cancel an ongoing looting.
function CORE.Reset()
  DEBUG( "MailLooter reset" )

  if mailLooterOpen then
    CORE.state = STATE_IDLE
    CORE.callbacks.StatusUpdateCB(false, false, "Cancel")
    SummaryScanMail()
  end
end

-- Returns true if the core is ready for a command.
function CORE.IsIdle()
  return CORE.state == STATE_IDLE
end

-- Returns true if the core is ready to perform a mailbox looting.
function CORE.IsActionReady()

  if (CORE.state == STATE_IDLE) and 
     (GetNumMailItems() > 0)
  then
    return true
  end

  return false
end


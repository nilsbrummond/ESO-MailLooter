

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

CORE.deconSpace = false

CORE.initialized = false
CORE.debug = true
CORE.state = nil
CORE.titles = {}
CORE.fromSystemOnly = false
CORE.items = {}
CORE.money = 0
CORE.currentMail = {}
CORE.currentItems = {}

CORE.callbacks = nil

-- Control modes
CORE.lootItems = true
CORE.lootMoney = true
CORE.deleteAfter = true


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

--
-- Functions
--

local function DEBUG(str)
  if CORE.debug then
    d("MailLooter: " .. str)
  end
end

-- This function must be called from the client ADDON's 
-- EVENT_ADD_ON_LOADED handler.
function CORE.Initialize(saveDeconSpace)

  if CORE.initialized then return end -- exit if already init'd.
  
  CORE.initialized = true

  CORE.deconSpace = saveDeconSpace

  EVENT_MANAGER:RegisterForEvent(
    LIB_NAME, EVENT_MAIL_OPEN_MAILBOX, CORE.OpenMailboxEvt )
  EVENT_MANAGER:RegisterForEvent(
    LIB_NAME, EVENT_MAIL_CLOSE_MAILBOX, CORE.CloseMailboxEvt )
  EVENT_MANAGER:RegisterForEvent(
    LIB_NAME, EVENT_MAIL_INBOX_UPDATE, CORE.InboxUpdateEvt )
  EVENT_MANAGER:RegisterForEvent(
    LIB_NAME, EVENT_MAIL_READABLE, CORE.MailReadableEvt )

  EVENT_MANAGER:RegisterForEvent(
    LIB_NAME, EVENT_MAIL_REMOVED, CORE.MailRemovedEvt )

  EVENT_MANAGER:RegisterForEvent(
    LIB_NAME, EVENT_MAIL_TAKE_ATTACHED_ITEM_SUCCESS, CORE.TakeItemsEvt )
  EVENT_MANAGER:RegisterForEvent(
    LIB_NAME, EVENT_MAIL_TAKE_ATTACHED_MONEY_SUCCESS, CORE.TakeMoneyEvt )

end

function CORE.OpenMailLooter()

  mailLooterOpen = true

  if not mailboxOpen then
    RequestOpenMailbox()
  else
    ScanMail()
  end
end

function CORE.CloseMailLooter()
  if mailLooterOpen then
    mailLooterOpen = false
    CORE.state = STATE_CLOSE
    CloseMailbox()
  end
end

function CORE.SetSaveDeconSpace(val)
  CORE.deconSpace = val
end

function CORE.NewCallbacks(listUpdateCB, statusUpdateCB, scanUpdateCB)

  local s = {}
  s.ListUpdateCB = listUpdateCB
  s.StatusUpdateCB = statusUpdateCB
  s.ScanUpdateCB = scanUpdateCB

  CORE.callbacks = s

end

local function AddItemsToHistory()

  for ind,item in ipairs(CORE.currentItems) do

    local name = GetItemLinkName(item.link)

    if CORE.items[name] == nil then
      CORE.items[name] = {}
    end

    table.insert(CORE.items[name], item )
    DEBUG( "MailLooter: " .. tostring(item.link))
    CORE.callbacks.ListUpdateCB(CORE.items, false, item.link)
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

local function SummaryScanMail()

  DEBUG( "SummaryScanMail" )

  local countAvA = 0
  local countHireling = 0
  local countCOD = 0
  local countStore = 0
  local countOther = 0

  local id = GetNextMailId(nil)
  while id ~= nil do
    local sdn, scn, subject, icon, unread, fromSystem, fromCustomerService, returned, numAttachments, attachedMoney, codAmount, expiresInDays, secsSinceReceived = GetMailItemInfo(id)

    -- DEBUG(" -- Mail:" .. Id64ToString(id) .. " " .. subject .. " from:"..sdn.."/"..scn .. " sys:" .. tostring(fromSystem) .. " cs:"..tostring(fromCustomerService))

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

  CORE.callbacks.ScanUpdateCB(result)

end


local function LootMails()
  DEBUG( "LootMails" )

  CORE.state = STATE_LOOT

  local count = 0
  local space = GetFreeLootSpace()
  local id = GetNextMailId(nil)

  while id ~= nil do

    local _, _, subject, icon, unread, fromSystem, fromCustomerService, returned, numAttachments, attachedMoney, codAmount, expiresInDays, secsSinceReceived = GetMailItemInfo(id)

    if (codAmount == 0) and 
       ( (not CORE.fromSystemOnly) or fromSystem ) and 
       ((CORE.titles == nil) or (CORE.titles[subject] ~= nil))
    then
      -- Loot this Mail
      DEBUG( "found mail: " .. Id64ToString(id) .. " '" .. 
             subject .. "' " .. numAttachments .. " " .. (secsSinceReceived/60))

      count = count + 1

      CORE.currentMail = { id=id, att=numAttachments, money=attachedMoney }
      local v = CORE.currentMail

      if CORE.lootItems and (v.att > 0) and (v.att <= space) then

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
        RequestReadMail(id)
        return
      elseif CORE.lootMoney and (v.money ~= nil) and (v.money > 0) then
        DEBUG("money id=" .. Id64ToString(id))
        CORE.state = STATE_MONEY
        TakeMailAttachedMoney(id)
        return
      elseif CORE.deleteAfter then
        DEBUG("delete id=" .. Id64ToString(id))
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

  if count > 0 then
    DEBUG ( "No room left in inventory" )
    CORE.callbacks.ListUpdateCB(CORE.items, true, nil)
    CORE.callbacks.StatusUpdateCB(false, true, nil)
    CORE.state = STATE_IDLE
    SummaryScanMail()
  else
    DEBUG ( "Done" )
    CORE.callbacks.ListUpdateCB(CORE.items, true, nil)
    CORE.callbacks.StatusUpdateCB(false, true, nil)
    CORE.state = STATE_IDLE
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

local function ScanMail()

  DEBUG( "ScanMail" )

  CORE.state = STATE_SCAN

  local count = 0
  local id = GetNextMailId(nil)

  while id ~= nil do

    local _, _, subject, icon, unread, fromSystem, fromCustomerService, returned, numAttachments, attachedMoney, codAmount, expiresInDays, secsSinceReceived = GetMailItemInfo(id)

    if (codAmount == 0) and ((CORE.titles == nil) or (CORE.titles[subject] ~= nil)) then
      -- Loot this Mail
      DEBUG( "found mail: " .. Id64ToString(id) .. " '" .. 
             subject .. "' " .. numAttachments .. " " .. (secsSinceReceived/60))

      count = count + 1
    end

    id = GetNextMailId(id)
  end

  if count == 0 then
    DEBUG( "MailLooter sees no mails to loot" )
    CORE.callbacks.ListUpdateCB(CORE.items, true, nil)
    CORE.callbacks.StatusUpdateCB(false, true, nil)
    CORE.state = STATE_IDLE
  else
    LootMails()
  end

end

local function Start()
  DEBUG( "Start" )

  CORE.items = {}
  CORE.money = 0
  CORE.currentMail = {}
  CORE.state = STATE_OPEN

  if CORE.lootItems and (GetFreeLootSpace() == 0) then
    d( "No free space in inventory" )
    CORE.callbacks.ListUpdateCB(CORE.items, true, nil)
    CORE.callbacks.StatusUpdateCB(false, false, "No free space in inventory")
    CORE.state = STATE_IDLE
    return
  end

  CORE.callbacks.StatusUpdateCB(true, true, nil)

  if not mailboxOpen then
    RequestOpenMailbox()
  else
    ScanMail()
  end
end

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

  if mailLooterOpen then
    if CORE.state == STATE_CLOSE then
      CORE.state = STATE_IDLE
      d( "MailLooter closed" )
    elseif CORE.state ~= STATE_IDLE then
      -- FIXME - Error!!
      CORE.state = STATE_IDLE
      d("MailLooter error!  Mailbox closed.")
    end
  end

end

function CORE.InboxUpdateEvt( eventCode )
  DEBUG( "InboxUpdate state=" .. CORE.state )

  if mailLooterOpen then
    SummaryScanMail()

    if CORE.state == STATE_UPDATE then
      ScanMail()
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

  DEBUG( "TakeItems end" )
end

function CORE.TakeMoneyEvt( eventCode, mailId )
  DEBUG( "TakeMoney state=" .. CORE.state )

  if mailLooterOpen then
    if CORE.state ~= STATE_MONEY then return end

    if (CORE.currentMail.id == mailId) then
      CORE.money = CORE.money + CORE.currentMail.money

      if CORE.deleteAfter then
        CORE.state = STATE_DELETE
        zo_callLater(DoDeleteCmd, 1)
        --DeleteMail(CORE.currentMail.id, true)
      else
          CORE.currentMail = nil
          LootMails()
      end
    end
  end

  DEBUG( "TakeMoney end" )
end

function CORE.ProcessMailAll()

  if CORE.state ~= STATE_IDLE then 
    d( "MailLooter is currently running" )
    return
  end
  
  d( "MailLooter starting all loot" )

  CORE.titles = nil
  CORE.fromSystemOnly = false
  CORE.lootItems = true
  CORE.lootMoney = true
  CORE.deleteAfter = true
  Start()

end

function CORE.Reset()
  d( "MailLooter reset" )
  CORE.state = STATE_IDLE
end

function CORE.IsIdle()
  return CORE.state == STATE_IDLE
end

function CORE.IsActionReady()

  if (CORE.state == STATE_IDLE) and 
     (GetFreeLootSpace() > 0)
  then

    return true
  end

  return false
end


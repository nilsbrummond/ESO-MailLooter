

MailLooter = MailLooter or {}
local ADDON = MailLooter
ADDON.Core = ADDON.Core or {}
local CORE = ADDON.Core


-- MAIL_TYPE
local MAILTYPE_UNKNOWN      = 1
local MAILTYPE_AVA          = 2
local MAILTYPE_HIRELING     = 3
local MAILTYPE_STORE        = 4
local MAILTYPE_COD          = 5
local MAILTYPE_RETURNED     = 6
local MAILTYPE_SIMPLE       = 7
local MAILTYPE_BOUNCE       = 8
local MAILTYPE_SIMPLE_PRE   = 9 -- Need to read body to classify...

-- exported
CORE.MAILTYPE_UNKNOWN  = MAILTYPE_UNKNOWN
CORE.MAILTYPE_AVA      = MAILTYPE_AVA
CORE.MAILTYPE_HIRELING = MAILTYPE_HIRELING
CORE.MAILTYPE_STORE    = MAILTYPE_STORE
CORE.MAILTYPE_COD      = MAILTYPE_COD
CORE.MAILTYPE_RETURNED = MAILTYPE_RETURNED
CORE.MAILTYPE_SIMPLE   = MAILTYPE_SIMPLE
CORE.MAILTYPE_BOUNCE   = MAILTYPE_BOUNCE

-- internal only
-- CORE.MAILTYPE_SIMPLE_PRE

local TitlesAvA = { 
  -- English
  ["Rewards for the Worthy!"] = true,
  -- ["For the Covenant!"] = true,  -- TODO: Need AD and EP versions too

  -- German
  ["Gerechter Lohn!"] = true,

  -- French
  ["La récompense des braves !"] = true,

}

local TitlesHirelings = {
  -- English
  ["Raw Blacksmith Materials"] = true, 
  ["Raw Woodworker Materials"] = true, 
  ["Raw Clothier Materials"] = true, 
  ["Raw Enchanter Materials"] = true, 
  ["Raw Provisioner Materials"] = true,

  -- German
  ["Schmiedematerial"] = true,
  ["Schreinermaterial"] = true,
  ["Schneidermaterial"] = true,
  ["Verzauberermaterial"] = true,
  ["Versorgerzutaten"] = true,

  -- French
  ["Matériaux bruts de forge"] = true,
  ["Matériaux bruts de travail du bois"] = true,
  ["Matériaux bruts de couture"] = true,
  ["Matériaux bruts d'enchantement"] = true,
  ["Matériaux bruts de cuisine"] = true,
}

local TitlesStores = {
  -- English
  ["Item Expired"] = true,
  ["Item Purchased"] = true,
  ["Item Canceled"] = true,
  ["Item Sold"] = true,

  -- German
  -- Need Expired
  ["Gegenstand gekauft"] = true, 
  ["Verkauf abgebrochen"] = true,
  ["Gegenstand verkauft"] = true, 

  -- French
  -- Need Expired
  ["Objet acheté"] = true,
  ["Objet annulé"] = true,
  ["Objet vendu"] = true,
  
}

local _

CORE.deconSpace = false
CORE.bounceWords = {}

CORE.initialized = false
CORE.state = nil
CORE.loot = {items={}, money=0, mails=0, codTotal=0}
CORE.currentMail = {}
CORE.currentItems = {}
CORE.skippedMails = {}

CORE.callbacks = nil

local testData = {}

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
local STATE_TEST   = 42

CORE.state = STATE_IDLE


CORE.filters = {}
CORE.filters[MAILTYPE_UNKNOWN] = true
CORE.filters[MAILTYPE_AVA] = true
CORE.filters[MAILTYPE_HIRELING] = true
CORE.filters[MAILTYPE_STORE] = true
CORE.filters[MAILTYPE_COD] = false 
CORE.filters[MAILTYPE_RETURNED] = true 
CORE.filters[MAILTYPE_SIMPLE_PRE] = true 
CORE.filters[MAILTYPE_SIMPLE] = true 
CORE.filters[MAILTYPE_BOUNCE] = false 

--
-- Local Functions
--

-- Placeholder.
local function DEBUG(str) end
local function IsSimplePre(subject, attachments, money) return false end
local function IsSimplePost(body) return false end
local function IsDeleteSimpleAfter() return false end

local function CleanBouncePhrase(phrase)
  if (phrase == nil) or (phrase == '') then return false end

  local words = {}
  local function AddWord(w) table.insert(words, w) end
  string.gsub(phrase.lower(), "(%w+)", AddWord)

  local cleaned = false
  for k,w in pairs(words) do
    if cleaned == false then 
      cleaned = w
    else
      cleaned = cleaned .. " " .. w
    end
  end

  return cleaned

end

-- Check the subject of a mail against the auto-return subjects.
local function IsBounceReqMail(subject)

  DEBUG("IsBounceReqMail: " .. subject)

  local cleaned = CleanBouncePhrase(subject)
  if cleaned == false then return false end

  DEBUG("cleaned: " .. cleaned)

  for k,v in pairs(CORE.bounceWords) do
    DEBUG(cleaned .. " : " .. v)
    if cleaned == v then return true end
  end

  return false
end

-- Detect the type of a mail message.
local function GetMailType(subject, fromSystem, codAmount, returned, attachments, money)

  if fromSystem then
    if TitlesAvA[subject] then
      return MAILTYPE_AVA
    elseif TitlesHirelings[subject] then
      return MAILTYPE_HIRELING
    elseif TitlesStores[subject] then
      return MAILTYPE_STORE
    end
  else
    if returned then return MAILTYPE_RETURNED end
    if codAmount > 0 then return MAILTYPE_COD end

    -- Check bounce type
    if IsBounceReqMail(subject) then return MAILTYPE_BOUNCE end

    -- Check simple type
    if IsSimplePre(subject, attachments, money) then
      return MAILTYPE_SIMPLE_PRE 
    end

  end

  return MAILTYPE_UNKNOWN
end

-- placeholder
local function LootThisMailCOD(codAmount, codTotal)
  return false
end

-- Return based on mailType and type filter.
local function LootThisMail(mailType, codAmount)

  -- filter
  if CORE.filters[mailType] then
    
    -- COD checks
    if (mailType == MAILTYPE_COD) then
  
      -- price check
      if codAmount > GetCurrentMoney() then return false end

      -- policy check
      return LootThisMailCOD(codAmount, CORE.loot.codTotal)
    end

    return true
  else
    return false
  end

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
    local link = GetAttachedItemLink(mailId, i, LINK_STYLE_DEFAULT)

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

local function AddItemsToHistory(loot, currentItems)

  local newItemType = false

  for ind,item in ipairs(currentItems) do

    if loot.items[item.link] == nil then
      loot.items[item.link] = item
      newItemType = true
    else
      loot.items[item.link].stack = loot.items[item.link].stack + item.stack
    end

    DEBUG( "MailLooter: " .. tostring(item.link))
    CORE.callbacks.ListUpdateCB(loot, false, item.link, newItemType)
  end

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
  local countReturned = 0
  local countBounce = 0
  local countOther = 0
  local countItems = 0
  local countMoney = 0

  local id = GetNextMailId(nil)
  while id ~= nil do
    local _, _, subject, _, unread, fromSystem, fromCustomerService, returned, numAttachments, attachedMoney, codAmount = GetMailItemInfo(id)

    -- DEBUG(" -- Mail:" .. Id64ToString(id) .. " " .. subject .. " from:"..sdn.."/"..scn .. " sys:" .. tostring(fromSystem) .. " cs:"..tostring(fromCustomerService))

    countItems = countItems + numAttachments
    countMoney = countMoney + attachedMoney

    numAttachments = numAttachments or 0
    attachedMoney = attachedMoney or 0

    local mailType = GetMailType(
      subject, fromSystem, codAmount, returned, numAttachments, attachedMoney)
   
    if mailType == MAILTYPE_COD then
      countCOD = countCOD + 1
      countMoney = countMoney + codAmount
    elseif mailType == MAILTYPE_AVA then
      countAvA = countAvA + 1
    elseif mailType == MAILTYPE_HIRELING then
      countHireling = countHireling + 1
    elseif mailType == MAILTYPE_STORE then
      countStore = countStore + 1
    elseif mailType == MAILTYPE_RETURNED then
      countReturned = countReturned + 1
    elseif mailType == MAILTYPE_BOUNCE then
      countBounce = countBounce + 1
    else
      countOther = countOther + 1
    end

    id = GetNextMailId(id)
  end

  local result = { countAvA = countAvA, countHireling=countHireling, 
                   countCOD = countCOD, countStore = countStore,
                   countReturned = countReturned,
                   countBounce = countBounce,
                   countOther = countOther, more = IsLocalMailboxFull(),
                   countItems = countItems, countMoney = countMoney }

  CORE.callbacks.ScanUpdateCB(result)

end

local function StoreCurrentMail(
  id, sdn, scn, numAttachments, attachedMoney, codAmount, mailType)

  CORE.currentMail = { 
    id=id, att=numAttachments, money=attachedMoney, 
    codAmount=codAmount, mailType=mailType
  }

  -- Might care who it is from for non-system mail...
  if not fromSystem then
    CORE.currentMail.sdn = sdn
    CORE.currentMail.scn = scn
  end

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

    if CORE.skippedMails[id] then
      -- Already looked at and rejected this mail for looting...
      DEBUG("skipping mail: " .. Id64ToString(id))
    else

      local sdn, scn, subject, icon, unread, fromSystem, 
            fromCustomerService, returned, numAttachments, 
            attachedMoney, codAmount, expiresInDays, secsSinceReceived 
        = GetMailItemInfo(id)
      
      numAttachments = numAttachments or 0
      attachedMoney = attachedMoney or 0

      local mailType = GetMailType(
        subject, fromSystem, codAmount, returned, numAttachments, attachedMoney)

      if fromCustomerService then
        -- NOOP - just skip it.
        -- Just being extra careful we don't mess with CS mail.
        CORE.skippedMail[id] = true

      elseif mailType == MAILTYPE_BOUNCE then
        -- Skip it for now.
        -- TODO: Add mail auto-return option.

        DEBUG("mail: " .. Id64ToString(id) .. 
          " '" .. subject .. "' - Marked Auto-return")

        CORE.skippedMails[id] = true

      elseif LootThisMail(mailType, codAmount) then


        -- Loot this Mail
        DEBUG( "found mail: " .. Id64ToString(id) .. " '" .. 
               subject .. "' " .. numAttachments .. " " .. 
               (secsSinceReceived/60))

        StoreCurrentMail(
          id, sdn, scn, numAttachments, attachedMoney, codAmount, mailType)

        local doItemLoot = false
        local noRoomToLoot = false
        if (numAttachments > 0) then
          if IsRoomToLoot(id, numAttachments) then
            doItemLoot = true
          else
            failedNoSpace = true
            noRoomToLoot = true
          end
        end

        if noRoomToLoot then
          -- NOOP
          -- Skip mails with no room to loot.
          -- Don't loot the money.  It is all or nothing.
        elseif mailType == MAILTYPE_SIMPLE_PRE then
          -- Must read the mail to know if we loot it...
   
          DEBUG("simple-pre id=" .. Id64ToString(id))
          CORE.state = STATE_READ
          RequestReadMail(id)
          return

        elseif doItemLoot then
          CORE.loot.mails = CORE.loot.mails + 1

          -- Setup currentItems moved from here to after read event.

          DEBUG("items id=" .. Id64ToString(id))
          CORE.state = STATE_READ
          -- NOTE: Seems reading the mail help with getting items more reliably.
          RequestReadMail(id)
          return
        elseif attachedMoney > 0 then
          DEBUG("money id=" .. Id64ToString(id))
          CORE.loot.mails = CORE.loot.mails + 1
          CORE.state = STATE_MONEY
          TakeMailAttachedMoney(id)
          return
        elseif numAttachments == 0 then 
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
    end

    CORE.currentMail = nil
    id = GetNextMailId(id)

  end

  if failedNoSpace then
    DEBUG ( "No room left in inventory" )
    CORE.callbacks.ListUpdateCB(CORE.loot, true, nil, false)
    CORE.state = STATE_IDLE
    CORE.loot = {items={}, money=0, mails=0, codTotal=0}
    CORE.callbacks.StatusUpdateCB(false, false, "Inventory Full")
    SummaryScanMail()
  else
    DEBUG ( "Done" )
    CORE.callbacks.ListUpdateCB(CORE.loot, true, nil, false)
    CORE.state = STATE_IDLE
    CORE.loot = {items={}, money=0, mails=0, codTotal=0}
    CORE.callbacks.StatusUpdateCB(false, true, nil)
    SummaryScanMail()
  end
end

local function LootMailsCont()
  DEBUG( "LootMailsCont" )

  if CORE.currentMail.mailType == MAILTYPE_SIMPLE_PRE then
    local body = ReadMail(CORE.currentMail.id)
    if IsSimplePost(body) then

      CORE.currentMail.mailType = MAILTYPE_SIMPLE
      CORE.loot.mails = CORE.loot.mails + 1

      if (CORE.currentMail.att > 0) then
        -- Fall through to loot items...
      elseif CORE.currentMail.money > 0 then
        -- loot money
        DEBUG("money id=" .. Id64ToString(CORE.currentMail.id))
        CORE.state = STATE_MONEY
        TakeMailAttachedMoney(CORE.currentMail.id)
        return
      else
        -- delete
        DEBUG("delete id=" .. Id64ToString(CORE.currentMail.id))
        CORE.state = STATE_DELETE
        DeleteMail(CORE.currentMail.id, true)
        return
      end

    else
      -- Skip this mail...
      DEBUG("not simple id=" .. Id64ToString(CORE.currentMail.id))
      CORE.skippedMails[CORE.currentMail.id] = true
      CORE.currentMail = {}
      LootMails()
      return
    end
  end

  --
  -- Loot Item....
  --

  -- Reading the attached items works better after reading the mail.
  CORE.currentItems = {}

  for i=1,CORE.currentMail.att do
    local icon, stack, creator = GetAttachedItemInfo(
      CORE.currentMail.id, i)
    local link = GetAttachedItemLink(
      CORE.currentMail.id, i, LINK_STYLE_DEFAULT)

    DEBUG("  item: " .. link .. " icon: " .. icon)

    table.insert(
      CORE.currentItems,
      { icon=icon, stack=stack, link=link, 
        mailType=CORE.currentMail.mailType,
        sdn=CORE.currentMail.sdn,
        scn=CORE.currentMail.scn,
      }
    )
  end

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
  CORE.filters[MAILTYPE_SIMPLE_PRE] = CORE.filters[MAILTYPE_SIMPLE]

  CORE.loot = { items = {}, money = 0, mails = 0, codTotal=0 }
  CORE.currentMail = {}
  CORE.skippedMails = {}

  CORE.callbacks.StatusUpdateCB(true, true, nil)

  LootMails()

end

local function DoTestLoot()

  local step = testData.testSteps[testData.nextStep]
  if step ~= nil then
    testData.nextStep = testData.nextStep + 1

    testData.loot.money = testData.loot.money + step.money
    testData.loot.mails = testData.loot.mails + 1

    AddItemsToHistory(testData.loot, step.items)

    zo_callLater(DoTestLoot, 250)
  else
    DEBUG ( "Test Done" )
    CORE.callbacks.ListUpdateCB(testData.loot, true, nil, false)
    CORE.state = STATE_IDLE
    CORE.callbacks.StatusUpdateCB(false, true, nil)
    SummaryScanMail()
  end

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
    if CORE.state == STATE_IDLE then return end

    -- For our mail.
    if (CORE.currentMail ~= nil) and 
       (CORE.currentMail.id == mailId) then

      -- normal case.
      if CORE.state == STATE_DELETE then
        CORE.currentMail = nil
        LootMails()

      -- Our mail was deleted on us...
      elseif (CORE.state == STATE_READ) or
             (CORE.state == STATE_ITEMS) or
             (CORE.state == STATE_MONEY) then

        DEBUG("Mail delete on us!!!")
        -- FIXME
        
      end
    end
  end

  DEBUG( "MailRemoved end" )
end

function CORE.TakeItemsEvt( eventCode, mailId )
  DEBUG( "TakeItems state=" .. CORE.state )

  if mailLooterOpen then
    if CORE.state ~= STATE_ITEMS then return end

    if CORE.currentMail.id == mailId then

      if CORE.currentMail.codAmount > 0 then
        CORE.loot.codTotal = CORE.loot.codTotal + CORE.currentMail.codAmount
      end

      AddItemsToHistory(CORE.loot, CORE.currentItems)
      CORE.currentItems = {}

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
    if numSlotsReq ~= CORE.currentMail.att then return end

    -- This is now PROBABLY in response to our take item request.

    -- Need to fail.  Trying again will lead to an infinite loop.
    DEBUG( "Inventory full ERROR!" )
    CORE.state = STATE_IDLE
    CORE.callbacks.StatusUpdateCB(false, false, "Inventory Full")
    SummaryScanMail()
  end

  DEBUG( "InventoryFull end" )
end

function CORE.NotEnoughMoneyEvt( eventCode )
  DEBUG( "NotEnoughMoney state=" .. CORE.state )

  if mailLooterOpen then
    if CORE.state ~= STATE_ITEMS then return end

    if CORE.currentMail.codAmount > 0 then 
      DEBUG( "Not enough money for COD!" )
      CORE.state = STATE_IDLE
      CORE.callbacks.StatusUpdateCB(false, false, "Not enough money")
      SummaryScanMail()
    end
  end
end

--
-- Public Functions
--

-- This function must be called from the client ADDON's 
-- EVENT_ADD_ON_LOADED handler.
function CORE.Initialize(
  saveDeconSpace, debugFunction, codTestFunction, 
  preSimpleTestFunction, bodySimpleTestFunction,
  deleteSimpleAfter)

  if CORE.initialized then return end -- exit if already init'd.

  CORE.initialized = true

  CORE.deconSpace = saveDeconSpace

  if debugFunction then
    DEBUG = function(msg) debugFunction("CORE: " .. msg) end
  end

  if codTestFunction then
    LootThisMailCOD = codTestFunction
  end

  if preSimpleTestFunction then
    IsSimplePre = preSimpleTestFunction
  end
  
  if bodySimpleTestFunction then
    IsSimplePost = bodySimpleTestFunction
  end

  if deleteSimpleAfter then
    IsDeleteSimpleAfter =  deleteSimpleAfter
  end

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
  EVENT_MANAGER:RegisterForEvent(
    ADDON.NAME, EVENT_NOT_ENOUGH_MONEY, CORE.NotEnoughMoneyEvt )

end

-- Set the set of phrases used to determine auto-return mails.
function CORE.SetAutoReturnStrings(strings)
  DEBUG("SetAutoReturnStrings")

  local newWords = {}

  for k,w in pairs(strings) do
    local clean = CleanBouncePhrase(w)
    if not (clean == false) then
      DEBUG("Auto-Return word: " .. clean)
      table.insert(newWords, clean)
    end
  end

  CORE.bounceWords = newWords

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

function CORE.GetSaveDeconSpace()
  return CORE.deconSpace
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
  filter[MAILTYPE_RETURNED] = true
  filter[MAILTYPE_SIMPLE] = true 
  filter[MAILTYPE_BOUNCE] = false 

  -- Don't auto loot COD.  So one can troll you for
  -- lots of money if your not watching..
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

-- Test functions to fake loot mail.
function CORE.TestLoot()
  
  if not (mailLooterOpen and (CORE.state == STATE_IDLE)) then
    d("Test function can not run right now")
    return
  end

  DEBUG("TestLoot start")

  local realItem = {}
  realItem[1] =
  {
    ["stack"] = 1,
    ["icon"] = "/esoui/art/icons/crafting_forester_weapon_vendor_component_002.dds",
    ["mailType"] = MAILTYPE_HIRELING,
    ["link"] = "|H1:item:54171:32:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|hdwarven oil|h",
    ["creator"] = "",
  }

  realItem[2] =
  {
    ["stack"] = 5,
    ["icon"] = "/esoui/art/icons/crafting_ore_voidstone.dds",
    ["mailType"] = 3,
    ["link"] = "|H1:item:23135:30:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|hvoidstone ore|h",
    ["creator"] = "",
  }

  realItem[3] =
  {
    ["stack"] = 2,
    ["icon"] = "/esoui/art/icons/crafting_ore_palladium.dds",
    ["mailType"] = 3,
    ["link"] = "|H1:item:46152:30:50:0:0:0:0:0:0:0:0:0:0:0:0:15:0:0:0:0:0|hPalladium|h",
    ["creator"] = "",
  }

  realItem[4] = 
  {
    ["stack"] = 1,
    ["icon"] = "/esoui/art/icons/crafting_wood_turpen.dds",
    ["mailType"] = 3,
    ["link"] = "|H1:item:54179:32:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|hturpen|h",
    ["creator"] = "",
  }

  local testItem = {}
  for i=1,20 do
    testItem[i] = { 
      link=ZO_LinkHandler_CreateLink(
        "Test Trash" .. i, nil, ITEM_LINK_TYPE, 45336, 1, 26, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 10000, 0),
      stack=1, 
      mailType=(i%6)+1, 
      icon='/esoui/art/icons/crafting_components_spice_004.dds',
      creator="",
      sdn="@Lodur",
      scn="",
    }
  end


  testData = {
    loot = { items={}, money=0, mails=0, codTotal=0 },
    nextStep = 1,
    testSteps = {
      { items={realItem[1],realItem[2],realItem[3]}, money=25 },
      { items={realItem[4]}, money=25 },
      { items={realItem[1],realItem[2],realItem[3]}, money=25 },
      { items={realItem[4]}, money=25 },
      { items={realItem[1],realItem[2],realItem[3]}, money=25 },
      { items={realItem[4]}, money=25 },
      { items={realItem[1],realItem[2],realItem[3]}, money=25 },
      { items={realItem[4]}, money=25 },
    },
  }

  for i=1,20 do
    table.insert(testData.testSteps, {items={testItem[i]}, money=1})
  end

  CORE.callbacks.StatusUpdateCB(true, true, nil)
  CORE.state = STATE_TEST

  zo_callLater(DoTestLoot, 250)

end

-- Scan inbox and print out interesting things about mails.
function CORE.Scan()

  if not (mailLooterOpen and (CORE.state == STATE_IDLE)) then
    d("Scan function can not run right now")
    return
  end

  local id = GetNextMailId(nil)

  local t = {}

  while id ~= nil do

    local _, _, subject, icon, unread, fromSystem, fromCustomerService, returned, 
      numAttachments, attachedMoney, codAmount, expiresInDays, secsSinceReceived = GetMailItemInfo(id)

    numAttachments = numAttachments or 0
    attachedMoney = attachedMoney or 0

    local mailType = GetMailType(subject, fromSystem, codAmount, 
                                 returned, numAttachments, attachedMoney)

    d("mail id=" .. Id64ToString(id) )
    d("-> subject='" .. subject .. "'")
    d("-> system=" .. tostring(fromSystem))
    d("-> custService=" .. tostring(fromCustomerService))
    d("-> returned=" .. tostring(returned))
    d("-> numAtt=" .. numAttachments .. " money=" .. attachedMoney .. " cod=" .. codAmount)
    d("-> mailType=" .. mailType)


    table.insert(t, 
      { id=id, subject=subject, system=fromSystem, 
        returned=returned, mailType=mailType }
    )

    id = GetNextMailId(id)
  end

  return t
end


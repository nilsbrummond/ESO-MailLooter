

MailLooter = MailLooter or {}
local ADDON = MailLooter
ADDON.Core = ADDON.Core or {}
local CORE = ADDON.Core
ADDON.Core.Test = ADDON.Core.Test or {}
local TEST = ADDON.Core.Test

-- ZOS API (for testing)
local API_GetNumBagFreeSlots = GetNumBagFreeSlots
local API_GetNextMailId = GetNextMailId
local API_GetMailItemInfo = GetMailItemInfo
local API_GetAttachedItemInfo = GetAttachedItemInfo
local API_GetAttachedItemLink = GetAttachedItemLink
local API_RequestReadMail = RequestReadMail
local API_ReadMail = ReadMail
local API_TakeMailAttachedMoney = TakeMailAttachedMoney
local API_TakeMailAttachedItems = TakeMailAttachedItems
local API_DeleteMail = DeleteMail
local API_ReturnMail = ReturnMail


-- MAIL_TYPE
local MAILTYPE_UNKNOWN      = 1
local MAILTYPE_AVA          = 2
local MAILTYPE_HIRELING     = 3
local MAILTYPE_STORE        = 4
local MAILTYPE_COD          = 5
local MAILTYPE_RETURNED     = 6
local MAILTYPE_SIMPLE       = 7
local MAILTYPE_COD_RECEIPT  = 8
local MAILTYPE_BOUNCE       = 9
local MAILTYPE_SIMPLE_PRE   = 10 -- Need to read body to classify...


-- exported
CORE.MAILTYPE_UNKNOWN     = MAILTYPE_UNKNOWN
CORE.MAILTYPE_AVA         = MAILTYPE_AVA
CORE.MAILTYPE_HIRELING    = MAILTYPE_HIRELING
CORE.MAILTYPE_STORE       = MAILTYPE_STORE
CORE.MAILTYPE_COD         = MAILTYPE_COD
CORE.MAILTYPE_RETURNED    = MAILTYPE_RETURNED
CORE.MAILTYPE_SIMPLE      = MAILTYPE_SIMPLE
CORE.MAILTYPE_COD_RECEIPT = MAILTYPE_COD_RECEIPT
CORE.MAILTYPE_BOUNCE      = MAILTYPE_BOUNCE

-- internal only
-- CORE.MAILTYPE_SIMPLE_PRE

-- Should these items be stacked or broken out for reporting.
-- This is not if the actual item types will stack.
-- This is how it is reported and therefore how displayed.
local MailTypeStackable = {
  [MAILTYPE_UNKNOWN]      = false,  -- n/a
  [MAILTYPE_AVA]          = true,
  [MAILTYPE_HIRELING]     = true,
  [MAILTYPE_STORE]        = true,
  [MAILTYPE_COD]          = false,
  [MAILTYPE_RETURNED]     = false,
  [MAILTYPE_SIMPLE]       = false,
  [MAILTYPE_COD_RECEIPT]  = false,  -- n/a
  [MAILTYPE_BOUNCE]       = false,  -- n/a
  [MAILTYPE_SIMPLE_PRE]   = false,  -- n/a
}


local TitlesAvA = { 
  -- English
  ["Rewards for the Worthy!"] = true,
  -- ["For the Covenant!"] = true,  -- TODO: Need AD and EP versions too
  -- ["Campaign Loyalty Reward"] = true,

  -- German
  ["Gerechter Lohn!"] = true,
  -- ["Für das Bündnis!"] = true,
  -- ["Für Eure Kampagnentreue"] = true,

  -- French
  ["La récompense des braves !"] = true,
  -- ["Pour l'Alliance !"] = true,
  -- ["La récompense de la loyauté"] = true,

}

local TitlesHirelings = {
  -- English
  ["Raw Blacksmith Materials"]  = { true, CRAFTING_TYPE_BLACKSMITHING},
  ["Raw Woodworker Materials"]  = { true, CRAFTING_TYPE_WOODWORKING},
  ["Raw Clothier Materials"]    = { true, CRAFTING_TYPE_CLOTHIER},
  ["Raw Enchanter Materials"]   = { true, CRAFTING_TYPE_ENCHANTING},
  ["Raw Provisioner Materials"] = { true, CRAFTING_TYPE_PROVISIONING},

  -- German
  ["Schmiedematerial"]    = { true, CRAFTING_TYPE_BLACKSMITHING},
  ["Schreinermaterial"]   = { true, CRAFTING_TYPE_WOODWORKING},
  ["Schneidermaterial"]   = { true, CRAFTING_TYPE_CLOTHIER},
  ["Verzauberermaterial"] = { true, CRAFTING_TYPE_ENCHANTING},
  ["Versorgerzutaten"]    = { true, CRAFTING_TYPE_PROVISIONING},

  -- French
  ["Matériaux bruts de forge"]           = { true, CRAFTING_TYPE_BLACKSMITHING},
  ["Matériaux bruts de travail du bois"] = { true, CRAFTING_TYPE_WOODWORKING},
  ["Matériaux bruts de couture"]         = { true, CRAFTING_TYPE_CLOTHIER},
  ["Matériaux bruts d'enchantement"]     = { true, CRAFTING_TYPE_ENCHANTING},
  ["Matériaux bruts de cuisine"]         = { true, CRAFTING_TYPE_PROVISIONING},
}

local TitlesStores = {
  -- English
  ["Item Expired"] = true,
  ["Item Purchased"] = true,
  ["Item Canceled"] = true,
  ["Item Sold"] = true,

  -- German
  ["Angebot ausgelaufen"] = true,
  ["Gegenstand gekauft"] = true, 
  ["Verkauf abgebrochen"] = true,
  ["Gegenstand verkauft"] = true, 

  -- French
  ["Objet arrivé à expiration"]  = true,
  ["Objet acheté"] = true,
  ["Objet annulé"] = true,
  ["Objet vendu"] = true,
  
}

local _

CORE.deconSpace = false
CORE.bounceWords = {}

CORE.initialized = false
CORE.state = nil
CORE.loot = false -- placehold till NewLootStruct() is defined.
CORE.currentMail = {}
CORE.currentItems = {}
CORE.skippedMails = {}
CORE.nextLootNum = 1
CORE.cancelClean = false


CORE.callbacks = nil

local testData = {}

local mailboxOpen = false
local mailLooterOpen = false

-- Processing States
local STATE_IDLE   = 0    -- Opening
local STATE_OPEN   = 1
local STATE_UPDATE = 2

local STATE_LOOT   = 3    -- Looting
local STATE_READ   = 4
local STATE_ITEMS  = 5
local STATE_MONEY  = 6
local STATE_DELETE = 7

local STATE_CLOSE  = 8    -- closing
local STATE_TEST   = 42   -- testing


CORE.state = STATE_IDLE


CORE.filters = {}
CORE.filters[MAILTYPE_UNKNOWN] = true
CORE.filters[MAILTYPE_AVA] = true
CORE.filters[MAILTYPE_HIRELING] = true
CORE.filters[MAILTYPE_STORE] = true
CORE.filters[MAILTYPE_COD] = true 
CORE.filters[MAILTYPE_RETURNED] = true 
CORE.filters[MAILTYPE_SIMPLE_PRE] = true 
CORE.filters[MAILTYPE_SIMPLE] = true 
CORE.filters[MAILTYPE_BOUNCE] = true -- Ignored
CORE.filters[MAILTYPE_COD_RECEIPT] = true 

CORE.lootAllFilters = CORE.filters

--
-- Local Functions
--

-- Placeholders.
local function DEBUG(str) end
local function IsSimplePre(subject, attachments, money) return false end
local function IsSimplePost(body) return false end
local function IsDeleteSimpleAfter() return false end
local function LootThisMailCOD(codAmount, codTotal) return false end
local function IsBounceEnabled() return false end

-- Makes a function to call a function later.  Like zo_callLater but there
-- is not a closure created for every call.  Just once up front.
local function MakeCallLater(func, id, ms)

  local mid = 'MailLooter' .. id

  local x = function()
    EVENT_MANAGER:UnregisterForUpdate(mid)
    func()
  end

  local delayFn = function()
    EVENT_MANAGER:RegisterForUpdate( mid, ms, x )
  end

  return delayFn
end


local function MailCount(mailType)
  CORE.loot.mailCount[mailType] = CORE.loot.mailCount[mailType] + 1
  CORE.loot.mailCount.all = CORE.loot.mailCount.all + 1
end

local function NewLootStruct()
  local l = {
    items={}, moneys={}, moneyTotal=0, codTotal=0,

    mailCount = {},

    -- mails keyed by mail-id
    mails={}
  }

  l.mailCount[MAILTYPE_UNKNOWN    ] = 0
  l.mailCount[MAILTYPE_AVA        ] = 0
  l.mailCount[MAILTYPE_HIRELING   ] = 0
  l.mailCount[MAILTYPE_STORE      ] = 0
  l.mailCount[MAILTYPE_COD        ] = 0
  l.mailCount[MAILTYPE_RETURNED   ] = 0
  l.mailCount[MAILTYPE_SIMPLE     ] = 0
  l.mailCount[MAILTYPE_COD_RECEIPT] = 0
  l.mailCount[MAILTYPE_BOUNCE     ] = 0
  l.mailCount.all = 0

  l.items[MAILTYPE_UNKNOWN] = {}
  l.items[MAILTYPE_AVA] = {}
  l.items[MAILTYPE_HIRELING] = {}
  l.items[MAILTYPE_STORE] = {}
  l.items[MAILTYPE_COD] = {}
  l.items[MAILTYPE_RETURNED] = {}
  l.items[MAILTYPE_SIMPLE] = {}

  l.debug = {}

  return l
end

CORE.loot = NewLootStruct()

local function CleanBouncePhrase(phrase)
  if (phrase == nil) or (phrase == '') then return false end

  local words = {}
  local function AddWord(w) table.insert(words, w) end
  string.gsub(string.lower(phrase), "(%w+)", AddWord)

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

  -- DEBUG("IsBounceReqMail: " .. subject)

  local cleaned = CleanBouncePhrase(subject)
  if cleaned == false then return false end

  -- DEBUG("cleaned: " .. cleaned)

  for k,v in pairs(CORE.bounceWords) do
    -- DEBUG(cleaned .. " : " .. v)
    if cleaned == v then return true end
  end

  return false
end

-- Detect the type of a mail message.
local function GetMailType(subject, fromSystem, codAmount, returned, attachments, money)

  if fromSystem then
    if TitlesAvA[subject] then
      return MAILTYPE_AVA
    elseif TitlesStores[subject] then
      return MAILTYPE_STORE
    else
      local hdata = TitlesHirelings[subject]
      if hdata and hdata[1] then
        return MAILTYPE_HIRELING, hdata[2]
      end
    end
  else
    if returned then return MAILTYPE_RETURNED end
    if codAmount > 0 then return MAILTYPE_COD end

    -- COD receipt
    -- has money only and subject starts with 'RE:'
    -- NOTE: Check de and fr mail for 'RE:' - may need transalation.
    -- NOTE: This is not perfect...  A player can send a mail
    --       that looks like this.
    if (attachments ==0) and (money > 0) and
       (string.sub(subject, 1, 3) == "RE:") then 
      return MAILTYPE_COD_RECEIPT
    end

    -- Check bounce type
    if IsBounceReqMail(subject) then return MAILTYPE_BOUNCE end

    -- Check simple type
    if IsSimplePre(subject, attachments, money) then
      return MAILTYPE_SIMPLE_PRE 
    end

  end

  return MAILTYPE_UNKNOWN
end

-- Return based on mailType and type filter.
local function LootThisMail(mailType, codAmount, hirelingType)

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

  -- Handle hireling sub-filtering...
  elseif mailType == MAILTYPE_HIRELING then

    if CORE.filters.hirelings and CORE.filters.hirelings[hirelingType] then
--      DEBUG("LootThisMail mt=_HIRELING ht=" .. hirelingType .. " - true")
      return true
    else
--      DEBUG("LootThisMail mt=_HIRELING ht=" .. hirelingType .. " - false")
      return false
    end

  else
    return false
  end

end

local function GetFreeLootSpace()
  local space = API_GetNumBagFreeSlots(BAG_BACKPACK)

  if CORE.deconSpace then
    if space > 4 then space=space-4 else space=0 end
  end

  return space
end


local function IsRoomToLoot(mailId, numAtt)

  -- NOTE: Testing seems to show that you can not loot items that will
  --       stack unless at least one inventory space is open.
  if API_GetNumBagFreeSlots(BAG_BACKPACK) == 0 then return false end


  local space = GetFreeLootSpace()

  -- Easy case: there is room
  DEBUG("   numAtt: " .. numAtt .. " space: " .. space)
  if (numAtt <= space) then return true end

  -- harder case: see if items will stack
  local roomNeeded = 0

  for i=1,numAtt do
    local link = API_GetAttachedItemLink(mailId, i, LINK_STYLE_DEFAULT)

    if IsItemLinkStackable(link) then
      -- Stackable Item
      local _, stack = API_GetAttachedItemInfo(mailId, i)
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

local function AddMoneyToHistory(loot, mail)
  if mail.money <= 0 then return end

  -- Add the total money
  loot.moneyTotal = loot.moneyTotal + mail.money

  -- Is a breakout type..
  if (mail.mailType == MAILTYPE_RETURNED) or
     (mail.mailType == MAILTYPE_SIMPLE) or
     (mail.mailType == MAILTYPE_COD_RECEIPT) then

    local mailId = mail.includeMail and mail.id or nil

    local moneyMail = {
      mailType = mail.mailType, 
      money = mail.money,
      id = mailId,
      lootNum = CORE.nextLootNum,
      sdn = mail.sdn,
      scn = mail.scn,
    }

    CORE.nextLootNum = CORE.nextLootNum + 1

    table.insert(loot.moneys, moneyMail)

    CORE.callbacks.ListUpdateCB(loot, false, nil, false, moneyMail, true)
  end
end

-- Since some equivalent items can have different meaningless levels.
-- Then these items have varrying links.
local function GetItemLinkKey(link)
  local itemType = GetItemLinkItemType(link)

  if (itemType == ITEMTYPE_ENCHANTING_RUNE_ASPECT) or
     (itemType == ITEMTYPE_WEAPON_TRAIT) or
     (itemType == ITEMTYPE_ARMOR_TRAIT) or
     (itemType == ITEMTYPE_WOODWORKING_BOOSTER) or
     (itemType == ITEMTYPE_CLOTHIER_BOOSTER) or
     (itemType == ITEMTYPE_BLACKSMITHING_BOOSTER) or
     (itemType == ITEMTYPE_INGREDIENT) then

    local _, _, _, f4, f5 = ZO_LinkHandler_ParseLink(link)

    return 'key:item:' ..  f4 .. ':' ..  f5, true

   else
     return link, false
   end
end

local function AddItemsToHistory(loot, currentItems)

  for ind,item in ipairs(currentItems) do

    if MailTypeStackable[item.mailType] then

      local key, diff = GetItemLinkKey(item.link)

      if diff then
        DEBUG( "Item (stackable): " .. key .. ' ' .. item.link)
      else
        DEBUG( "Item (stackable): " .. key)
      end

      if loot.items[item.mailType][key] == nil then
        item.lootNum = CORE.nextLootNum
        CORE.nextLootNum = CORE.nextLootNum + 1

        loot.items[item.mailType][key] = item

        CORE.callbacks.ListUpdateCB(loot, false, item, true)
      else
        loot.items[item.mailType][key].stack = 
          loot.items[item.mailType][key].stack + item.stack

        DEBUG("stack=" .. loot.items[item.mailType][key].stack)
        
        CORE.callbacks.ListUpdateCB(
          loot, false, loot.items[item.mailType][key], false)
      end

    else

      DEBUG( "Item (unstackable): " .. tostring(item.link))

      -- Not stackable - keep them sepatated...
      item.lootNum = CORE.nextLootNum
      CORE.nextLootNum = CORE.nextLootNum + 1

      table.insert( loot.items[item.mailType], item )

      CORE.callbacks.ListUpdateCB(loot, false, item, true)

    end
  end

end


local function DoDeleteCmd()
  DEBUG( "DoDeleteCmd" )

  if CORE.state ~= STATE_DELETE then return end
  API_DeleteMail(CORE.currentMail.id, true)
end

local DelayedDeleteCmd = MakeCallLater(DoDeleteCmd, "Delete", 10)


local function DoReturnCmd()
  DEBUG( "DoReturnCmd" )

  -- Mail is confirmed returned by the deleted event.
  if CORE.state ~= STATE_DELETE then return end

  API_ReturnMail(CORE.currentMail.id)
end

local DelayedReturnCmd = MakeCallLater(DoReturnCmd, "Return", 50)


local function SummaryScanMail()

  DEBUG( "SummaryScanMail" )

  local countLootable = 0
  local countAvA = 0
  local countHireling = 0
  local countCOD = 0
  local countCODReceipt = 0
  local countStore = 0
  local countReturned = 0
  local countBounce = 0
  local countOther = 0
  local countItems = 0
  local countMoney = 0

  local codTotal = 0

  local id = API_GetNextMailId(nil)
  while id ~= nil do
    local _, _, subject, _, unread, fromSystem, fromCustomerService, returned, numAttachments, attachedMoney, codAmount = API_GetMailItemInfo(id)

    -- DEBUG(" -- Mail:" .. Id64ToString(id) .. " " .. subject .. " from:"..sdn.."/"..scn .. " sys:" .. tostring(fromSystem) .. " cs:"..tostring(fromCustomerService))

    countItems = countItems + numAttachments
    countMoney = countMoney + attachedMoney

    numAttachments = numAttachments or 0
    attachedMoney = attachedMoney or 0

    local mailType = GetMailType(
      subject, fromSystem, codAmount, returned, numAttachments, attachedMoney)

    if mailType == MAILTYPE_COD then
      countCOD = countCOD + 1
      if LootThisMailCOD(codAmount, codTotal) then
        countLootable = countLootable + 1
        codTotal = codTotal + codAmount
      end
      -- Should not add this - subtract if anything... :
      -- countMoney = countMoney + codAmount
    elseif mailType == MAILTYPE_AVA then
      countAvA = countAvA + 1
      countLootable = countLootable + 1
    elseif mailType == MAILTYPE_HIRELING then
      countHireling = countHireling + 1
      countLootable = countLootable + 1
    elseif mailType == MAILTYPE_STORE then
      countStore = countStore + 1
      countLootable = countLootable + 1
    elseif mailType == MAILTYPE_RETURNED then
      countReturned = countReturned + 1
      countLootable = countLootable + 1
    elseif mailType == MAILTYPE_BOUNCE then
      countBounce = countBounce + 1
    elseif mailType == MAILTYPE_COD_RECEIPT then
      countCODReceipt = countCODReceipt + 1
      countLootable = countLootable + 1
    else
      countOther = countOther + 1
    end

    id = API_GetNextMailId(id)
  end

  local result = { countLootable = countLootable,
                   countAvA = countAvA, countHireling=countHireling, 
                   countCOD = countCOD, countCODReceipt = countCODReceipt,
                   countStore = countStore,
                   countReturned = countReturned,
                   countBounce = countBounce,
                   countOther = countOther, more = IsLocalMailboxFull(),
                   countItems = countItems, countMoney = countMoney }

  CORE.callbacks.ScanUpdateCB(result)

end

local function StoreCurrentMail(
  id, sdn, scn, subject, fromSystem, numAttachments, attachedMoney, codAmount, mailType)

  CORE.currentMail = { 
    id=id, att=numAttachments, money=attachedMoney, 
    codAmount=codAmount, mailType=mailType
  }

  -- Might care who it is from for non-system mail...
  if not fromSystem then
    CORE.currentMail.includeMail = true
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
  local id = API_GetNextMailId(nil)

  if CORE.cancelClean then
    CORE.cancelClean = false

    -- Canceled:
    if id ~= nil then
      DEBUG ( "Looting Canceled" )
      CORE.state = STATE_IDLE
      CORE.loot = NewLootStruct()
      CORE.callbacks.StatusUpdateCB(false, false, "Canceled")
      SummaryScanMail()
      return
    end
  end


  while id ~= nil do

    if CORE.skippedMails[zo_getSafeId64Key(id)] then
      -- Already looked at and rejected this mail for looting...
      -- DEBUG("skipping mail: " .. Id64ToString(id))
    else

      local sdn, scn, subject, icon, unread, fromSystem, 
            fromCustomerService, returned, numAttachments, 
            attachedMoney, codAmount, expiresInDays, secsSinceReceived 
        = API_GetMailItemInfo(id)
      
      numAttachments = numAttachments or 0
      attachedMoney = attachedMoney or 0

      local mailType, hirelingType = GetMailType(
        subject, fromSystem, codAmount, returned, numAttachments, attachedMoney)

      -- DEBUG: Store mail as looted
      table.insert(CORE.loot.debug, {API_GetMailItemInfo(id)})
      CORE.loot.debug[#CORE.loot.debug].id = Id64ToString(id)
      CORE.loot.debug[#CORE.loot.debug].mailType = mailType

      if fromCustomerService then
        -- NOOP - just skip it.
        -- Just being extra careful we don't mess with CS mail.
        CORE.skippedMails[zo_getSafeId64Key(id)] = true

      elseif mailType == MAILTYPE_BOUNCE then

        DEBUG("mail: " .. Id64ToString(id) .. 
          " '" .. subject .. "' - Marked Auto-return")

        if IsBounceEnabled() then
          DEBUG("bounce id=" .. Id64ToString(id))
          -- CORE.loot.autoReturnCount = CORE.loot.autoReturnCount + 1
          -- increment(CORE.loot, "autoReturnCount")
          MailCount(MAILTYPE_BOUNCE)

          -- Returned mail is 'Deleted' by ZOS.  Wait for Delete event.
          CORE.state = STATE_DELETE
          CORE.currentMail = {id=id}
          DelayedReturnCmd()
          return
        else
          -- Skip it.
          CORE.skippedMails[zo_getSafeId64Key(id)] = true
        end

      elseif LootThisMail(mailType, codAmount, hirelingType) then

        -- Loot this Mail
        DEBUG( "found mail: " .. Id64ToString(id) .. " '" .. 
               subject .. "' numAtt=" .. numAttachments)

        StoreCurrentMail(
          id, sdn, scn, subject, fromSystem, numAttachments, 
          attachedMoney, codAmount, mailType)

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
          --
          -- NOTE:
          -- Don't add to the skip list or failedNoSpace
          --    may not be set on the last call of LootMails().

        elseif mailType == MAILTYPE_SIMPLE_PRE then
          -- Must read the mail to know if we loot it...
   
          DEBUG("simple-pre id=" .. Id64ToString(id))
          CORE.state = STATE_READ
          API_RequestReadMail(id)
          return

        elseif doItemLoot then

          -- NOTE: Seems reading the mail help with getting items more reliably.
          -- Setup currentItems moved from here to after read event.

          DEBUG("items id=" .. Id64ToString(id))
          CORE.state = STATE_READ
          API_RequestReadMail(id)
          return

        elseif not fromSystem then

          -- Read all player mail to store it for tooltip

          DEBUG("player-mail id=" .. Id64ToString(id))
          CORE.state = STATE_READ
          API_RequestReadMail(id)
          return

        elseif attachedMoney > 0 then
          DEBUG("money id=" .. Id64ToString(id))
          -- CORE.loot.mailCount = CORE.loot.mailCount + 1
          MailCount(mailType)
          CORE.state = STATE_MONEY
          API_TakeMailAttachedMoney(id)
          return
        elseif numAttachments == 0 then 
          -- DELETE
          -- player may have manually looted and not deleted it.
          DEBUG("delete id=" .. Id64ToString(id))
          -- CORE.loot.mailCount = CORE.loot.mailCount + 1
          MailCount(mailType)
          CORE.state = STATE_DELETE
          DelayedDeleteCmd()
          return
        else
          -- NOOP
        end

      else

        -- This mail is not for looting.
        DEBUG("not-loot id=" .. Id64ToString(id))
        CORE.skippedMails[zo_getSafeId64Key(id)] = true

      end
    end

    CORE.currentMail = nil
    id = API_GetNextMailId(id)

  end

  if failedNoSpace then
    DEBUG ( "No room left in inventory" )
    CORE.callbacks.ListUpdateCB(CORE.loot, true, nil, false)
    CORE.state = STATE_IDLE
    CORE.loot = NewLootStruct()
    CORE.callbacks.StatusUpdateCB(false, false, "Inventory Full")
    SummaryScanMail()
  else
    DEBUG ( "Done" )
    CORE.callbacks.ListUpdateCB(CORE.loot, true, nil, false)
    CORE.state = STATE_IDLE
    CORE.loot = NewLootStruct()
    CORE.callbacks.StatusUpdateCB(false, true, nil)
    SummaryScanMail()
  end
end

local LootMailsAgain = MakeCallLater(LootMails, "Loot", 50)

local function AddPlayerMailToHistory(id, body)

  local mail = {body = body}

  local sdn, scn, subject, icon, unread, fromSystem, 
        fromCustomerService, returned, numAttachments, 
        attachedMoney, codAmount, expiresInDays, secsSinceReceived 
    = API_GetMailItemInfo(id)

  mail.sdn = sdn
  mail.scn = scn
  mail.subject = subject
  mail.icon = icon 
  mail.fromSystem = fromSystem 
  mail.returned = returned 
  mail.numAtt = numAttachments 
  mail.money = attachedMoney 
  mail.codAmount = codAmount 
  mail.expiresInDays = expiresInDays 
  mail.secsSinceReceived = secsSinceReceived 

  mail.items = {}
  for i=1,numAttachments do
    local icon, stack, creator = API_GetAttachedItemInfo(id, i)
    local link = API_GetAttachedItemLink(id, i, LINK_STYLE_DEFAULT)

    table.insert(
      mail.items,
      { icon=icon, stack=stack, creator=creator, link=link, }
    )
  end

  CORE.loot.mails[zo_getSafeId64Key(id)] = mail
end

local function LootMailsCont()
  DEBUG( "LootMailsCont" )

  local body = false

  if CORE.currentMail.includeMail then
    body = API_ReadMail(CORE.currentMail.id)
    AddPlayerMailToHistory(CORE.currentMail.id, body)

    -- DEBUG
    CORE.loot.debug[#CORE.loot.debug].body = body
  end

  if CORE.currentMail.mailType == MAILTYPE_SIMPLE_PRE then
    body = (not body) and API_ReadMail(CORE.currentMail.id) or body

    -- DEBUG
    CORE.loot.debug[#CORE.loot.debug].body = body
 
    if IsSimplePost(body) then

      CORE.currentMail.mailType = MAILTYPE_SIMPLE

      -- DEBUG
      CORE.loot.debug[#CORE.loot.debug].mailType = MAILTYPE_SIMPLE

      if (CORE.currentMail.att > 0) then
        -- Fall through to loot items...
      elseif CORE.currentMail.money > 0 then
        -- loot money
        DEBUG("money id=" .. Id64ToString(CORE.currentMail.id))
        -- CORE.loot.mailCount = CORE.loot.mailCount + 1
        MailCount(MAILTYPE_SIMPLE)
        CORE.state = STATE_MONEY
        API_TakeMailAttachedMoney(CORE.currentMail.id)
        return
      elseif IsDeleteSimpleAfter() then
        -- delete
        DEBUG("delete id=" .. Id64ToString(CORE.currentMail.id))
        -- CORE.loot.mailCount = CORE.loot.mailCount + 1
        MailCount(MAILTYPE_SIMPLE)
        CORE.state = STATE_DELETE

        -- In case any other Addon or code wants to handle
        -- this event.  Don't deleted it till after all 
        -- interested handlers have a chance to run....
        DelayedDeleteCmd()
        return
      else
        DEBUG("simple mail - Do not delete")
        CORE.skippedMails[zo_getSafeId64Key(CORE.currentMail.id)] = true
        CORE.currentMail = {}
        LootMails()
        return
      end

    else
      -- Skip this mail...
      DEBUG("not simple id=" .. Id64ToString(CORE.currentMail.id))
      CORE.skippedMails[zo_getSafeId64Key(CORE.currentMail.id)] = true
      CORE.currentMail = {}
      
      CORE.state = STATE_LOOT
      LootMailsAgain()
      return
    end
  end


  if CORE.currentMail.att > 0 then
    --
    -- Loot Item....
    --

    -- CORE.loot.mailCount = CORE.loot.mailCount + 1
    MailCount(CORE.currentMail.mailType)

    -- Reading the attached items works better after reading the mail.
    CORE.currentItems = {}

    -- DEBUG
    CORE.loot.debug[#CORE.loot.debug].items = {}

    for i=1,CORE.currentMail.att do
      local icon, stack, creator = API_GetAttachedItemInfo(
        CORE.currentMail.id, i)
      local link = API_GetAttachedItemLink(
        CORE.currentMail.id, i, LINK_STYLE_DEFAULT)

      DEBUG("  item: " .. link .. " icon: " .. icon)

      local mailId = CORE.currentMail.includeMail and CORE.currentMail.id or nil

      table.insert(
        CORE.currentItems,
        { icon=icon, stack=stack, link=link, 
          mailType=CORE.currentMail.mailType,
          id = mailId,
          sdn=CORE.currentMail.sdn,
          scn=CORE.currentMail.scn,
        }
      )

      -- DEBUG
      table.insert(
        CORE.loot.debug[#CORE.loot.debug].items, 
        { icon, stack, creator, link }
      )

    end

    CORE.state = STATE_ITEMS

    -- BUG: Why does this sometimes fail??? (FIXED)
    -- Work around: load the mail to be read first.
    API_TakeMailAttachedItems(CORE.currentMail.id)

  elseif CORE.currentMail.money > 0 then
    --
    -- Loot Money - this includes COD RECEIPT cases.
    --

    DEBUG("money id=" .. Id64ToString(CORE.currentMail.id))
    -- CORE.loot.mailCount = CORE.loot.mailCount + 1
    MailCount(CORE.currentMail.mailType)
    CORE.state = STATE_MONEY
    API_TakeMailAttachedMoney(CORE.currentMail.id)

  else

    -- Don't delete player mail with no loot.
    -- Is that the only way to get here?

    -- Unstore this mail
    CORE.loot.mails[zo_getSafeId64Key(CORE.currentMail.id)] = nil

    -- skip it...
    CORE.skippedMails[zo_getSafeId64Key(CORE.currentMail.id)] = true
    CORE.currentMail = {}
  
    CORE.state = STATE_LOOT
    LootMailsAgain()
  end

end

local function Start(filter)
  DEBUG( "Start" )

  if CORE.state ~= STATE_IDLE then
    CORE.callbacks.StatusUpdateCB(false, false, "Core Not Ready")
    return
  end

  CORE.filters = filter
  CORE.filters[MAILTYPE_SIMPLE_PRE] = CORE.filters[MAILTYPE_SIMPLE]

  CORE.loot = NewLootStruct()
  CORE.currentMail = {}
  CORE.skippedMails = {}
  CORE.nextLootNum = 1

  CORE.state = STATE_LOOT
  CORE.callbacks.StatusUpdateCB(true, true, nil)

  LootMails()

end

-- forward declared.
local DelayedTestLoot

-- Perform a test step on the timer.
local function DoTestLoot()

  if CORE.state ~= STATE_TEST then
    DEBUG("Test Error - state=" .. CORE.state)
    return
  end

  -- canceled:
  if CORE.cancelClean then
    DEBUG ( "Test Canceled" )
    CORE.cancelClean = false
    testData = {}
    CORE.state = STATE_IDLE
    CORE.callbacks.StatusUpdateCB(false, false, "Canceled")
    SummaryScanMail()
    return
  end

  -- Do a test step...
  local step = testData.testSteps[testData.nextStep]
  if step ~= nil then
    testData.nextStep = testData.nextStep + 1
    step = ZO_DeepTableCopy(step)

    testData.loot.mailCount[step.mail.mailType] = 
      testData.loot.mailCount[step.mail.mailType] + 1
    testData.loot.mailCount.all = testData.loot.mailCount.all + 1

    for ind,item in ipairs(step.items) do
      item.mailType = step.mail.mailType
      item.sdn = step.mail.sdn
      item.scn = step.mail.scn
    end

    AddItemsToHistory(testData.loot, step.items)
    AddMoneyToHistory(testData.loot, step.mail)

    DelayedTestLoot()
  else
    DEBUG ( "Test Done" )
    CORE.callbacks.ListUpdateCB(testData.loot, true, nil, false)
    testData = {}
    CORE.state = STATE_IDLE
    CORE.callbacks.StatusUpdateCB(false, true, nil)
    SummaryScanMail()
  end

end

DelayedTestLoot = MakeCallLater(DoTestLoot, "Test", 50)

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
    if (CORE.state == STATE_READ) and 
       AreId64sEqual(CORE.currentMail.id, mailId) then

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
       AreId64sEqual(CORE.currentMail.id, mailId) then

      -- normal case.
      if CORE.state == STATE_DELETE then
        CORE.currentMail = nil
        
        CORE.state = STATE_LOOT
        LootMailsAgain()

      -- Our mail was deleted on us...
      elseif (CORE.state == STATE_READ) or
             (CORE.state == STATE_ITEMS) or
             (CORE.state == STATE_MONEY) then

        DEBUG("Mail delete on us!!!")

        CORE.currentMail = nil
        CORE.state = STATE_IDLE
        CORE.callbacks.StatusUpdateCB(false, false, "Our mail was deleted.")
        SummaryScanMail()
        
      end
    end
  end

  DEBUG( "MailRemoved end" )
end

function CORE.TakeItemsEvt( eventCode, mailId )
  DEBUG( "TakeItems state=" .. CORE.state )

  if mailLooterOpen then
    if CORE.state ~= STATE_ITEMS then return end

    if AreId64sEqual(CORE.currentMail.id, mailId) then

      if CORE.currentMail.codAmount > 0 then
        CORE.loot.codTotal = CORE.loot.codTotal + CORE.currentMail.codAmount
      end

      AddItemsToHistory(CORE.loot, CORE.currentItems)
      CORE.currentItems = {}

      if (CORE.currentMail.money ~= nil) and (CORE.currentMail.money > 0) then

        CORE.state = STATE_MONEY
        API_TakeMailAttachedMoney(CORE.currentMail.id)

      elseif (CORE.currentMail.mailType ~= MAILTYPE_SIMPLE) or 
             IsDeleteSimpleAfter() then

        CORE.state = STATE_DELETE

        -- In case any other Addon or code wants to handle
        -- this event.  Don't deleted it till after all 
        -- interested handlers have a chance to run....
        DelayedDeleteCmd()

      else
        -- simple mail - do not delete
        DEBUG("simple mail - Do not delete")
        CORE.skippedMails[zo_getSafeId64Key(CORE.currentMail.id)] = true
        CORE.currentMail = {}

        CORE.state = STATE_LOOT
        LootMailsAgain()
      end
    end
  end

  DEBUG( "TakeItems end" )
end

function CORE.TakeMoneyEvt( eventCode, mailId )
  DEBUG( "TakeMoney state=" .. CORE.state )

  if mailLooterOpen then
    if CORE.state ~= STATE_MONEY then return end

    if AreId64sEqual(CORE.currentMail.id, mailId) then
      AddMoneyToHistory(CORE.loot, CORE.currentMail)

      if (CORE.currentMail.mailType ~= MAILTYPE_SIMPLE) or 
         IsDeleteSimpleAfter() then
        
        CORE.state = STATE_DELETE

        -- In case any other Addon or code wants to handle
        -- this event.  Don't deleted it till after all 
        -- interested handlers have a chance to run....
        DelayedDeleteCmd()

      else

        -- simple mail - do not delete
        DEBUG("simple mail - Do not delete")
        CORE.skippedMails[zo_getSafeId64Key(CORE.currentMail.id)] = true
        CORE.currentMail = {}
  
        CORE.state = STATE_LOOT
        LootMailsAgain()

      end
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
  deleteSimpleAfter, isBounceEnabledFunction)

  if CORE.initialized then return end -- exit if already init'd.

  CORE.initialized = true

  CORE.deconSpace = saveDeconSpace

  if debugFunction then
    DEBUG = function(msg) return debugFunction("CORE: " .. msg) end
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

  if isBounceEnabledFunction then
    IsBounceEnabled = isBounceEnabledFunction
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

-- Used by testing framework.
function CORE.SetAPI(api)
  if api == nil then
    -- Set API to ZOS API
    API_GetNumBagFreeSlots = GetNumBagFreeSlots
    API_GetNextMailId = GetNextMailId
    API_GetMailItemInfo = GetMailItemInfo
    API_GetAttachedItemInfo = GetAttachedItemInfo
    API_GetAttachedItemLink = GetAttachedItemLink
    API_ReadMail = ReadMail
    API_TakeMailAttachedMoney = TakeMailAttachedMoney
    API_TakeMailAttachedItems = TakeMailAttachedItems
    API_DeleteMail = DeleteMail
    API_ReturnMail = ReturnMail
  else
    -- Set API to Testing framework.
    API_GetNumBagFreeSlots = api.GetNumBagFreeSlots
    API_GetNextMailId = api.GetNextMailId
    API_GetMailItemInfo = api.GetMailItemInfo
    API_GetAttachedItemInfo = api.GetAttachedItemInfo
    API_GetAttachedItemLink = api.GetAttachedItemLink
    API_ReadMail = api.ReadMail
    API_TakeMailAttachedMoney = api.TakeMailAttachedMoney
    API_TakeMailAttachedItems = api.TakeMailAttachedItems
    API_DeleteMail = api.DeleteMail
    API_ReturnMail = api.ReturnMail
  end
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
 
  DEBUG( "MailLooter starting all loot" )
  Start( CORE.lootAllFilters )

end

-- New Version
-- Start looting the mailbox.
-- Allows filtering on mail type.
function CORE.ProcessMail(filter)

  if CORE.state ~= STATE_IDLE then 
    DEBUG( "MailLooter is currently running" )
    return
  end
 
  DEBUG( "MailLooter starting filtered loot" )
  Start(filter)
end

-- Stop the looting process after completing the current mail.
function CORE.CancelClean()
  DEBUG( "CancelClean state=" .. CORE.state )

  if mailLooterOpen and (CORE.state ~= STATE_IDLE) then
    DEBUG( "----> Canceling")
    CORE.cancelClean = true
  end

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
function CORE.TestLoot(arg)
  
  if not (mailLooterOpen and (CORE.state == STATE_IDLE)) then
    d("Test function can not run right now")
    return
  end

  if not arg then
    CORE.TestLootOld()
    return true
  else
    if TEST.tests[arg] then
      testData = {}
      testData.testSteps = TEST.MakeItemTest(TEST.tests[arg])
      testData.loot = NewLootStruct()
      testData.nextStep = 1

      -- Start the test..
      CORE.state = STATE_TEST
      CORE.nextLootNum = 1
      CORE.callbacks.StatusUpdateCB(true, true, nil)

      DelayedTestLoot()
      return true
    end
  end

  return false
end

function CORE.TestLootOld()
  DEBUG("TestLoot start")

  local realItem = {}
  realItem[1] =
  {
    ["stack"] = 1,
    ["icon"] = "/esoui/art/icons/crafting_forester_weapon_vendor_component_002.dds",
    ["link"] = "|H1:item:54171:32:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|hdwarven oil|h",
    ["creator"] = "",
  }

  realItem[2] =
  {
    ["stack"] = 5,
    ["icon"] = "/esoui/art/icons/crafting_ore_voidstone.dds",
    ["link"] = "|H1:item:23135:30:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|hvoidstone ore|h",
    ["creator"] = "",
  }

  realItem[3] =
  {
    ["stack"] = 2,
    ["icon"] = "/esoui/art/icons/crafting_ore_palladium.dds",
    ["link"] = "|H1:item:46152:30:50:0:0:0:0:0:0:0:0:0:0:0:0:15:0:0:0:0:0|hPalladium|h",
    ["creator"] = "",
  }

  realItem[4] = 
  {
    ["stack"] = 1,
    ["icon"] = "/esoui/art/icons/crafting_wood_turpen.dds",
    ["link"] = "|H1:item:54179:32:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|hturpen|h",
    ["creator"] = "",
  }

  local testItem = {}
  for i=1,20 do
    testItem[i] = { 
      link=ZO_LinkHandler_CreateLink(
        "Test Trash" .. i, nil, ITEM_LINK_TYPE, 45336, 1, 26, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 10000, 0),
      stack=1, 
      icon='/esoui/art/icons/crafting_components_spice_004.dds',
      creator="",
    }
  end

  local function Mail(mailType, money, sdn, scn, subject, body)
    local mail = { mailType=mailType, money=money, sdn=sdn, scn=scn }
    return mail
  end

  testData = {
    loot = NewLootStruct(),

    nextStep = 1,

    testSteps = {
      { items={realItem[1],realItem[2],realItem[3]},
        mail=Mail(MAILTYPE_HIRELING,25) },
      { items={realItem[4]}, mail=Mail(MAILTYPE_HIRELING,25) },
      { items={realItem[1],realItem[2],realItem[3]}, 
        mail=Mail(MAILTYPE_HIRELING,25) },
      { items={realItem[4]}, mail=Mail(MAILTYPE_HIRELING,25) },
      { items={realItem[1],realItem[2],realItem[3]}, 
        mail=Mail(MAILTYPE_HIRELING,25) },
      { items={realItem[4]}, mail=Mail(MAILTYPE_HIRELING,25) },
      { items={realItem[1],realItem[2],realItem[3]}, 
        mail=Mail(MAILTYPE_HIRELING,25) },
      { items={realItem[4]}, mail=Mail(MAILTYPE_HIRELING,25) },
    },
  }

  for i=1,20 do
    table.insert(
      testData.testSteps, {items={testItem[1]}, mail=Mail((i%5)+1, 1)})
  end

  for i=1,20 do
    table.insert(
      testData.testSteps, {items={testItem[i]}, mail=Mail((i%5)+1, 1)})
  end

  -- Test the stacking display bug:
  local special1 = {
    icon = "/esoui/art/icons/crafting_components_runestones_002.dds",
    link = "|H0:item:45853:23:3:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|hRekuta|h",
    stack = 1,
    creator = "",
  }
  local special2 = {
    icon = "/esoui/art/icons/crafting_components_runestones_002.dds",
    link = "|H0:item:45853:23:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|hRekuta|h",
    stack = 2,
    creator = "",
  }

  for i=1,5 do
    table.insert(
      testData.testSteps, {items={special1}, mail=Mail(MAILTYPE_HIRELING, 0)})
    table.insert(
      testData.testSteps, {items={special2}, mail=Mail(MAILTYPE_HIRELING, 0)})
  end

  -- with items
  table.insert(
    testData.testSteps,
    { items={realItem[4]}, 
      mail=Mail(MAILTYPE_RETURNED, 0, 
                "Lodur", "Lodur", "Hi", "xxx")})

  table.insert(
    testData.testSteps,
    { items={realItem[4]}, 
      mail=Mail(MAILTYPE_SIMPLE, 0, 
                "Lodur", "Lodur", "Hi", "xxx")})

  -- Money only:
  table.insert(
    testData.testSteps,
    { items={}, 
      mail=Mail(MAILTYPE_RETURNED, 7777, 
                "Lodur", "Lodur", "Hi", "xxx")})
  table.insert(
    testData.testSteps,
    { items={}, 
      mail=Mail(MAILTYPE_SIMPLE, 7777, 
                "Lodur", "Lodur", "Hi", "xxx")})
  table.insert(
    testData.testSteps,
    { items={}, 
      mail=Mail(MAILTYPE_COD_RECEIPT, 7777, 
                "Lodur", "Lodur", "Hi", "xxx")})
  table.insert(
    testData.testSteps,
    { items={}, 
      mail=Mail(MAILTYPE_COD_RECEIPT, 7777, 
                "Lodur", "Lodur", "Hi", "xxx")})
  table.insert(
    testData.testSteps,
    { items={}, 
      mail=Mail(MAILTYPE_COD_RECEIPT, 7777, 
                "Lodur", "Lodur", "Hi", "xxx")})

  -- Start the test..
  CORE.state = STATE_TEST
  CORE.nextLootNum = 1
  CORE.callbacks.StatusUpdateCB(true, true, nil)

  DelayedTestLoot()

end

-- Scan inbox and print out interesting things about mails.
function CORE.Scan()

  if not (mailLooterOpen and (CORE.state == STATE_IDLE)) then
    d("Scan function can not run right now")
    return
  end

  local id = API_GetNextMailId(nil)

  local t = {}

  while id ~= nil do

    local _, _, subject, icon, unread, fromSystem, fromCustomerService, returned, 
      numAttachments, attachedMoney, codAmount, expiresInDays, secsSinceReceived = API_GetMailItemInfo(id)

    numAttachments = numAttachments or 0
    attachedMoney = attachedMoney or 0

    local mailType, hirelingType = GetMailType(
      subject, fromSystem, codAmount, returned, numAttachments, attachedMoney)

    d("mail id=" .. Id64ToString(id) )
    d("-> subject='" .. subject .. "'")
    d("-> system=" .. tostring(fromSystem))
    d("-> custService=" .. tostring(fromCustomerService))
    d("-> returned=" .. tostring(returned))
    d("-> numAtt=" .. numAttachments .. " money=" .. attachedMoney .. " cod=" .. codAmount)
    d("-> mailType=" .. mailType)


    local items

    if numAttachments > 0 then 
      items = {}
      GetMailAttachmentInfo(id)

      for i=1, numAttachments do
        local icon, stack, cn, sp, meets = API_GetAttachedItemInfo(id, i)
        local link = API_GetAttachedItemLink(id, i, LINK_STYLE_BRACKETS)
        table.insert(items, {stack=stack, link=link})
      end
    end

    table.insert(t, 
      { id=Id64ToString(id), subject=subject, system=fromSystem, 
        returned=returned, mailType=mailType, hirelingType=hirelingType,
        money=attachedMoney, cod=codAmount, items=items,
      }
    )

    id = API_GetNextMailId(id)
  end

  return t
end



MailLooter = MailLooter or {}
local ADDON = MailLooter
ADDON.Core = ADDON.Core or {}
local CORE = ADDON.Core
ADDON.Core.Test = ADDON.Core.Test or {}
local TEST = ADDON.Core.Test



local function NewTest(testdata)
  local test = {}
    
    test.numBagFreeSlots = 100
    test.mailReadId = 0
    test.mailId = nil

    test.mails = testdata

    -- build mail ID -> index table
    -- build list of delete mail
    test.mailId = {}
    test.deleted = {}
    test.moneyed = {}
    test.itemed = {}
    for k,v in ipairs(testdata) do
      if v.id == nil then
        -- use index as the id
        test.mailId[k] = k
        testdata[k].id = k
      else
        test.mailId[v.id] = k
      end
      test.deleted[k] = false
      test.moneyed[k] = false
      test.itemed[k] = false
    end

  return test
end

local function MailIdToIndex(id)

  if id == nil then return false, nil end

  -- id -> mail index
  local index = TEST.current.mailId[id]
  if index == nil then return false, nil end

  -- handle deleted mail
  if TEST.current.deleted[index] then return false, index end

  -- all good
  return true, index
end

local function PerformEvent()

  local event = TEST.current.event
  TEST.current.event = nil

  if event[1] == EVENT_MAIL_REMOVED then
    CORE.MailRemovedEvt(unpack(event))
  elseif event[1] == EVENT_MAIL_READABLE then
    TEST.current.mailReadId = event[2]
    CORE.MailReadableEvt(unpack(event))
  elseif event[1] == EVENT_MAIL_TAKE_ATTACHED_ITEM_SUCCESS then
    CORE.TakeItemsEvt(unpack(event))
  elseif event[1] == EVENT_MAIL_TAKE_ATTACHED_MONEY_SUCCESS then
    CORE.TakeMoneyEvt(unpack(event))
  end

end

--
-- API
--

local function Test_GetNumBagFreeSlots(bad)
  return TEST.current.numBagFreeSlots
end

local function Test_GetNextMailId(id)

  -- We don't edit the test mails.
  -- Deleted mails are tracked by TEST.current.deleted[index] boolean array.
  -- This function considers deletion.

  local nextId = nil

  if id == nil then

    for index=1, #TEST.current.mails do
      if not TEST.current.deleted[index] then
        nextId = TEST.current.mails[index].id
        break
      end
    end
  
  else

    local index = TEST.current.mailId[id]

    if (index ~= nil) and
       (not TEST.current.deleted[index]) and
       (index < #TEST.current.mails) then

      --
      -- return index of next non-deleted mail
      --
      
      for n=index+1, #TEST.current.mails do
        if not TEST.current.deleted[n] then
          nextId = TEST.current.mails[n].id
          break
        end
      end
    end

  end

  -- TEST.DEBUG("GetNextMailId id=" .. tostring(id) .. " -> " .. tostring(nextId))

  return nextId

end

local function Test_GetMailItemInfo(id)

  TEST.DEBUG("GetMailItemInfo id=" .. tostring(id))

  local good, index = MailIdToIndex(id)
  if not good then return nil end

  local mail = TEST.current.mails[index]

  local items = mail[9]
  local money = mail[10]
  local cod   = mail[11]

  if TEST.current.itemed[index] then
    items = 0
    cod = 0
  end

  if TEST.current.moneyed[index] then
    money = 0
  end

  return mail[1], mail[2], mail[3], mail[4], mail[5], mail[6], mail[7], mail[8], items, money, cod, mail[12], mail[13]

end

local function Test_GetAttachedItemInfo(id, item)

  TEST.DEBUG("GetMailItemInfo id=" .. tostring(id) .. " item=" .. item)

  local good, index = MailIdToIndex(id)
  if not good then return nil end

  local mail = TEST.current.mails[index]

  -- Handle the info not being available till after a read.
  if TEST.current.mailReadId ~= id then
    return '','',''
  end

  if mail.items == nil then return '','','' end

  local item = mail.items[item]
  if item == nil then return '','','' end

  return item[1], item[2], item[3]

end

local function Test_GetAttachedItemLink(id, item, linktype)

  -- linkType is not handled - you get the type that was recorded.

  local good, index = MailIdToIndex(id)
  if not good then return nil end

  local mail = TEST.current.mails[index]

  -- Handle the info not being available till after a read.
  if TEST.current.mailReadId ~= id then
    return ''
  end

  if mail.items == nil then return '' end

  local item = mail.items[item]
  if item == nil then return '' end

  return item[4]

end

local function Test_RequestReadMail(id)

  TEST.DEBUG("RequestReadMail id=" .. tostring(id))

  local good, index = MailIdToIndex(id)
  if not good then return nil end

  -- clear it
  TEST.current.mailReadId = nil

  TEST.current.event = { EVENT_MAIL_READABLE, id }
  zo_callLater(PerformEvent, 50)
end

local function Test_ReadMail(id)
  TEST.DEBUG("ReadMail id=" .. tostring(id))

  local good, index = MailIdToIndex(id)
  if not good then return nil end

  -- Did we request the read?
  if TEST.current.mailReadId ~= id then
    return nil
  end
  
  local mail = TEST.current.mails[index]

  if mail.body == nil then 
    return "This is a default test body.  A b c d e f g 1 2 3 4" 
  end

  return mail.body
end

local function Test_TakeMailAttachedMoney(id)

  TEST.DEBUG("TakeMailAttachedMoney id=" .. tostring(id))

  local good, index = MailIdToIndex(id)
  if not good then return end

  TEST.current.moneyed[index] = true
  TEST.current.event = { EVENT_MAIL_TAKE_ATTACHED_MONEY_SUCCESS, id }
  zo_callLater(PerformEvent, 50)

end

local function Test_TakeMailAttachedItems(id)

  TEST.DEBUG("TakeMailAttachedItems id=" .. tostring(id))

  local good, index = MailIdToIndex(id)
  if not good then return end

  TEST.current.itemed[index] = true
  TEST.current.event = { EVENT_MAIL_TAKE_ATTACHED_ITEM_SUCCESS, id }
  zo_callLater(PerformEvent, 50)

end

local function Test_DeleteMail(id, forceDelete)

  TEST.DEBUG("DeleteMail id=" .. tostring(id))

  local good, index = MailIdToIndex(id)
  if not good then return end

  TEST.current.deleted[index] = true
  TEST.current.event = { EVENT_MAIL_REMOVED, id }
  zo_callLater(PerformEvent, 50)
end

local function Test_ReturnMail(id)

  TEST.DEBUG("ReturnMail id=" .. tostring(id))

  local good, index = MailIdToIndex(id)
  if not good then return end

  TEST.current.deleted[index] = true
  TEST.current.event = { EVENT_MAIL_REMOVED, id }
  zo_callLater(PerformEvent, 50)

end

local function Test_IsMailReturnable(id)

  local good, index = MailIdToIndex(id)
  if not good then return false end

  local mail = TEST.current.mails[index]

  return (not mail[6]) and (not mail[7]) and (not mail[8])

end

local function Test_IsReadMailInfoReady(id)

  -- TODO: What should this really do?

  local good, index = MailIdToIndex(id)
  if not good then return false end

  return TEST.current.mailReadId == id

end

local function Test_IsLocalMailboxFull()
  -- TODO: add local mailbox concept.
  return false
end

local function Test_Id64ToString(id)

  -- Test data is not really an Id64...

  local t = type(id)
  if t == 'string' then
    return id
  elseif t == 'number' then
    return tostring(id)
  elseif t == 'userdata' then
    -- actually an Id64?
    return Id64ToString(id)
  end

end

local apiTestInterface = {
  GetNumBagFreeSlots = Test_GetNumBagFreeSlots,
  GetNextMailId = Test_GetNextMailId,
  GetMailItemInfo = Test_GetMailItemInfo,
  GetAttachedItemInfo = Test_GetAttachedItemInfo,
  GetAttachedItemLink = Test_GetAttachedItemLink,
  RequestReadMail = Test_RequestReadMail,
  ReadMail = Test_ReadMail,
  TakeMailAttachedMoney = Test_TakeMailAttachedMoney,
  TakeMailAttachedItems = Test_TakeMailAttachedItems,
  DeleteMail = Test_DeleteMail,
  ReturnMail = Test_ReturnMail,
  IsMailReturnable = Test_IsMailReturnable,
  IsReadMailInfoReady = Test_IsReadMailInfoReady,
  IsLocalMailboxFull = Test_IsLocalMailboxFull,
  Id64ToString = Test_Id64ToString,
}

function TEST.StartTest(test)

  if test == 'end' then
    TEST.DEBUG("Ending Test")
    CORE.SetAPI(nil)

    -- Trigger a summary update.
    CORE.InboxUpdateEvt(0)

    return true
  end

  -- Start: ...
  if TEST.tests[test] then

    TEST.DEBUG("Starting Test: " .. test)

    TEST.current = NewTest(TEST.tests[test])

    CORE.SetAPI(apiTestInterface)

    -- Trigger a summary update.
    CORE.InboxUpdateEvt(0)

    return true
  end

  return false
end

function TEST.Initialize(debugFn)
 
  TEST.DEBUG = function(msg) debugFn("TEST: " .. msg) end

end


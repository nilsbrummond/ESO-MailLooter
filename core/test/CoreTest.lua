
MailLooter = MailLooter or {}
local ADDON = MailLooter
ADDON.Core = ADDON.Core or {}
local CORE = ADDON.Core
ADDON.Core.Test = ADDON.Core.Test or {}
local TEST = ADDON.Core.Test



local function NewTest(test)
  local test = {}
    
    test.numBagFreeSlots = 100
    test.mailReadId = 0
    test.mailId = nil

    test.mails = test

    -- build mail ID -> index table
    -- build list of delete mail
    test.mailId = {}
    test.deleted = {}
    for k,v in ipairs(test) do
      if v.id == nil then
        -- use index as the id
        test.mailId[k] = k
        v.id = k
      else
        test.mailId[v.id] = k
      end
      test.deleted[k] = false
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

  if event[0] == EVENT_MAIL_REMOVED then
    CORE.MailRemovedEvt(unpack(event))
  elseif event[0] == EVENT_MAIL_READABLE then
    TEST.current.mailReadId = event[2]
    CORE.MailReadableEvt(unpack(event))
  elseif event[0] == EVENT_MAIL_TAKE_ATTACHED_ITEM_SUCCESS then
    CORE.TakeItemsEvt(unpack(event))
  elseif event[0] == EVENT_MAIL_TAKE_ATTACHED_MONEY_SUCCESS then
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

  if id == nil then

    for index=1, #TEST.current.mails do
      if not TEST.current.deleted[index] then
        return TEST.current.mails[index].id
      end
    end
  
    -- no mail left
    return nil

  else

    local index = TEST.current.mailId[id]

    -- This mail does not exist
    if index == nil then return nil end

    -- This mail has been deleted
    if TEST.current.deleted[index] then return nil end

    -- return nil if last mail
    if index == #TEST.current.mails then return nil end

    --
    -- return index of next non-deleted mail
    --
    
    for n=index+1, #TEST.current.mails do
      if not TEST.current.deleted[n] then
        return TEST.current.mails[n].id
      end
    end
    
    -- no mail left...
    return nil

  end

end

local function Test_GetMailItemInfo(id)

  local good, index = MailIdToIndex(id)
  if not good then return nil end

  local mail = TEST.current.mails[index]

  return mail[1], mail[2], mail[3], mail[4], mail[5], mail[6], mail[7], mail[8], mail[9], mail[10], mail[11], mail[12], mail[13]

end

local function Test_GetAttachedItemInfo(id, index)

  local good, index = MailIdToIndex(id)
  if not good then return nil end

  local mail = TEST.current.mails[index]

  -- Handle the info not being available till after a read.
  if TEST.current.mailReadId ~= id then
    return nil,nil,nil
  end

  if mail.items == nil then return nil,nil,nil end

  local item = mail.items[index]
  if item == nil then return nil,nil,nil end

  return item[1], item[2], item[3]

end

local function Test_GetAttachedItemLink(id, index, linktype)

  -- linkType is not handled - you get the type that was recorded.

  local good, index = MailIdToIndex(id)
  if not good then return nil end

  local mail = TEST.current.mails[index]

  -- Handle the info not being available till after a read.
  if TEST.current.mailReadId ~= id then
    return nil
  end

  if mail.items == nil then return nil end

  local item = mail.items[index]
  if item == nil then return nil end

  return item[4]

end

local function Test_RequestReadMail(id)
  local good, index = MailIdToIndex(id)
  if not good then return nil end

  -- clear it
  TEST.current.mailReadId = nil

  TEST.current.event = { EVENT_MAIL_READABLE, id }
  zo_callLater("PerformEvent", 50)
end

local function Test_ReadMail(id)
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

  local good, index = MailIdToIndex(id)
  if not good then return end

  TEST.current.event = { EVENT_MAIL_TAKE_ATTACHED_MONEY_SUCCESS, id }
  zo_callLater("PerformEvent", 50)

end

local function Test_TakeMailAttachedItems(id)

  local good, index = MailIdToIndex(id)
  if not good then return end

  TEST.current.event = { EVENT_MAIL_TAKE_ATTACHED_ITEM_SUCCESS, id }
  zo_callLater("PerformEvent", 50)

end

local function Test_DeleteMail(id, forceDelete)

  local good, index = MailIdToIndex(id)
  if not good then return end

  TEST.current.deleted[index] = true
  TEST.current.event = { EVENT_MAIL_REMOVED, id }
  zo_callLater("PerformEvent", 50)
end

local function Test_ReturnMail(id)

  local good, index = MailIdToIndex(id)
  if not good then return end

  TEST.current.deleted[index] = true
  TEST.current.event = { EVENT_MAIL_REMOVED, id }
  zo_callLater("PerformEvent", 50)

end

local function Test_IsMailReturnable(id)

  local good, index = MailIdToIndex(id)
  if not good then return false end

  local mail = TEST.current.mails[index]

end

local function Test_IsReadMailInfoReady(id)

  local good, index = MailIdToIndex(id)
  if not good then return false end

  local mail = TEST.current.mails[index]

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
}

function TEST.StartTest(test)

  if TEST.tests[test] then

    TEST.DEBUG("Starting Test: " .. test)

    TEST.current = NewTest(TEST.tests[test])

    CORE.SetAPI(apiTestInterface)

    return true
  end

  return false
end

function TEST.Initialize(debugFn)
 
  TEST.DEBUG = function(msg) debugFn("TEST: " .. msg) end

end


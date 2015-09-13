
MailLooter = MailLooter or {}
local ADDON = MailLooter
ADDON.Core = ADDON.Core or {}
local CORE = ADDON.Core
ADDON.Core.Test = ADDON.Core.Test or {}
local TEST = ADDON.Core.Test




local function Test_GetNumBagFreeSlots(bad)
  return TEST.current.numBagFreeSlots
end

local function Test_GetNextMailId(id)

  if (TEST.current.tests[TEST.current.index] ~= nil) then
    
    TEST.current.index = TEST.current.index + 1
    
    if (TEST.current.tests[TEST.current.index] ~= nil) then
      return TEST.current.tests[TEST.current.index].id
    else
      return nil
    end

  else
    return nil
  end
end

local function Test_GetMailItemInfo(id)

end

local function Test_GetAttachedItemInfo(id, index)

end

local function Test_GetAttachedItemLink(id, index, linktype)

end

local function Test_ReadMail(id)
  return "TEST BODY: abcdefghijklmnopqrstuvwxyz 1 2 3 4 5 6 7 8 9 0 a b c d e"
end

local function Test_TakeMailAttachedMoney(id)

end

local function Test_TakeMailAttachedItems(id)

end

local function Test_DeleteMail(id, forceDelete)

end

local apiTestInterface = {
  GetNumBagFreeSlots = Test_GetNumBagFreeSlots
  GetNextMailId = Test_GetNextMailId
  GetMailItemInfo = Test_GetMailItemInfo
  GetAttachedItemInfo = Test_GetAttachedItemInfo
  GetAttachedItemLink = Test_GetAttachedItemLink
  ReadMail = Test_ReadMail
  TakeMailAttachedMoney = Test_TakeMailAttachedMoney
  TakeMailAttachedItems = Test_TakeMailAttachedItems
  DeleteMail = Test_DeleteMail
  ReturnMail = Test_ReturnMail
}

local test1 = {}
test1.inventory = {cur=0, max=150}
test1.mail = {
}

local tests = {}
tests['test1'] = test1

function CORE.SetTest(test)
end


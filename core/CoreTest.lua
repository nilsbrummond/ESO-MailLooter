
MailLooter = MailLooter or {}
local ADDON = MailLooter
ADDON.Core = ADDON.Core or {}
local CORE = ADDON.Core

CORE.TEST = {}

local function Test_GetNumBagFreeSlots(bad)

end

local function Test_GetNextMailId(id)

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


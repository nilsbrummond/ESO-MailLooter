
MailLooter = MailLooter or {}
local ADDON = MailLooter
ADDON.Core = ADDON.Core or {}
local CORE = ADDON.Core
ADDON.Core.Test = ADDON.Core.Test or {}
local TEST = ADDON.Core.Test

TEST.tests = TEST.tests or {}

function TEST.GetTestDataOld()
  
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

  local testData = {

    testSteps = {
      { items={realItem[1],realItem[2],realItem[3]},
        mail=Mail(CORE.MAILTYPE_HIRELING,25) },
      { items={realItem[4]}, mail=Mail(CORE.MAILTYPE_HIRELING,25) },
      { items={realItem[1],realItem[2],realItem[3]}, 
        mail=Mail(CORE.MAILTYPE_HIRELING,25) },
      { items={realItem[4]}, mail=Mail(CORE.MAILTYPE_HIRELING,25) },
      { items={realItem[1],realItem[2],realItem[3]}, 
        mail=Mail(CORE.MAILTYPE_HIRELING,25) },
      { items={realItem[4]}, mail=Mail(CORE.MAILTYPE_HIRELING,25) },
      { items={realItem[1],realItem[2],realItem[3]}, 
        mail=Mail(CORE.MAILTYPE_HIRELING,25) },
      { items={realItem[4]}, mail=Mail(CORE.MAILTYPE_HIRELING,25) },
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
      testData.testSteps, {items={special1}, mail=Mail(CORE.MAILTYPE_HIRELING, 0)})
    table.insert(
      testData.testSteps, {items={special2}, mail=Mail(CORE.MAILTYPE_HIRELING, 0)})
  end

  -- with items
  table.insert(
    testData.testSteps,
    { items={realItem[4]}, 
      mail=Mail(CORE.MAILTYPE_RETURNED, 0, 
                "Lodur", "Lodur", "Hi", "xxx")})

  table.insert(
    testData.testSteps,
    { items={realItem[4]}, 
      mail=Mail(CORE.MAILTYPE_SIMPLE, 0, 
                "Lodur", "Lodur", "Hi", "xxx")})

  -- Money only:
  table.insert(
    testData.testSteps,
    { items={}, 
      mail=Mail(CORE.MAILTYPE_RETURNED, 7777, 
                "Lodur", "Lodur", "Hi", "xxx")})
  table.insert(
    testData.testSteps,
    { items={}, 
      mail=Mail(CORE.MAILTYPE_SIMPLE, 7777, 
                "Lodur", "Lodur", "Hi", "xxx")})
  table.insert(
    testData.testSteps,
    { items={}, 
      mail=Mail(CORE.MAILTYPE_COD_RECEIPT, 7777, 
                "Lodur", "Lodur", "Hi", "xxx")})
  table.insert(
    testData.testSteps,
    { items={}, 
      mail=Mail(CORE.MAILTYPE_COD_RECEIPT, 7777, 
                "Lodur", "Lodur", "Hi", "xxx")})
  table.insert(
    testData.testSteps,
    { items={}, 
      mail=Mail(CORE.MAILTYPE_COD_RECEIPT, 7777, 
                "Lodur", "Lodur", "Hi", "xxx")})

  return testData.testSteps
end

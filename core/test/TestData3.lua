
MailLooter = MailLooter or {}
local ADDON = MailLooter
ADDON.Core = ADDON.Core or {}
local CORE = ADDON.Core
ADDON.Core.Test = ADDON.Core.Test or {}
local TEST = ADDON.Core.Test

TEST.tests = TEST.tests or {}


local testData = {


  [1] = 
  {
    [1] = "@Elder_III",
    [2] = "Caspar Moltavious",
    [3] = "BMW 50-50 Raffle Winner",
    [4] = "/esoui/art/icons/mail_001.dds",
    [5] = false,
    [6] = false,
    [7] = false,
    [8] = false,
    [9] = 0,
    [10] = 0,
    [11] = 0,
    [12] = 1,
    [13] = 218781,
    ["id"] = "381792643",
    ["mailType"] = 1,
  },
  [2] = 
  {
    [1] = "@azianduv03",
    [2] = "S'kura",
    [3] = "|c00ff00Requiem Raffle Results|r",
    [4] = "/esoui/art/icons/mail_001.dds",
    [5] = false,
    [6] = false,
    [7] = false,
    [8] = false,
    [9] = 0,
    [10] = 0,
    [11] = 0,
    [12] = 1,
    [13] = 211859,
    ["id"] = "381838007",
    ["mailType"] = 1,
  },
  [3] = 
  {
    [1] = "@Ohai_3",
    [2] = "O'hai",
    [3] = "Tinkers SUPER RAFFLE!",
    [4] = "/esoui/art/icons/mail_001.dds",
    [5] = false,
    [6] = false,
    [7] = false,
    [8] = false,
    [9] = 0,
    [10] = 0,
    [11] = 0,
    [12] = 1,
    [13] = 181231,
    ["id"] = "381959479",
    ["mailType"] = 1,
  },
  [4] = 
  {
    [1] = "Grulzul, Scribe to the Warlord",
    [2] = "",
    [3] = "Our Thanks, Warrior",
    [4] = "/esoui/art/icons/mail_003.dds",
    [5] = false,
    [6] = true,
    [7] = false,
    [8] = false,
    [9] = 0,
    [10] = 0,
    [11] = 0,
    [12] = 30,
    [13] = 168704,
    ["id"] = "382028243",
    ["mailType"] = 1,
  },
  [5] = 
  {
    [1] = "@Finrfin",
    [2] = "",
    [3] = "return",
    [4] = "/esoui/art/icons/crafting_forester_potion_sp_names_002.dds",
    [5] = false,
    [6] = false,
    [7] = false,
    [8] = true,
    [9] = 6,
    [10] = 0,
    [11] = 0,
    [12] = 29,
    [13] = 161708,
    ["mailType"] = 6,
    ["body"] = "",
    ["id"] = "382069567",
    ["items"] = 
    {
      [1] = 
      {
        [1] = "/esoui/art/icons/crafting_forester_potion_sp_names_002.dds",
        [2] = 3,
        [3] = "",
        [4] = "|H0:item:30162:31:16:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|hdragonthorn|h",
      },
      [2] = 
      {
        [1] = "/esoui/art/icons/crafting_cooking_fish_fillet.dds",
        [2] = 1,
        [3] = "",
        [4] = "|H0:item:33753:25:20:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|hFish|h",
      },
      [3] = 
      {
        [1] = "/esoui/art/icons/crafting_flower_mountain_flower_r1.dds",
        [2] = 1,
        [3] = "",
        [4] = "|H0:item:30163:31:16:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|hmountain flower|h",
      },
      [4] = 
      {
        [1] = "/esoui/art/icons/quest_food_003.dds",
        [2] = 20,
        [3] = "",
        [4] = "|H0:item:33752:25:27:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|hRed Meat|h",
      },
      [5] = 
      {
        [1] = "/esoui/art/icons/crafting_water_plant_water_hyacinth_r1.dds",
        [2] = 4,
        [3] = "",
        [4] = "|H0:item:30166:31:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|hwater hyacinth|h",
      },
      [6] = 
      {
        [1] = "/esoui/art/icons/quest_trollfat_001.dds",
        [2] = 20,
        [3] = "",
        [4] = "|H0:item:27057:25:27:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|hCheese|h",
      },
    },
  },
  [6] = 
  {
    [1] = "@Finrfin",
    [2] = "",
    [3] = "rts",
    [4] = "/esoui/art/icons/quest_scroll_001.dds",
    [5] = false,
    [6] = false,
    [7] = false,
    [8] = true,
    [9] = 5,
    [10] = 0,
    [11] = 0,
    [12] = 29,
    [13] = 161682,
    ["mailType"] = 6,
    ["body"] = "",
    ["id"] = "382069709",
    ["items"] = 
    {
      [1] = 
      {
        [1] = "/esoui/art/icons/quest_scroll_001.dds",
        [2] = 1,
        [3] = "",
        [4] = "|H0:item:68222:4:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|hBravil Bitter Barley Beer Recipe|h",
      },
      [2] = 
      {
        [1] = "/esoui/art/icons/quest_scroll_001.dds",
        [2] = 1,
        [3] = "",
        [4] = "|H0:item:68196:3:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|hBravil's Best Beet Risotto Recipe|h",
      },
      [3] = 
      {
        [1] = "/esoui/art/icons/quest_scroll_001.dds",
        [2] = 1,
        [3] = "",
        [4] = "|H0:item:68189:3:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|hGarlic-and-Pepper Venison Steak Recipe|h",
      },
      [4] = 
      {
        [1] = "/esoui/art/icons/quest_scroll_001.dds",
        [2] = 1,
        [3] = "",
        [4] = "|H0:item:68189:3:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|hGarlic-and-Pepper Venison Steak Recipe|h",
      },
      [5] = 
      {
        [1] = "/esoui/art/icons/quest_scroll_001.dds",
        [2] = 1,
        [3] = "",
        [4] = "|H0:item:46017:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|hGingerose Tea Recipe|h",
      },
    },
  },
  [7] = 
  {
    [1] = "Guild Store",
    [2] = "",
    [3] = "Item Sold",
    [4] = "/esoui/art/icons/mail_003.dds",
    [5] = false,
    [6] = true,
    [7] = false,
    [8] = false,
    [9] = 0,
    [10] = 37200,
    [11] = 0,
    [12] = 30,
    [13] = 67082,
    ["id"] = "382608069",
    ["mailType"] = 4,
  },
  [8] = 
  {
    [1] = "@Alphashado",
    [2] = "Alphashado",
    [3] = "BMW Newsletter 9/29",
    [4] = "/esoui/art/icons/mail_001.dds",
    [5] = false,
    [6] = false,
    [7] = false,
    [8] = false,
    [9] = 0,
    [10] = 0,
    [11] = 0,
    [12] = 3,
    [13] = 52222,
    ["id"] = "382721635",
    ["mailType"] = 1,
  },
  [9] = 
  {
    [1] = "Guild Store",
    [2] = "",
    [3] = "Item Sold",
    [4] = "/esoui/art/icons/mail_003.dds",
    [5] = false,
    [6] = true,
    [7] = false,
    [8] = false,
    [9] = 0,
    [10] = 37200,
    [11] = 0,
    [12] = 30,
    [13] = 18501,
    ["id"] = "382908171",
    ["mailType"] = 4,
  },
  [10] = 
  {
    [1] = "Gavin Gavonne",
    [2] = "",
    [3] = "Raw Provisioner Materials",
    [4] = "/esoui/art/icons/monster_plant_creature_seeds_001.dds",
    [5] = false,
    [6] = true,
    [7] = false,
    [8] = false,
    [9] = 2,
    [10] = 0,
    [11] = 0,
    [12] = 30,
    [13] = 580,
    ["mailType"] = 3,
    ["id"] = "382982325",
    ["items"] = 
    {
      [1] = 
      {
        [1] = "/esoui/art/icons/monster_plant_creature_seeds_001.dds",
        [2] = 20,
        [3] = "",
        [4] = "|H0:item:27063:25:28:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|hSaltrice|h",
      },
      [2] = 
      {
        [1] = "/esoui/art/icons/quest_flower_001.dds",
        [2] = 20,
        [3] = "",
        [4] = "|H0:item:34330:25:28:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|hLotus|h",
      },
    },
  },
}

TEST.tests['data3'] = testData


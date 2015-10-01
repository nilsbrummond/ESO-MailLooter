
MailLooter = MailLooter or {}
local ADDON = MailLooter
ADDON.Core = ADDON.Core or {}
local CORE = ADDON.Core
ADDON.Core.Test = ADDON.Core.Test or {}
local TEST = ADDON.Core.Test

TEST.tests = TEST.tests or {}

--
-- Test Goal... At least one of each type of mail...
--

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
  [11] = 
  {
    [1] = "@BobsNotYourUnkle",
    [2] = "",
    [3] = "rts",
    [4] = "/esoui/art/icons/quest_scroll_001.dds",
    [5] = false,
    [6] = false,
    [7] = false,
    [8] = false,
    [9] = 5,
    [10] = 0,
    [11] = 0,
    [12] = 29,
    [13] = 161682,
    ["body"] = "",
    ["id"] = "382069729",
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
 [12] = 
  {
    [1] = "Melina Cassel",
    [2] = "",
    [3] = "Raw Enchanter Materials",
    [4] = "/esoui/art/icons/crafting_components_runestones_034.dds",
    [5] = true,
    [6] = true,
    [7] = false,
    [8] = false,
    [9] = 3,
    [10] = 0,
    [11] = 0,
    [12] = 30,
    [13] = 176097,
    ["id"] = "382069739",
    ["items"] = 
    {
      [1] = 
      {
        [1] = "/esoui/art/icons/crafting_components_runestones_034.dds",
        [2] = 1,
        [3] = "",
        [4] = "|H0:item:45816:134:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|hKura|h",
      },
      [2] = 
      {
        [1] = "/esoui/art/icons/crafting_components_runestones_021.dds",
        [2] = 1,
        [3] = "",
        [4] = "|H0:item:45840:20:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|hMeip|h",
      },
      [3] = 
      {
        [1] = "/esoui/art/icons/crafting_components_runestones_001.dds",
        [2] = 1,
        [3] = "",
        [4] = "|H0:item:45854:24:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|hKuta|h",
      },
    },
  },
  [13] = 
  {
    [1] = "Guild Store",
    [2] = "",
    [3] = "Item Expired",
    [4] = "/esoui/art/icons/gear_breton_medium_waist_d.dds",
    [5] = false,
    [6] = true,
    [7] = false,
    [8] = false,
    [9] = 1,
    [10] = 0,
    [11] = 0,
    [12] = 29,
    [13] = 165184,
    ["id"] = "382069749",
    ["items"] = 
    {
      [1] = 
      {
        [1] = "/esoui/art/icons/gear_yokudan_medium_waist_a.dds",
        [2] = 1,
        [3] = "",
        [4] = "|H0:item:54932:283:50:0:0:0:0:0:0:0:0:0:0:0:0:35:0:0:0:10000:0|hBelt of the Air|h",
      },
    },
  },
  [14] = 
  {
    [1] = "Aksel Rockbiter",
    [2] = "",
    [3] = "Raw Blacksmith Materials",
    [4] = "/esoui/art/icons/crafting_ore_voidstone.dds",
    [5] = false,
    [6] = true,
    [7] = false,
    [8] = false,
    [9] = 3,
    [10] = 0,
    [11] = 0,
    [12] = 30,
    [13] = 253182,
    ["id"] = "382069759",
    ["items"] = 
    {
      [1] = 
      {
        [1] = "/esoui/art/icons/crafting_ore_voidstone.dds",
        [2] = 5,
        [3] = "",
        [4] = "|H0:item:23135:30:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|hvoidstone ore|h",
      },
      [2] = 
      {
        [1] = "/esoui/art/icons/crafting_smith_potion_standard_f_002.dds",
        [2] = 2,
        [3] = "",
        [4] = "|H0:item:33150:30:50:0:0:0:0:0:0:0:0:0:0:0:0:6:0:0:0:0:0|hflint|h",
      },
      [3] = 
      {
        [1] = "/esoui/art/icons/crafting_forester_weapon_vendor_component_002.dds",
        [2] = 1,
        [3] = "",
        [4] = "|H0:item:54171:32:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|hdwarven oil|h",
      },
    },
  },
  [15] = 
  {
    [1] = "Pacrooti",
    [2] = "",
    [3] = "Raw Woodworker Materials",
    [4] = "/esoui/art/icons/crafting_forester_weapon_component_004.dds",
    [5] = false,
    [6] = true,
    [7] = false,
    [8] = false,
    [9] = 3,
    [10] = 0,
    [11] = 0,
    [12] = 30,
    [13] = 253493,
    ["id"] = "382069769",
    ["items"] = 
    {
      [1] = 
      {
        [1] = "/esoui/art/icons/crafting_forester_weapon_component_004.dds",
        [2] = 3,
        [3] = "",
        [4] = "|H0:item:802:30:26:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|hrough maple^ns|h",
      },
      [2] = 
      {
        [1] = "/esoui/art/icons/crafting_forester_weapon_vendor_component_002.dds",
        [2] = 1,
        [3] = "",
        [4] = "|H0:item:54178:31:26:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|hpitch|h",
      },
      [3] = 
      {
        [1] = "/esoui/art/icons/crafting_wood_mastic.dds",
        [2] = 1,
        [3] = "",
        [4] = "|H0:item:54180:33:26:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|hmastic|h",
      },
    },
  },
  [16] = 
  {
    [1] = "Veesk-Olan",
    [2] = "",
    [3] = "Raw Clothier Materials",
    [4] = "/esoui/art/icons/crafting_enchantment_base_sardonyx_r2.dds",
    [5] = false,
    [6] = true,
    [7] = false,
    [8] = false,
    [9] = 3,
    [10] = 0,
    [11] = 0,
    [12] = 30,
    [13] = 342471,
    ["id"] = "382069779",
    ["items"] = 
    {
      [1] = 
      {
        [1] = "/esoui/art/icons/crafting_enchantment_base_sardonyx_r2.dds",
        [2] = 1,
        [3] = "",
        [4] = "|H0:item:30221:30:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|hSardonyx|h",
      },
      [2] = 
      {
        [1] = "/esoui/art/icons/crafting_flower_voidbloom.dds",
        [2] = 5,
        [3] = "",
        [4] = "|H0:item:33220:30:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|hraw void bloom^ns|h",
      },
      [3] = 
      {
        [1] = "/esoui/art/icons/crafting_outfitter_potion_014.dds",
        [2] = 2,
        [3] = "",
        [4] = "|H0:item:54177:34:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|hdreugh wax|h",
      },
    },
  },
  [17] = 
  {
    [1] = "Grulzul, Scribe to the Warlord",
    [2] = "",
    [3] = "Rewards for the Worthy!",
    [4] = "/esoui/art/icons/gear_breton_heavy_shoulders_d.dds",
    [5] = false,
    [6] = true,
    [7] = false,
    [8] = false,
    [9] = 1,
    [10] = 210,
    [11] = 0,
    [12] = 30,
    [13] = 332118,
    ["id"] = "382069789",
    ["items"] = 
    {
      [1] = 
      {
        [1] = "/esoui/art/icons/gear_khajiit_heavy_shoulders_d.dds",
        [2] = 1,
        [3] = "",
        [4] = "|H0:item:45100:359:50:26580:359:50:0:0:0:0:0:0:0:0:0:9:0:0:0:10000:0|hrubedite pauldron of health^p|h",
      },
    },
  },
  [18] = 
  {
    [1] = "@Finrfin",
    [2] = "Rhyli",
    [3] = "",
    [4] = "/esoui/art/icons/crafting_metals_molybdenum.dds",
    [5] = false,
    [6] = false,
    [7] = false,
    [8] = false,
    [9] = 1,
    [10] = 0,
    [11] = 10,
    [12] = 2,
    [13] = 159936,
    ["body"] = "",
    ["id"] = "382069799",
    ["items"] = 
    {
      [1] = 
      {
        [1] = "/esoui/art/icons/crafting_metals_molybdenum.dds",
        [2] = 1,
        [3] = "",
        [4] = "|H0:item:33251:30:3:0:0:0:0:0:0:0:0:0:0:0:0:1:0:0:0:0:0|hMolybdenum|h",
      },
    },
  },


}

TEST.tests['data3'] = testData



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
    [1] = "Abnab",
    [2] = "",
    [3] = "Raw Enchanter Materials",
    [4] = "/esoui/art/icons/crafting_components_runestones_023.dds",
    [5] = true,
    [6] = true,
    [7] = false,
    [8] = false,
    [9] = 3,
    [10] = 0,
    [11] = 0,
    [12] = 30,
    [13] = 332,
    ["id"] = "510348077",
    ["mailType"] = 3,
    ["items"] = 
    {
      [1] = 
      {
        [1] = "/esoui/art/icons/crafting_components_runestones_023.dds",
        [2] = 1,
        [3] = "",
        [4] = "|H0:item:45832:20:29:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",
      },
      [2] = 
      {
        [1] = "/esoui/art/icons/crafting_components_runestones_004.dds",
        [2] = 1,
        [3] = "",
        [4] = "|H0:item:45852:22:29:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",
      },
      [3] = 
      {
        [1] = "/esoui/art/icons/crafting_components_runestones_046.dds",
        [2] = 1,
        [3] = "",
        [4] = "|H0:item:45856:20:29:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",
      },
    },
  },
  [2] = 
  {
    [1] = "Gavin Gavonne",
    [2] = "",
    [3] = "Raw Provisioner Materials",
    [4] = "/esoui/art/icons/crafting_components_gin_002.dds",
    [5] = true,
    [6] = true,
    [7] = false,
    [8] = false,
    [9] = 3,
    [10] = 0,
    [11] = 0,
    [12] = 30,
    [13] = 332,
    ["id"] = "510348079",
    ["mailType"] = 3,
    ["items"] = 
    {
      [1] = 
      {
        [1] = "/esoui/art/icons/crafting_components_gin_002.dds",
        [2] = 20,
        [3] = "",
        [4] = "|H0:item:27052:25:29:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",
      },
      [2] = 
      {
        [1] = "/esoui/art/icons/crafting_components_malt_003.dds",
        [2] = 4,
        [3] = "",
        [4] = "|H0:item:27059:28:29:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",
      },
      [3] = 
      {
        [1] = "/esoui/art/icons/crafting_components_veg_001.dds",
        [2] = 20,
        [3] = "",
        [4] = "|H0:item:33758:25:29:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",
      },
    },
  },
  [3] = 
  {
    [1] = "Valinka Stoneheaver",
    [2] = "",
    [3] = "Raw Blacksmith Materials",
    [4] = "/esoui/art/icons/crafting_ore_base_iron_r1.dds",
    [5] = true,
    [6] = true,
    [7] = false,
    [8] = false,
    [9] = 4,
    [10] = 0,
    [11] = 0,
    [12] = 30,
    [13] = 333,
    ["id"] = "510348081",
    ["mailType"] = 3,
    ["items"] = 
    {
      [1] = 
      {
        [1] = "/esoui/art/icons/crafting_ore_base_iron_r1.dds",
        [2] = 4,
        [3] = "",
        [4] = "|H0:item:808:30:29:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",
      },
      [2] = 
      {
        [1] = "/esoui/art/icons/crafting_jewelry_base_amethyst_r3.dds",
        [2] = 1,
        [3] = "",
        [4] = "|H0:item:23204:30:29:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",
      },
      [3] = 
      {
        [1] = "/esoui/art/icons/crafting_metals_corundum.dds",
        [2] = 1,
        [3] = "",
        [4] = "|H0:item:33256:30:29:0:0:0:0:0:0:0:0:0:0:0:0:5:0:0:0:0:0|h|h",
      },
      [4] = 
      {
        [1] = "/esoui/art/icons/crafting_forester_weapon_vendor_component_002.dds",
        [2] = 1,
        [3] = "",
        [4] = "|H0:item:54171:32:29:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",
      },
    },
  },
  [4] = 
  {
    [1] = "Madam Firilanya",
    [2] = "",
    [3] = "Raw Clothier Materials",
    [4] = "/esoui/art/icons/crafting_cloth_base_jute_r1.dds",
    [5] = true,
    [6] = true,
    [7] = false,
    [8] = false,
    [9] = 4,
    [10] = 0,
    [11] = 0,
    [12] = 30,
    [13] = 333,
    ["id"] = "510348083",
    ["mailType"] = 3,
    ["items"] = 
    {
      [1] = 
      {
        [1] = "/esoui/art/icons/crafting_cloth_base_jute_r1.dds",
        [2] = 4,
        [3] = "",
        [4] = "|H0:item:812:30:29:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",
      },
      [2] = 
      {
        [1] = "/esoui/art/icons/crafting_jewelry_base_garnet_r3.dds",
        [2] = 1,
        [3] = "",
        [4] = "|H0:item:23171:30:29:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",
      },
      [3] = 
      {
        [1] = "/esoui/art/icons/crafting_smith_plug_sp_names_001.dds",
        [2] = 1,
        [3] = "",
        [4] = "|H0:item:33255:30:29:0:0:0:0:0:0:0:0:0:0:0:0:9:0:0:0:0:0|h|h",
      },
      [4] = 
      {
        [1] = "/esoui/art/icons/crafting_light_armor_vendor_component_002.dds",
        [2] = 1,
        [3] = "",
        [4] = "|H0:item:54175:32:29:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",
      },
    },
    ["requestReadMailFail"] = true,
  },
  [5] = 
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
    [13] = 334,
    ["id"] = "510348085",
    ["mailType"] = 3,
    ["items"] = 
    {
      [1] = 
      {
        [1] = "/esoui/art/icons/crafting_forester_weapon_component_004.dds",
        [2] = 3,
        [3] = "",
        [4] = "|H0:item:802:30:29:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",
      },
      [2] = 
      {
        [1] = "/esoui/art/icons/crafting_smith_potion_standard_f_002.dds",
        [2] = 1,
        [3] = "",
        [4] = "|H0:item:33150:30:29:0:0:0:0:0:0:0:0:0:0:0:0:6:0:0:0:0:0|h|h",
      },
      [3] = 
      {
        [1] = "/esoui/art/icons/crafting_wood_turpen.dds",
        [2] = 1,
        [3] = "",
        [4] = "|H0:item:54179:32:29:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",
      },
    },
    ["deleteMailFail"] = true,
  },
  [6] = 
  {
    [1] = "Madam Firilanya",
    [2] = "",
    [3] = "Raw Clothier Materials",
    [4] = "/esoui/art/icons/crafting_medium_armor_component_004.dds",
    [5] = true,
    [6] = true,
    [7] = false,
    [8] = false,
    [9] = 2,
    [10] = 0,
    [11] = 0,
    [12] = 30,
    [13] = 169,
    ["id"] = "510349337",
    ["mailType"] = 3,
    ["items"] = 
    {
      [1] = 
      {
        [1] = "/esoui/art/icons/crafting_medium_armor_component_004.dds",
        [2] = 3,
        [3] = "",
        [4] = "|H0:item:793:30:3:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",
      },
      [2] = 
      {
        [1] = "/esoui/art/icons/crafting_runecrafter_plug_component_002.dds",
        [2] = 1,
        [3] = "",
        [4] = "|H0:item:4456:30:3:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",
      },
    },
    ["takeMailItemsFail"] = true,
  },
  [7] = 
  {
    [1] = "Pacrooti",
    [2] = "",
    [3] = "Raw Woodworker Materials",
    [4] = "/esoui/art/icons/crafting_forester_weapon_component_004.dds",
    [5] = true,
    [6] = true,
    [7] = false,
    [8] = false,
    [9] = 2,
    [10] = 0,
    [11] = 0,
    [12] = 30,
    [13] = 169,
    ["id"] = "510349339",
    ["mailType"] = 3,
    ["items"] = 
    {
      [1] = 
      {
        [1] = "/esoui/art/icons/crafting_forester_weapon_component_004.dds",
        [2] = 3,
        [3] = "",
        [4] = "|H0:item:802:30:3:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",
      },
      [2] = 
      {
        [1] = "/esoui/art/icons/crafting_forester_weapon_vendor_component_002.dds",
        [2] = 1,
        [3] = "",
        [4] = "|H0:item:54178:31:3:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",
      },
    },
  },
  [8] = 
  {
    [1] = "Abnab",
    [2] = "",
    [3] = "Raw Enchanter Materials",
    [4] = "/esoui/art/icons/crafting_components_runestones_004.dds",
    [5] = false,
    [6] = true,
    [7] = false,
    [8] = false,
    [9] = 2,
    [10] = 0,
    [11] = 0,
    [12] = 30,
    [13] = 168,
    ["id"] = "510349345",
    ["mailType"] = 3,
    ["items"] = 
    {
      [1] = 
      {
        [1] = "/esoui/art/icons/crafting_components_runestones_004.dds",
        [2] = 1,
        [3] = "",
        [4] = "|H0:item:45852:22:3:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",
      },
      [2] = 
      {
        [1] = "/esoui/art/icons/crafting_components_runestones_046.dds",
        [2] = 1,
        [3] = "",
        [4] = "|H0:item:45856:20:3:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",
      },
    },
  },
}

TEST.tests['data4'] = testData


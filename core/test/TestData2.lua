
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
    [1] = "Gavin Gavonne",
    [2] = "",
    [3] = "Raw Provisioner Materials",
    [4] = "/esoui/art/icons/crafting_lemons.dds",
    [5] = false,
    [6] = true,
    [7] = false,
    [8] = false,
    [9] = 0,
    [10] = 0,
    [11] = 0,
    [12] = 30,
    [13] = 378616,
  },
  [2] = 
  {
    [1] = "Gavin Gavonne",
    [2] = "",
    [3] = "Raw Provisioner Materials",
    [4] = "/esoui/art/icons/crafting_components_malt_003.dds",
    [5] = false,
    [6] = true,
    [7] = false,
    [8] = false,
    [9] = 0,
    [10] = 0,
    [11] = 0,
    [12] = 30,
    [13] = 289805,
  },
  [3] = 
  {
    [1] = "Gavin Gavonne",
    [2] = "",
    [3] = "Raw Provisioner Materials",
    [4] = "/esoui/art/icons/crafting_wood_gum.dds",
    [5] = false,
    [6] = true,
    [7] = false,
    [8] = false,
    [9] = 0,
    [10] = 0,
    [11] = 0,
    [12] = 30,
    [13] = 209256,
  },
  [4] = 
  {
    [1] = "@Finrfin",
    [2] = "Rhyli",
    [3] = "",
    [4] = "/esoui/art/icons/crafting_jewelry_base_garnet_r3.dds",
    [5] = false,
    [6] = false,
    [7] = false,
    [8] = false,
    [9] = 0,
    [10] = 0,
    [11] = 0,
    [12] = 28,
    [13] = 196284,
    ["body"] = "x",
  },
  [5] = 
  {
    [1] = "@Finrfin",
    [2] = "Rhyli",
    [3] = "x",
    [4] = "/esoui/art/icons/crafting_fishing_torchbug.dds",
    [5] = true,
    [6] = false,
    [7] = false,
    [8] = false,
    [9] = 0,
    [10] = 0,
    [11] = 0,
    [12] = 28,
    [13] = 196273,
  },
  [6] = 
  {
    [1] = "@Finrfin",
    [2] = "Rhyli",
    [3] = "",
    [4] = "/esoui/art/icons/crafting_metals_molybdenum.dds",
    [5] = false,
    [6] = false,
    [7] = false,
    [8] = false,
    [9] = 0,
    [10] = 0,
    [11] = 10,
    [12] = 1,
    [13] = 196237,
  },
  [7] = 
  {
    [1] = "Gavin Gavonne",
    [2] = "",
    [3] = "Raw Provisioner Materials",
    [4] = "/esoui/art/icons/quest_dust_004.dds",
    [5] = true,
    [6] = true,
    [7] = false,
    [8] = false,
    [9] = 0,
    [10] = 0,
    [11] = 0,
    [12] = 30,
    [13] = 122787,
  },
  [8] = 
  {
    [1] = "@Rickter2049",
    [2] = "Rickter Tevintus",
    [3] = "Official Requiem PVP Campaign",
    [4] = "/esoui/art/icons/mail_001.dds",
    [5] = false,
    [6] = false,
    [7] = false,
    [8] = false,
    [9] = 0,
    [10] = 0,
    [11] = 0,
    [12] = 2,
    [13] = 86754,
  },
  [9] = 
  {
    [1] = "Gavin Gavonne",
    [2] = "",
    [3] = "Raw Provisioner Materials",
    [4] = "/esoui/art/icons/quest_honeycomb_001.dds",
    [5] = true,
    [6] = true,
    [7] = false,
    [8] = false,
    [9] = 0,
    [10] = 0,
    [11] = 0,
    [12] = 30,
    [13] = 38253,
  },
  [10] = 
  {
    [1] = "Madam Firilanya",
    [2] = "",
    [3] = "Raw Clothier Materials",
    [4] = "/esoui/art/icons/crafting_cloth_base_jute_r1.dds",
    [5] = false,
    [6] = true,
    [7] = false,
    [8] = false,
    [9] = 2,
    [10] = 0,
    [11] = 0,
    [12] = 30,
    [13] = 37927,
    ["items"] = 
    {
      [1] = 
      {
        [1] = "/esoui/art/icons/crafting_cloth_base_jute_r1.dds",
        [2] = 3,
        [3] = "",
        [4] = "|H0:item:812:30:3:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|hraw jute^ns|h",
      },
      [2] = 
      {
        [1] = "/esoui/art/icons/crafting_light_armor_vendor_001.dds",
        [2] = 1,
        [3] = "",
        [4] = "|H0:item:54174:31:3:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|hhemming|h",
      },
    },
  },
  [11] = 
  {
    [1] = "Abnab",
    [2] = "",
    [3] = "Raw Enchanter Materials",
    [4] = "/esoui/art/icons/crafting_components_runestones_035.dds",
    [5] = false,
    [6] = true,
    [7] = false,
    [8] = false,
    [9] = 2,
    [10] = 0,
    [11] = 0,
    [12] = 30,
    [13] = 37927,
    ["items"] = 
    {
      [1] = 
      {
        [1] = "/esoui/art/icons/crafting_components_runestones_035.dds",
        [2] = 1,
        [3] = "",
        [4] = "|H0:item:45817:20:3:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|hJode|h",
      },
      [2] = 
      {
        [1] = "/esoui/art/icons/crafting_components_runestones_004.dds",
        [2] = 1,
        [3] = "",
        [4] = "|H0:item:45852:22:3:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|hDenata|h",
      },
    },
  },
  [12] = 
  {
    [1] = "Pacrooti",
    [2] = "",
    [3] = "Raw Woodworker Materials",
    [4] = "/esoui/art/icons/crafting_forester_weapon_component_004.dds",
    [5] = true,
    [6] = true,
    [7] = false,
    [8] = false,
    [9] = 4,
    [10] = 0,
    [11] = 0,
    [12] = 30,
    [13] = 37928,
    ["items"] = 
    {
      [1] = 
      {
        [1] = "/esoui/art/icons/crafting_forester_weapon_component_004.dds",
        [2] = 3,
        [3] = "",
        [4] = "|H0:item:802:30:3:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|hrough maple^ns|h",
      },
      [2] = 
      {
        [1] = "/esoui/art/icons/crafting_jewelry_base_ruby_r3.dds",
        [2] = 1,
        [3] = "",
        [4] = "|H0:item:4486:30:3:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|hRuby|h",
      },
      [3] = 
      {
        [1] = "/esoui/art/icons/crafting_medium_armor_sp_names_002.dds",
        [2] = 1,
        [3] = "",
        [4] = "|H0:item:33258:30:3:0:0:0:0:0:0:0:0:0:0:0:0:2:0:0:0:0:0|hStarmetal|h",
      },
      [4] = 
      {
        [1] = "/esoui/art/icons/crafting_wood_turpen.dds",
        [2] = 1,
        [3] = "",
        [4] = "|H0:item:54179:32:3:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|hturpen|h",
      },
    },
  },
  [13] = 
  {
    [1] = "Aksel Rockbiter",
    [2] = "",
    [3] = "Raw Blacksmith Materials",
    [4] = "/esoui/art/icons/crafting_enchantment_base_jade_r3.dds",
    [5] = false,
    [6] = true,
    [7] = false,
    [8] = false,
    [9] = 5,
    [10] = 0,
    [11] = 0,
    [12] = 30,
    [13] = 20493,
    ["items"] = 
    {
      [1] = 
      {
        [1] = "/esoui/art/icons/crafting_enchantment_base_jade_r3.dds",
        [2] = 1,
        [3] = "",
        [4] = "|H0:item:810:30:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|hJade|h",
      },
      [2] = 
      {
        [1] = "/esoui/art/icons/crafting_jewelry_base_emerald_r2.dds",
        [2] = 1,
        [3] = "",
        [4] = "|H0:item:4442:30:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|hEmerald|h",
      },
      [3] = 
      {
        [1] = "/esoui/art/icons/crafting_ore_voidstone.dds",
        [2] = 5,
        [3] = "",
        [4] = "|H0:item:23135:30:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|hvoidstone ore|h",
      },
      [4] = 
      {
        [1] = "/esoui/art/icons/crafting_runecrafter_potion_008.dds",
        [2] = 1,
        [3] = "",
        [4] = "|H0:item:23203:30:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|hChysolite|h",
      },
      [5] = 
      {
        [1] = "/esoui/art/icons/crafting_forester_potion_vendor_001.dds",
        [2] = 2,
        [3] = "",
        [4] = "|H0:item:54172:33:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|hgrain solvent|h",
      },
    },
  },
  [14] = 
  {
    [1] = "Margog the Hammer",
    [2] = "",
    [3] = "Raw Woodworker Materials",
    [4] = "/esoui/art/icons/crafting_wood_rough_nightwood.dds",
    [5] = true,
    [6] = true,
    [7] = false,
    [8] = false,
    [9] = 6,
    [10] = 0,
    [11] = 0,
    [12] = 30,
    [13] = 20494,
    ["items"] = 
    {
      [1] = 
      {
        [1] = "/esoui/art/icons/crafting_wood_rough_nightwood.dds",
        [2] = 5,
        [3] = "",
        [4] = "|H0:item:23138:30:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|hrough nightwood^ns|h",
      },
      [2] = 
      {
        [1] = "/esoui/art/icons/crafting_enchantment_base_sardonyx_r2.dds",
        [2] = 1,
        [3] = "",
        [4] = "|H0:item:30221:30:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|hSardonyx|h",
      },
      [3] = 
      {
        [1] = "/esoui/art/icons/crafting_smith_plug_sp_names_001.dds",
        [2] = 2,
        [3] = "",
        [4] = "|H0:item:33255:30:50:0:0:0:0:0:0:0:0:0:0:0:0:9:0:0:0:0:0|hMoonstone|h",
      },
      [4] = 
      {
        [1] = "/esoui/art/icons/crafting_wood_turpen.dds",
        [2] = 1,
        [3] = "",
        [4] = "|H0:item:54179:32:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|hturpen|h",
      },
      [5] = 
      {
        [1] = "/esoui/art/icons/crafting_wood_mastic.dds",
        [2] = 1,
        [3] = "",
        [4] = "|H0:item:54180:33:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|hmastic|h",
      },
      [6] = 
      {
        [1] = "/esoui/art/icons/crafting_wood_ruddy_ash.dds",
        [2] = 1,
        [3] = "",
        [4] = "|H0:item:64502:30:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|hSanded Ruby Ash|h",
      },
    },
  },
  [15] = 
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
    [13] = 20495,
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
        [1] = "/esoui/art/icons/crafting_components_runestones_009.dds",
        [2] = 1,
        [3] = "",
        [4] = "|H0:item:45848:20:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|hMakderi|h",
      },
      [3] = 
      {
        [1] = "/esoui/art/icons/crafting_components_runestones_005.dds",
        [2] = 1,
        [3] = "",
        [4] = "|H0:item:45851:21:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|hJejota|h",
      },
    },
  },
  [16] = 
  {
    [1] = "Veesk-Olan",
    [2] = "",
    [3] = "Raw Clothier Materials",
    [4] = "/esoui/art/icons/crafting_runecrafter_plug_component_002.dds",
    [5] = false,
    [6] = true,
    [7] = false,
    [8] = false,
    [9] = 6,
    [10] = 0,
    [11] = 0,
    [12] = 30,
    [13] = 20495,
    ["items"] = 
    {
      [1] = 
      {
        [1] = "/esoui/art/icons/crafting_runecrafter_plug_component_002.dds",
        [2] = 1,
        [3] = "",
        [4] = "|H0:item:4456:30:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|hQuartz|h",
      },
      [2] = 
      {
        [1] = "/esoui/art/icons/crafting_scraps_daedra_hide.dds",
        [2] = 5,
        [3] = "",
        [4] = "|H0:item:4478:30:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|hshadowhide scraps^p|h",
      },
      [3] = 
      {
        [1] = "/esoui/art/icons/crafting_accessory_sp_names_001.dds",
        [2] = 1,
        [3] = "",
        [4] = "|H0:item:23173:30:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|hSapphire|h",
      },
      [4] = 
      {
        [1] = "/esoui/art/icons/crafting_enchantment_baxe_bloodstone_r2.dds",
        [2] = 1,
        [3] = "",
        [4] = "|H0:item:30219:30:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|hBloodstone|h",
      },
      [5] = 
      {
        [1] = "/esoui/art/icons/grafting_gems_adamantine.dds",
        [2] = 2,
        [3] = "",
        [4] = "|H0:item:33252:30:50:0:0:0:0:0:0:0:0:0:0:0:0:7:0:0:0:0:0|hAdamantite|h",
      },
      [6] = 
      {
        [1] = "/esoui/art/icons/crafting_runecrafter_potion_sp_name_001.dds",
        [2] = 2,
        [3] = "",
        [4] = "|H0:item:54176:33:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|helegant lining|h",
      },
    },
  },
}

TEST.tests['data2'] = testData


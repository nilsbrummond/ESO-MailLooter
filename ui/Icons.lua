
MailLooter = MailLooter or {}
local ADDON = MailLooter
ADDON.UI = ADDON.UI or {}
local UI = ADDON.UI

UI.standardIcons = {

    [ADDON.Core.MAILTYPE_UNKNOWN] = {
      normal = "/esoui/art/menubar/menuBar_help_up.dds",
    },

    [ADDON.Core.MAILTYPE_AVA] = {
      normal = "/esoui/art/mainmenu/menuBar_ava_up.dds",
      pressed = "/esoui/art/mainmenu/menuBar_ava_down.dds",
      disabled = "/esoui/art/mainmenu/menuBar_ava_disabled.dds",
      highlight = "/esoui/art/mainmenu/menuBar_ava_over.dds",
    },

    [ADDON.Core.MAILTYPE_HIRELING] = {
      normal = "/esoui/art/progression/progression_indexicon_tradeskills_up.dds",
      pressed = "EsoUI/Art/progression/progression_indexicon_tradeskills_down.dds",
      disabled = "EsoUI/Art/progression/progression_indexicon_tradeskills_disabled.dds",
      highlight = "EsoUI/Art/progression/progression_indexicon_tradeskills_over.dds",

      ------------------------

      blacksmithing = {
        normal = '/esoui/art/crafting/smithing_tabicon_refine_up.dds',
        pressed = '/esoui/art/crafting/smithing_tabicon_refine_down.dds',
        disabled = '/esoui/art/crafting/smithing_tabicon_refine_disabled.dds',
        highlight = '/esoui/art/crafting/smithing_tabicon_refine_over.dds',
      },
      clothing = {
        normal = "MailLooter/assets/clothier_up.dds",
        pressed = "MailLooter/assets/clothier_down.dds",
        disabled = "",
        highlight = "MailLooter/assets/clothier_over.dds",
      },
      enchanting = {
        normal = "/esoui/art/crafting/enchantment_tabicon_potency_up.dds",
        pressed = "/esoui/art/crafting/enchantment_tabicon_potency_down.dds",
        disabled = "/esoui/art/crafting/enchantment_tabicon_potency_disabled.dds",
        highlight = "/esoui/art/crafting/enchantment_tabicon_potency_over.dds",
      },
      provisioning = {
        normal = "/esoui/art/crafting/provisioner_indexicon_meat_up.dds",
        pressed = "/esoui/art/crafting/provisioner_indexicon_meat_down.dds",
        disabled = "/esoui/art/crafting/provisioner_indexicon_meat_disabled.dds",
        highlight = "/esoui/art/crafting/provisioner_indexicon_meat_over.dds",
      },
      woodworking = {
        normal = "MailLooter/assets/woodworking_up.dds",
        pressed = "MailLooter/assets/woodworking_down.dds",
        disabled = "",
        highlight = "MailLooter/assets/woodworking_over.dds",
      },
    },

    [ADDON.Core.MAILTYPE_STORE] = {
      normal = "/esoui/art/mainmenu/menuBar_guilds_up.dds",
      pressed = "/esoui/art/mainmenu/menuBar_guilds_down.dds",
      disabled = "/esoui/art/mainmenu/menuBar_guilds_disabled.dds",
      highlight = "/esoui/art/mainmenu/menuBar_guilds_over.dds",
    },

    [ADDON.Core.MAILTYPE_COD] = {
      normal = "/esoui/art/menubar/menubar_temp_over.dds",  -- Use the original that works.
      pressed = "MailLooter/assets/menubar_temp_down.dds",
      disabled = "MailLooter/assets/menubar_temp_disabled.dds",
      highlight = "MailLooter/assets/menubar_temp_over.dds",
    },

    [ADDON.Core.MAILTYPE_RETURNED] = {
      normal = "/esoui/art/vendor/vendor_tabicon_sell_up.dds",
      pressed = "/esoui/art/vendor/vendor_tabicon_sell_down.dds",
      disabled = "/esoui/art/vendor/vendor_tabicon_sell_disabled.dds",
      highlight = "/esoui/art/vendor/vendor_tabicon_sell_over.dds",
    },

    [ADDON.Core.MAILTYPE_SIMPLE] = {
      normal = "/esoui/art/mainmenu/menuBar_mail_up.dds",
      pressed = "/esoui/art/mainmenu/menuBar_mail_down.dds",
      disabled = "/esoui/art/mainmenu/menuBar_mail_disabled.dds",
      highlight = "/esoui/art/mainmenu/menuBar_mail_over.dds",
    },

    [ADDON.Core.MAILTYPE_COD_RECEIPT] = {
      normal = "/esoui/art/mainmenu/menubar_inventory_up.dds",
      pressed = "/esoui/art/mainmenu/menubar_inventory_down.dds",
      disabled = "/esoui/art/mainmenu/menubar_inventory_disabled.dds",
      highlight = "/esoui/art/mainmenu/menubar_inventory_over.dds",
    },

    [ADDON.Core.MAILTYPE_BOUNCE] = {
      normal = '/esoui/art/vendor/vendor_tabicon_buyback_up.dds',
    },

    ["all"] = {
      normal = 'esoui/art/inventory/inventory_tabicon_all_up.dds',
      pressed = "esoui/art/inventory/inventory_tabicon_all_down.dds",
      disabled = "esoui/art/inventory/inventory_tabicon_all_disabled.dds",
      highlight = "esoui/art/inventory/inventory_tabicon_all_over.dds",
    },

}

function UI.GetIcon(mailType, s1, s2)

  local i = UI.standardIcons[mailType]
  
  if not i then return nil end

  if s1 then 
    local i2 = i[s1]
    if not i2 then return nil end
    if s2 then
      return i2[s2]
    else
      return i2
    end
  else
    return i['normal']
  end

end


MailLooter = MailLooter or {}
local ADDON = MailLooter
ADDON.UI = ADDON.UI or {}
local UI = ADDON.UI


--
-- FilterFragmentClass
--

UI.FilterFragmentClass = ZO_Object:Subclass()

function UI.FilterFragmentClass:New()
  local obj = ZO_Object.New(self)
  obj:Initialize()
  return obj
end

function UI.FilterFragmentClass:Initialize()

  self.win = WINDOW_MANAGER:CreateTopLevelWindow(
                   "MailLooterFilterFragment")
 
  self.win:SetWidth(ZO_MailInbox:GetWidth() - 20)
  self.win:SetAnchor(TOPRIGHT, ZO_MailInbox, TOPRIGHT, -20, 100)
  self.win:SetHidden(true)

  local filterBar = CreateControlFromVirtual(
    "MailLooterFitlerMenuBar", self.win, "ZO_MenuBarTemplate")

  ZO_MenuBar_SetData(filterBar,
    { initialButtonAnchorPoint = RIGHT,
      normalSize = 50, 
      buttonPadding = -16, 
  })

  filterBar:SetAnchor(TOPRIGHT, self.win, TOPRIGHT, 0, 0)

  local avaButton = {
    descriptor = "ava",
    normal = "EsoUI/Art/mainmenu/menubar_ava_up.dds",
    pressed = "EsoUI/Art/mainmenu/menubar_ava_down.dds",
    disabled = "EsoUI/Art/mainmenu/menubar_ava_disabled.dds",
    highlight = "EsoUI/Art/mainmenu/menubar_ava_over.dds",
    callback = function(button) end,
    onInitializeCallback = function(button) end,
  }

  local blacksmithButton= {
    descriptor = "smith",
    normal = "EsoUI/Art/progression/progression_indexicon_tradeskills_up.dds",
    pressed = "EsoUI/Art/progression/progression_indexicon_tradeskills_down.dds",
    disabled = "EsoUI/Art/progression/progression_indexicon_tradeskills_disabled.dds",
    highlight = "EsoUI/Art/progression/progression_indexicon_tradeskills_over.dds",
    callback = function(button) end,
    onInitializeCallback = function(button) end,
  }
  local clothingButton= {
    descriptor = "clothing",
    normal = "EsoUI/Art/progression/progression_indexicon_tradeskills_up.dds",
    pressed = "EsoUI/Art/progression/progression_indexicon_tradeskills_down.dds",
    disabled = "EsoUI/Art/progression/progression_indexicon_tradeskills_disabled.dds",
    highlight = "EsoUI/Art/progression/progression_indexicon_tradeskills_over.dds",
    callback = function(button) end,
    onInitializeCallback = function(button) end,
  }
  local enchantingButton= {
    descriptor = "enchanting",
    normal = "EsoUI/Art/progression/progression_indexicon_tradeskills_up.dds",
    pressed = "EsoUI/Art/progression/progression_indexicon_tradeskills_down.dds",
    disabled = "EsoUI/Art/progression/progression_indexicon_tradeskills_disabled.dds",
    highlight = "EsoUI/Art/progression/progression_indexicon_tradeskills_over.dds",
    callback = function(button) end,
    onInitializeCallback = function(button) end,
  }
  local provisioningButton= {
    descriptor = "provisioning",
    normal = "EsoUI/Art/progression/progression_indexicon_tradeskills_up.dds",
    pressed = "EsoUI/Art/progression/progression_indexicon_tradeskills_down.dds",
    disabled = "EsoUI/Art/progression/progression_indexicon_tradeskills_disabled.dds",
    highlight = "EsoUI/Art/progression/progression_indexicon_tradeskills_over.dds",
    callback = function(button) end,
    onInitializeCallback = function(button) end,
  }
  local woodworkingButton= {
    descriptor = "woodworking",
    normal = "EsoUI/Art/progression/progression_indexicon_tradeskills_up.dds",
    pressed = "EsoUI/Art/progression/progression_indexicon_tradeskills_down.dds",
    disabled = "EsoUI/Art/progression/progression_indexicon_tradeskills_disabled.dds",
    highlight = "EsoUI/Art/progression/progression_indexicon_tradeskills_over.dds",
    callback = function(button) end,
    onInitializeCallback = function(button) end,
  }


  local hirelingButton = {
    descriptor = "hireling",
    normal = "EsoUI/Art/progression/progression_indexicon_tradeskills_up.dds",
    pressed = "EsoUI/Art/progression/progression_indexicon_tradeskills_down.dds",
    disabled = "EsoUI/Art/progression/progression_indexicon_tradeskills_disabled.dds",
    highlight = "EsoUI/Art/progression/progression_indexicon_tradeskills_over.dds",
    callback = function(button) end,
    onInitializeCallback = function(button) end,

    sub = { blacksmithButton, clothingButton, enchantingButton,
            provisioningButton, woodworkingButton, }
  }

  local storeButton = {
    descriptor = "store",
    normal = "EsoUI/Art/mainmenu/menubar_guilds_up.dds",
    pressed = "EsoUI/Art/mainmenu/menubar_guilds_down.dds",
    disabled = "EsoUI/Art/mainmenu/menubar_guilds_disabled.dds",
    highlight = "EsoUI/Art/mainmenu/menubar_guilds_over.dds",
    callback = function(button) end,
    onInitializeCallback = function(button) end,
  }

  local codButton = {
    descriptor = "cod",
    normal = "EsoUI/Art/Inventory/inventory_tabIcon_all_up.dds",
    pressed = "EsoUI/Art/Inventory/inventory_tabIcon_all_down.dds",
    disabled = "EsoUI/Art/Inventory/inventory_tabIcon_all_disabled.dds",
    highlight = "EsoUI/Art/Inventory/inventory_tabIcon_all_over.dds",
    callback = function(button) end,
    onInitializeCallback = function(button) end,
  }

  local returnedButton = {
    descriptor = "returned",
    normal = "EsoUI/Art/Inventory/inventory_tabIcon_all_up.dds",
    pressed = "EsoUI/Art/Inventory/inventory_tabIcon_all_down.dds",
    disabled = "EsoUI/Art/Inventory/inventory_tabIcon_all_disabled.dds",
    highlight = "EsoUI/Art/Inventory/inventory_tabIcon_all_over.dds",
    callback = function(button) end,
    onInitializeCallback = function(button) end,
  }

  local simpleButton = {
    descriptor = "simple",
    normal = "/esoui/art/mainmenu/menubar_mail_up.dds",
    pressed = "/esoui/art/mainmenu/menubar_mail_down.dds",
    disabled = "EsoUI/Art/Inventory/inventory_tabIcon_all_disabled.dds",
    highlight = "/esoui/art/mainmenu/menubar_mail_over.dds",
    callback = function(button) end,
    onInitializeCallback = function(button) end,
  }

  local codReceiptButton = {
    descriptor = "codReceipt",
    normal = "EsoUI/Art/Inventory/inventory_tabIcon_all_up.dds",
    pressed = "EsoUI/Art/Inventory/inventory_tabIcon_all_down.dds",
    disabled = "EsoUI/Art/Inventory/inventory_tabIcon_all_disabled.dds",
    highlight = "EsoUI/Art/Inventory/inventory_tabIcon_all_over.dds",
    callback = function(button) end,
    onInitializeCallback = function(button) end,
  }

  local allButton = {
    descriptor = "all",
    normal = "EsoUI/Art/Inventory/inventory_tabIcon_all_up.dds",
    pressed = "EsoUI/Art/Inventory/inventory_tabIcon_all_down.dds",
    disabled = "EsoUI/Art/Inventory/inventory_tabIcon_all_disabled.dds",
    highlight = "EsoUI/Art/Inventory/inventory_tabIcon_all_over.dds",
    callback = function(button) end,
    onInitializeCallback = function(button) end,

    sub = { avaButton, hirelingButton, storeButton, codButton, 
            returnedButton, simpleButton, codReceiptButton }

  }


  local newControl = ZO_MenuBar_AddButton(filterBar, codReceiptButton)
  local newControl = ZO_MenuBar_AddButton(filterBar, simpleButton)
  local newControl = ZO_MenuBar_AddButton(filterBar, returnedButton)
  local newControl = ZO_MenuBar_AddButton(filterBar, codButton)
  local newControl = ZO_MenuBar_AddButton(filterBar, storeButton)
  local newControl = ZO_MenuBar_AddButton(filterBar, hirelingButton)
  local newControl = ZO_MenuBar_AddButton(filterBar, avaButton)
  local newControl = ZO_MenuBar_AddButton(filterBar, allButton)

  ZO_MenuBar_SetAllButtonsEnabled(filterBar, true, true)

  self.filterBar = filterBar


  local label = CreateControl(
    "MailLooterFitlerLabel", self.win, CT_LABEL)
  
  label:SetFont("ZoFontWinH3")
  label:SetFont("ALL")
  label:SetAnchor(RIGHT, filterBar, LEFT, -10, 0)


  self.FRAGMENT = ZO_FadeSceneFragment:New(self.win)

end


MailLooter = MailLooter or {}
local ADDON = MailLooter
ADDON.UI = ADDON.UI or {}
local UI = ADDON.UI


UI.MultiSelectMenuBar = {}


function UI.MultiSelectMenuBar:New()
  local obj = MenuBar.New(self)
  obj:Initialize()
  return obj
end

--
--
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

  local menuBar = CreateControlFromVirtual("MailLooterFitlerMenuBar", self.win, "ZO_MenuBarTemplate")
  ZO_MenuBar_SetData(menuBar, { initialButtonAnchorPoint = RIGHT, normalSize = 50, buttonPadding = -16, })

  menuBar:SetAnchor(TOPRIGHT, self.win, TOPRIGHT, 0, 0)

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
  }
  local clothingButton= {
    descriptor = "clothing",
  }
  local enchantingButton= {
    descriptor = "enchanting",
  }
  local provisioningButton= {
    descriptor = "provisioning",
  }
  local woodworkingButton= {
    descriptor = "woodworking",
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
    descriptor = "cod",
    normal = "EsoUI/Art/Inventory/inventory_tabIcon_all_up.dds",
    pressed = "EsoUI/Art/Inventory/inventory_tabIcon_all_down.dds",
    disabled = "EsoUI/Art/Inventory/inventory_tabIcon_all_disabled.dds",
    highlight = "EsoUI/Art/Inventory/inventory_tabIcon_all_over.dds",
    callback = function(button) end,
    onInitializeCallback = function(button) end,
  }

  local simpleButton = {
    descriptor = "cod",
    normal = "EsoUI/Art/Inventory/inventory_tabIcon_all_up.dds",
    pressed = "EsoUI/Art/Inventory/inventory_tabIcon_all_down.dds",
    disabled = "EsoUI/Art/Inventory/inventory_tabIcon_all_disabled.dds",
    highlight = "EsoUI/Art/Inventory/inventory_tabIcon_all_over.dds",
    callback = function(button) end,
    onInitializeCallback = function(button) end,
  }

  local codReceiptButton = {
    descriptor = "cod",
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


--  local newControl = ZO_MenuBar_AddButton(menuBar, codReceiptButton)
--  local newControl = ZO_MenuBar_AddButton(menuBar, simpleButton)
--  local newControl = ZO_MenuBar_AddButton(menuBar, returnedButton)
--  local newControl = ZO_MenuBar_AddButton(menuBar, codButton)
--  local newControl = ZO_MenuBar_AddButton(menuBar, storeButton)
--  local newControl = ZO_MenuBar_AddButton(menuBar, hirelingButton)
--  local newControl = ZO_MenuBar_AddButton(menuBar, avaButton)
  local newControl = ZO_MenuBar_AddButton(menuBar, allButton)

  self.menuBar = menuBar

  self.FRAGMENT = ZO_FadeSceneFragment:New(self.win)

end

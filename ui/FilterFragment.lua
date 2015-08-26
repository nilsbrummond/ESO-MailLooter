
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
  self.win:SetAnchor(TOP, ZO_MailInbox, TOP, 0, 64)
  self.win:SetHidden(true)

  local filterBar = CreateControlFromVirtual(
    "MailLooterFitlerBar", self.win, "Lodur_MultiSelectBarTemplate")
  filterBar:SetAnchor(TOPRIGHT, self.win, TOPRIGHT, 0, 0)

  Lodur_MultiSelectBar_OnInitialized(filterBar)

  Lodur_MultiSelectBar_SetData(filterBar,
    { initialButtonAnchorPoint = LEFT,
      normalSize = {50, 50, 32},
      downSize = {64, 50, 32},
      buttonPadding = {15, 10, 0 }, 
      buttonTemplate = "ZO_MenuBarButtonTemplateWithTooltip",
  })

  filterBar:SetAnchor(TOP, self.win, TOP, 58, 0)

  local avaButton = {
    descriptor = "ava",
    normal = UI.GetIcon(ADDON.Core.MAILTYPE_AVA, 'normal'),
    pressed = UI.GetIcon(ADDON.Core.MAILTYPE_AVA, 'pressed'),
    disabled = UI.GetIcon(ADDON.Core.MAILTYPE_AVA, 'disabled'),
    highlight = UI.GetIcon(ADDON.Core.MAILTYPE_AVA, 'highlight'),
    callback = function(button) end,
    onInitializeCallback = function(button) end,
  }

  local blacksmithButton= {
    descriptor = "smith",
    normal = UI.GetIcon(ADDON.Core.MAILTYPE_HIRELING, 'blacksmithing', 'normal'),
    pressed = UI.GetIcon(ADDON.Core.MAILTYPE_HIRELING, 'blacksmithing', 'pressed'),
    disabled = UI.GetIcon(ADDON.Core.MAILTYPE_HIRELING, 'blacksmithing', 'disabled'),
    highlight = UI.GetIcon(ADDON.Core.MAILTYPE_HIRELING, 'blacksmithing', 'highlight'),
    callback = function(button) end,
    onInitializeCallback = function(button) end,
  }
  local clothingButton= {
    descriptor = "clothing",
    normal = UI.GetIcon(ADDON.Core.MAILTYPE_HIRELING, 'clothing', 'normal'),
    pressed = UI.GetIcon(ADDON.Core.MAILTYPE_HIRELING, 'clothing', 'pressed'),
    disabled = UI.GetIcon(ADDON.Core.MAILTYPE_HIRELING, 'clothing', 'disabled'),
    highlight = UI.GetIcon(ADDON.Core.MAILTYPE_HIRELING, 'clothing', 'highlight'),
    callback = function(button) end,
    onInitializeCallback = function(button) end,
  }
  local enchantingButton= {
    descriptor = "enchanting",
    normal = UI.GetIcon(ADDON.Core.MAILTYPE_HIRELING, 'enchanting', 'normal'),
    pressed = UI.GetIcon(ADDON.Core.MAILTYPE_HIRELING, 'enchanting', 'pressed'),
    disabled = UI.GetIcon(ADDON.Core.MAILTYPE_HIRELING, 'enchanting', 'disabled'),
    highlight = UI.GetIcon(ADDON.Core.MAILTYPE_HIRELING, 'enchanting', 'highlight'),
    callback = function(button) end,
    onInitializeCallback = function(button) end,
  }
  local provisioningButton= {
    descriptor = "provisioning",
    normal = UI.GetIcon(ADDON.Core.MAILTYPE_HIRELING, 'provisioning', 'normal'),
    pressed = UI.GetIcon(ADDON.Core.MAILTYPE_HIRELING, 'provisioning', 'pressed'),
    disabled = UI.GetIcon(ADDON.Core.MAILTYPE_HIRELING, 'provisioning', 'disabled'),
    highlight = UI.GetIcon(ADDON.Core.MAILTYPE_HIRELING, 'provisioning', 'highlight'),
    callback = function(button) end,
    onInitializeCallback = function(button) end,
  }
  local woodworkingButton= {
    descriptor = "woodworking",
    normal = UI.GetIcon(ADDON.Core.MAILTYPE_HIRELING, 'woodworking', 'normal'),
    pressed = UI.GetIcon(ADDON.Core.MAILTYPE_HIRELING, 'woodworking', 'pressed'),
    disabled = UI.GetIcon(ADDON.Core.MAILTYPE_HIRELING, 'woodworking', 'disabled'),
    highlight = UI.GetIcon(ADDON.Core.MAILTYPE_HIRELING, 'woodworking', 'highlight'),
    callback = function(button) end,
    onInitializeCallback = function(button) end,
  }


  local hirelingButton = {
    descriptor = "hireling",
    normal = UI.GetIcon(ADDON.Core.MAILTYPE_HIRELING, 'normal'),
    pressed = UI.GetIcon(ADDON.Core.MAILTYPE_HIRELING, 'pressed'),
    disabled = UI.GetIcon(ADDON.Core.MAILTYPE_HIRELING, 'disabled'),
    highlight = UI.GetIcon(ADDON.Core.MAILTYPE_HIRELING, 'highlight'),
    callback = function(button) end,
    onInitializeCallback = function(button) end,

    sub = { blacksmithButton, clothingButton, enchantingButton,
            provisioningButton, woodworkingButton, }
  }

  local storeButton = {
    descriptor = "store",
    normal = UI.GetIcon(ADDON.Core.MAILTYPE_STORE, 'normal'),
    pressed = UI.GetIcon(ADDON.Core.MAILTYPE_STORE, 'pressed'),
    disabled = UI.GetIcon(ADDON.Core.MAILTYPE_STORE, 'disabled'),
    highlight = UI.GetIcon(ADDON.Core.MAILTYPE_STORE, 'highlight'),
    callback = function(button) end,
    onInitializeCallback = function(button) end,
  }

  local codButton = {
    descriptor = "cod",
    normal = UI.GetIcon(ADDON.Core.MAILTYPE_COD),
    pressed = UI.GetIcon(ADDON.Core.MAILTYPE_COD, 'pressed'),
    disabled = UI.GetIcon(ADDON.Core.MAILTYPE_COD, 'disabled'),
    highlight = UI.GetIcon(ADDON.Core.MAILTYPE_COD, 'highlight'),
    callback = function(button) end,
    onInitializeCallback = function(button) end,
  }

  local returnedButton = {
    descriptor = "returned",
    normal = UI.GetIcon(ADDON.Core.MAILTYPE_RETURNED, 'normal'),
    pressed = UI.GetIcon(ADDON.Core.MAILTYPE_RETURNED, 'pressed'),
    disabled = UI.GetIcon(ADDON.Core.MAILTYPE_RETURNED, 'disabled'),
    highlight = UI.GetIcon(ADDON.Core.MAILTYPE_RETURNED, 'highlight'),
    callback = function(button) end,
    onInitializeCallback = function(button) end,
  }

  local simpleButton = {
    descriptor = "simple",
    normal = UI.GetIcon(ADDON.Core.MAILTYPE_SIMPLE, 'normal'),
    pressed = UI.GetIcon(ADDON.Core.MAILTYPE_SIMPLE, 'pressed'),
    disabled = UI.GetIcon(ADDON.Core.MAILTYPE_SIMPLE, 'disabled'),
    highlight = UI.GetIcon(ADDON.Core.MAILTYPE_SIMPLE, 'highlight'),
    callback = function(button) end,
    onInitializeCallback = function(button) end,
  }

  local codReceiptButton = {
    descriptor = "codReceipt",
    normal = UI.GetIcon(ADDON.Core.MAILTYPE_COD_RECEIPT, 'normal'),
    pressed = UI.GetIcon(ADDON.Core.MAILTYPE_COD_RECEIPT, 'pressed'),
    disabled = UI.GetIcon(ADDON.Core.MAILTYPE_COD_RECEIPT, 'disabled'),
    highlight = UI.GetIcon(ADDON.Core.MAILTYPE_COD_RECEIPT, 'highlight'),
    callback = function(button) end,
    onInitializeCallback = function(button) end,
  }

  local allButton = {
    descriptor = "all",
    toolTip = "ALL",
    normal = UI.GetIcon('all', 'normal'),
    pressed = UI.GetIcon('all', 'pressed'),
    disabled = UI.GetIcon('all', 'disabled'),
    highlight = UI.GetIcon('all', 'highlight'),
    callback = function(button) end,
    onInitializeCallback = function(button) end,

    sub = { avaButton, hirelingButton, storeButton, codButton, 
            returnedButton, simpleButton, codReceiptButton }

  }

  Lodur_MultiSelectBar_AddButtons(filterBar, allButton)

  local fn = function() self:UpdateFilterLabel() end
  filterBar:SetHandler("OnValueChanged", fn)

  --local fn_out = filterBar:GetHandler("OnValueChanged") 
  --assert(fn_out ~= nil)
  --assert(fn == fn_out)

  self.filterBar = filterBar

  local label = CreateControl(
    "MailLooterFitlerLabel", self.win, CT_LABEL)
  
  label:SetFont("ZoFontWinH3")
  label:SetText("Filter Coming Soon")
  label:SetHeight(label:GetFontHeight())
  label:SetAnchor(RIGHT, filterBar, LEFT, -20, 0)

  self.label = label


  local div = WINDOW_MANAGER:CreateControl(
    nil, self.win, CT_TEXTURE)
  div:SetTexture("EsoUI/Art/Miscellaneous/centerscreen_topDivider.dds")
  div:SetHeight(2)
  div:SetWidth(900)
  div:SetAnchor(TOP, self.win, TOP, 0, 42)


  self.FRAGMENT = ZO_FadeSceneFragment:New(self.win)

end

function UI.FilterFragmentClass:UpdateFilterLabel()
  UI.DEBUG("UpdateFilterLabel")

  local selected = Lodur_MultiSelectBar_GetSelected(self.filterBar)
end

function UI.FilterFragmentClass:SetLocked(locked)
  Lodur_MultiSelectBar_SetEnabled(self.filterBar, not locked)
end



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
  self.win:SetAnchor(TOP, ZO_MailInbox, TOP, 0, 53)
  self.win:SetMouseEnabled(true)
  self.win:SetHeight(50)
  self.win:SetHidden(true)

  local filterBar = CreateControlFromVirtual(
    "MailLooterFitlerBar", self.win, "Lodur_MultiSelectBarTemplate")
  filterBar:SetAnchor(CENTER, self.win, CENTER, 58, 2)

  Lodur_MultiSelectBar_SetData(filterBar,
    { initialButtonAnchorPoint = LEFT,
      normalSize = {50, 50, 32},
      downSize = {64, 58, 40},
      buttonPadding = {15, 10, 0 }, 
      separator = { false, true},
  })


  local avaButton = {
    descriptor = "ava",
    tooltip = SI_MAILLOOTER_FILTER_AVA,
    normal = UI.GetIcon(ADDON.Core.MAILTYPE_AVA, 'normal'),
    pressed = UI.GetIcon(ADDON.Core.MAILTYPE_AVA, 'pressed'),
    disabled = UI.GetIcon(ADDON.Core.MAILTYPE_AVA, 'disabled'),
    highlight = UI.GetIcon(ADDON.Core.MAILTYPE_AVA, 'highlight'),
    callback = function(button) end,
    onInitializeCallback = function(button) end,
  }

  local blacksmithButton= {
    descriptor = "smith",
    tooltip = SI_MAILLOOTER_FILTER_HIRELING_SMITH,
    normal = UI.GetIcon(ADDON.Core.MAILTYPE_HIRELING, 'blacksmithing', 'normal'),
    pressed = UI.GetIcon(ADDON.Core.MAILTYPE_HIRELING, 'blacksmithing', 'pressed'),
    disabled = UI.GetIcon(ADDON.Core.MAILTYPE_HIRELING, 'blacksmithing', 'disabled'),
    highlight = UI.GetIcon(ADDON.Core.MAILTYPE_HIRELING, 'blacksmithing', 'highlight'),
    callback = function(button) end,
    onInitializeCallback = function(button) end,
  }
  local clothingButton= {
    descriptor = "clothing",
    tooltip = SI_MAILLOOTER_FILTER_HIRELING_CLOTH,
    normal = UI.GetIcon(ADDON.Core.MAILTYPE_HIRELING, 'clothing', 'normal'),
    pressed = UI.GetIcon(ADDON.Core.MAILTYPE_HIRELING, 'clothing', 'pressed'),
    disabled = UI.GetIcon(ADDON.Core.MAILTYPE_HIRELING, 'clothing', 'disabled'),
    highlight = UI.GetIcon(ADDON.Core.MAILTYPE_HIRELING, 'clothing', 'highlight'),
    callback = function(button) end,
    onInitializeCallback = function(button) end,
  }
  local enchantingButton= {
    descriptor = "enchanting",
    tooltip = SI_MAILLOOTER_FILTER_HIRELING_ENCHANT,
    normal = UI.GetIcon(ADDON.Core.MAILTYPE_HIRELING, 'enchanting', 'normal'),
    pressed = UI.GetIcon(ADDON.Core.MAILTYPE_HIRELING, 'enchanting', 'pressed'),
    disabled = UI.GetIcon(ADDON.Core.MAILTYPE_HIRELING, 'enchanting', 'disabled'),
    highlight = UI.GetIcon(ADDON.Core.MAILTYPE_HIRELING, 'enchanting', 'highlight'),
    callback = function(button) end,
    onInitializeCallback = function(button) end,
  }
  local provisioningButton= {
    descriptor = "provisioning",
    tooltip = SI_MAILLOOTER_FILTER_HIRELING_PROVISION,
    normal = UI.GetIcon(ADDON.Core.MAILTYPE_HIRELING, 'provisioning', 'normal'),
    pressed = UI.GetIcon(ADDON.Core.MAILTYPE_HIRELING, 'provisioning', 'pressed'),
    disabled = UI.GetIcon(ADDON.Core.MAILTYPE_HIRELING, 'provisioning', 'disabled'),
    highlight = UI.GetIcon(ADDON.Core.MAILTYPE_HIRELING, 'provisioning', 'highlight'),
    callback = function(button) end,
    onInitializeCallback = function(button) end,
  }
  local woodworkingButton= {
    descriptor = "woodworking",
    tooltip = SI_MAILLOOTER_FILTER_HIRELING_WOOD,
    normal = UI.GetIcon(ADDON.Core.MAILTYPE_HIRELING, 'woodworking', 'normal'),
    pressed = UI.GetIcon(ADDON.Core.MAILTYPE_HIRELING, 'woodworking', 'pressed'),
    disabled = UI.GetIcon(ADDON.Core.MAILTYPE_HIRELING, 'woodworking', 'disabled'),
    highlight = UI.GetIcon(ADDON.Core.MAILTYPE_HIRELING, 'woodworking', 'highlight'),
    callback = function(button) end,
    onInitializeCallback = function(button) end,
  }


  local hirelingButton = {
    descriptor = "hireling",
    tooltip = SI_MAILLOOTER_FILTER_HIRELING,
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
    tooltip = SI_MAILLOOTER_FILTER_STORE,
    normal = UI.GetIcon(ADDON.Core.MAILTYPE_STORE, 'normal'),
    pressed = UI.GetIcon(ADDON.Core.MAILTYPE_STORE, 'pressed'),
    disabled = UI.GetIcon(ADDON.Core.MAILTYPE_STORE, 'disabled'),
    highlight = UI.GetIcon(ADDON.Core.MAILTYPE_STORE, 'highlight'),
    callback = function(button) end,
    onInitializeCallback = function(button) end,
  }

  local codButton = {
    descriptor = "cod",
    tooltip = SI_MAILLOOTER_FILTER_COD,
    normal = UI.GetIcon(ADDON.Core.MAILTYPE_COD),
    pressed = UI.GetIcon(ADDON.Core.MAILTYPE_COD, 'pressed'),
    disabled = UI.GetIcon(ADDON.Core.MAILTYPE_COD, 'disabled'),
    highlight = UI.GetIcon(ADDON.Core.MAILTYPE_COD, 'highlight'),
    callback = function(button) end,
    onInitializeCallback = function(button) end,
  }

  local returnedButton = {
    descriptor = "returned",
    tooltip = SI_MAILLOOTER_FILTER_RETURNED,
    normal = UI.GetIcon(ADDON.Core.MAILTYPE_RETURNED, 'normal'),
    pressed = UI.GetIcon(ADDON.Core.MAILTYPE_RETURNED, 'pressed'),
    disabled = UI.GetIcon(ADDON.Core.MAILTYPE_RETURNED, 'disabled'),
    highlight = UI.GetIcon(ADDON.Core.MAILTYPE_RETURNED, 'highlight'),
    callback = function(button) end,
    onInitializeCallback = function(button) end,
  }

  local simpleButton = {
    descriptor = "simple",
    tooltip = SI_MAILLOOTER_FILTER_SIMPLE,
    normal = UI.GetIcon(ADDON.Core.MAILTYPE_SIMPLE, 'normal'),
    pressed = UI.GetIcon(ADDON.Core.MAILTYPE_SIMPLE, 'pressed'),
    disabled = UI.GetIcon(ADDON.Core.MAILTYPE_SIMPLE, 'disabled'),
    highlight = UI.GetIcon(ADDON.Core.MAILTYPE_SIMPLE, 'highlight'),
    callback = function(button) end,
    onInitializeCallback = function(button) end,
  }

  local codReceiptButton = {
    descriptor = "codReceipt",
    tooltip = SI_MAILLOOTER_FILTER_COD_RECEIPT,
    normal = UI.GetIcon(ADDON.Core.MAILTYPE_COD_RECEIPT, 'normal'),
    pressed = UI.GetIcon(ADDON.Core.MAILTYPE_COD_RECEIPT, 'pressed'),
    disabled = UI.GetIcon(ADDON.Core.MAILTYPE_COD_RECEIPT, 'disabled'),
    highlight = UI.GetIcon(ADDON.Core.MAILTYPE_COD_RECEIPT, 'highlight'),
    callback = function(button) end,
    onInitializeCallback = function(button) end,
  }

  local allButton = {
    descriptor = "all",
    tooltip = SI_MAILLOOTER_FILTER_ALL,
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

  Lodur_MultiSelectBar_SetOnChanged(
    filterBar, function() self:UpdateFilterLabel() end)


  self.filterBar = filterBar

  local label = CreateControl(
    "MailLooterFitlerLabel", self.win, CT_LABEL)
  
  label:SetFont("ZoFontWinH3")
  label:SetText("Filtering Coming Soon:")
  label:SetHeight(label:GetFontHeight())
  label:SetAnchor(RIGHT, filterBar, LEFT, -20, 0)

  self.label = label


  local div = WINDOW_MANAGER:CreateControl(
    nil, self.win, CT_TEXTURE)
  div:SetTexture("EsoUI/Art/Miscellaneous/centerscreen_topDivider.dds")
  div:SetHeight(2)
  div:SetWidth(900)
  div:SetAnchor(TOP, self.win, TOP, 0, 54)

  Lodur_MultiSelectBar_SelectDescriptor(filterBar, 'all', true)

  self.FRAGMENT = ZO_FadeSceneFragment:New(self.win)

end

local filterTerms = {
  ['all'] = SI_MAILLOOTER_FILTER_LABEL_ALL,
  ['ava'] = SI_MAILLOOTER_FILTER_LABEL_AVA,
  ['hireling'] = SI_MAILLOOTER_FILTER_LABEL_HIRELING,
  ['smith'] = SI_MAILLOOTER_FILTER_LABEL_SMITH,
  ['clothing'] = SI_MAILLOOTER_FILTER_LABEL_CLOTH,
  ['enchanting'] = SI_MAILLOOTER_FILTER_LABEL_ENCHANT,
  ['provisioning'] = SI_MAILLOOTER_FILTER_LABEL_PROVISION,
  ['woodworking'] = SI_MAILLOOTER_FILTER_LABEL_WOOD,
  ['store'] = SI_MAILLOOTER_FILTER_LABEL_STORE,
  ['cod'] = SI_MAILLOOTER_FILTER_LABEL_COD,
  ['returned'] = SI_MAILLOOTER_FILTER_LABEL_RETURNED,
  ['simple'] = SI_MAILLOOTER_FILTER_LABEL_SIMPLE,
  ['codReceipt'] = SI_MAILLOOTER_FILTER_LABEL_COD_RECEIPT,
}

function UI.FilterFragmentClass:UpdateFilterLabel(control)
  UI.DEBUG("UpdateFilterLabel")

  local selections = Lodur_MultiSelectBar_GetSelected(self.filterBar)
  local selected = selections.selected
  local unselected = selections.unselected

  local font = "ZoFontWinH3"
  local msg

  if #selected == 0 then
    msg = GetString(SI_MAILLOOTER_FILTER_LABEL_NOTHING)
  elseif #selected == 1 then
    msg = GetString(filterTerms[selected[1]])
  elseif #selected == 2 then
    -- TODO: Need a translate method for '&'
    font = "ZoFontWinH5"
    msg = GetString(filterTerms[selected[1]]) .. " & " ..
          GetString(filterTerms[selected[2]])

  elseif #unselected == 1 then
    msg = "|cFF0000NO|r " .. GetString(filterTerms[unselected[1]])
  elseif #unselected == 2 then
    font = "ZoFontWinH5"
    -- TODO: Need a translate method for '&'
    msg = "|cFF0000NO|r " .. 
          GetString(filterTerms[unselected[1]]) .. " & " ..
          GetString(filterTerms[unselected[2]])
  else
    msg = GetString(SI_MAILLOOTER_FILTER_LABEL_COMPLEX)
  end

  self.label:SetFont(font)
  self.label:SetText(msg)

end

function UI.FilterFragmentClass:SetLocked(locked)
  Lodur_MultiSelectBar_SetLocked(self.filterBar, locked)
end


function UI.FilterFragmentClass:SetFilter(filter, skipAnimation)

  UI.DEBUG("FilterFragmentClass:SetFilter:")

  Lodur_MultiSelectBar_ClearSelection(self.filterBar)

  for i,k in ipairs(filter) do
    UI.DEBUG("  " .. k)
    if not Lodur_MultiSelectBar_SelectDescriptor(self.filterBar, k, skipAnimation) then
      UI.DEBUG("SelectDescriptor failed")
    end
  end

end

function UI.FilterFragmentClass:GetFilter()
  return Lodur_MultiSelectBar_GetSelected(self.filterBar)
end

function UI.FilterFragmentClass:SetEnabled(descriptor, enabled)
  UI.DEBUG("Filter:SetEnabled d='" .. descriptor .. "' e=" .. tostring(enabled))

  Lodur_MultiSelectBar_SetEnabled(self.filterBar, descriptor, enabled, true)

end


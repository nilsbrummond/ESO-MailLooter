
MailLooter = MailLooter or {}
local ADDON = MailLooter
ADDON.UI = ADDON.UI or {}
local UI = ADDON.UI

-- Just one type for now
local ROW_TYPE_ID = 1

local typeIcons = {
  [ADDON.Core.MAILTYPE_UNKNOWN] = "/esoui/art/menubar/menuBar_help_up.dds",
  [ADDON.Core.MAILTYPE_AVA] = "/esoui/art/mainmenu/menuBar_ava_up.dds",
  [ADDON.Core.MAILTYPE_HIRELING] = "/esoui/art/mainmenu/menuBar_group_up.dds",
  [ADDON.Core.MAILTYPE_STORE] = "/esoui/art/mainmenu/menuBar_guilds_up.dds",
  [ADDON.Core.MAILTYPE_COD] = "/esoui/art/mainmenu/menuBar_mail_up.dds",
  [ADDON.Core.MAILTYPE_RETURNED] = "/esoui/art/mainmenu/menuBar_mail_up.dds",
}

-- TODO: Translate:
local typeTooltips = {
  [ADDON.Core.MAILTYPE_UNKNOWN]   = "Unknown Mail Type",
  [ADDON.Core.MAILTYPE_AVA]       = "AvA Mail",
  [ADDON.Core.MAILTYPE_HIRELING]  = "Hireling Mail",
  [ADDON.Core.MAILTYPE_STORE]     = "Guild Store Mail",
  [ADDON.Core.MAILTYPE_COD]       = "COD Mail",
  [ADDON.Core.MAILTYPE_RETURNED]  = "Returned Mail",
}

local currencyOptions = {
  showTooltips = false,
  useShortFormat = false,
  font = "ZoFontGameBold",
  iconSide = RIGHT,
}

-- Right from inventoryslot.lua
-- It is local so had to copy it...
local NoComparisionTooltip =
{
    [SLOT_TYPE_PENDING_CHARGE] = true,
    [SLOT_TYPE_ENCHANTMENT] = true,
    [SLOT_TYPE_ENCHANTMENT_RESULT] = true,
    [SLOT_TYPE_REPAIR] = true,
    [SLOT_TYPE_PENDING_REPAIR] = true,
    [SLOT_TYPE_CRAFTING_COMPONENT] = true,
    [SLOT_TYPE_PENDING_CRAFTING_COMPONENT] = true,
    [SLOT_TYPE_SMITHING_MATERIAL] = true,
    [SLOT_TYPE_SMITHING_STYLE] = true,
    [SLOT_TYPE_SMITHING_TRAIT] = true,
    [SLOT_TYPE_SMITHING_BOOSTER] = true,
    [SLOT_TYPE_LIST_DIALOG_ITEM] = true,
}


--
-- Local functions
--

local function SetListHighlightHidden(listPart, hidden)
    if(listPart) then
        local highlight = listPart:GetNamedChild("_Highlight")
        if(highlight and (highlight:GetType() == CT_TEXTURE)) then
            if not highlight.animation then
                highlight.animation = 
                  ANIMATION_MANAGER:CreateTimelineFromVirtual(
                    "ShowOnMouseOverLabelAnimation", highlight)
            end
            if hidden then
                highlight.animation:PlayBackward()
            else
                highlight.animation:PlayForward()
            end
        end
    end
end

local function Row_OnMouseEnter(control, rowControl)

  -- UI.DEBUG("Row_OnMouseEnter")

  -- Scale the icon...
  local iconPart = rowControl:GetNamedChild("_Icon")
  if not iconPart.animation then
    iconPart.animation = ANIMATION_MANAGER:CreateTimelineFromVirtual(
      "IconSlotMouseOverAnimation", iconPart)
  end
  iconPart.animation:PlayForward()

 
  -- Highlight backdrop
  SetListHighlightHidden(rowControl, false)


  -- Setup tooltips
  InitializeTooltip(ItemTooltip)

  ItemTooltip:SetLink(rowControl.data.link)
  if not NoComparisionTooltip[GetItemLinkItemType(rowControl.data.link)] then
    ItemTooltip:HideComparativeTooltips()
    ItemTooltip:ShowComparativeTooltips()
    ZO_PlayShowAnimationOnComparisonTooltip(ComparativeTooltip1)
    ZO_PlayShowAnimationOnComparisonTooltip(ComparativeTooltip2)
  end
  
  ItemTooltip:SetHidden(false)

  -- Attach the tooltip left of the type icon...
  local typePart = rowControl:GetNamedChild("_Type")
  if typePart.customTooltipAnchor then
    typePart.customTooltipAnchor(
      ItemTooltip, typePart, ComparativeTooltip1, ComparativeTooltip2)
  else
    ZO_Tooltips_SetupDynamicTooltipAnchors(
      ItemTooltip, typePart.tooltipAnchor or typePart, 
      ComparativeTooltip1, ComparativeTooltip2)
  end

end

local function Row_OnMouseExit(control, rowControl)

  -- UI.DEBUG("Row_OnMouseExit")

  ClearTooltip(ItemTooltip)
  ClearTooltip(InformationTooltip)
  ZO_PlayHideAnimationOnComparisonTooltip(ComparativeTooltip1)
  ZO_PlayHideAnimationOnComparisonTooltip(ComparativeTooltip2)

  local iconPart = rowControl:GetNamedChild("_Icon")
  if iconPart.animation then
    iconPart.animation:PlayBackward()
  end

  SetListHighlightHidden(rowControl, true)

end

local function RowStatus_OnMouseEnter(control)
  
  local mailType = control:GetParent().data.mailType

  InitializeTooltip(InformationTooltip, control, TOPRIGHT, 0, 0, TOPLEFT)
  SetTooltipText(InformationTooltip, typeTooltips[mailType])
end

local function RowStatus_OnMouseExit(control)
  ClearTooltip(InformationTooltip)
end

local function SetupRowData(rowControl, data, scrollList)

  data.control = rowControl
  rowControl.data = data

  local typeIcon = rowControl:GetNamedChild("_Type")
  typeIcon:SetTexture(typeIcons[data.mailType])

  rowControl:GetNamedChild("_Icon"):SetTexture(data.icon)

  local text = zo_strformat("<<t:1>>", data.link)
 
  rowControl:GetNamedChild("_Name"):SetText(
    text .. "|r   (" .. data.stack .. ")")

  if data.mailType == ADDON.Core.MAILTYPE_RETURNED then
    local extra = rowControl:GetNamedChild("_Extra")
    extra:SetHidden(false)
    extra:SetText(
      "|cFF0000Returned|r from: " .. data.scn .. " (@" .. data.sdn .. ")")
  end

  ZO_CurrencyControl_SetSimpleCurrency(
    rowControl:GetNamedChild("_Value"),
    CURRENCY_TYPE_MONEY,
    GetItemLinkValue(data.link, true) * data.stack, 
    currencyOptions, CURRENCY_SHOW_ALL, CURRENCY_HAS_ENOUGH)

  -- Handlers
  rowControl:SetHandler("OnMouseEnter", function()
      Row_OnMouseEnter(scrollList, rowControl)
    end)

  rowControl:SetHandler("OnMouseExit", function()
      Row_OnMouseExit(scrollList, rowControl)
    end)

  typeIcon:SetHandler("OnMouseEnter", function()
      RowStatus_OnMouseEnter(typeIcon)
    end)

  typeIcon:SetHandler("OnMouseExit", function()
      RowStatus_OnMouseExit(typeIcon)
    end)

end

local function RowDataHidden(rowControl, data)
  data.control = nil
end

local function RowDataReset(control)
  control:SetHidden(true)
  control:GetNamedChild("_Extra"):SetHidden(true)
  control.data = nil
end

--
-- Functions
--

UI.LootFragmentClass = ZO_Object:Subclass()

function UI.LootFragmentClass:New()
  local obj = ZO_Object.New(self)
  obj:Initialize()
  return obj
end


function UI.LootFragmentClass:Initialize()
  local fragment = self

  fragment.win = WINDOW_MANAGER:CreateTopLevelWindow(
                   "MailLooterLootFragment")
 
  fragment.win:SetWidth(ZO_MailInbox:GetWidth())
  fragment.win:SetAnchor(TOP, ZO_MailInbox, TOP, -20, 100)
  fragment.win:SetHidden(true)
  fragment.win:SetMouseEnabled(true)

  WINDOW_MANAGER:CreateControlFromVirtual(
    "MAIL_LOOTER_LOOT_TITLE", fragment.win, "ZO_PanelTitle")
  MAIL_LOOTER_LOOT_TITLE:SetAnchor(TOP, fragment.win, TOP, 0, 0)
  MAIL_LOOTER_LOOT_TITLELabel:SetText("LOOTED")
  MAIL_LOOTER_LOOT_TITLELabel:SetFont("ZoFontWinH2")
  MAIL_LOOTER_LOOT_TITLELabel:SetAnchor(
    CENTER, MAIL_LOOTER_LOOT_TITLEDivider, CENTER, 0, -15)
  MAIL_LOOTER_LOOT_TITLEDivider:SetDimensions(900,2)

  --
  -- Scroll List
  --

  local scrollList = WINDOW_MANAGER:CreateControlFromVirtual(
    "MailLooterLootList", fragment.win, "ZO_ScrollList")
  scrollList:SetDimensions(750, 500)
  scrollList:SetAnchor(
    TOP, MAIL_LOOTER_LOOT_TITLEDivider, BOTTOM, 0, 10)

  ZO_ScrollList_AddDataType(scrollList, ROW_TYPE_ID, "MailLooterLootListRow",
      52, SetupRowData, RowDataHidden, nil, RowDataReset)

  -- NOTE: No longer uses the ZO_ScrollList to handle the Highlight.
  --       Follows the model of the default UI inventory list.
  --
  -- ZO_ScrollList_EnableHighlight(
  --   scrollList, "MailLooterLootListRow", HighlightRow)
  -- ZO_ScrollList_EnableHighlight(
  --   scrollList, "ZO_ThinListHighlight", HighlightRow)

  ZO_ScrollList_AddCategory(scrollList, 1, nil)

  ZO_ScrollList_AddResizeOnScreenResize(scrollList)

  fragment.scrollList = scrollList

  --
  -- Footer
  --

  local div = WINDOW_MANAGER:CreateControl(
    nil, fragment.win, CT_TEXTURE)
  div:SetTexture("EsoUI/Art/Miscellaneous/centerscreen_topDivider.dds")
  div:SetHeight(2)
  div:SetWidth(900)
  div:SetAnchor(TOP, scrollList, BOTTOM, 0, 15)

  local invLabel = WINDOW_MANAGER:CreateControl(
    nil, fragment.win, CT_LABEL)
  invLabel:SetFont("ZoFontGameBold")
  invLabel:SetText("|cC0C0A0Inventory Space: ")
  invLabel:SetHeight(invLabel:GetFontHeight())
  invLabel:SetHorizontalAlignment(TEXT_ALIGN_LEFT)
  invLabel:SetAnchor(TOPLEFT, div, BOTTOMLEFT, 40, 10)

  local invValue = WINDOW_MANAGER:CreateControl(
    nil, fragment.win, CT_LABEL)
  invValue:SetFont("ZoFontGameBold")
  invValue:SetText("XXX / XXX (4 Reserved)")
  invValue:SetHeight(invValue:GetFontHeight())
  invValue:SetHorizontalAlignment(TEXT_ALIGN_LEFT)
  invValue:SetAnchor(LEFT, invLabel, RIGHT, 10, 0)

  fragment.lootInventoryText = invValue

  local moneyLabel = WINDOW_MANAGER:CreateControl(
    nil, fragment.win, CT_LABEL)
  moneyLabel:SetFont("ZoFontGameBold")
  moneyLabel:SetText(" |cC0C0A0Looted")
  moneyLabel:SetHeight(moneyLabel:GetFontHeight())
  moneyLabel:SetHorizontalAlignment(TEXT_ALIGN_RIGHT)
  moneyLabel:SetAnchor(TOPRIGHT, div, BOTTOMRIGHT, -40, 10)

  local moneyValue = WINDOW_MANAGER:CreateControl(
    nil, fragment.win, CT_LABEL)
  moneyValue:SetFont("ZoFontGameBold")
  moneyValue:SetText("Money: |u0:4:currency:1")
  moneyValue:SetHeight(moneyValue:GetFontHeight())
  moneyValue:SetHorizontalAlignment(TEXT_ALIGN_RIGHT)
  moneyValue:SetAnchor(TOPRIGHT, moneyLabel, TOPLEFT, -10, 0)

  fragment.lootMoneyText = moneyValue

  fragment.FRAGMENT = ZO_FadeSceneFragment:New(fragment.win)

  -- fragment.win:SetResizeToFitDescendents(true)

  self:UpdateMoney(0)
end

function UI.LootFragmentClass:UpdateInv(current, max, reserved)

  local msg = ""

  if reserved then
    if (current >= (max - 4)) then
      msg = "|cFF0000" .. current .. " / " .. (max-4) .. "|r   (4 Reserved)"
    else
      msg = current .. " / " .. (max-4) .. "   (4 Reserved)"
    end
  else
    msg = current .. " / " .. max
    if current == max then
      msg = "|cFF0000".. msg
    end
  end

  self.lootInventoryText:SetText(msg)
end

function UI.LootFragmentClass:UpdateMoney(gold)
 
  ZO_CurrencyControl_SetSimpleCurrency(
    self.lootMoneyText, CURRENCY_TYPE_MONEY, gold, 
    currencyOptions, CURRENCY_SHOW_ALL, CURRENCY_HAS_ENOUGH)

end

function UI.LootFragmentClass:AddLooted(item, isNewItemType)

  if isNewItemType then
    -- add row
    local row = ZO_ScrollList_CreateDataEntry(
      ROW_TYPE_ID, ZO_DeepTableCopy(item), 1)

    table.insert(
      ZO_ScrollList_GetDataList(
        self.scrollList),
        row)
  else
    -- update row
    --
    local data = ZO_ScrollList_GetDataList(self.scrollList)
    for i,v in ipairs(data) do
      local data = ZO_ScrollList_GetDataEntryData(v)
      if data.link == item.link then
        data.stack = item.stack
        break
      end
    end

  end

  ZO_ScrollList_Commit(self.scrollList)

end

function UI.LootFragmentClass:Clear()
  ZO_ScrollList_Clear(self.scrollList)
  ZO_ScrollList_Commit(self.scrollList)
  self:UpdateMoney(0)
end


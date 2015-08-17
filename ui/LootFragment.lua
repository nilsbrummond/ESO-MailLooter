
MailLooter = MailLooter or {}
local ADDON = MailLooter
ADDON.UI = ADDON.UI or {}
local UI = ADDON.UI

-- Row types:
local ROW_TYPE_ID       = 1
local ROW_TYPE_ID_EXTRA = 2
local ROW_TYPE_ID_MONEY = 3

local CATEGORY_DEFAULT  = 1

local typeIcons = {
  [ADDON.Core.MAILTYPE_UNKNOWN] = "/esoui/art/menubar/menuBar_help_up.dds",
  [ADDON.Core.MAILTYPE_AVA] = "/esoui/art/mainmenu/menuBar_ava_up.dds",
  [ADDON.Core.MAILTYPE_HIRELING] = "/esoui/art/progression/progression_indexicon_tradeskills_up.dds",
  [ADDON.Core.MAILTYPE_STORE] = "/esoui/art/mainmenu/menuBar_guilds_up.dds",
  [ADDON.Core.MAILTYPE_COD] = "/esoui/art/mainmenu/menuBar_mail_up.dds",
  [ADDON.Core.MAILTYPE_RETURNED] = "/esoui/art/mainmenu/menuBar_mail_up.dds",
  [ADDON.Core.MAILTYPE_SIMPLE] = "/esoui/art/mainmenu/menuBar_mail_up.dds",
  [ADDON.Core.MAILTYPE_COD_RECEIPT] = "/esoui/art/mainmenu/menuBar_mail_up.dds",
}

local typeRowType = {
  [ADDON.Core.MAILTYPE_UNKNOWN]     = ROW_TYPE_ID,
  [ADDON.Core.MAILTYPE_AVA]         = ROW_TYPE_ID,
  [ADDON.Core.MAILTYPE_HIRELING]    = ROW_TYPE_ID,
  [ADDON.Core.MAILTYPE_STORE]       = ROW_TYPE_ID,
  [ADDON.Core.MAILTYPE_COD]         = ROW_TYPE_ID,
  [ADDON.Core.MAILTYPE_RETURNED]    = ROW_TYPE_ID_EXTRA,
  [ADDON.Core.MAILTYPE_SIMPLE]      = ROW_TYPE_ID_EXTRA,
  [ADDON.Core.MAILTYPE_COD_RECEIPT] = ROW_TYPE_ID_MONEY,
}

-- TODO: Translate:
local typeTooltips = {
  [ADDON.Core.MAILTYPE_UNKNOWN]     = "Unknown Mail Type",
  [ADDON.Core.MAILTYPE_AVA]         = "AvA Mail",
  [ADDON.Core.MAILTYPE_HIRELING]    = "Hireling Mail",
  [ADDON.Core.MAILTYPE_STORE]       = "Guild Store Mail",
  [ADDON.Core.MAILTYPE_COD]         = "COD Mail",
  [ADDON.Core.MAILTYPE_RETURNED]    = "Returned Mail",
  [ADDON.Core.MAILTYPE_SIMPLE]      = "Player Mail",
  [ADDON.Core.MAILTYPE_COD_RECEIPT] = "COD Receipt Mail",
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

local SortKeys =
{
  mailType =  { tiebreaker = { "quality","name","stack","value" }, 
                isNumberic=true },
  quality =   { tiebreaker = { "name", "mailType", "stack", "value" },
                isNumberic=true },
  name =      { tiebreaker = { "mailType", "quality", "stack", "value" }},
  value =     { tiebreaker = { "quality", "mailType", "name", "stack" },
                isNumberic=true },

  -- tiebreakers only:              
  stack =     { isNumberic=true },
  lootNum =   { isNumberic=true },

  -- Meta:
  final =     "lootNum"
}


--
-- Local functions
--

-- This function is must be determanistic. 
-- Less then or great then - no equal.
--
-- Based on ZOS code for ZO_TableOrderingFunction.  But this
-- one makes sure we never end in a IS_EQUAL_TO case.  This was
-- causing table.sort with a ZO_TableOrderingFunction to infinate 
-- loop for MailLooter.
--
-- Return true if entry1 < entry2
--
local function TableOrderingFunction(entry1, entry2, key, keys, sortOrder)
 
  local IS_LESS_THAN = -1
  local IS_EQUAL_TO = 0
  local IS_GREATER_THAN = 1

  local function CompareSimple(entry1, entry2, key, keys)
    local value1 = entry1[key]
    local value2 = entry2[key]

    if keys[key].isNumberic then
      value1 = tonumber(value1)
      value2 = tonumber(value2)
    else -- "string"
      value1 = zo_strlower(value1)
      value2 = zo_strlower(value2)
    end

    local compareResult

    if value1 < value2 then
      compareResult = IS_LESS_THAN
    elseif value1 > value2 then
      compareResult = IS_GREATER_THAN
    else
      compareResult = IS_EQUAL_TO
    end

    return compareResult
  end

  local cr = CompareSimple(entry1, entry2, key, keys)

  if (cr == IS_EQUAL_TO) and (keys[key].tieBreaker ~= nil) then

    for i,v in keys[key].tieBreaker do
      cr = CompareSimple(entry1, entry2, v, keys)
      if cr ~= IS_EQUAL_TO then break end
    end

  end

  -- last chance
  if (cr == IS_EQUAL_TO) and (keys.final ~= nil) then
    cr = CompareSimple(entry1, entry2, keys.final, keys)
  end

  if sortOrder == ZO_SORT_ORDER_UP then
    return cr == IS_LESS_THAN
  end
  return cr == IS_GREATER_THAN

end

local function SenderString(sdn, scn)
  if scn and (scn ~= "") then
    if sdn then
      return "(" .. scn .. ") " .. sdn
    else
      return "(" .. scn .. ")"
    end
  elseif sdn then
    return sdn
  else
    return "UNKNOWN"
  end
end

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
  if rowControl.data.link then
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

local function SetupRowDataBase(rowControl, data, scrollList)
  data.control = rowControl
  rowControl.data = data

  local typeIcon = rowControl:GetNamedChild("_Type")
  typeIcon:SetTexture(typeIcons[data.mailType])

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

local function SetupRowDataMoney(rowControl, data, scrollList)

  SetupRowDataBase(rowControl, data, scrollList)

  if data.mailType == ADDON.Core.MAILTYPE_COD_RECEIPT then
    rowControl:GetNamedChild("_Name"):SetText("COD Payment")
  elseif data.mailType == ADDON.Core.MAILTYPE_RETURNED then
    rowControl:GetNamedChild("_Name"):SetText("Returned Money")
  elseif data.mailType == ADDON.Core.MAILTYPE_SIMPLE then
    rowControl:GetNamedChild("_Name"):SetText("Simple Mail")
  end

  local extra = rowControl:GetNamedChild("_Extra")
  if data.mailType == ADDON.Core.MAILTYPE_RETURNED then
    extra:SetText(
      "|cFF0000Returned|r from: " .. SenderString(data.text.sdn, data.text.scn))
  else
    extra:SetText("From: " .. SenderString(data.text.sdn, data.text.scn))
  end

  ZO_CurrencyControl_SetSimpleCurrency(
    rowControl:GetNamedChild("_Value"),
    CURRENCY_TYPE_MONEY,
    data.money, 
    currencyOptions, CURRENCY_SHOW_ALL, CURRENCY_HAS_ENOUGH)
end

local function SetupRowDataItem(rowControl, data, scrollList)

  SetupRowDataBase(rowControl, data, scrollList)

  rowControl:GetNamedChild("_Icon"):SetTexture(data.icon)

  local text = zo_strformat("<<t:1>>", data.link)
 
  rowControl:GetNamedChild("_Name"):SetText(
    text .. "|r   (" .. data.stack .. ")")

  if data.mailType == ADDON.Core.MAILTYPE_RETURNED then
    local extra = rowControl:GetNamedChild("_Extra")
    extra:SetText(
      "|cFF0000Returned|r from: " .. SenderString(data.text.sdn, data.text.scn))
  elseif data.mailType == ADDON.Core.MAILTYPE_SIMPLE then
    local extra = rowControl:GetNamedChild("_Extra")
    extra:SetText(
      "From: " .. SenderString(data.text.sdn, data.text.scn))
  end

  ZO_CurrencyControl_SetSimpleCurrency(
    rowControl:GetNamedChild("_Value"),
    CURRENCY_TYPE_MONEY,
    GetItemLinkValue(data.link, true) * data.stack, 
    currencyOptions, CURRENCY_SHOW_ALL, CURRENCY_HAS_ENOUGH)

end

local function RowDataHidden(rowControl, data)
  data.control = nil
end

local function RowDataReset(control)
  control:SetHidden(true)
  control:GetNamedChild("_Highlight"):SetAlpha(0)
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
  
  self.currentSortKey = "quality"
  self.currentSortOrder = ZO_SORT_ORDER_DOWN

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
  -- Scroll List headers
  --

  local headers = WINDOW_MANAGER:CreateControlFromVirtual(
    "MailLooterLootHeaders", fragment.win, "MailLooterLootListHeaders")
  headers:SetAnchor(
    TOP, MAIL_LOOTER_LOOT_TITLEDivider, BOTTOM, 0, 0)

  fragment.sortHeaders = ZO_SortHeaderGroup:New(headers, true)
  fragment.sortHeaders:AddHeadersFromContainer()
  fragment.sortHeaders:RegisterCallback(
    ZO_SortHeaderGroup.HEADER_CLICKED, 
    function (a,b) self:ChangeSort(a,b) end)

  -- call twice to toggle to current setting.
  fragment.sortHeaders:SelectHeaderByKey(
    self.currentSortKey, ZO_SortHeaderGroup.SUPPRESS_CALLBACKS)
  fragment.sortHeaders:SelectHeaderByKey(
    self.currentSortKey, ZO_SortHeaderGroup.SUPPRESS_CALLBACKS)

  --
  -- Scroll List
  --

  local scrollList = WINDOW_MANAGER:CreateControlFromVirtual(
    "MailLooterLootList", fragment.win, "ZO_ScrollList")
  scrollList:SetDimensions(750, 450)
  scrollList:SetAnchor(TOP, headers, BOTTOM, 0, 0)

  ZO_ScrollList_AddDataType(scrollList, ROW_TYPE_ID, 
      "MailLooterLootListRow",
      52, SetupRowDataItem, RowDataHidden, nil, RowDataReset)

  ZO_ScrollList_AddDataType(scrollList, ROW_TYPE_ID_EXTRA,
      "MailLooterLootListRowExtra",
      52, SetupRowDataItem, RowDataHidden, nil, RowDataReset)

  ZO_ScrollList_AddDataType(scrollList, ROW_TYPE_ID_MONEY,
      "MailLooterLootListRowMoney",
      52, SetupRowDataMoney, RowDataHidden, nil, RowDataReset)

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

function UI.LootFragmentClass:ChangeSort(newSortKey, newSortOrder)

  UI.DEBUG("ChangeSort: newSortKey=" .. newSortKey .. 
           " newSortOrder=" .. tostring(newSortOrder))

  self.currentSortKey = newSortKey
  self.currentSortOrder = newSortOrder

  self:ApplySort()

end

function UI.LootFragmentClass:ApplySort()

  local scrollData = ZO_ScrollList_GetDataList(self.scrollList)

  if self.sortFn == nil then
    self.sortFn = function(entry1, entry2)
                    return TableOrderingFunction (
                      ZO_ScrollList_GetDataEntryData(entry1),
                      ZO_ScrollList_GetDataEntryData(entry2),
                      self.currentSortKey, SortKeys, self.currentSortOrder)
                  end
  end

  table.sort(scrollData, self.sortFn)
  ZO_ScrollList_Commit(self.scrollList)

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
    local data = ZO_DeepTableCopy(item)

    data.quality = GetItemLinkQuality(item.link)
    data.name = GetItemLinkName(item.link)
    data.value = GetItemLinkValue(item.link, true) * item.stack

    local row = ZO_ScrollList_CreateDataEntry(
      typeRowType[item.mailType], data, CATEGORY_DEFAULT)

    table.insert(
      ZO_ScrollList_GetDataList(
        self.scrollList),
        row)

    self:ApplySort()
  else
    -- update row
    --
    local data = ZO_ScrollList_GetDataList(self.scrollList)
    for i,v in ipairs(data) do
      local data = ZO_ScrollList_GetDataEntryData(v)
      if (data.link ~= nil) and                 -- is an item
         (data.mailType == item.mailType) and   -- in the same category 
         (data.link == item.link) then          -- and the same item.

        UI.DEBUG("Updating stack")
        -- update the stack size  
        data.stack = item.stack
        data.value = GetItemLinkValue(data.link, true) * data.stack
        break

      end
    end

    if self.currentSortKey == "value" then
      -- Order only changes on a value ordering.
      self:ApplySort()
    else
      ZO_ScrollList_Commit(self.scrollList)
    end
  end


end

function UI.LootFragmentClass:AddLootedMoney(mail, isNewMoneyStack)

  if isNewMoneyStack then

    local data = ZO_DeepTableCopy(mail)

    data.quality = -1
    data.name = "money"
    data.value = mail.money

    local row = ZO_ScrollList_CreateDataEntry(
      ROW_TYPE_ID_MONEY, data, CATEGORY_DEFAULT)

    table.insert(
      ZO_ScrollList_GetDataList(
        self.scrollList),
        row)
    
    self:ApplySort()

  else
    -- NOT SUPPORTED CURRENTLY
  end

end

function UI.LootFragmentClass:Clear()
  ZO_ScrollList_Clear(self.scrollList)
  ZO_ScrollList_Commit(self.scrollList)
  self:UpdateMoney(0)
end


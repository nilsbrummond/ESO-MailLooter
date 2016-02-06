
MailLooter = MailLooter or {}
local ADDON = MailLooter
ADDON.UI = ADDON.UI or {}
local UI = ADDON.UI

-- Row types:
local ROW_TYPE_ID       = 1
local ROW_TYPE_ID_EXTRA = 2
local ROW_TYPE_ID_MONEY = 3

local CATEGORY_DEFAULT  = 1

local typeRowType = {
  [ADDON.Core.MAILTYPE_UNKNOWN]     = ROW_TYPE_ID,
  [ADDON.Core.MAILTYPE_AVA]         = ROW_TYPE_ID,
  [ADDON.Core.MAILTYPE_HIRELING]    = ROW_TYPE_ID,

  -- ADDON.Core.SUBTYPE_STORE_* ordered
  [ADDON.Core.MAILTYPE_STORE]       = { ROW_TYPE_ID_EXTRA,
                                        ROW_TYPE_ID_EXTRA, 
                                        ROW_TYPE_ID, 
                                        ROW_TYPE_ID_MONEY },

  [ADDON.Core.MAILTYPE_COD]         = ROW_TYPE_ID_EXTRA,
  [ADDON.Core.MAILTYPE_RETURNED]    = ROW_TYPE_ID_EXTRA,
  [ADDON.Core.MAILTYPE_SIMPLE]      = ROW_TYPE_ID_EXTRA,
  [ADDON.Core.MAILTYPE_COD_RECEIPT] = ROW_TYPE_ID_MONEY,
}

-- TODO: Translate:
local typeTooltips = {
  [ADDON.Core.MAILTYPE_UNKNOWN]     = GetString(SI_MAILLOOTER_LOOT_MT_UNKNOWN),
  [ADDON.Core.MAILTYPE_AVA]         = GetString(SI_MAILLOOTER_LOOT_MT_AVA),
  [ADDON.Core.MAILTYPE_HIRELING]    = GetString(SI_MAILLOOTER_LOOT_MT_HIRELING),
  [ADDON.Core.MAILTYPE_STORE]       = GetString(SI_MAILLOOTER_LOOT_MT_STORE),
  [ADDON.Core.MAILTYPE_COD]         = GetString(SI_MAILLOOTER_LOOT_MT_COD),
  [ADDON.Core.MAILTYPE_RETURNED]    = GetString(SI_MAILLOOTER_LOOT_MT_RETURNED),
  [ADDON.Core.MAILTYPE_SIMPLE]      = GetString(SI_MAILLOOTER_LOOT_MT_SIMPLE),
  [ADDON.Core.MAILTYPE_COD_RECEIPT] = GetString(
                                          SI_MAILLOOTER_LOOT_MT_COD_RECEIPT),
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
  mailType =  { tieBreaker = { "quality","name","value" }, 
                isNumberic=true, order=ZO_SORT_ORDER_UP },
  quality =   { tieBreaker = { "name", "mailType", "value" },
                isNumberic=true, order=ZO_SORT_ORDER_DOWN },
  name =      { tieBreaker = { "mailType", "quality", "value" },
                order=ZO_SORT_ORDER_UP },
  value =     { tieBreaker = { "quality", "mailType", "name" },
                isNumberic=true, order=ZO_SORT_ORDER_DOWN },

  -- tiebreakers only:              
  stack =     { isNumberic=true },
  lootNum =   { isNumberic=true },

  -- Meta:
  final =     "lootNum"
}


--
-- Local functions
--

local IS_LESS_THAN = -1
local IS_EQUAL_TO = 0
local IS_GREATER_THAN = 1

-- Used by TableOrderingFunction.
local function TOFCompareSimple(entry1, entry2, key, keys)
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

-- Adjust for sort order.  Used by TableOrderingFunction
local function TOFSortOrder(cr, sortOrder)
  if sortOrder == ZO_SORT_ORDER_UP then
    return cr == IS_LESS_THAN
  end
  return cr == IS_GREATER_THAN
end


-- This function must be determanistic. 
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
 
  local cr = TOFCompareSimple(entry1, entry2, key, keys)

  -- sortOrder for first key only
  if cr ~= IS_EQUAL_TO then 
    return TOFSortOrder(cr, sortOrder)
  end

  if (cr == IS_EQUAL_TO) and (keys[key].tieBreaker ~= nil) then

    for i,v in ipairs(keys[key].tieBreaker) do
      cr = TOFCompareSimple(entry1, entry2, v, keys)
      if cr ~= IS_EQUAL_TO then
        return TOFSortOrder(cr, keys[v].order)
      end
    end

  end

  -- last chance
  if (cr == IS_EQUAL_TO) and (keys.final ~= nil) then
    cr = TOFCompareSimple(entry1, entry2, keys.final, keys)
  end

  return cr == IS_LESS_THAN

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

local function GetMoneyName(data)

  local name = GetString(SI_MAILLOOTER_LOOT_MN_MONEY)

  if data.mailType == ADDON.Core.MAILTYPE_COD_RECEIPT then
    name = GetString(SI_MAILLOOTER_LOOT_MN_COD_PAYMENT)
  elseif data.mailType == ADDON.Core.MAILTYPE_RETURNED then
    name = GetString(SI_MAILLOOTER_LOOT_MN_RETURNED)
  elseif data.mailType == ADDON.Core.MAILTYPE_SIMPLE then
    name = GetString(SI_MAILLOOTER_LOOT_MN_SIMPLE)
  end

  return name

end

-- Global function for external XML access.
function MailLooter_LootListRow_OnMouseEnter(rowControl)

  local control = rowControl:GetParent()

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

  -- Tooltip mail display:
  if rowControl.data.id then
    -- TODO
  end
end

-- Global function for external XML access.
function MailLooter_LootListRow_OnMouseExit(rowControl)

  local control = rowControl:GetParent()

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

-- Global function for external XML access.
function MailLooter_LootListRowStatus_OnMouseEnter(control)
 
  InitializeTooltip(InformationTooltip, control, TOPRIGHT, 0, 0, TOPLEFT)

  local mailType = control:GetParent().data.mailType
  SetTooltipText(InformationTooltip, typeTooltips[mailType])
end

-- Global function for external XML access.
function MailLooter_LootListRowStatus_OnMouseExit(control)
  ClearTooltip(InformationTooltip)
end

function MailLooter_LootListRow_OnMouseUp(rowControl, button, upInside)
  
  if not upInside then return end
  if button ~= MOUSE_BUTTON_INDEX_RIGHT then return end

  --[[
  ClearMenu()

  AddMenuItem(
    GetString(SI_ITEM_ACTION_LINK_TO_CHAT), 
    function() 
      ZO_LinkHandler_InsertLink(
        zo_strformat(SI_TOOLTIP_ITEM_NAME, rowControl.data.link))
    end
  )

  ShowMenu(rowControl)
  --]]

  ZO_LinkHandler_OnLinkMouseUp(rowControl.data.link, button, rowControl)

end

local function SetupRowDataBase(rowControl, data, scrollList)
  data.control = rowControl
  rowControl.data = data

  local typeIcon = rowControl:GetNamedChild("_Type")
  typeIcon:SetTexture(UI.GetIcon(data.mailType))

  -- NOTE:
  -- SetHandler now done ONCE in XML on creation.  This was bad
  -- to all SetHandler in the row setup function which can be
  -- called many times with the list is scrolled...
  -- Calling SetHandler often leads to bad performance per ZOS.

  --[[
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

  --]]

end

local function SetupRowDataMoney(rowControl, data, scrollList)

  SetupRowDataBase(rowControl, data, scrollList)

  rowControl:GetNamedChild("_Name"):SetText(GetMoneyName(data))

  local extra = rowControl:GetNamedChild("_Extra")
  if data.mailType == ADDON.Core.MAILTYPE_RETURNED then
    extra:SetText(
      GetString(SI_MAILLOOTER_LOOT_EXTRA_RETURNED_FROM) .. 
      SenderString(data.sdn, data.scn))
  else
    extra:SetText(
      GetString(SI_MAILLOOTER_LOOT_EXTRA_FROM) .. 
      SenderString(data.sdn, data.scn))
  end

  ZO_CurrencyControl_SetSimpleCurrency(
    rowControl:GetNamedChild("_Value"),
    CURT_MONEY,
    data.money, 
    currencyOptions, CURRENCY_SHOW_ALL, CURRENCY_HAS_ENOUGH)
end

local function SetupRowDataItem(rowControl, data, scrollList)

  SetupRowDataBase(rowControl, data, scrollList)

  rowControl:GetNamedChild("_Icon"):SetTexture(data.icon)

  local text = zo_strformat("<<t:1>>", data.link)
 
  rowControl:GetNamedChild("_Name"):SetText(
    text .. "|r   (" .. data.stack .. ")")

  local extra = rowControl:GetNamedChild("_Extra")
  if extra ~= nil then
    local text = ""

    if data.mailType == ADDON.Core.MAILTYPE_RETURNED then
      text = GetString(SI_MAILLOOTER_LOOT_EXTRA_RETURNED_FROM) .. 
        SenderString(data.sdn, data.scn)

    elseif (data.mailType == ADDON.Core.MAILTYPE_SIMPLE) or
           (data.mailType == ADDON.Core.MAILTYPE_COD) then
      text = GetString(SI_MAILLOOTER_LOOT_EXTRA_FROM) .. 
        SenderString(data.sdn, data.scn)

    elseif data.mailType == ADDON.Core.MAILTYPE_STORE then
      if data.subType == ADDON.Core.SUBTYPE_STORE_EXPIRED then
        text = GetString(SI_MAILLOOTER_LOOT_EXTRA_EXPIRED)

      elseif data.subType == ADDON.Core.SUBTYPE_STORE_CANCELLED then
        text = GetString(SI_MAILLOOTER_LOOT_EXTRA_CANCELED)
      end
    end

    extra:SetText(text)
  end

  ZO_CurrencyControl_SetSimpleCurrency(
    rowControl:GetNamedChild("_Value"),
    CURT_MONEY,
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
 
  fragment.win:SetAnchor(TOPRIGHT, ZO_MailInbox, TOPRIGHT, -20, 108)
  fragment.win:SetHidden(true)
  fragment.win:SetMouseEnabled(true)

--  local topdiv = WINDOW_MANAGER:CreateControl(
--    nil, fragment.win, CT_TEXTURE)
--  topdiv:SetTexture("EsoUI/Art/Miscellaneous/centerscreen_topDivider.dds")
--  topdiv:SetHeight(2)
--  topdiv:SetWidth(650)
--  topdiv:SetAnchor(TOPRIGHT, fragment.win, BOTTOMRIGHT, 0, 15)

--  WINDOW_MANAGER:CreateControlFromVirtual(
--    "MAIL_LOOTER_LOOT_TITLE", fragment.win, "ZO_PanelTitle")
--  MAIL_LOOTER_LOOT_TITLE:SetAnchor(TOP, fragment.win, TOP, 0, 0)
--  MAIL_LOOTER_LOOT_TITLELabel:SetText("LOOTED")
--  MAIL_LOOTER_LOOT_TITLELabel:SetFont("ZoFontWinH2")
--  MAIL_LOOTER_LOOT_TITLELabel:SetAnchor(
--    CENTER, MAIL_LOOTER_LOOT_TITLEDivider, CENTER, 0, -15)
--  MAIL_LOOTER_LOOT_TITLEDivider:SetDimensions(900,2)

  --
  -- Scroll List headers
  --

  local headers = WINDOW_MANAGER:CreateControlFromVirtual(
    "MailLooterLootHeaders", fragment.win, "MailLooterLootListHeaders")
  headers:SetAnchor(TOPRIGHT, fragment.win, TOPRIGHT, 0, 0)

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
  scrollList:SetDimensions(650, 500)
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
  div:SetAnchor(TOPRIGHT, scrollList, BOTTOMRIGHT, 0, 15)

  local invLabel = WINDOW_MANAGER:CreateControl(
    nil, fragment.win, CT_LABEL)
  invLabel:SetFont("ZoFontGameBold")
  invLabel:SetText(
    "|cC0C0A0" .. GetString(SI_MAILLOOTER_LOOT_FOOTER_INV_SPACE))
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
  moneyLabel:SetText(
    " |cC0C0A0" .. GetString(SI_MAILLOOTER_LOOT_FOOTER_LOOTED))
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
    local res4 = GetString(SI_MAILLOOTER_LOOT_FOOTER_INV_RES4)

    if (current >= (max - 4)) then
      msg = "|cFF0000" .. current .. " / " .. (max-4) .. "|r   " .. res4
    else
      msg = current .. " / " .. (max-4) .. "   " .. res4
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
    self.lootMoneyText, CURT_MONEY, gold, 
    currencyOptions, CURRENCY_SHOW_ALL, CURRENCY_HAS_ENOUGH)

end

local function GetLootRowType(mailType, subType)

  UI.DEBUG("GetLootRowType(".. mailType..", ".. tostring(subType) .. ")")

  local val = typeRowType[mailType]

  if type(val) == 'table' then
    val = val[subType]
  end

  UI.DEBUG("GetLootRowType()=" .. val)

  return val
end

function UI.LootFragmentClass:AddLooted(item, isNewItemType)

  if isNewItemType then
    -- add row
    local data = ZO_DeepTableCopy(item)

    data.quality = GetItemLinkQuality(item.link)
    data.name = GetItemLinkName(item.link)
    data.value = GetItemLinkValue(item.link, true) * item.stack

    UI.DEBUG("New stack: " .. data.stack)

    local row = ZO_ScrollList_CreateDataEntry(
      GetLootRowType(item.mailType, item.subType), data, CATEGORY_DEFAULT)

    table.insert(
      ZO_ScrollList_GetDataList(
        self.scrollList),
        row)

    self:ApplySort()
  else
    -- update row
    --
    local updated = false
    local data = ZO_ScrollList_GetDataList(self.scrollList)
    for i,v in ipairs(data) do
      local rowdata = ZO_ScrollList_GetDataEntryData(v)
      if (rowdata.link ~= nil) and                 -- is an item
         (rowdata.mailType == item.mailType) and   -- in the same category 
         (rowdata.link == item.link) then          -- and the same item.

        UI.DEBUG("Updating stack: " .. rowdata.stack .. " -> " .. item.stack)
        -- update the stack size  
        rowdata.stack = item.stack
        rowdata.value = GetItemLinkValue(rowdata.link, true) * rowdata.stack
        updated = true
        break

      end
    end

    if not updated then
      UI.DEBUG("Update of stack FAILED: " .. item.link)
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
    data.name = GetMoneyName(data)
    data.value = mail.money
    -- data.stack = 1


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


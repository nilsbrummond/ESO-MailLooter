
eso_addon_MailLooter = eso_addon_MailLooter or {}
local ADDON = eso_addon_MailLooter
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

  --  [ADDON.Core.MAILTYPE_HIRELING] = "/esoui/art/icons/ability_enchanter_008.dds",
}

local currencyOptions = {
  showTooltips = true,
  useShortFormat = false,
  font = "ZoFontGameBold",
  iconSide = RIGHT,
}

--
-- Local functions
--

local function SetupRowData(rowControl, data, scrollList)

  rowControl:GetNamedChild("_Type"):SetTexture(typeIcons[data.mailType])
  rowControl:GetNamedChild("_Icon"):SetTexture(data.icon)
  rowControl:GetNamedChild("_Name"):SetText(
    GetItemLinkName(data.link) .. "   (" .. data.stack .. ")")
 
  ZO_CurrencyControl_SetSimpleCurrency(
    rowControl:GetNamedChild("_Value"),
    CURRENCY_TYPE_MONEY,
    GetItemLinkValue(data.link, true) * data.stack, 
    currencyOptions, CURRENCY_SHOW_ALL, CURRENCY_HAS_ENOUGH)

  rowControl:SetHandler("OnMouseUp", function()
      ZO_ScrollList_MouseClick(scrollList, rowControl)
    end)

end

--
-- Functions
--

function UI.CreateLootFragment()
  local fragment = {}
  fragment.win = WINDOW_MANAGER:CreateTopLevelWindow(
                   "MailLooterLootFragment")
 
  fragment.win:SetWidth(ZO_MailInbox:GetWidth())
  fragment.win:SetAnchor(TOP, ZO_MailInbox, TOP, 0, 100)
  fragment.win:SetHidden(true)

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
      52, SetupRowData, nil, nil, nil)

  ZO_ScrollList_EnableSelection(scrollList, "ZO_ThingListHighlight", nil)

  ZO_ScrollList_AddCategory(scrollList, 1, nil)

  UI.lootScrollList = scrollList

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
  invLabel:SetHorizontalAlignment(TEXT_ALIGN_LEFT)
  invLabel:SetAnchor(TOPLEFT, div, BOTTOMLEFT, 40, 10)

  local invValue = WINDOW_MANAGER:CreateControl(
    nil, fragment.win, CT_LABEL)
  invValue:SetFont("ZoFontGameBold")
  invValue:SetText("XXX / XXX (4 Reserved)")
  invValue:SetHorizontalAlignment(TEXT_ALIGN_LEFT)
  invValue:SetAnchor(LEFT, invLabel, RIGHT, 10, 0)

  UI.lootInventoryText = invValue

  local moneyLabel = WINDOW_MANAGER:CreateControl(
    nil, fragment.win, CT_LABEL)
  moneyLabel:SetFont("ZoFontGameBold")
  moneyLabel:SetText(" |cC0C0A0Looted")
  moneyLabel:SetHorizontalAlignment(TEXT_ALIGN_RIGHT)
  moneyLabel:SetAnchor(TOPRIGHT, div, BOTTOMRIGHT, -40, 10)

  local moneyValue = WINDOW_MANAGER:CreateControl(
    nil, fragment.win, CT_LABEL)
  moneyValue:SetFont("ZoFontGameBold")
  moneyValue:SetText("Money: |u0:4:currency:1")
  moneyValue:SetHorizontalAlignment(TEXT_ALIGN_RIGHT)
  moneyValue:SetAnchor(TOPRIGHT, moneyLabel, TOPLEFT, -10, 0)

  UI.lootMoneyText = moneyValue
  UI.LootFragUpdateMoney(0)

  fragment.FRAGMENT = ZO_FadeSceneFragment:New(fragment.win)

  return fragment

end

function UI.LootFragUpdateInv(current, max, reserved)

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

  UI.lootInventoryText:SetText(msg)
end

function UI.LootFragUpdateMoney(gold)
 
  ZO_CurrencyControl_SetSimpleCurrency(
    UI.lootMoneyText, CURRENCY_TYPE_MONEY, gold, 
    currencyOptions, CURRENCY_SHOW_ALL, CURRENCY_HAS_ENOUGH)

end

function UI.LootFragAddLooted(item, isNewItemType)

  if isNewItemType then
    -- add row
    local row = ZO_ScrollList_CreateDataEntry(
      ROW_TYPE_ID, ZO_DeepTableCopy(item), 1)

    table.insert(
      ZO_ScrollList_GetDataList(
        UI.lootScrollList),
        row)
  else
    -- update row
    --
    local data = ZO_ScrollList_GetDataList(UI.lootScrollList)
    for i,v in ipairs(data) do
      local data = ZO_ScrollList_GetDataEntryData(v)
      if data.link == item.link then
        data.stack = item.stack
        break
      end
    end

    -- ZO_ScrollList_Clear(UI.lootScrollList)
    -- ZO_ScrollList_AddCategory(UI.lootScrollList, 1, nil)

  end

  ZO_ScrollList_Commit(UI.lootScrollList)

end

function UI.LootFragClear()
  ZO_ScrollList_Clear(UI.lootScrollList)
  ZO_ScrollList_Commit(UI.lootScrollList)
  UI.LootFragUpdateMoney(0)
end


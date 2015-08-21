
MailLooter = MailLooter or {}
local ADDON = MailLooter
ADDON.UI = ADDON.UI or {}
local UI = ADDON.UI
ADDON.Core = ADDON.Core or {}
local CORE = ADDON.Core


local currencyOptions = {
  showTooltips = false,
  useShortFormat = false,
  font = "ZoFontGame",
  iconSide = RIGHT,
}

UI.OverviewFragmentClass = ZO_Object:Subclass()

function UI.OverviewFragmentClass:New()
  local obj = ZO_Object.New(self)
  obj:Initialize()
  return obj
end

local function MakeLabel(index, parent, icon, text)
  
  if icon ~= nil then
    local texture = WINDOW_MANAGER:CreateControl(
      "MailLooterOverviewTexture" .. index, parent, CT_TEXTURE)
    texture:SetTexture(icon)
    texture:SetDimensions(32,32)
    texture:SetAnchor(TOPLEFT, parent, TOPLEFT, 5, 170 + (index * 30) - 5)
  end

  if text ~= nil then
    local label = WINDOW_MANAGER:CreateControl(
      "MailLooterOverviewLabel" .. index, parent, CT_LABEL)
    label:SetFont("ZoFontGameBold")
    label:SetText(text)
    label:SetColor(ZO_NORMAL_TEXT:UnpackRGBA())
    label:SetHeight(label:GetFontHeight())
    label:SetHorizontalAlignment(TEXT_ALIGN_LEFT)
    label:SetAnchor(TOPLEFT, parent, TOPLEFT, 36, 170 + (index * 30))
  end
end

local function MakeValue(index, parent)
  local label = WINDOW_MANAGER:CreateControl(
    "MailLooterOverviewValue" .. index, parent, CT_LABEL)

  label:SetFont("ZoFontGame")
  label:SetText("0")
  label:SetColor(1,1,1,1)
  label:SetHeight(label:GetFontHeight())
  label:SetHorizontalAlignment(TEXT_ALIGN_RIGHT)
  label:SetAnchor(TOPRIGHT, parent, TOPRIGHT, -5, 170 + (index * 30))

  return label
end

function UI.OverviewFragmentClass:Initialize()

  self.win = WINDOW_MANAGER:CreateTopLevelWindow(
                   "MailLooterOverviewFragment")
 
  self.win:SetWidth(ZO_SharedTreeUnderlay:GetWidth() * 0.6)
  self.win:SetHeight(600)
  self.win:SetAnchor(TOP, ZO_SharedTreeUnderlay, TOP, 0, 150)
  self.win:SetHidden(true)
  self.win:SetMouseEnabled(true)
  self.win:SetResizeToFitDescendents(false)

  local label = WINDOW_MANAGER:CreateControl(
    "MailLooterOverviewTitle", self.win, CT_LABEL)

  label:SetFont("ZoFontWinH2")
  label:SetText("OVERVIEW")
  label:SetHeight(label:GetFontHeight())
  label:SetHorizontalAlignment(TEXT_ALIGN_CENTER)
  label:SetAnchor(TOP, self.win, TOP, 0, 100)

  MakeLabel(1, self.win, nil, "Total Mails")
  MakeLabel(2, self.win, 'esoui/art/inventory/inventory_tabicon_all_up.dds', "All Looted:")
  MakeLabel(3, self.win, UI.typeIcons[CORE.MAILTYPE_AVA], "AvA:")
  MakeLabel(4, self.win, UI.typeIcons[CORE.MAILTYPE_HIRELING], "Hireling:")
  MakeLabel(5, self.win, UI.typeIcons[CORE.MAILTYPE_STORE], "Store:")
  MakeLabel(6, self.win, UI.typeIcons[CORE.MAILTYPE_COD], "COD:")
  MakeLabel(7, self.win, UI.typeIcons[CORE.MAILTYPE_RETURNED], "Returned:")
  MakeLabel(8, self.win, UI.typeIcons[CORE.MAILTYPE_SIMPLE], "Simple:")
  MakeLabel(9, self.win, UI.typeIcons[CORE.MAILTYPE_COD_RECEIPT], "COD Receipts:")
  MakeLabel(10, self.win, '/esoui/art/vendor/vendor_tabicon_buyback_up.dds', "Auto-Returned:")

  self.countLabels = {}
  self.countLabels.all = MakeValue(2, self.win)
  self.countLabels[CORE.MAILTYPE_AVA] = MakeValue(3, self.win)
  self.countLabels[CORE.MAILTYPE_HIRELING] = MakeValue(4, self.win)
  self.countLabels[CORE.MAILTYPE_STORE] = MakeValue(5, self.win)
  self.countLabels[CORE.MAILTYPE_COD] = MakeValue(6, self.win)
  self.countLabels[CORE.MAILTYPE_RETURNED] = MakeValue(7, self.win)
  self.countLabels[CORE.MAILTYPE_SIMPLE] = MakeValue(8, self.win)
  self.countLabels[CORE.MAILTYPE_COD_RECEIPT] = MakeValue(9, self.win)
  self.countLabels[CORE.MAILTYPE_BOUNCE] = MakeValue(10, self.win)


  local div = WINDOW_MANAGER:CreateControl(
    nil, self.win, CT_TEXTURE)
  div:SetTexture("EsoUI/Art/Miscellaneous/centerscreen_topDivider.dds")
  div:SetHeight(2)
  div:SetWidth(self.win:GetWidth() * 0.8)
  div:SetAnchor(TOP, self.win, TOP, 0, 170 + 11 * 30 + 14)

  MakeLabel(12, self.win, UI.typeIcons[CORE.MAILTYPE_COD_RECEIPT], "COD Paid")
  self.codPayments = MakeValue(12, self.win)

  ZO_CurrencyControl_SetSimpleCurrency(
    self.codPayments, CURRENCY_TYPE_MONEY, 0, 
    currencyOptions, CURRENCY_SHOW_ALL, CURRENCY_HAS_ENOUGH)


  self.FRAGMENT = ZO_FadeSceneFragment:New(self.win)

end


function UI.OverviewFragmentClass:Update(loot)

  local function Set(x)
    local val = loot.mailCount[x]
    self.countLabels[x]:SetText(val)
  end

  self.countLabels.all:SetText(loot.mailCount.all)

  Set(CORE.MAILTYPE_AVA)
  Set(CORE.MAILTYPE_HIRELING)
  Set(CORE.MAILTYPE_STORE)
  Set(CORE.MAILTYPE_STORE)
  Set(CORE.MAILTYPE_COD)
  Set(CORE.MAILTYPE_RETURNED)
  Set(CORE.MAILTYPE_SIMPLE)
  Set(CORE.MAILTYPE_COD_RECEIPT)
  Set(CORE.MAILTYPE_BOUNCE)

  ZO_CurrencyControl_SetSimpleCurrency(
    self.codPayments, CURRENCY_TYPE_MONEY, loot.codTotal, 
    currencyOptions, CURRENCY_SHOW_ALL, CURRENCY_HAS_ENOUGH)

end

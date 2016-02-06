
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

local function VertPosition(index)
  return 200 + (index * 30)
end

local function MakeLabel(index, parent, icon, text)
  
  if icon ~= nil then
    local texture = WINDOW_MANAGER:CreateControl(
      "MailLooterOverviewTexture" .. index, parent, CT_TEXTURE)
    texture:SetTexture(icon)
    texture:SetDimensions(32,32)
    texture:SetAnchor(TOPLEFT, parent, TOPLEFT, 5, VertPosition(index) - 5)
  end

  if text ~= nil then
    local label = WINDOW_MANAGER:CreateControl(
      "MailLooterOverviewLabel" .. index, parent, CT_LABEL)
    label:SetFont("ZoFontGameBold")
    label:SetText(GetString(text))
    label:SetColor(ZO_NORMAL_TEXT:UnpackRGBA())
    label:SetHeight(label:GetFontHeight())
    label:SetHorizontalAlignment(TEXT_ALIGN_LEFT)
    label:SetAnchor(TOPLEFT, parent, TOPLEFT, 36, VertPosition(index))
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
  label:SetAnchor(TOPRIGHT, parent, TOPRIGHT, -5, VertPosition(index))

  return label
end

function UI.OverviewFragmentClass:Initialize()

  self.win = WINDOW_MANAGER:CreateTopLevelWindow(
                   "MailLooterOverviewFragment")
 
  self.win:SetWidth(ZO_SharedTreeUnderlay:GetWidth() * 0.6)
  self.win:SetHeight(600)
  self.win:SetAnchor(TOP, ZO_SharedTreeUnderlay, TOP, 0, 150)
  self.win:SetHidden(true)
  -- self.win:SetMouseEnabled(true)
  self.win:SetResizeToFitDescendents(false)

  --
  -- Heading
  --

  local label = WINDOW_MANAGER:CreateControl(
    "MailLooterOverviewTitle", self.win, CT_LABEL)

  label:SetFont("ZoFontWinH2")
  label:SetText(GetString(SI_MAILLOOTER_OVERVIEW))
  label:SetModifyTextType(MODIFY_TEXT_TYPE_UPPERCASE)
  label:SetHeight(label:GetFontHeight())
  label:SetHorizontalAlignment(TEXT_ALIGN_CENTER)
  label:SetAnchor(TOP, self.win, TOP, 0, 100)


  local thing = WINDOW_MANAGER:CreateControl(
    "MailLooterOverviewThing", self.win, CT_CONTROL)
  thing:SetAnchor(TOP, label, BOTTOM, 0, 50)

  local tex4 = WINDOW_MANAGER:CreateControl(
    "MailLooterOverviewThingTex4", thing, CT_TEXTURE)
  tex4:SetTexture('/esoui/art/crafting/white_burst.dds')
  tex4:SetAnchor(CENTER, thing, CENTER, 0, 0)
  tex4:SetDimensions(150,150)
  tex4:SetAlpha(0.5)

  local texc1 = WINDOW_MANAGER:CreateControl(
    "MailLooterOverviewThingTexC1", thing, CT_TEXTURE)
  texc1:SetTexture('/esoui/art/buttons/tree_closed_up.dds')
  texc1:SetAnchor(CENTER, thing, CENTER, 0, 0)
  texc1:SetDimensions(40,40)

  local texc2 = WINDOW_MANAGER:CreateControl(
    "MailLooterOverviewThingTexC2", thing, CT_TEXTURE)
  texc2:SetTexture('/esoui/art/buttons/tree_closed_up.dds')
  texc2:SetAnchor(RIGHT, texc1, LEFT, 25, 0)
  texc2:SetDimensions(40,40)

  local texc3 = WINDOW_MANAGER:CreateControl(
    "MailLooterOverviewThingTexC3", thing, CT_TEXTURE)
  texc3:SetTexture('/esoui/art/buttons/tree_closed_up.dds')
  texc3:SetAnchor(LEFT, texc1, RIGHT, -25, 0)
  texc3:SetDimensions(40,40)

  local tex1 = WINDOW_MANAGER:CreateControl(
    "MailLooterOverviewTex1", self.win, CT_TEXTURE)
  tex1:SetTexture(UI.GetIcon(CORE.MAILTYPE_SIMPLE))
  tex1:SetAnchor(RIGHT, texc1, LEFT, -10, 0)
  tex1:SetDimensions(50,50)

  local tex3 = WINDOW_MANAGER:CreateControl(
    "MailLooterOverviewTex3", thing, CT_TEXTURE)
  tex3:SetTexture(UI.GetIcon(CORE.MAILTYPE_COD_RECEIPT))
  tex3:SetAnchor(LEFT, texc1, RIGHT, 10, 0)
  tex3:SetDimensions(50,50)

  self.thing = thing

  --
  -- Total Mails
  --

  local mclabel = WINDOW_MANAGER:CreateControl(
    "MailLooterOverviewTotal", self.win, CT_LABEL)

  mclabel:SetFont("ZoFontGameBold")
  mclabel:SetText(GetString(SI_MAILLOOTER_OVERVIEW_TOTAL))
  mclabel:SetHeight(mclabel:GetFontHeight())
  mclabel:SetHorizontalAlignment(TEXT_ALIGN_CENTER)
  mclabel:SetAnchor(TOP, self.win, TOP, 0, VertPosition(1))

  -- MakeLabel(1, self.win, nil, "Total Mails")
  MakeLabel(2, self.win, UI.GetIcon("all"), 
            SI_MAILLOOTER_OVERVIEW_ALL)
  MakeLabel(3, self.win, UI.GetIcon(CORE.MAILTYPE_AVA), 
            SI_MAILLOOTER_OVERVIEW_AVA)
  MakeLabel(4, self.win, UI.GetIcon(CORE.MAILTYPE_HIRELING), 
            SI_MAILLOOTER_OVERVIEW_HIRELING)
  MakeLabel(5, self.win, UI.GetIcon(CORE.MAILTYPE_STORE), 
            SI_MAILLOOTER_OVERVIEW_STORE)
  MakeLabel(6, self.win, UI.GetIcon(CORE.MAILTYPE_COD), 
            SI_MAILLOOTER_OVERVIEW_COD)
  MakeLabel(7, self.win, UI.GetIcon(CORE.MAILTYPE_RETURNED), 
            SI_MAILLOOTER_OVERVIEW_RETURNED)
  MakeLabel(8, self.win, UI.GetIcon(CORE.MAILTYPE_SIMPLE), 
            SI_MAILLOOTER_OVERVIEW_SIMPLE)
  MakeLabel(9, self.win, UI.GetIcon(CORE.MAILTYPE_COD_RECEIPT), 
            SI_MAILLOOTER_OVERVIEW_COD_RTN)
  MakeLabel(10, self.win, UI.GetIcon(CORE.MAILTYPE_BOUNCE), 
            SI_MAILLOOTER_OVERVIEW_AUTO_RTN)

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

  --
  -- Moneys
  --

  local div = WINDOW_MANAGER:CreateControl(
    nil, self.win, CT_TEXTURE)
  div:SetTexture("EsoUI/Art/Miscellaneous/centerscreen_topDivider.dds")
  div:SetHeight(2)
  div:SetWidth(self.win:GetWidth() * 0.8)
  div:SetAnchor(TOP, self.win, TOP, 0, VertPosition(11) + 14)

  MakeLabel(12, self.win, UI.GetIcon(CORE.MAILTYPE_COD_RECEIPT), 
            SI_MAILLOOTER_OVERVIEW_COD_PAID)
            
  self.codPayments = MakeValue(12, self.win)

  ZO_CurrencyControl_SetSimpleCurrency(
    self.codPayments, CURT_MONEY, 0, 
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
    self.codPayments, CURT_MONEY, loot.codTotal, 
    currencyOptions, CURRENCY_SHOW_ALL, CURRENCY_HAS_ENOUGH)

end

local function MakeArrowAnimation(arrow1, arrow2, arrow3)
  local timeline = ANIMATION_MANAGER:CreateTimeline()

  local a1i = timeline:InsertAnimation(ANIMATION_ALPHA, arrow1, 0)
  local a1o = timeline:InsertAnimation(ANIMATION_ALPHA, arrow1, 333)
  local a2i = timeline:InsertAnimation(ANIMATION_ALPHA, arrow2, 333)
  local a2o = timeline:InsertAnimation(ANIMATION_ALPHA, arrow2, 666)
  local a3i = timeline:InsertAnimation(ANIMATION_ALPHA, arrow3, 666)
  local a3o = timeline:InsertAnimation(ANIMATION_ALPHA, arrow3, 999)


  a1i:SetDuration(333)
  a1i:SetAlphaValues(0, 0.8)
  a1o:SetDuration(333)
  a1o:SetAlphaValues(0.8, 0)

  a2i:SetDuration(333)
  a2i:SetAlphaValues(0, 0.8)
  a2o:SetDuration(333)
  a2o:SetAlphaValues(0.8, 0)

  a3i:SetDuration(333)
  a3i:SetAlphaValues(0, 0.8)
  a3o:SetDuration(333)
  a3o:SetAlphaValues(0.8, 0)

  timeline:SetPlaybackType(ANIMATION_PLAYBACK_LOOP, 100)

  return timeline
end

local function MakeBGAnimation(bg)
  local timeline = ANIMATION_MANAGER:CreateTimeline()

  local a4i = timeline:InsertAnimation(ANIMATION_ALPHA, bg, 0)
  local a4o = timeline:InsertAnimation(ANIMATION_ALPHA, bg, 1332)
  
  a4i:SetDuration(1332)
  a4i:SetAlphaValues(0.2, 0.8)
  a4o:SetDuration(1332)
  a4o:SetAlphaValues(0.8, 0.2)

  timeline:SetPlaybackType(ANIMATION_PLAYBACK_LOOP, 50)

  return timeline
end

function UI.OverviewFragmentClass:SetLooting(isLooting)

  if not self.thing.animArrow then

    self.thing.animArrow = MakeArrowAnimation(
      self.thing:GetNamedChild("TexC2"),
      self.thing:GetNamedChild("TexC1"),
      self.thing:GetNamedChild("TexC3"))

    self.thing.animBG = MakeBGAnimation(
      self.thing:GetNamedChild("Tex4"))

  end

  if isLooting then
    self.thing.animArrow:PlayForward()
    self.thing.animBG:PlayForward()
  else
    self.thing.animArrow:Stop()
    self.thing.animBG:Stop()

    self.thing:GetNamedChild("TexC2"):SetAlpha(0)
    self.thing:GetNamedChild("TexC1"):SetAlpha(0)
    self.thing:GetNamedChild("TexC3"):SetAlpha(0)
    self.thing:GetNamedChild("Tex4"):SetAlpha(0.2)
  end
end

function UI.OverviewFragmentClass:Showing()
  self.thing:GetNamedChild("TexC2"):SetAlpha(0)
  self.thing:GetNamedChild("TexC1"):SetAlpha(0)
  self.thing:GetNamedChild("TexC3"):SetAlpha(0)
  self.thing:GetNamedChild("Tex4"):SetAlpha(0.2)
end

function UI.OverviewFragmentClass:Clear()

 local function Clear(x)
    self.countLabels[x]:SetText("0")
  end

  self.countLabels.all:SetText("0")

  Clear(CORE.MAILTYPE_AVA)
  Clear(CORE.MAILTYPE_HIRELING)
  Clear(CORE.MAILTYPE_STORE)
  Clear(CORE.MAILTYPE_STORE)
  Clear(CORE.MAILTYPE_COD)
  Clear(CORE.MAILTYPE_RETURNED)
  Clear(CORE.MAILTYPE_SIMPLE)
  Clear(CORE.MAILTYPE_COD_RECEIPT)
  Clear(CORE.MAILTYPE_BOUNCE)

  ZO_CurrencyControl_SetSimpleCurrency(
    self.codPayments, CURT_MONEY, 0, 
    currencyOptions, CURRENCY_SHOW_ALL, CURRENCY_HAS_ENOUGH)

end


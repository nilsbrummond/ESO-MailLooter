
MailLooter = MailLooter or {}
local ADDON = MailLooter
ADDON.UI = ADDON.UI or {}
local UI = ADDON.UI

UI.OverviewFragmentClass = ZO_Object:Subclass()

function UI.OverviewFragmentClass:New()
  local obj = ZO_Object.New(self)
  obj:Initialize()
  return obj
end

local function MakeLabel(index, parent, icon, text)
  local label = WINDOW_MANAGER:CreateControl(
    "MailLooterOverviewLabel" .. index, parent, CT_LABEL)
  
  if icon ~= nil then
    local texture = WINDOW_MANAGER:CreateControl(
      "MailLooterOverviewTexture" .. index, parent, CT_TEXTURE)
    texture:SetTexture(icon)
    texture:SetDimensions(26,26)
    texture:SetAnchor(TOPLEFT, parent, TOPLEFT, 5, 170 + (index * 30))
  end

  if text ~= nil then
    local label = WINDOW_MANAGER:CreateControl(
      "MailLooterOverviewLabel" .. index, parent, CT_LABEL)
    label:SetFont("ZoFontGameBold")
    label:SetText(text)
    label:SetColor(1,1,1,1)
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
  label:SetColor(ZO_NORMAL_TEXT:UnpackRGBA())
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

  label:SetFont("ZoFontGameBold")
  label:SetText("OVERVIEW")
  label:SetHeight(label:GetFontHeight())
  label:SetHorizontalAlignment(TEXT_ALIGN_CENTER)
  label:SetAnchor(TOP, self.win, TOP, 0, 80)

  MakeLabel(1, self.win, nil, "Total Mails")
  MakeLabel(2, self.win, nil, "Looted:")
  MakeLabel(3, self.win, nil, "AvA:")
  MakeLabel(4, self.win, nil, "Hireling:")
  MakeLabel(5, self.win, nil, "Store:")
  MakeLabel(6, self.win, nil, "COD:")
  MakeLabel(7, self.win, nil, "Returned:")
  MakeLabel(8, self.win, nil, "Simple:")
  MakeLabel(9, self.win, nil, "COD Receipt:")
  MakeLabel(10, self.win, nil, "Auto-Return:")

  MakeValue(2, self.win)
  MakeValue(3, self.win)
  MakeValue(4, self.win)
  MakeValue(5, self.win)
  MakeValue(6, self.win)
  MakeValue(7, self.win)
  MakeValue(8, self.win)
  MakeValue(9, self.win)
  MakeValue(10, self.win)

  self.FRAGMENT = ZO_FadeSceneFragment:New(self.win)

end

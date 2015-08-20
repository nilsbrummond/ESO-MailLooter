
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

function UI.OverviewFragmentClass:Initialize()

  self.win = WINDOW_MANAGER:CreateTopLevelWindow(
                   "MailLooterOverviewFragment")
 
  self.win:SetWidth(300)
  self.win:SetHeight(600)
  self.win:SetAnchor(TOPLEFT, ZO_MailInbox, TOPLEFT, 0, 100)
  self.win:SetHidden(true)
  self.win:SetMouseEnabled(true)
  self.win:SetResizeToFitDescendents(false)

  local label = WINDOW_MANAGER:CreateControl(
    "MailLooterOverviewLabel", self.win, CT_LABEL)

  label:SetFont("ZoFontGame")
  label:SetText("OVERVIEW")
  label:SetHeight(label:GetFontHeight())
  label:SetHorizontalAlignment(TEXT_ALIGN_CENTER)
  label:SetAnchor(TOP, self.win, TOP, 0, 80)

  self.FRAGMENT = ZO_FadeSceneFragment:New(self.win)

end

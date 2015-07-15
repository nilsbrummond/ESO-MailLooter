
eso_addon_MailLooter = eso_addon_MailLooter or {}
local ADDON = eso_addon_MailLooter
ADDON.UI = ADDON.UI or {}
local UI = ADDON.UI

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
  MAIL_LOOTER_LOOT_TITLEDivider:SetDimensions(800,2)

  local label = WINDOW_MANAGER:CreateControl(
    "MAIL_LOOTER_LOOTED_TEXT", fragment.win, CT_LABEL)

  label:SetFont("ZoFontGame")
  label:SetText("Looted items list feature is coming soon.")
  label:SetWidth(800)
  label:SetHorizontalAlignment(TEXT_ALIGN_CENTER)
  label:SetAnchor(TOP, MAIL_LOOTER_LOOT_TITLEDivider, BOTTOM, 0, 10)

  fragment.FRAGMENT = ZO_FadeSceneFragment:New(fragment.win)

  return fragment

end

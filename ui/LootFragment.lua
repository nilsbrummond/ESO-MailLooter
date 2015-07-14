
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

   

  fragment.FRAGMENT = ZO_FadeSceneFragment:New(fragment.win)

  return fragment

end

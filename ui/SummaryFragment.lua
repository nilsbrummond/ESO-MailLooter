
eso_addon_MailLooter = eso_addon_MailLooter or {}
local ADDON = eso_addon_MailLooter
ADDON.UI = ADDON.UI or {}
local UI = ADDON.UI

function UI.CreateSummaryFragment()
  local fragment = {}
  fragment.win = WINDOW_MANAGER:CreateTopLevelWindow(
                   "MailLooterSummaryFragment")
 
  fragment.win:SetWidth(ZO_MailInbox:GetWidth())
  fragment.win:SetAnchor(TOP, ZO_MailInbox, TOP, 0, 0)
  fragment.win:SetHidden(true)

  WINDOW_MANAGER:CreateControlFromVirtual(
    "MAIL_LOOTER_SUMMARY_TITLE", fragment.win, "ZO_PanelTitle")
  MAIL_LOOTER_SUMMARY_TITLE:SetAnchor(TOP, fragment.win, TOP, 0, 0)
  MAIL_LOOTER_SUMMARY_TITLELabel:SetText("SUMMARY")
  MAIL_LOOTER_SUMMARY_TITLELabel:SetFont("ZoFontBookSkin")
  MAIL_LOOTER_SUMMARY_TITLELabel:SetAnchor(
    CENTER, MAIL_LOOTER_SUMMARY_TITLEDivider, CENTER, 0, -15)
  MAIL_LOOTER_SUMMARY_TITLEDivider:SetDimensions(800,2)

--  fragment.background = WINDOW_MANAGER:CreateControl(
--    "MailLooterSummaryBackground", fragment.win, CT_BACKDROP)
--  fragment.background:SetAnchorFill(fragment.win)
--  fragment.background:SetCenterColor(1,0,0,1)

  -- Label layout
  --      1           2          3
  --  ----------  ---------  ----------
  --  Mail-Count    unread     lootable
  --      AVA       hireling   store
  --      cod                  other

  -- rule of thirds for padding size.  Then 3 columns.
  local columnWidth = fragment.win:GetWidth()
  columnWidth = (columnWidth - (columnWidth / 3)) / 3

  fragment.mailCountLabel = WINDOW_MANAGER:CreateControl(
                              "MAIL_LOOTER_SUMMARY_MAILCOUNT", fragment.win, CT_LABEL)
  fragment.mailCountLabel:SetText("All Mail: 00+   Unread: 00+   Lootable: 00+   AvA: 00+   Hireling: 00+   Store: 00+   CoD: 00+   Other: 00+")
  fragment.mailCountLabel:SetFont("ZoFontGame")
  fragment.mailCountLabel:SetAnchor(TOP, MAIL_LOOTER_SUMMARY_TITLEDivider, BOTTOM, 0, 3)


  fragment.FRAGMENT = ZO_FadeSceneFragment:New(fragment.win)

  return fragment

end


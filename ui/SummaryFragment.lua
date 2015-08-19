
MailLooter = MailLooter or {}
local ADDON = MailLooter
ADDON.UI = ADDON.UI or {}
local UI = ADDON.UI


local function mailfull(str)
  if IsLocalMailboxFull() then return str .. "+" else return str end
end

local function summaryStr(num)
  return string.format("%2d", num)
end

local function colortxt(txt)
  return "|cC0C0A0" .. txt
end

local function colorval(txt)
  return "|cFFFFFF" .. txt
end


UI.SummaryFragmentClass = ZO_Object:Subclass()

function UI.SummaryFragmentClass:New()
  local obj = ZO_Object.New(self)
  obj:Initialize()
  return obj
end

function UI.SummaryFragmentClass:Initialize()
  local fragment = self

  fragment.win = WINDOW_MANAGER:CreateTopLevelWindow(
                   "MailLooterSummaryFragment")
 
  fragment.win:SetWidth(ZO_MailInbox:GetWidth() - 20)
  fragment.win:SetAnchor(TOP, ZO_MailInbox, TOP, -20, 0)
  fragment.win:SetHidden(true)
  fragment.win:SetMouseEnabled(true)
  fragment.win:SetResizeToFitDescendents(false)


  local wrapper = WINDOW_MANAGER:CreateControl(
    "MailLooterSummaryWrapper", fragment.win, CT_CONTROL)
  wrapper:SetMouseEnabled(true)
  wrapper:SetResizeToFitDescendents(true)
  wrapper:SetAnchor(TOP, fragment.win, TOP, 0, 15)


  local title = WINDOW_MANAGER:CreateControl(
    "MailLooterSummaryTitle", wrapper, CT_LABEL)
  title:SetFont("ZoFontGameBold")
  title:SetText("INBOX:")
  title:SetColor(1,1,1,1)
  title:SetHeight(title:GetFontHeight())
  --title:SetHorizontalAlignment(TEXT_ALIGN_CENTER)
  title:SetAnchor(LEFT, wrapper, LEFT, 0, 0)


  local label = WINDOW_MANAGER:CreateControl(
    "MailLooterSummaryLabel", wrapper, CT_LABEL)

  label:SetFont("ZoFontGame")
  label:SetText("XXX")
  label:SetHeight(label:GetFontHeight())
  label:SetHorizontalAlignment(TEXT_ALIGN_LEFT)
  label:SetAnchor(LEFT, title, RIGHT, 10, 0)

  self.summaryLabel = label


  local div = WINDOW_MANAGER:CreateControl(
    "MailLooterSummaryDivider", fragment.win, CT_TEXTURE)
  div:SetTexture("EsoUI/Art/Miscellaneous/centerscreen_topDivider.dds")
  div:SetHeight(2)
  div:SetWidth(900)
  div:SetAnchor(TOP, wrapper, BOTTOM, 0, 15)

  fragment.win:SetHeight((div:GetBottom() - fragment.win:GetTop()) + 2)

  fragment.FRAGMENT = ZO_FadeSceneFragment:New(fragment.win)

end

function UI.SummaryFragmentClass:UpdateSummarySimple(text)
  self.summaryLabel:SetText(text)
end

function UI.SummaryFragmentClass:UpdateSummary(summary)

  local full = IsLocalMailboxFull()
  local mailCount = GetNumMailItems()
  local unreadCount = GetNumUnreadMail()

  local strAllMail = mailfull(summaryStr(mailCount))
  local strUnread = mailfull(summaryStr(unreadCount))
  local strLootable = mailfull(summaryStr(summary.countLootable))
  local strAVA = mailfull(summaryStr(summary.countAvA))
  local strHireling = mailfull(summaryStr(summary.countHireling))
  local strStore = mailfull(summaryStr(summary.countStore))
  local strCoD = mailfull(summaryStr(summary.countCOD))
  local strOther = mailfull(summaryStr(summary.countOther))

  self.summaryLabel:SetText(
    colortxt(   "All Mail: ") .. colorval(strAllMail) ..
    colortxt("   Unread: ") .. colorval(strUnread) ..
    colortxt("   Lootable: ") .. colorval(strLootable) ..
    colortxt("   AvA: ") .. colorval(strAVA) ..
    colortxt("   Hireling: ") .. colorval(strHireling) ..
    colortxt("   Store: ") .. colorval(strStore) ..
    colortxt("   CoD: ") .. colorval(strCoD) ..
    colortxt("   Other: ") .. colorval(strOther)
  )

end



eso_addon_MailLooter = eso_addon_MailLooter or {}
local ADDON = eso_addon_MailLooter
ADDON.UI = ADDON.UI or {}
local UI = ADDON.UI

UI.debug = true

--
-- Functions
--

local function DEBUG(str)
  if UI.debug then
    d("UI: " .. str)
  end
end

function UI.CoreListUpdateCB(list, complete, itemLink)
  DEBUG("ListUpdateCB")

  if not complete then return end

  d("Gold looted: " .. ADDON.Core.money)

  d("Items looted:")
  for i1,v1 in pairs(list) do
    for i2,v2 in ipairs(v1) do
      d("  " .. GetItemLinkName(v2.link) .. " " .. v2.stack .. " " .. v2.icon )
    end
  end

end

function UI.CoreStatusUpdateCB(inProgess, success, msg)
  DEBUG("StatusUpdateCB")

  KEYBIND_STRIP:UpdateKeybindButtonGroup(UI.mailLooterButtonGroup)

  if (inProgress) then
    UI.summaryLabel:SetText("Looting...")
  end

end

function UI.CoreScanUpdateCB(summary)
  DEBUG("ScanUpdateCB")

  if UI.debug then
    d( "Mail type counts" )
    d( "AvA Mails:      " .. summary.countAvA )
    d( "Hireling Mails: " .. summary.countHireling )
    d( "Store Mails:    " .. summary.countStore )
    d( "COD Mails:      " .. summary.countCOD )
    d( "Other Mails:    " .. summary.countOther )
    d( "More Mail:      " .. tostring(summary.more) )
  end

  UI.UpdateSummary(summary)

end

function UI.SceneStateChange(_, newState)
  DEBUG("SceneStateChange " .. newState)

  if newState == SCENE_SHOWING then
    KEYBIND_STRIP:AddKeybindButtonGroup(UI.mailLooterButtonGroup)
    ADDON.Core.OpenMailLooter()

    -- NOTE: HACK
    -- Pretty sure there is a better way this is supposed to be handled.
    -- But there is not enough documentation on this stuff...
    -- This is only an issue if you have MailLooter open then switch to 
    -- another non-mail UI screen (notifications, skills, etc) and 
    -- back again.
    ZO_SharedTitleLabel:SetText( GetString(SI_MAIN_MENU_MAIL) )

  elseif newState == SCENE_HIDDEN then
    KEYBIND_STRIP:RemoveKeybindButtonGroup(UI.mailLooterButtonGroup)
    ADDON.Core.CloseMailLooter()
  end
end


function UI.InitUserInterface()

  UI.InitSettings()
  UI.SummaryFragment = UI.CreateSummaryFragment()
  UI.LootFragment = UI.CreateLootFragment()
  UI.CreateScene()

  ADDON.Core.NewCallbacks(
    UI.CoreListUpdateCB,
    UI.CoreStatusUpdateCB,
    UI.CoreScanUpdateCB)

end

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

function UI.UpdateSummary(summary)

  local full = IsLocalMailboxFull()
  local mailCount = GetNumMailItems()
  local unreadCount = GetNumUnreadMail()

  local lootableCount = 
    summary.countAvA + summary.countHireling +
    summary.countStore + summary.countCOD

  local strAllMail = mailfull(summaryStr(mailCount))
  local strUnread = mailfull(summaryStr(unreadCount))
  local strLootable = mailfull(summaryStr(lootableCount))
  local strAVA = mailfull(summaryStr(summary.countAvA))
  local strHireling = mailfull(summaryStr(summary.countHireling))
  local strStore = mailfull(summaryStr(summary.countStore))
  local strCoD = mailfull(summaryStr(summary.countCOD))
  local strOther = mailfull(summaryStr(summary.countOther))

--  UI.summaryLabelAll:SetText(strAllMail)
--  UI.summaryLabelUnread:SetText(strUnread)
--  UI.summaryLabelLootable:SetText(strLootable)
--  UI.summaryLabelAVA:SetText(strAVA)
--  UI.summaryLabelHireling:SetText(strHireling)
--  UI.summaryLabelStore:SetText(strStore)
--  UI.summaryLabelCOD:SetText(strCoD)
--  UI.summaryLabelOther:SetText(strOther)

  GetInterfaceColor(INTERFACE_COLOR_TYPE_STAT_VALUE, 1)
  GetInterfaceColor(INTERFACE_COLOR_TYPE_STAT_VALUE, 1)

  UI.summaryLabel:SetText(
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

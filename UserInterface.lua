
local ADDON = eso_addon_MailLooter
ADDON.UI = {}
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

function UI.ListUpdateCB(list, complete, itemLink)
  DEBUG("ListUpdateCB")

  if not complete then return end

  d("Gold looted: " .. ADDON.Core.gold)

  d("Items looted:")
  for i1,v1 in pairs(list) do
    for i2,v2 in ipairs(v1) do
      d("  " .. GetItemLinkName(v2.link) .. " " .. v2.stack .. " " .. v2.icon )
    end
  end

end

function UI.StatusUpdateCB(inProgess, success, msg)
  DEBUG("StatusUpdateCB")
end

function UI.ScanUpdateCB(avaNum, hirelingNum, mailNum, moreMail)
  DEBUG("ScanUpdateCB")
end

function UI.InitUserInterface()
end

function UI.ToggleDisplay()
  DEBUG("ToggleDisplay")
end

function UI.ShowDisplay()
  DEBUG("ShowDisplay")
end

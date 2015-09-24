
MailLooter = MailLooter or {}
local ADDON = MailLooter
ADDON.Core = ADDON.Core or {}
local CORE = ADDON.Core
ADDON.Core.Test = ADDON.Core.Test or {}
local TEST = ADDON.Core.Test


local function Mail(mailType, money, sdn, scn, subject, body)
  local mail = { mailType=mailType, money=money, sdn=sdn, scn=scn }
  return mail
end

function TEST.MakeItemTest(testData)

  local testSteps = { }

  for i,v in ipairs(testData) do

    -- if item or money
    if v.items or v[10] then

      if (not v.mailType) or (v.mailType ~= CORE.MAILTYPE_UNKNOWN) then

        local mt = CORE.MAILTYPE_HIRELING

        if v.mailType then
          mt = v.mailType
        end

        local step = { 
          items= {}, 
          mail = Mail(mt, v[10], v[1], v[2], v[3])
        }

        if v.items then
          for ii, iv in ipairs(v.items) do
            table.insert( step.items, 
              { stack = iv[2],
                icon = iv[1],
                link = iv[4],
                creator = iv[3],
              }
            )

          end
        end

        table.insert(testSteps, step)

      end
    end
  end

  return testSteps

end


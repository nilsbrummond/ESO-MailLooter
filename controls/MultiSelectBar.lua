
--
-- MultiSelectBarSegment
--
-- A layer between the MenuBarButton and the MultiSelectBar to handle levels.
--

local MultiSelectBarSegment = ZO_Object:Subclass()

function MultiSelectBarSegment:New(...)
    local object = ZO_Object.New(self)
    object:Initialize(...)
    return object
end

function MultiSelectBarSegment:Initialize(menuBar, level)
    self.m_class = "Lodur_MultiSelectBarSegment"

    self.m_menuBar = menuBar
    self.m_level = level
end

function MultiSelectBarSegment:SetClickedButton(button, skipAnimation)
  self.m_menuBar:SetClickedButton(button, skipAnimation)
end


function MultiSelectBarSegment:GetClickSound()
  return self.m_menuBar:GetClickSound()
end

function MultiSelectBarSegment:GetAnimationData()
  return self.m_menuBar:GetAnimationData(self.m_level)
end

--
-- Multi Select Bar Controller
--
-- Like a MenuBar but different!!!
--

local INDEX_BUTTON = 1
local INDEX_POOL_KEY = 2
local INDEX_DESCRIPTOR = 3
local INDEX_LEVEL = 4


local MultiSelectBar = ZO_Object:Subclass()

function MultiSelectBar:New(...)
    local object = ZO_Object.New(self)
    object:Initialize(...)
    return object
end

function MultiSelectBar:Initialize(control)
    self.m_class = "Lodur_MultiSelectBar"

    self.m_buttons = {}
    self.m_control = control
    self.m_point = LEFT
    self.m_relativePoint = RIGHT
    self.m_buttonPadding = 0
    self.m_clickSound = SOUNDS.MENU_BAR_CLICK

    self.m_segments = {}
end

function MultiSelectBar:AddSubButtons(buttonData, level)
  local button, key = self.m_pool:AcquireObject()

  if not self.m_segments[level] then 
    self.m_segments[level] = MultiSelectBarSegment:New(self, level)
  end

  local segment = self.m_segments[level]
  button.m_object:SetData(segment, buttonData)

  local onInitializeCallback = buttonData.onInitializeCallback
  if onInitializeCallback then
    onInitializeCallback(button)
  end

  local b = { button, key, buttonData.descriptor, level , }
  table.insert(self.m_buttons, b)

  if buttonData.sub then

    for k,v in ipairs(buttonData.sub) do
      self:AddSubButtons(v, level + 1)
    end

  end
end

-- Adds a button plus all of it sub-buttons.
-- Expect to generally be called only once for the 'All' Button.
function MultiSelectBar:AddButtons(buttonData)
  
    self:AddSubButtons(buttonData, 1)

    self:UpdateButtons()

    return button
end

-- Perform the layout of the buttons...
function MultiSelectBar:UpdateButtons()

  -- /esoui/art/interaction/conversation_verticalborder.dds
 
  local lastVisibleButton

  for i, button in ipairs(self.m_buttons) do
    local buttonControl = button[INDEX_BUTTON]
    buttonControl:ClearAnchors()

    if (lastVisibleButton) then
      local padding = self.m_buttonPadding
      if type(padding) == 'table' then
        padding = zo_max(padding[button[INDEX_LEVEL]], 
                         padding[lastVisibleButton[INDEX_LEVEL]])
      end

      buttonControl:SetAnchor(
        self.m_point, lastVisibleButton[INDEX_BUTTON], 
        self.m_relativePoint, padding)
    else
      buttonControl:SetAnchor(self.m_point, nil, self.m_point, 0, 0)
    end

    lastVisibleButton = button
  end

end

function MultiSelectBar:GetButtonControl(descriptor)
    local buttonObject = self:ButtonObjectForDescriptor(descriptor)
    if(buttonObject) then
        return buttonObject:GetControl()
    end
end

function MultiSelectBar:SetData(data)
    if(self.m_pool ~= nil) then return end

    if(data.initialButtonAnchorPoint and data.initialButtonAnchorPoint == RIGHT) then
        self.m_point = RIGHT
        self.m_relativePoint = LEFT
    else
        self.m_point = LEFT
        self.m_relativePoint = RIGHT
    end

    self.m_pool = ZO_ControlPool:New(
      data.buttonTemplate or "ZO_MenuBarButtonTemplate1", 
      self.m_control, "Button")
    self.m_pool:SetCustomResetBehavior( function(control)
                                            control.m_object:Reset()
                                        end)

    self.m_buttonPadding = data.buttonPadding or 0
    self.m_normalSize = data.normalSize or 50
    self.m_downSize = data.downSize or 64
    self.m_animationDuration = data.animationDuration or 180
end

function MultiSelectBar:FindButtonIndex(buttonObject)

  for i,k in ipairs(self.m_buttons) do
    if k[INDEX_BUTTON] == buttonObject.m_button then
      return i
    end
  end

  return false
end

function MultiSelectBar:UpdateLowerButtons(buttonObject, skipAnimation)
  local index = self:FindButtonIndex(buttonObject)
  if not index then return end

  local level = self.m_buttons[index][INDEX_LEVEL]

  index = index + 1
  local findex = index
  local lindex = index

  while self.m_buttons[index] and 
       (self.m_buttons[index][INDEX_LEVEL] > level) do

    self.m_buttons[index][INDEX_BUTTON].m_object:SetLocked(false)
    self.m_buttons[index][INDEX_BUTTON].m_object:UnPress(skipAnimation)
    index = index + 1
  end

  lindex = index - 1

  MailLooter.UI.DEBUG("UpdateLowerButtons: " .. findex .. " -> " .. lindex)

end

function MultiSelectBar:UpdateHigherButtons(buttonObject, skipAnimation)
  local index = self:FindButtonIndex(buttonObject)
  if not index then return end

  if (self.m_buttons[index][INDEX_LEVEL] <= 1) then return end

  local level = self.m_buttons[index][INDEX_LEVEL]

  index = index - 1
  while self.m_buttons[index][INDEX_LEVEL] >= level do
    index = index - 1
  end

  local parent = self.m_buttons[index][INDEX_BUTTON].m_object
  if parent:GetState() == BSTATE_PRESSED then
    parent:SetLocked(false)
    parent:UnPress(skipAnimation)
  else
    self:UpdateHigherButtons(self.m_buttons[index][INDEX_BUTTON].m_object, skipAnimation)
  end

end

-- Called by MenuBarButton
function MultiSelectBar:SetClickedButton(buttonObject, skipAnimation)

  MailLooter.UI.DEBUG(
    "SetClickedButton id=" .. buttonObject.m_buttonData.descriptor ..
    " skip=" .. tostring(skipAnimation) .. 
    " state=" .. buttonObject:GetState() ..
    " index=" .. tostring(self:FindButtonIndex(buttonObject)))

  if(buttonObject) then
    if (buttonObject:GetState() == BSTATE_NORMAL) then
      self:UpdateLowerButtons(buttonObject, skipAnimation)
      self:UpdateHigherButtons(buttonObject, skipAnimation)
      buttonObject:Press(skipAnimation)
      buttonObject:SetLocked(true)

    elseif (buttonObject:GetState() == BSTATE_PRESSED) then
      buttonObject:SetLocked(false)
      buttonObject:UnPress(skipAnimation)
    end
  end

  local handled = zo_callHandler(self.m_control, "OnValueChanged")
  MailLooter.UI.DEBUG("OnChanged handled=" .. tostring(handled))

end


-- Called by MenuBarButton
function MultiSelectBar:GetClickSound()
  return self.m_clickSound
end

-- Called by MenuBarButton
function MultiSelectBar:GetAnimationData(level)
  local normalSize
  if type(self.m_normalSize) == 'table' then
    normalSize = self.m_normalSize[level]
  else
    normalSize = self.m_normalSize
  end

  local downSize = 0
  if type(self.m_downSize) == 'table' then
    downSize = self.m_downSize[level]
  else
    downSize = self.m_downSize
  end

  return normalSize, downSize, self.m_animationDuration
end

function MultiSelectBar:GetSelected()
  return {}
end

function MultiSelectBar:SetEnabled(enabled)
  for i,k in ipairs(self.m_buttons) do
    k[INDEX_BUTTON]:SetAlpha((not enabled) and 0.5 or 1.0)
    k[INDEX_BUTTON].m_object:SetLocked(not enabled)
  end
  
end

--
-- Multi Select Bar
--

function Lodur_MultiSelectBar_OnInitialized(self)
  self.m_object = MultiSelectBar:New(self)
end

function Lodur_MultiSelectBar_SetData(self, data)
  self.m_object:SetData(data)
end

function Lodur_MultiSelectBar_AddButtons(self, buttonData)
  self.m_object:AddButtons(buttonData)
end

function Lodur_MultiSelectBar_GetButtonControl(self, descriptor)
  return self.m_object:GetButtonControl(descriptor)
end

function Lodur_MultiSelectBar_GetSelected(self)
  return self.m_object:GetSelected()
end

function Lodur_MultiSelectBar_SetEnabled(self, enabled)
  self.m_object:SetEnabled(enabled)
end


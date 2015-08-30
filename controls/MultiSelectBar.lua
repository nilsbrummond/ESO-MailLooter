
--
-- This code is based on the ZOS ESO file:  zo_menubar.lua
-- 
--


--
-- MultiSelectBarButtomTemplate
--


local MultiSelectBarButton = ZO_Object:Subclass()

function MultiSelectBarButton:New(...)
    local object = ZO_Object.New(self)
    object:Initialize(...)
    return object
end

function MultiSelectBarButton:Initialize(button)
  self.m_class = "Lodur_MultiSelectBarButton"

  -- the control
  self.m_button = button

  -- the next level up owner
  self.m_parent = nil

  -- the level of this control
  self.m_level = nil

  -- Child objects:
  self.m_image = button:GetNamedChild("Image")
  self.m_highlight = button:GetNamedChild("ImageHighlight")

  -- logical button state
  self.m_latched = false

  -- disabled - preemptive
  self.m_disabled = false

  -- Locked - show logical state but can not change
  -- self.m_locked = false

  -- in the visual down state - an attempt to press.
  self.m_down = false

  self.m_highlightHidden = true

  -- start out at some default size...
  self.m_image:SetDimensions(32, 32)
end

function MultiSelectBarButton:Reset()
  if self.m_anim then
    self.m_anim:GetTimeline():Stop()
  end

  self.m_parent = nil
  self.m_level = nil
  self.m_subtree = nil

  self.m_highlightHidden = true
  self.m_latched = false
  --self.m_locked = false
  self.m_disabled = true
  self.m_down = false

  self:SetState(ADJUST_SIZE_INSTANT)

end

function MultiSelectBarButton:SetData(owner, buttonData, parent, level)

  self.m_buttonData = buttonData
  self.m_menuBar = owner
  self.m_parent = parent
  self.m_level = level

  self.m_highlight:SetTexture(buttonData.highlight)

  -- normal button
  self.m_latched = false
  --self.m_locked = false
  self.m_disabled = false
  self.m_down = false
  self:SetState(ADJUST_SIZE_INSTANT)

end

function MultiSelectBarButton:UpdateTexturesFromState()
    local buttonData = self.m_buttonData
    local texture

    if self.m_disabled then
      texture = buttonData.disabled
    elseif (self.m_down or self.m_latched) then
      texture = buttonData.pressed
    else
      texture = buttonData.normal
    end

    self.m_image:SetTexture(texture)
    self.m_highlight:SetHidden(self.m_highlightHidden)
end

function MultiSelectBarButton:SetState(adjustSizeInstant)
  self:UpdateTexturesFromState()

  if adjustSizeInstant then
    local normalSize, downSize = 
      self.m_menuBar:GetAnimationData(self.m_level)

    if (self.m_down or self.m_latched) then
      self.m_image:SetDimensions(downSize, downSize)
    else
      self.m_image:SetDimensions(normalSize, normalSize)
    end

    if(self.m_anim) then
      local timeline = self.m_anim:GetTimeline()
      timeline:Stop()
      if (self.m_down or self.m_latched) then
        timeline:SetProgress(0)
      else
        timeline:SetProgress(1)
      end
    end
  else
    if (self.m_down or self.m_latched) then
      self:SizeUp()
    else
      self:SizeDown()
    end
  end
end

function MultiSelectBarButton:SetHighlightHidden(hidden)
    if(hidden ~= self.m_highlightHidden) then
        self.m_highlightHidden = hidden
        self:UpdateTexturesFromState()
    end
end

function MultiSelectBarButton:CreateAnim(sizingUp)
  if (not self.m_anim) then
    self.m_anim = CreateSimpleAnimation(ANIMATION_SIZE, self.m_image)

    local normalSize, downSize, duration = 
    self.m_menuBar:GetAnimationData(self.m_level)

    self.m_anim:SetStartAndEndHeight(normalSize, downSize)
    self.m_anim:SetStartAndEndWidth(normalSize, downSize)
    self.m_anim:SetDuration(duration)

    if sizingUp then
      self.m_anim:GetTimeline():PlayInstantlyToStart()
    else
      self.m_anim:GetTimeline():PlayInstantlyToEnd()
    end
  end
end

local SIZING_UP = true

function MultiSelectBarButton:SizeUp()
  self:CreateAnim(SIZING_UP)
  self.m_anim:GetTimeline():PlayForward()
end

local SIZING_DOWN = false

function MultiSelectBarButton:SizeDown()
  self:CreateAnim(SIZING_DOWN)
  self.m_anim:GetTimeline():PlayBackward()
end

function MultiSelectBarButton:MouseEnter()
  if (not self.m_disabled) and (not self.m_latched) and 
     (not self.m_down) and (not self.m_menuBar.m_locked) then
    self:SetHighlightHidden(false)
    self:SizeUp()
  end

  if not self.m_disabled then
    if self.m_buttonData.tooltip then
      InitializeTooltip(InformationTooltip, self.m_button, BOTTOM, 0, -10)
      SetTooltipText(
        InformationTooltip,
        zo_strformat(SI_MENU_BAR_TOOLTIP, GetString(self.m_buttonData.tooltip)))
    end
  end

  return not self.m_disabled

end

function MultiSelectBarButton:MouseExit()
  if (not self.m_disabled) and (not self.m_latched) then
    self:SetHighlightHidden(true)
    self:SizeDown()
  end

  if not self.m_disabled then
    ClearTooltip(InformationTooltip)
  end

  return not self.m_disabled
end

function MultiSelectBarButton:MouseDown(adjustSizeInstant)
  if (not self.m_disabled) and (not self.m_latched) and 
     (not self.m_menuBar.m_locked) then
    self.m_down = true
    self:SetState(adjustSizeInstant)
  end
end

local PLAYER_DRIVEN = true
local CODE_DRIVEN = false

function MultiSelectBarButton:MouseUp(upInside, skipAnimation, playerDriven)
  if (self.m_menuBar.m_locked) then return end
  if (self.m_disabled) then return end

  if(upInside) then
    self.m_menuBar:SetClickedButton(self, skipAnimation)

    local buttonData = self.m_buttonData
    if(buttonData.callback) then
      buttonData:callback()
    end

    local clickSound = buttonData.clickSound or self.m_menuBar:GetClickSound()
    if(clickSound and playerDriven) then
      PlaySound(clickSound)
    end

    -- Pop up if the button did not latch.
    if not self.m_latched and self.m_down then
      self.m_down = false
      self:SetState(adjustSizeInstant)
    end

  else
    self:UnLatch(skipAnimation)
  end
end

function MultiSelectBarButton:Latch(adjustSizeInstant)
  if self.m_disabled then return end
  if self.m_latched then return end

  self.m_highlightHidden = true
  self.m_down = false
  self.m_latched = true
  self:SetState(adjustSizeInstant)
end

function MultiSelectBarButton:UnLatch(adjustSizeInstant)
  if self.m_disabled then return end
  if not self.m_latched then return end

  self.m_highlightHidden = true -- batch update, don't allow texture update from this

  self.m_down = false
  self.m_latched = false

  self:SetState(adjustSizeInstant)

end

function MultiSelectBarButton:SetLocked(locked)

  if locked then
    self:SetHighlightHidden(true)

    if self.m_down then
      self:UnLatch()
    end
  end

  self.m_button:SetAlpha(locked and 0.5 or 1.0)
end

function MultiSelectBarButton:GetDescriptor()
  return self.m_buttonData and self.m_buttonData.descriptor
end

function MultiSelectBarButton:GetControl()
  return self.m_button
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
    self.m_topButtons = {}
    self.m_control = control
    self.m_point = LEFT
    self.m_relativePoint = RIGHT
    self.m_buttonPadding = 0
    self.m_clickSound = SOUNDS.MENU_BAR_CLICK
    self.m_locked = false
end

local function GetNormalSize(control, level)
  local normalSize
  if type(control.m_normalSize) == 'table' then
    normalSize = control.m_normalSize[level]
  else
    normalSize = control.m_normalSize
  end

  return normalSize
end

function MultiSelectBar:AddSubButtons(buttonData, parent, level)
  local button, key = self.m_pool:AcquireObject()

  button.m_object:SetData(self, buttonData, parent, level)

  local onInitializeCallback = buttonData.onInitializeCallback
  if onInitializeCallback then
    onInitializeCallback(button)
  end

  local b = { button, key, buttonData.descriptor, level}
  table.insert(self.m_buttons, b)

  if buttonData.sub then
    button.m_object.m_subtree = {}

    for k,v in ipairs(buttonData.sub) do
      local sbutton = self:AddSubButtons(v, button.m_object, level + 1)
      table.insert(button.m_object.m_subtree, sbutton.m_object)
    end

  end

  return button
end

-- Adds a button plus all of it sub-buttons.
-- Expect to generally be called only once for the 'All' Button.
function MultiSelectBar:AddButtons(buttonData)
  
    local button = self:AddSubButtons(buttonData, nil, 1)

    table.insert(self.m_topButtons, button.m_object)

    self:UpdateButtons()

    return button
end

local function NeedSeparator( control, nextLevel, prevLevel )
  if nextLevel == prevLevel then return false end

  if type(control.m_separator) == 'table' then

    if nextLevel > prevLevel then
      return control.m_separator[nextLevel - 1], 
        GetNormalSize(control, nextLevel)
    else

      for i=nextLevel, prevLevel-1, 1 do
        if control.m_separator[i] then
          return true, GetNormalSize(control, i+1)
        end
      end
      
      return false
    end

  elseif control.m_separator then

    return true, zo_max(GetNormalSize(control, nextLevel),
                        GetNormalSize(control, prevLevel))

  end

  return false
end

-- Perform the layout of the buttons...
function MultiSelectBar:UpdateButtons()

  local lastVisibleButton

  for i, button in ipairs(self.m_buttons) do
    local buttonControl = button[INDEX_BUTTON]
    buttonControl:ClearAnchors()

    if (lastVisibleButton) then

      local padding = self.m_buttonPadding
      if type(padding) == 'table' then
        padding = zo_max(
          padding[button[INDEX_LEVEL]], 
          padding[lastVisibleButton[INDEX_LEVEL]])
      end

      local needSeparator, separatorHeight =
        NeedSeparator( self,
          button[INDEX_LEVEL],
          lastVisibleButton[INDEX_LEVEL] )

      if needSeparator then

        local separator, key = self.m_separatorPool:AcquireObject()

        separator:SetDimensions(2, separatorHeight)

        separator:SetAnchor(
          self.m_point, lastVisibleButton[INDEX_BUTTON], 
          self.m_relativePoint, padding/2)

        buttonControl:SetAnchor(
          self.m_point, separator, self.m_relativePoint, padding/2)

      else
        buttonControl:SetAnchor(
          self.m_point, lastVisibleButton[INDEX_BUTTON], 
          self.m_relativePoint, padding)
      end

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
  if (self.m_pool ~= nil) then return end

  if data.initialButtonAnchorPoint and 
     (data.initialButtonAnchorPoint == RIGHT) then
    self.m_point = RIGHT
    self.m_relativePoint = LEFT
  else
    self.m_point = LEFT
    self.m_relativePoint = RIGHT
  end

  self.m_pool = ZO_ControlPool:New(
    data.buttonTemplate or "Lodur_MultiSelectBarButtonTemplate", 
    self.m_control, "Button")

  self.m_pool:SetCustomResetBehavior( 
    function(control) control.m_object:Reset() end)

  self.m_separatorPool = ZO_ControlPool:New(
    "Lodur_MultiSelectBarSeparatorTemplate",
    self.m_control, "Separator")

  self.m_buttonPadding = data.buttonPadding or 0
  self.m_normalSize = data.normalSize or 50
  self.m_downSize = data.downSize or 64
  self.m_animationDuration = data.animationDuration or 180
  self.m_separator = data.separator or false
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
    self.m_buttons[index][INDEX_BUTTON].m_object:UnLatch(skipAnimation)
    index = index + 1
  end

  lindex = index - 1

  if lindex >= findex then
    MailLooter.UI.DEBUG("UpdateLowerButtons: " .. findex .. " -> " .. lindex)
  end

end

function MultiSelectBar:UpdateHigherButtons(buttonObject, skipAnimation)

  if (buttonObject.m_level <= 1) then return end

  local parent = buttonObject.m_parent

  if parent.m_latched then
    parent:UnLatch(skipAnimation)
  else
    self:UpdateHigherButtons(parent, skipAnimation)
  end

end

-- Called by MenuBarButton
function MultiSelectBar:SetClickedButton(buttonObject, skipAnimation)

  MailLooter.UI.DEBUG(
    "SetClickedButton id=" .. buttonObject.m_buttonData.descriptor ..
    " skip=" .. tostring(skipAnimation) .. 
    " index=" .. tostring(self:FindButtonIndex(buttonObject)))

  if not buttonObject.m_latched then
    -- Attempt to press

    buttonObject:Latch(skipAnimation)
    self:UpdateLowerButtons(buttonObject, skipAnimation)
    self:UpdateHigherButtons(buttonObject, skipAnimation)

  else
    -- Attempt to un-press

    buttonObject:UnLatch(skipAnimation)

  end

  if self.m_onChangedFunc then
    self.m_onChangedFunc(self)
  end

end


-- Called by MenuBarButton
function MultiSelectBar:GetClickSound()
  return self.m_clickSound
end

-- Called by MenuBarButton
function MultiSelectBar:GetAnimationData(level)
  local normalSize = GetNormalSize(self, level)

  local downSize = 0
  if type(self.m_downSize) == 'table' then
    downSize = self.m_downSize[level]
  else
    downSize = self.m_downSize
  end

  return normalSize, downSize, self.m_animationDuration
end




local function GetSelectedSubtree(buttonObject, selected, unselected)

  if buttonObject.m_latched then
    table.insert(selected, buttonObject:GetDescriptor())
    return true
  elseif buttonObject.m_subtree then

    local untmp = {}
    local falsy = false

    for i,k in ipairs(buttonObject.m_subtree) do
      falsy = GetSelectedSubtree(k, selected, untmp) or falsy
    end

    if falsy then
      for i,k in ipairs(untmp) do
        table.insert(unselected, k)
      end
    else
      table.insert(unselected, buttonObject:GetDescriptor())
    end

    return falsy
  else
    table.insert(unselected, buttonObject:GetDescriptor())
    return false
  end

end

function MultiSelectBar:GetSelected()
  local selected = {}
  local unselected = {}

  for i,k in ipairs(self.m_topButtons) do
    GetSelectedSubtree(k, selected, unselected)
  end

  return { selected=selected, unselected=unselected }
end

function MultiSelectBar:SetLocked(locked)
  if locked ~= self.m_locked then
    self.m_locked = locked

    for i,k in ipairs(self.m_buttons) do
      k[INDEX_BUTTON].m_object:SetLocked(locked)
    end

  end
end

function MultiSelectBar:SetOnChanged(func)
  self.m_onChangedFunc = func
end


function MultiSelectBar:ButtonObjectForDescriptor(descriptor)
  for _, data in ipairs(self.m_buttons) do
    if(data[INDEX_DESCRIPTOR] == descriptor) then
      return data[INDEX_BUTTON].m_object
    end
  end
end

function MultiSelectBar:SelectDescriptor( descriptor, skipAnimation )

  local buttonObject = self:ButtonObjectForDescriptor(descriptor)

  if buttonObject then
    self:SetClickedButton(buttonObject, skipAnimation)
    return true
  end

  return false

end

--
-- Multi Select Bar Button
--

function Lodur_MultiSelectBarButton_OnInitialized(self)
  self.m_object = MultiSelectBarButton:New(self)
end

function Lodur_MultiSelectBarButton_OnMouseEnter(self)
  return self.m_object:MouseEnter()
end

function Lodur_MultiSelectBarButton_OnMouseExit(self)
  return self.m_object:MouseExit()
end

function Lodur_MultiSelectBarButton_OnMouseDown(self, button)
  if(button == 1) then
    self.m_object:MouseDown()
  end
end

function Lodur_MultiSelectBarButton_OnMouseUp(self, button, upInside)
  if(button == 1) then
    self.m_object:MouseUp(upInside, ADJUST_SIZE_ANIMATED, PLAYER_DRIVEN)
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

function Lodur_MultiSelectBar_SetLocked(self, locked)
  self.m_object:SetLocked(locked)
end

function Lodur_MultiSelectBar_SetOnChanged(self, func)
  self.m_object:SetOnChanged(func)
end

function Lodur_MultiSelectBar_SelectDescriptor(self, descriptor, skipAnimation)
  self.m_object:SelectDescriptor( descriptor, skipAnimation )
end

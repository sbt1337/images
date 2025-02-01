local Library = {}
Library.__index = Library

local Window = {}
Window.__index = Window

local Tab = {}
Tab.__index = Tab

local Section = {}
Section.__index = Section

local Draggable = {}
Draggable.__index = Draggable

local MultiDropdown = {}
MultiDropdown.__index = MultiDropdown

local Label = {}
Label.__index = Label

local Theme = {
    BackgroundColor = Color3.fromRGB(28, 28, 28),
    BorderColor = Color3.fromRGB(70, 70, 70),
    TextColor = Color3.fromRGB(255, 255, 255),
    AccentColor = Color3.fromRGB(212, 103, 38),
    Font = Enum.Font.SourceSansBold,
    FontSize = 14,
    StrokeThickness = 2,
}

function Draggable:MakeDraggable(frame)
    local UserInputService = game:GetService("UserInputService")
    local dragging = false
    local dragInput, mousePos, framePos

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            mousePos = input.Position
            framePos = frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            frame.Position = UDim2.new(
                framePos.X.Scale,
                framePos.X.Offset + delta.X,
                framePos.Y.Scale,
                framePos.Y.Offset + delta.Y
            )
        end
    end)
end

function Library:CreateWindow(title)
    local window = setmetatable({}, Window)
    window.title = title
    window.screenGui = Instance.new("ScreenGui")
    window.screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    window.screenGui.Parent = game.StarterGui

    window.mainFrame = Instance.new("Frame")
    window.mainFrame.Size = UDim2.new(0, 600, 0, 500)
    window.mainFrame.Name = "MainFrame"
    window.mainFrame.BorderMode = Enum.BorderMode.Inset
    window.mainFrame.BorderColor3 = Theme.BorderColor
    window.mainFrame.Position = UDim2.new(0.5, -300, 0.5, -250)
    window.mainFrame.BorderSizePixel = 2
    window.mainFrame.BackgroundColor3 = Theme.BackgroundColor
    window.mainFrame.Parent = window.screenGui

    local outline = Instance.new("UIStroke")
    outline.LineJoinMode = Enum.LineJoinMode.Miter
    outline.Thickness = Theme.StrokeThickness
    outline.Parent = window.mainFrame

    window.titleLabel = Instance.new("TextLabel")
    window.titleLabel.RichText = true
    window.titleLabel.TextColor3 = Theme.TextColor
    window.titleLabel.Text = title
    window.titleLabel.Name = "Title"
    window.titleLabel.TextStrokeTransparency = 0
    window.titleLabel.Size = UDim2.new(0, 143, 0, 22)
    window.titleLabel.Position = UDim2.new(0.5, -292, 0.004, 0)
    window.titleLabel.BackgroundTransparency = 1
    window.titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    window.titleLabel.BorderSizePixel = 0
    window.titleLabel.Font = Theme.Font
    window.titleLabel.TextSize = 12
    window.titleLabel.Parent = window.mainFrame

    local titleOutline = Instance.new("UIStroke")
    titleOutline.LineJoinMode = Enum.LineJoinMode.Miter
    titleOutline.Thickness = 1.25
    titleOutline.Parent = window.titleLabel

    window.tabs = Instance.new("Frame")
    window.tabs.Name = "Tabs"
    window.tabs.BackgroundTransparency = 1
    window.tabs.Position = UDim2.new(0.252, 0, 0.026, -9)
    window.tabs.BorderColor3 = Color3.fromRGB(0, 0, 0)
    window.tabs.Size = UDim2.new(0, 300, 0, 22)
    window.tabs.BorderSizePixel = 0
    window.tabs.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    window.tabs.Parent = window.mainFrame

    local tabsLayout = Instance.new("UIListLayout")
    tabsLayout.FillDirection = Enum.FillDirection.Horizontal
    tabsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabsLayout.Parent = window.tabs

    local tabsOutline = Instance.new("UIStroke")
    tabsOutline.LineJoinMode = Enum.LineJoinMode.Miter
    tabsOutline.Thickness = Theme.StrokeThickness
    tabsOutline.Parent = window.tabs

    window.sectionsContainer = Instance.new("Frame")
    window.sectionsContainer.Name = "SectionsContainer"
    window.sectionsContainer.Position = UDim2.new(0.5, -295, 0.5, -223)
    window.sectionsContainer.BorderColor3 = Color3.fromRGB(0, 0, 0)
    window.sectionsContainer.Size = UDim2.new(0, 585, 0, 466)
    window.sectionsContainer.BorderSizePixel = 0
    window.sectionsContainer.BackgroundColor3 = Color3.fromRGB(33, 33, 33)
    window.sectionsContainer.Parent = window.mainFrame

    local sectionsOutline = Instance.new("UIStroke")
    sectionsOutline.Thickness = 2
    sectionsOutline.LineJoinMode = Enum.LineJoinMode.Miter
    sectionsOutline.Parent = window.sectionsContainer

    local sectionsLayout = Instance.new("UIListLayout")
    sectionsLayout.FillDirection = Enum.FillDirection.Horizontal
    sectionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    sectionsLayout.Padding = UDim.new(0, 7)
    sectionsLayout.Parent = window.sectionsContainer

    window.tabsList = {}
    return window
end

function Window:AddTab(name)
    local tab = setmetatable({}, Tab)
    tab.name = name
    tab.parentWindow = self

    tab.button = Instance.new("TextButton")
    tab.button.Font = Theme.Font
    tab.button.TextColor3 = Color3.fromRGB(165, 165, 165)
    tab.button.Text = name
    tab.button.Name = "Unselected"
    tab.button.Size = UDim2.new(0, 50, 0, 19)
    tab.button.BorderSizePixel = 2
    tab.button.AutoButtonColor = false
    tab.button.TextSize = Theme.FontSize
    tab.button.BackgroundColor3 = Color3.fromRGB(46, 46, 46)
    tab.button.Parent = self.tabs

    local buttonOutline = Instance.new("UIStroke")
    buttonOutline.LineJoinMode = Enum.LineJoinMode.Miter
    buttonOutline.Thickness = 1.25
    buttonOutline.Parent = tab.button

    table.insert(self.tabsList, tab)
    return tab
end

function Tab:CreateLeftSection(name)
    return self:CreateSection(name, "LeftSection")
end

function Tab:CreateRightSection(name)
    return self:CreateSection(name, "RightSection")
end

function Tab:CreateSection(name, position)
    local section = setmetatable({}, Section)
    section.name = name
    section.parentTab = self

    section.frame = Instance.new("Frame")
    section.frame.Size = UDim2.new(0, 283, 0, 448)
    section.frame.Name = position
    section.frame.Position = position == "LeftSection" and UDim2.new(0.01, 0, 0.133, -50) or UDim2.new(0.506, 0, 0.133, -50)
    section.frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
    section.frame.BorderSizePixel = 0
    section.frame.AutomaticSize = Enum.AutomaticSize.Y
    section.frame.BackgroundColor3 = Theme.BackgroundColor
    section.frame.Parent = self.parentTab.parentWindow.sectionsContainer

    local sectionOutline = Instance.new("UIStroke")
    sectionOutline.Thickness = 2
    sectionOutline.LineJoinMode = Enum.LineJoinMode.Miter
    sectionOutline.Parent = section.frame

    section.nameLabel = Instance.new("TextLabel")
    section.nameLabel.Font = Theme.Font
    section.nameLabel.TextColor3 = Color3.fromRGB(185, 185, 185)
    section.nameLabel.Text = name
    section.nameLabel.Name = "SectionName"
    section.nameLabel.Size = UDim2.new(0, 80, 0, 20)
    section.nameLabel.Position = UDim2.new(0, 0, -0.02875, 0)
    section.nameLabel.BackgroundTransparency = 1
    section.nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    section.nameLabel.BorderSizePixel = 0
    section.nameLabel.TextSize = 12
    section.nameLabel.Parent = section.frame

    local nameOutline = Instance.new("UIStroke")
    nameOutline.LineJoinMode = Enum.LineJoinMode.Miter
    nameOutline.Thickness = 1.25
    nameOutline.Parent = section.nameLabel

    section.uiElements = Instance.new("Frame")
    section.uiElements.Name = "UIElements"
    section.uiElements.BackgroundTransparency = 1
    section.uiElements.Size = UDim2.new(0, 260, 0, 434)
    section.uiElements.Position = UDim2.new(0.5, -130, 0.5, -217)
    section.uiElements.BorderColor3 = Color3.fromRGB(0, 0, 0)
    section.uiElements.BorderSizePixel = 0
    section.uiElements.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    section.uiElements.Parent = section.frame

    local elementsLayout = Instance.new("UIListLayout")
    elementsLayout.Padding = UDim.new(0, 4)
    elementsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    elementsLayout.Parent = section.uiElements

    return section
end

function Section:CreateSlider(params)
    local slider = {}
    slider.name = params.Name or "Slider"
    slider.suffix = params.Suffix or ""
    slider.min = params.Min or 0
    slider.max = params.Max or 100
    slider.callback = params.Callback or function() end

    slider.frame = Instance.new("Frame")
    slider.frame.Name = "Slider"
    slider.frame.BackgroundTransparency = 1
    slider.frame.Size = UDim2.new(0, 265, 0, 40)
    slider.frame.Parent = self.uiElements

    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 5)
    padding.PaddingLeft = UDim.new(0, 5)
    padding.Parent = slider.frame

    slider.sliderBG = Instance.new("Frame")
    slider.sliderBG.Name = "SliderBG"
    slider.sliderBG.Size = UDim2.new(0, 200, 0, 7)
    slider.sliderBG.Position = UDim2.new(0.058, 0, 0.543, 0)
    slider.sliderBG.BorderColor3 = Color3.fromRGB(0, 0, 0)
    slider.sliderBG.BorderSizePixel = 0
    slider.sliderBG.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    slider.sliderBG.Parent = slider.frame

    local sliderOutline = Instance.new("UIStroke")
    sliderOutline.LineJoinMode = Enum.LineJoinMode.Miter
    sliderOutline.Thickness = 2
    sliderOutline.Parent = slider.sliderBG

    slider.mainSlider = Instance.new("Frame")
    slider.mainSlider.Name = "MainSlider"
    slider.mainSlider.Size = UDim2.new(0, 141, 0, 7)
    slider.mainSlider.BorderSizePixel = 0
    slider.mainSlider.BackgroundColor3 = Theme.AccentColor
    slider.mainSlider.Parent = slider.sliderBG

    slider.nameLabel = Instance.new("TextLabel")
    slider.nameLabel.Font = Theme.Font
    slider.nameLabel.TextColor3 = Theme.TextColor
    slider.nameLabel.Text = "70.5" .. slider.suffix
    slider.nameLabel.Name = "Name"
    slider.nameLabel.Size = UDim2.new(0, 51, 0, 22)
    slider.nameLabel.Position = UDim2.new(0.83, 0, -0.043, 0)
    slider.nameLabel.BackgroundTransparency = 1
    slider.nameLabel.TextWrapped = true
    slider.nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    slider.nameLabel.TextSize = 12
    slider.nameLabel.Parent = slider.mainSlider

    local nameOutline = Instance.new("UIStroke")
    nameOutline.LineJoinMode = Enum.LineJoinMode.Miter
    nameOutline.Name = "Outline"
    nameOutline.Parent = slider.nameLabel

    slider.increaseBtn = Instance.new("TextButton")
    slider.increaseBtn.Font = Theme.Font
    slider.increaseBtn.TextColor3 = Theme.TextColor
    slider.increaseBtn.Text = "+"
    slider.increaseBtn.Size = UDim2.new(0, 10, 0, 10)
    slider.increaseBtn.Position = UDim2.new(1.445, 0, -0.286, 0)
    slider.increaseBtn.BorderSizePixel = 0
    slider.increaseBtn.AutoButtonColor = false
    slider.increaseBtn.BackgroundTransparency = 1
    slider.increaseBtn.TextSize = 14
    slider.increaseBtn.Parent = slider.mainSlider

    local increaseOutline = Instance.new("UIStroke")
    increaseOutline.LineJoinMode = Enum.LineJoinMode.Miter
    increaseOutline.Name = "Outline"
    increaseOutline.Parent = slider.increaseBtn

    slider.decreaseBtn = Instance.new("TextButton")
    slider.decreaseBtn.Font = Theme.Font
    slider.decreaseBtn.TextColor3 = Theme.TextColor
    slider.decreaseBtn.Text = "-"
    slider.decreaseBtn.Size = UDim2.new(0, 10, 0, 10)
    slider.decreaseBtn.Position = UDim2.new(-0.08, -1, -0.286, 0)
    slider.decreaseBtn.BorderSizePixel = 0
    slider.decreaseBtn.AutoButtonColor = false
    slider.decreaseBtn.BackgroundTransparency = 1
    slider.decreaseBtn.TextSize = 14
    slider.decreaseBtn.Parent = slider.mainSlider

    local decreaseOutline = Instance.new("UIStroke")
    decreaseOutline.LineJoinMode = Enum.LineJoinMode.Miter
    decreaseOutline.Name = "Outline"
    decreaseOutline.Parent = slider.decreaseBtn

    slider.nameLabelOutline = Instance.new("UIStroke")
    slider.nameLabelOutline.LineJoinMode = Enum.LineJoinMode.Miter
    slider.nameLabelOutline.Name = "Outline"
    slider.nameLabelOutline.Parent = slider.nameLabel

    slider.sliderBGOutline = Instance.new("UIStroke")
    slider.sliderBGOutline.LineJoinMode = Enum.LineJoinMode.Miter
    slider.sliderBGOutline.Name = "Outline"
    slider.sliderBGOutline.Parent = slider.sliderBG

    local function updateSlider(value)
        local percent = (value - slider.min) / (slider.max - slider.min)
        slider.mainSlider.Size = UDim2.new(percent, 0, 0, 7)
        slider.nameLabel.Text = tostring(math.floor(value * 10) / 10) .. slider.suffix
        slider.callback(value)
    end

    slider.increaseBtn.MouseButton1Click:Connect(function()
        local currentValue = (slider.mainSlider.Size.X.Scale * (slider.max - slider.min)) + slider.min
        if currentValue + 1 <= slider.max then
            updateSlider(currentValue + 1)
        end
    end)

    slider.decreaseBtn.MouseButton1Click:Connect(function()
        local currentValue = (slider.mainSlider.Size.X.Scale * (slider.max - slider.min)) + slider.min
        if currentValue - 1 >= slider.min then
            updateSlider(currentValue - 1)
        end
    end)

    return slider
end

function Section:CreateButton(params)
    local button = {}
    button.name = params.Name or "Button"
    button.callback = params.Callback or function() end

    button.button = Instance.new("TextButton")
    button.button.Font = Theme.Font
    button.button.TextColor3 = Theme.TextColor
    button.button.Text = button.name
    button.button.Name = button.name
    button.button.Size = UDim2.new(0, 260, 0, 30)
    button.button.BorderSizePixel = 0
    button.button.AutoButtonColor = false
    button.button.BackgroundColor3 = Theme.BackgroundColor
    button.button.TextSize = Theme.FontSize
    button.button.Parent = self.uiElements

    local buttonOutline = Instance.new("UIStroke")
    buttonOutline.LineJoinMode = Enum.LineJoinMode.Miter
    buttonOutline.Thickness = Theme.StrokeThickness
    buttonOutline.Parent = button.button

    button.button.MouseButton1Click:Connect(button.callback)

    return button
end

function Section:CreateDropdown(params)
    local dropdown = {}
    dropdown.name = params.Name or "Dropdown"
    dropdown.options = params.Options or {}
    dropdown.callback = params.Callback or function() end

    dropdown.frame = Instance.new("Frame")
    dropdown.frame.Name = "Dropdown"
    dropdown.frame.BackgroundTransparency = 1
    dropdown.frame.Size = UDim2.new(0, 265, 0, 55)
    dropdown.frame.Parent = self.uiElements

    dropdown.mainFrame = Instance.new("Frame")
    dropdown.mainFrame.Name = "MainDropdownFrame"
    dropdown.mainFrame.Position = UDim2.new(0, 0, 0.344, 0)
    dropdown.mainFrame.Size = UDim2.new(0, 265, 0, 30)
    dropdown.mainFrame.BorderSizePixel = 0
    dropdown.mainFrame.BackgroundColor3 = Color3.fromRGB(42, 42, 42)
    dropdown.mainFrame.Parent = dropdown.frame

    local mainOutline = Instance.new("UIStroke")
    mainOutline.Thickness = 2
    mainOutline.LineJoinMode = Enum.LineJoinMode.Miter
    mainOutline.Parent = dropdown.mainFrame

    dropdown.opener = Instance.new("TextButton")
    dropdown.opener.RichText = true
    dropdown.opener.TextColor3 = Color3.fromRGB(165, 165, 165)
    dropdown.opener.Text = "Selected: <font color=\"rgb(255,255,255)\">None</font>"
    dropdown.opener.Name = "DropdownOpener"
    dropdown.opener.AutoButtonColor = false
    dropdown.opener.Size = UDim2.new(0, 250, 0, 30)
    dropdown.opener.Position = UDim2.new(0.5, -125, 0.5, -15)
    dropdown.opener.BackgroundTransparency = 1
    dropdown.opener.TextXAlignment = Enum.TextXAlignment.Left
    dropdown.opener.BorderSizePixel = 0
    dropdown.opener.Font = Theme.Font
    dropdown.opener.TextSize = 14
    dropdown.opener.Parent = dropdown.mainFrame

    local openerOutline = Instance.new("UIStroke")
    openerOutline.LineJoinMode = Enum.LineJoinMode.Miter
    openerOutline.Thickness = 2
    openerOutline.Parent = dropdown.opener

    dropdown.nameLabel = Instance.new("TextLabel")
    dropdown.nameLabel.Font = Theme.Font
    dropdown.nameLabel.TextColor3 = Theme.TextColor
    dropdown.nameLabel.Text = dropdown.name
    dropdown.nameLabel.Name = "DropdownName"
    dropdown.nameLabel.Size = UDim2.new(0, 200, 0, 15)
    dropdown.nameLabel.Position = UDim2.new(0, 0, 0.018, 0)
    dropdown.nameLabel.BackgroundTransparency = 1
    dropdown.nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    dropdown.nameLabel.BorderSizePixel = 0
    dropdown.nameLabel.TextSize = 13
    dropdown.nameLabel.Parent = dropdown.frame

    local nameOutline = Instance.new("UIStroke")
    nameOutline.LineJoinMode = Enum.LineJoinMode.Miter
    nameOutline.Thickness = 1.25
    nameOutline.Parent = dropdown.nameLabel

    dropdown.optionsFrame = Instance.new("Frame")
    dropdown.optionsFrame.Name = "DropdownOptions"
    dropdown.optionsFrame.Size = UDim2.new(0, 265, 0, 0)
    dropdown.optionsFrame.BorderSizePixel = 0
    dropdown.optionsFrame.BackgroundColor3 = Color3.fromRGB(42, 42, 42)
    dropdown.optionsFrame.AutomaticSize = Enum.AutomaticSize.Y
    dropdown.optionsFrame.Visible = false
    dropdown.optionsFrame.Parent = dropdown.mainFrame

    local optionsLayout = Instance.new("UIListLayout")
    optionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    optionsLayout.Parent = dropdown.optionsFrame

    for i, option in ipairs(dropdown.options) do
        local optionButton = Instance.new("TextButton")
        optionButton.Font = Theme.Font
        optionButton.TextColor3 = i % 2 == 1 and Color3.fromRGB(227, 139, 81) or Color3.fromRGB(255, 255, 255)
        optionButton.Text = option
        optionButton.AutoButtonColor = false
        optionButton.Size = UDim2.new(0, 265, 0, 30)
        optionButton.BorderSizePixel = 0
        optionButton.BackgroundColor3 = i % 2 == 1 and Color3.fromRGB(46, 46, 46) or Color3.fromRGB(42, 42, 42)
        optionButton.Name = "Option" .. i .. (i % 2 == 1 and "Selected" or "Unselected")
        optionButton.Parent = dropdown.optionsFrame

        local optionOutline = Instance.new("UIStroke")
        optionOutline.LineJoinMode = Enum.LineJoinMode.Miter
        optionOutline.Thickness = 2
        optionOutline.Parent = optionButton

        optionButton.MouseButton1Click:Connect(function()
            dropdown.opener.Text = "Selected: <font color=\"rgb(255,255,255)\">" .. option .. "</font>"
            dropdown.optionsFrame.Visible = false
            dropdown.callback(option)
        end)
    end

    dropdown.opener.MouseButton1Click:Connect(function()
        dropdown.optionsFrame.Visible = not dropdown.optionsFrame.Visible
    end)

    return dropdown
end

function Section:CreateToggle(params)
    local toggle = {}
    toggle.name = params.Name or "Toggle"
    toggle.state = params.Default or false
    toggle.callback = params.Callback or function() end

    toggle.frame = Instance.new("Frame")
    toggle.frame.Name = "ToggleFrame"
    toggle.frame.BackgroundTransparency = 1
    toggle.frame.Size = UDim2.new(0, 260, 0, 17)
    toggle.frame.Parent = self.uiElements

    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 5)
    padding.PaddingLeft = UDim.new(0, 5)
    padding.Parent = toggle.frame

    toggle.button = Instance.new("TextButton")
    toggle.button.Font = Theme.Font
    toggle.button.TextColor3 = Color3.fromRGB(0, 0, 0)
    toggle.button.Text = ""
    toggle.button.AutoButtonColor = false
    toggle.button.Name = "ToggleButton"
    toggle.button.Size = UDim2.new(0, 10, 0, 10)
    toggle.button.BorderMode = Enum.BorderMode.Inset
    toggle.button.TextSize = 14
    toggle.button.BackgroundColor3 = toggle.state and Color3.fromRGB(212, 103, 38) or Color3.fromRGB(13, 13, 13)
    toggle.button.Parent = toggle.frame

    local buttonOutline = Instance.new("UIStroke")
    buttonOutline.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    buttonOutline.LineJoinMode = Enum.LineJoinMode.Miter
    buttonOutline.Thickness = 2
    buttonOutline.Parent = toggle.button

    toggle.nameLabel = Instance.new("TextLabel")
    toggle.nameLabel.Font = Theme.Font
    toggle.nameLabel.TextColor3 = Theme.TextColor
    toggle.nameLabel.Text = toggle.name
    toggle.nameLabel.Name = "ButtonName"
    toggle.nameLabel.Size = UDim2.new(0, 185, 0, 15)
    toggle.nameLabel.Position = UDim2.new(0.0625, 0, -0.25, 0)
    toggle.nameLabel.BackgroundTransparency = 1
    toggle.nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    toggle.nameLabel.BorderSizePixel = 2
    toggle.nameLabel.TextSize = 13
    toggle.nameLabel.Parent = toggle.frame

    local nameOutline = Instance.new("UIStroke")
    nameOutline.LineJoinMode = Enum.LineJoinMode.Miter
    nameOutline.Name = "Outline"
    nameOutline.Parent = toggle.nameLabel

    toggle.keyPicker = Instance.new("Frame")
    toggle.keyPicker.Name = "KeyPicker"
    toggle.keyPicker.Position = UDim2.new(0, 220, 0, 0)
    toggle.keyPicker.Size = UDim2.new(0, 40, 0, 12)
    toggle.keyPicker.BorderSizePixel = 2
    toggle.keyPicker.BackgroundColor3 = Color3.fromRGB(39, 39, 39)
    toggle.keyPicker.BorderColor3 = Color3.fromRGB(0, 0, 0)
    toggle.keyPicker.Parent = toggle.frame

    toggle.keyButton = Instance.new("TextButton")
    toggle.keyButton.Font = Theme.Font
    toggle.keyButton.TextColor3 = Color3.fromRGB(162, 162, 162)
    toggle.keyButton.Text = "None"
    toggle.keyButton.AutoButtonColor = false
    toggle.keyButton.BackgroundTransparency = 1
    toggle.keyButton.Size = UDim2.new(0, 40, 0, 10)
    toggle.keyButton.BorderSizePixel = 0
    toggle.keyButton.TextSize = 10
    toggle.keyButton.Parent = toggle.keyPicker

    local keyOutline = Instance.new("UIStroke")
    keyOutline.LineJoinMode = Enum.LineJoinMode.Miter
    keyOutline.Parent = toggle.keyButton

    toggle.button.MouseButton1Click:Connect(function()
        toggle.state = not toggle.state
        toggle.button.BackgroundColor3 = toggle.state and Color3.fromRGB(212, 103, 38) or Color3.fromRGB(13, 13, 13)
        toggle.callback(toggle.state)
    end)

    return toggle
end

function Section:CreateKeyPicker(params)
    local keyPicker = {}
    keyPicker.name = params.Name or "KeyPicker"
    keyPicker.default = params.Default or "None"
    keyPicker.callback = params.Callback or function() end

    keyPicker.frame = Instance.new("Frame")
    keyPicker.frame.Name = "KeyPicker"
    keyPicker.frame.Position = UDim2.new(0, 220, 0, 0)
    keyPicker.frame.Size = UDim2.new(0, 40, 0, 12)
    keyPicker.frame.BorderSizePixel = 2
    keyPicker.frame.BackgroundColor3 = Color3.fromRGB(39, 39, 39)
    keyPicker.frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
    keyPicker.frame.Parent = self.uiElements

    keyPicker.textButton = Instance.new("TextButton")
    keyPicker.textButton.Font = Theme.Font
    keyPicker.textButton.TextColor3 = Color3.fromRGB(162, 162, 162)
    keyPicker.textButton.Text = keyPicker.default
    keyPicker.textButton.AutoButtonColor = false
    keyPicker.textButton.BackgroundTransparency = 1
    keyPicker.textButton.Size = UDim2.new(0, 40, 0, 10)
    keyPicker.textButton.BorderSizePixel = 0
    keyPicker.textButton.TextSize = 10
    keyPicker.textButton.Parent = keyPicker.frame

    local keyOutline = Instance.new("UIStroke")
    keyOutline.LineJoinMode = Enum.LineJoinMode.Miter
    keyOutline.Parent = keyPicker.textButton

    keyPicker.textButton.MouseButton1Click:Connect(function()
        local UserInputService = game:GetService("UserInputService")
        keyPicker.textButton.Text = "..."
        local connection
        connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if not gameProcessed then
                keyPicker.textButton.Text = input.KeyCode.Name
                keyPicker.callback(input.KeyCode.Name)
                connection:Disconnect()
            end
        end)
    end)

    return keyPicker
end

function Library:SetTheme(newTheme)
    for key, value in pairs(newTheme) do
        Theme[key] = value
    end
end


function Section:CreateMultiDropdown(parent, params)
    local multiDropdown = {}

    local frame = Instance.new("Frame")
    frame.Name = "MultiDropdown"
    frame.BackgroundTransparency = 1
    frame.Size = UDim2.new(0, 265, 0, 197)
    frame.Parent = parent.uiElements

    local mainDropdown = Instance.new("Frame")
    mainDropdown.Name = "MainDropdownFrame"
    mainDropdown.Position = UDim2.new(0, 0, 0.344, 0)
    mainDropdown.Size = UDim2.new(0, 265, 0, 30)
    mainDropdown.BackgroundColor3 = Color3.fromRGB(42, 42, 42)
    mainDropdown.BorderSizePixel = 0
    mainDropdown.Parent = frame

    local outline = Instance.new("UIStroke")
    outline.Thickness = 2
    outline.LineJoinMode = Enum.LineJoinMode.Miter
    outline.Name = "Outline"
    outline.Parent = mainDropdown

    local dropdownOpener = Instance.new("TextButton")
    dropdownOpener.RichText = true
    dropdownOpener.TextColor3 = Color3.fromRGB(165, 165, 165)
    dropdownOpener.Text = "Select..."
    dropdownOpener.Name = "DropdownOpener"
    dropdownOpener.AutoButtonColor = false
    dropdownOpener.Size = UDim2.new(0, 250, 0, 30)
    dropdownOpener.Position = UDim2.new(0.5, -125, 0.5, -15)
    dropdownOpener.BackgroundTransparency = 1
    dropdownOpener.TextXAlignment = Enum.TextXAlignment.Left
    dropdownOpener.TextSize = 14
    dropdownOpener.Font = Enum.Font.Zekton
    dropdownOpener.Parent = mainDropdown

    local dropdownOpenerOutline = Instance.new("UIStroke")
    dropdownOpenerOutline.LineJoinMode = Enum.LineJoinMode.Miter
    dropdownOpenerOutline.Name = "Outline"
    dropdownOpenerOutline.Parent = dropdownOpener

    local dropdownName = Instance.new("TextLabel")
    dropdownName.Font = Enum.Font.Zekton
    dropdownName.TextColor3 = Color3.fromRGB(255, 255, 255)
    dropdownName.Text = params.Name or "MultiDropdown"
    dropdownName.Name = "DropdownName"
    dropdownName.Size = UDim2.new(0, 200, 0, 15)
    dropdownName.BackgroundTransparency = 1
    dropdownName.TextXAlignment = Enum.TextXAlignment.Left
    dropdownName.Position = UDim2.new(0, 0, 0.018, 0)
    dropdownName.TextSize = 13
    dropdownName.Parent = frame

    local dropdownNameOutline = Instance.new("UIStroke")
    dropdownNameOutline.LineJoinMode = Enum.LineJoinMode.Miter
    dropdownNameOutline.Name = "Outline"
    dropdownNameOutline.Parent = dropdownName

    local dropdownFrameOpened = Instance.new("Frame")
    dropdownFrameOpened.Name = "DropdownFrameOpened"
    dropdownFrameOpened.Size = UDim2.new(0, 265, 0, 0)
    dropdownFrameOpened.BackgroundColor3 = Color3.fromRGB(42, 42, 42)
    dropdownFrameOpened.BorderSizePixel = 0
    dropdownFrameOpened.AutomaticSize = Enum.AutomaticSize.Y
    dropdownFrameOpened.Visible = false
    dropdownFrameOpened.Parent = mainDropdown

    local optionsLayout = Instance.new("UIListLayout")
    optionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    optionsLayout.Parent = dropdownFrameOpened

    local selectedOptions = {}
    local selectedText = {}

    local function updateDropdownText()
        dropdownOpener.Text = "Selected: " .. table.concat(selectedOptions, ", ")
        if params.Callback then
            params.Callback(selectedOptions)
        end
    end

    for i, option in ipairs(params.Options or {}) do
        local optionButton = Instance.new("TextButton")
        optionButton.Font = Enum.Font.Zekton
        optionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        optionButton.Text = option
        optionButton.AutoButtonColor = false
        optionButton.Size = UDim2.new(0, 265, 0, 30)
        optionButton.BackgroundColor3 = Color3.fromRGB(46, 46, 46)
        optionButton.Name = option
        optionButton.TextSize = 13
        optionButton.Parent = dropdownFrameOpened

        local optionOutline = Instance.new("UIStroke")
        optionOutline.LineJoinMode = Enum.LineJoinMode.Miter
        optionOutline.Name = "Outline"
        optionOutline.Parent = optionButton

        optionButton.MouseButton1Click:Connect(function()
            if selectedOptions[option] then
                selectedOptions[option] = nil
                optionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                optionButton.BackgroundColor3 = Color3.fromRGB(46, 46, 46)
            else
                selectedOptions[option] = true
                optionButton.TextColor3 = Color3.fromRGB(212, 103, 38)
                optionButton.BackgroundColor3 = Color3.fromRGB(42, 42, 42)
            end
            updateDropdownText()
        end)
    end

    dropdownOpener.MouseButton1Click:Connect(function()
        dropdownFrameOpened.Visible = not dropdownFrameOpened.Visible
    end)

    return MultiDropdown
end



function Section:CreateLabel(parent, params)
    local label = {}

    local textLabel = Instance.new("TextLabel")
    textLabel.Font = Enum.Font.Zekton
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.Text = params.Text or "Label"
    textLabel.Name = "Label"
    textLabel.Size = UDim2.new(0, 265, 0, 20)
    textLabel.BackgroundTransparency = 1
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.TextSize = 14
    textLabel.Parent = parent.uiElements

    local outline = Instance.new("UIStroke")
    outline.LineJoinMode = Enum.LineJoinMode.Miter
    outline.Name = "Outline"
    outline.Parent = textLabel

    return Label
end

return setmetatable(Label, Label)

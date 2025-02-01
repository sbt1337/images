-- Components.lua
local Components = {}

-- Function to create ScreenGui
function Components.CreateScreenGui(props)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = props.Name or "ScreenGui"
    screenGui.ZIndexBehavior = props.ZIndexBehavior or Enum.ZIndexBehavior.Sibling
    screenGui.Parent = props.Parent
    return screenGui
end

-- Function to create Frames
function Components.CreateFrame(props)
    local frame = Instance.new("Frame")
    frame.Name = props.Name or "Frame"
    frame.Size = props.Size or UDim2.new(0, 100, 0, 100)
    frame.Position = props.Position or UDim2.new(0, 0, 0, 0)
    frame.BackgroundColor3 = props.BackgroundColor3 or Color3.fromRGB(255, 255, 255)
    frame.BorderColor3 = props.BorderColor3 or Color3.fromRGB(0, 0, 0)
    frame.BorderMode = props.BorderMode or Enum.BorderMode.Inset
    frame.BorderSizePixel = props.BorderSizePixel or 1
    frame.BackgroundTransparency = props.BackgroundTransparency or 0
    frame.Parent = props.Parent
    return frame
end

-- Function to create TextLabels
function Components.CreateTextLabel(props)
    local textLabel = Instance.new("TextLabel")
    textLabel.Name = props.Name or "TextLabel"
    textLabel.Text = props.Text or ""
    textLabel.Size = props.Size or UDim2.new(0, 100, 0, 50)
    textLabel.Position = props.Position or UDim2.new(0, 0, 0, 0)
    textLabel.TextColor3 = props.TextColor3 or Color3.fromRGB(0, 0, 0)
    textLabel.TextSize = props.TextSize or 14
    textLabel.FontFace = props.FontFace or Enum.Font.SourceSans
    textLabel.RichText = props.RichText or false
    textLabel.BackgroundTransparency = props.BackgroundTransparency or 0
    textLabel.TextXAlignment = props.TextXAlignment or Enum.TextXAlignment.Center
    textLabel.Parent = props.Parent
    return textLabel
end

-- Function to create TextButtons
function Components.CreateTextButton(props)
    local textButton = Instance.new("TextButton")
    textButton.Name = props.Name or "TextButton"
    textButton.Text = props.Text or ""
    textButton.Size = props.Size or UDim2.new(0, 100, 0, 50)
    textButton.Position = props.Position or UDim2.new(0, 0, 0, 0)
    textButton.TextColor3 = props.TextColor3 or Color3.fromRGB(0, 0, 0)
    textButton.TextSize = props.TextSize or 14
    textButton.FontFace = props.FontFace or Enum.Font.SourceSans
    textButton.AutoButtonColor = props.AutoButtonColor or true
    textButton.BackgroundColor3 = props.BackgroundColor3 or Color3.fromRGB(255, 255, 255)
    textButton.BackgroundTransparency = props.BackgroundTransparency or 0
    textButton.BorderColor3 = props.BorderColor3 or Color3.fromRGB(0, 0, 0)
    textButton.BorderSizePixel = props.BorderSizePixel or 1
    textButton.Parent = props.Parent
    return textButton
end

-- Function to add UIStroke
function Components.AddUIStroke(instance, props)
    local uiStroke = Instance.new("UIStroke")
    uiStroke.Name = props.Name or "UIStroke"
    uiStroke.Thickness = props.Thickness or 1
    uiStroke.LineJoinMode = props.LineJoinMode or Enum.LineJoinMode.Bevel
    uiStroke.ApplyStrokeMode = props.ApplyStrokeMode or Enum.ApplyStrokeMode.Border
    uiStroke.Color = props.Color or Color3.fromRGB(0, 0, 0)
    uiStroke.Parent = instance
    return uiStroke
end

-- Function to add UIListLayout
function Components.AddUIListLayout(parent, props)
    local uiListLayout = Instance.new("UIListLayout")
    uiListLayout.FillDirection = props.FillDirection or Enum.FillDirection.Vertical
    uiListLayout.HorizontalAlignment = props.HorizontalAlignment or Enum.HorizontalAlignment.Center
    uiListLayout.SortOrder = props.SortOrder or Enum.SortOrder.LayoutOrder
    uiListLayout.Padding = props.Padding or UDim.new(0, 0)
    uiListLayout.Parent = parent
    return uiListLayout
end

-- Function to create Tab Buttons
function Components.CreateTabButton(parent, name, isSelected)
    local tabButton = Components.CreateTextButton({
        Name = isSelected and "Selected" or "Unselected",
        Text = name,
        Size = UDim2.new(0, 50, 0, 19),
        BackgroundColor3 = isSelected and Color3.fromRGB(33, 33, 33) or Color3.fromRGB(46, 46, 46),
        TextColor3 = isSelected and Color3.fromRGB(215, 144, 89) or Color3.fromRGB(165, 165, 165),
        TextSize = 14,
        FontFace = Font.new("rbxasset://fonts/families/Zekton.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
        Parent = parent
    })

    Components.AddUIStroke(tabButton, {
        Thickness = 1.25,
        LineJoinMode = Enum.LineJoinMode.Miter,
        Name = "Outline"
    })

    -- Disable interaction for selected tab
    if isSelected then
        tabButton.Selectable = false
        tabButton.Interactable = false
    end

    return tabButton
end

-- Function to create Sections
function Components.CreateSection(parent, sectionName)
    local sectionFrame = Components.CreateFrame({
        Name = sectionName,
        Size = UDim2.new(0, 283, 0, 448),
        Position = sectionName == "LeftSection" and UDim2.new(0.009999957866966724, 0, 0.13300006091594696, -50) 
                                     or UDim2.new(0.5059999227523804, 0, 0.13300006091594696, -50),
        BackgroundColor3 = Color3.fromRGB(28, 28, 28),
        Parent = parent
    })

    Components.AddUIStroke(sectionFrame, {
        Thickness = 2,
        LineJoinMode = Enum.LineJoinMode.Miter,
        Name = "Outline"
    })

    local sectionLabel = Components.CreateTextLabel({
        Name = "SectionName",
        Text = "Section",
        Size = UDim2.new(0, 80, 0, 20),
        Position = UDim2.new(0, 0, -0.028750624507665634, 0),
        TextColor3 = Color3.fromRGB(185, 185, 185),
        TextSize = 12,
        FontFace = Font.new("rbxasset://fonts/families/Zekton.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
        Parent = sectionFrame
    })

    Components.AddUIStroke(sectionLabel, {
        Thickness = 1.25,
        LineJoinMode = Enum.LineJoinMode.Miter,
        Name = "Outline"
    })

    local UIElements = Components.CreateFrame({
        Name = "UIElements",
        Size = UDim2.new(0, 260, 0, 434),
        Position = UDim2.new(0.5, -130, 0.5, -217),
        BackgroundTransparency = 1,
        Parent = sectionFrame
    })

    Components.AddUIListLayout(UIElements, {
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 4),
        Parent = UIElements
    })

    -- Add sample UI elements (Buttons, Dropdowns, etc.)
    Components.CreateToggle(UIElements, {
        Name = "SampleToggle",
        Text = "Disabled",
        Default = false,
        KeyBind = "None"
    })

    Components.CreateDropdown(UIElements, {
        Name = "Hitpart",
        Selected = {"Right Leg"},
        Options = {"Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg"}
    })

    Components.CreateSlider(UIElements, {
        Name = "Field of View",
        Value = 70.5,
        Min = 0,
        Max = 120,
        Step = 0.1,
        Unit = "°"
    })

    -- Add more components as needed
end

-- Function to create Toggles with KeyBind
function Components.CreateToggle(parent, props)
    local toggleFrame = Components.CreateFrame({
        Name = props.Name or "Toggle",
        Size = UDim2.new(0, 260, 0, 17),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        Parent = parent
    })

    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 5)
    padding.PaddingLeft = UDim.new(0, 5)
    padding.Parent = toggleFrame

    -- Toggle Button
    local toggleButton = props.Default and "ToggledButtonWithKeyBind" or "UnToggledButtonWithKeyBind"
    local toggleStates = {
        ToggledButtonWithKeyBind = {
            ButtonColor = Color3.fromRGB(212, 103, 38),
            Text = "Enabled",
            TextColor = Color3.fromRGB(255, 255, 255),
            StrokeColor = Color3.fromRGB(179, 86, 30)
        },
        UnToggledButtonWithKeyBind = {
            ButtonColor = Color3.fromRGB(13, 13, 13),
            Text = "Disabled",
            TextColor = Color3.fromRGB(255, 255, 255),
            StrokeColor = Color3.fromRGB(0, 0, 0)
        }
    }

    local state = props.Default and "ToggledButtonWithKeyBind" or "UnToggledButtonWithKeyBind"

    local toggleStateFrame = Components.CreateFrame({
        Name = toggleButton,
        Size = UDim2.new(0, 260, 0, 17),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        Parent = toggleFrame
    })

    if props.Default then
        toggleStateFrame.Name = "ToggledButtonWithKeyBind"
    else
        toggleStateFrame.Name = "UnToggledButtonWithKeyBind"
    end

    -- Inner Components
    local button = Components.CreateTextButton({
        Name = props.Default and "EnabledButton" or "DisabledButton",
        Text = "",
        Size = UDim2.new(0, 10, 0, 10),
        Position = UDim2.new(0, 0, 0.5, -5),
        BackgroundColor3 = toggleStates[state].ButtonColor,
        BorderSizePixel = 0,
        Parent = toggleStateFrame
    })

    Components.AddUIStroke(button, {
        Thickness = 2,
        LineJoinMode = Enum.LineJoinMode.Miter,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Parent = button
    })

    local buttonName = Components.CreateTextLabel({
        Name = "ButtonName",
        Text = toggleStates[state].Text,
        Size = UDim2.new(0, 185, 0, 15),
        Position = UDim2.new(0.0625, 0, -0.25, 0),
        TextColor3 = toggleStates[state].TextColor,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        FontFace = Font.new("rbxasset://fonts/families/Zekton.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
        BackgroundTransparency = 1,
        Parent = toggleStateFrame
    })

    Components.AddUIStroke(buttonName, {
        LineJoinMode = Enum.LineJoinMode.Miter,
        Name = "Outline"
    })

    -- KeyPicker
    local keyPicker = Components.CreateFrame({
        Name = "KeyPicker",
        Size = UDim2.new(0, 40, 0, 12),
        Position = UDim2.new(0, 220, 0, 0),
        BackgroundColor3 = Color3.fromRGB(39, 39, 39),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 2,
        Parent = toggleStateFrame
    })

    local keyTextButton = Components.CreateTextButton({
        Name = "TextButton",
        Text = props.KeyBind or "None",
        Size = UDim2.new(0, 40, 0, 10),
        Position = UDim2.new(0, 0, 0, 0),
        TextColor3 = Color3.fromRGB(162, 162, 162),
        TextSize = 10,
        BackgroundTransparency = 1,
        FontFace = Font.new("rbxasset://fonts/families/Zekton.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
        Parent = keyPicker
    })

    Components.AddUIStroke(keyTextButton, {
        LineJoinMode = Enum.LineJoinMode.Miter,
        Parent = keyTextButton
    })

    return toggleFrame
end

-- Function to create Dropdowns
function Components.CreateDropdown(parent, props)
    local dropdownFrame = Components.CreateFrame({
        Name = props.Name or "Dropdown",
        Size = UDim2.new(0, 265, 0, 55),
        Position = UDim2.new(0, 0, 0.1981566846370697, 0),
        BackgroundColor3 = Color3.fromRGB(42, 42, 42),
        BackgroundTransparency = 1,
        Parent = parent
    })

    local mainDropdownFrame = Components.CreateFrame({
        Name = "MainDropdownFrame",
        Size = UDim2.new(0, 265, 0, 30),
        Position = UDim2.new(0, 0, 0.3444444537162781, 0),
        BackgroundColor3 = Color3.fromRGB(42, 42, 42),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        Parent = dropdownFrame
    })

    Components.AddUIStroke(mainDropdownFrame, {
        Thickness = 2,
        LineJoinMode = Enum.LineJoinMode.Miter,
        Name = "Outline"
    })

    local dropdownOpener = Components.CreateTextButton({
        Name = "DropdownOpener",
        Text = 'Selected: <font color="rgb(255,255,255)">' .. table.concat(props.Selected, ", ") .. '</font>',
        Size = UDim2.new(0, 250, 0, 30),
        Position = UDim2.new(0.5, -125, 0.5, -15),
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextColor3 = Color3.fromRGB(165, 165, 165),
        TextSize = 14,
        RichText = true,
        FontFace = Font.new("rbxasset://fonts/families/Zekton.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
        Parent = mainDropdownFrame
    })

    Components.AddUIStroke(dropdownOpener, {
        LineJoinMode = Enum.LineJoinMode.Miter,
        Name = "Outline"
    })

    local dropdownName = Components.CreateTextLabel({
        Name = "DropdownName",
        Text = props.Name or "DropdownName",
        Size = UDim2.new(0, 200, 0, 15),
        Position = UDim2.new(0, 0, 0.01825425960123539, 0),
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        FontFace = Font.new("rbxasset://fonts/families/Zekton.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
        BackgroundTransparency = 1,
        Parent = dropdownFrame
    })

    Components.AddUIStroke(dropdownName, {
        LineJoinMode = Enum.LineJoinMode.Miter,
        Name = "Outline"
    })

    -- Dropdown Options
    local dropdownOptions = Components.CreateFrame({
        Name = "DropdownOptions",
        Size = UDim2.new(0, 265, 0, 0), -- Start with height 0, adjust dynamically
        Position = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(42, 42, 42),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        Visible = false,
        Parent = mainDropdownFrame
    })

    Components.AddUIListLayout(dropdownOptions, {
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 0),
        Parent = dropdownOptions
    })

    -- Add Dropdown Options
    for _, option in ipairs(props.Options) do
        local optionButton = Components.CreateTextButton({
            Name = "Option_" .. option,
            Text = option,
            Size = UDim2.new(0, 265, 0, 30),
            BackgroundColor3 = Color3.fromRGB(46, 46, 46),
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 13,
            FontFace = Font.new("rbxasset://fonts/families/Zekton.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
            Parent = dropdownOptions
        })

        Components.AddUIStroke(optionButton, {
            LineJoinMode = Enum.LineJoinMode.Miter,
            Name = "Outline"
        })
    end

    return dropdownFrame
end

-- Function to create MultiDropdowns (similar to Dropdown)
function Components.CreateMultiDropdown(parent, props)
    -- Implementation similar to CreateDropdown with modifications for multiple selections
    -- This is a placeholder for brevity
    -- You can expand this based on your specific requirements
    local multiDropdownFrame = Components.CreateFrame({
        Name = "MultiDropdown",
        Size = UDim2.new(0, 265, 0, 197),
        Position = UDim2.new(0, 0, 0.3341013789176941, 0),
        BackgroundColor3 = Color3.fromRGB(42, 42, 42),
        BackgroundTransparency = 1,
        Parent = parent
    })

    local mainMultiDropdownFrame = Components.CreateFrame({
        Name = "MainDropdownFrame",
        Size = UDim2.new(0, 265, 0, 30),
        Position = UDim2.new(0, 0, 0.3444444537162781, 0),
        BackgroundColor3 = Color3.fromRGB(42, 42, 42),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        Parent = multiDropdownFrame
    })

    Components.AddUIStroke(mainMultiDropdownFrame, {
        Thickness = 2,
        LineJoinMode = Enum.LineJoinMode.Miter,
        Name = "Outline"
    })

    local multiDropdownOpener = Components.CreateTextButton({
        Name = "DropdownOpener",
        Text = 'Selected: <font color="rgb(255,255,255)">' .. table.concat(props.Selected, ", ") .. '</font>',
        Size = UDim2.new(0, 250, 0, 30),
        Position = UDim2.new(0.5, -125, 0.5, -15),
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextColor3 = Color3.fromRGB(165, 165, 165),
        TextSize = 14,
        RichText = true,
        FontFace = Font.new("rbxasset://fonts/families/Zekton.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
        Parent = mainMultiDropdownFrame
    })

    Components.AddUIStroke(multiDropdownOpener, {
        LineJoinMode = Enum.LineJoinMode.Miter,
        Name = "Outline"
    })

    local multiDropdownName = Components.CreateTextLabel({
        Name = "DropdownName",
        Text = props.Name or "DropdownName",
        Size = UDim2.new(0, 200, 0, 15),
        Position = UDim2.new(0, 0, 0.01825425960123539, 0),
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        FontFace = Font.new("rbxasset://fonts/families/Zekton.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
        BackgroundTransparency = 1,
        Parent = multiDropdownFrame
    })

    Components.AddUIStroke(multiDropdownName, {
        LineJoinMode = Enum.LineJoinMode.Miter,
        Name = "Outline"
    })

    -- Dropdown Options
    local multiDropdownOptions = Components.CreateFrame({
        Name = "DropdownFrameOpened",
        Size = UDim2.new(0, 265, 0, 0), -- Start with height 0, adjust dynamically
        Position = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(42, 42, 42),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        Visible = false,
        Parent = mainMultiDropdownFrame
    })

    Components.AddUIListLayout(multiDropdownOptions, {
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 0),
        Parent = multiDropdownOptions
    })

    -- Add Dropdown Options
    for _, option in ipairs(props.Options) do
        local optionButton = Components.CreateTextButton({
            Name = "Option_" .. option,
            Text = option,
            Size = UDim2.new(0, 265, 0, 30),
            BackgroundColor3 = Color3.fromRGB(46, 46, 46),
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 13,
            FontFace = Font.new("rbxasset://fonts/families/Zekton.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
            Parent = multiDropdownOptions
        })

        Components.AddUIStroke(optionButton, {
            LineJoinMode = Enum.LineJoinMode.Miter,
            Name = "Outline"
        })
    end

    return multiDropdownFrame
end

-- Function to create Sliders
function Components.CreateSlider(parent, props)
    local sliderFrame = Components.CreateFrame({
        Name = "Slider",
        Size = UDim2.new(0, 265, 0, 40),
        Position = UDim2.new(0, 0, 0.09677419066429138, 0),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        Parent = parent
    })

    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 5)
    padding.PaddingLeft = UDim.new(0, 5)
    padding.Parent = sliderFrame

    local sliderBG = Components.CreateFrame({
        Name = "SliderBG",
        Size = UDim2.new(0, 200, 0, 7),
        Position = UDim2.new(0.057692307978868484, 0, 0.5428571701049805, 0),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        Parent = sliderFrame
    })

    local mainSlider = Components.CreateFrame({
        Name = "MainSlider",
        Size = UDim2.new(0, 141, 0, 7),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = Color3.fromRGB(212, 103, 38),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        Parent = sliderBG
    })

    Components.CreateTextLabel({
        Name = "Name",
        Text = props.Value .. props.Unit,
        Size = UDim2.new(0, 51, 0, 22),
        Position = UDim2.new(0.8296123743057251, 0, -0.04285583645105362, 0),
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 12,
        TextWrapped = true,
        BackgroundTransparency = 1,
        FontFace = Font.new("rbxasset://fonts/families/Zekton.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = mainSlider
    })

    Components.AddUIStroke(mainSlider, {
        LineJoinMode = Enum.LineJoinMode.Miter,
        Name = "Outline"
    })

    -- Increase Button
    local increaseButton = Components.CreateTextButton({
        Name = "Increase",
        Text = "+",
        Size = UDim2.new(0, 10, 0, 10),
        Position = UDim2.new(1.4449999332427979, 0, -0.2857142984867096, 0),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 10,
        BackgroundTransparency = 1,
        FontFace = Font.new("rbxasset://fonts/families/Zekton.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
        Parent = mainSlider
    })

    Components.AddUIStroke(increaseButton, {
        LineJoinMode = Enum.LineJoinMode.Miter,
        Name = "Outline"
    })

    -- Decrease Button
    local decreaseButton = Components.CreateTextButton({
        Name = "Decrease",
        Text = "-",
        Size = UDim2.new(0, 10, 0, 10),
        Position = UDim2.new(-0.07999999821186066, -1, -0.28600001335144043, 0),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 10,
        BackgroundTransparency = 1,
        FontFace = Font.new("rbxasset://fonts/families/Zekton.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
        Parent = mainSlider
    })

    Components.AddUIStroke(decreaseButton, {
        LineJoinMode = Enum.LineJoinMode.Miter,
        Name = "Outline"
    })

    -- Slider Label
    Components.CreateTextLabel({
        Name = "NameLabel",
        Text = props.Name or "Slider",
        Size = UDim2.new(0, 200, 0, 22),
        Position = UDim2.new(0.057692307978868484, 0, -0.1428571492433548, 0),
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        BackgroundTransparency = 1,
        FontFace = Font.new("rbxasset://fonts/families/Zekton.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
        Parent = sliderFrame
    })

    Components.AddUIStroke(sliderFrame:FindFirstChild("NameLabel"), {
        LineJoinMode = Enum.LineJoinMode.Miter,
        Name = "Outline"
    })

    Components.AddUIStroke(sliderBG, {
        Thickness = 2,
        LineJoinMode = Enum.LineJoinMode.Miter,
        Name = "Outline"
    })

    return sliderFrame
end

return Components

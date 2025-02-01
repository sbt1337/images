local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local function randomString(length)
    local characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
    local result = ""
    for i = 1, length do
        local randIndex = math.random(1, #characters)
        result = result .. characters:sub(randIndex, randIndex)
    end
    return result
end

local function createStroke(parent, thickness, color)
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = thickness or 2
    stroke.Color = color or Color3.fromRGB(0, 0, 0)
    stroke.LineJoinMode = Enum.LineJoinMode.Miter
    stroke.Parent = parent
    return stroke
end

local Section = {}
Section.__index = Section

function Section.new(container, name)
    local self = setmetatable({}, Section)

    self.Container = Instance.new("Frame")
    self.Container.Size = UDim2.new(1, 0, 0, 0)
    self.Container.BackgroundTransparency = 1
    self.Container.AutomaticSize = Enum.AutomaticSize.Y
    self.Container.Parent = container

    self.Label = Instance.new("TextLabel")
    self.Label.Font = Enum.Font.SourceSans
    self.Label.TextColor3 = Color3.fromRGB(185, 185, 185)
    self.Label.Text = name
    self.Label.BackgroundTransparency = 1
    self.Label.Size = UDim2.new(1, 0, 0, 20)
    self.Label.TextSize = 12
    self.Label.TextXAlignment = Enum.TextXAlignment.Left
    self.Label.Parent = self.Container

    createStroke(self.Label, 1.25)

    self.UIListLayout = Instance.new("UIListLayout")
    self.UIListLayout.Padding = UDim.new(0, 4)
    self.UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    self.UIListLayout.Parent = self.Container

    return self
end

function Section:AddLabel(text, options)
    options = options or {}
    local label = Instance.new("TextLabel")
    label.Font = Enum.Font.SourceSans
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Text = text or ""
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(0, options.Width or 265, 0, options.Height or 20)
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = self.Container

    createStroke(label, 1.25)

    return label
end

function Section:AddToggle(name, options)
    options = options or {}
    local toggle = Instance.new("Frame")
    toggle.Size = UDim2.new(1, 0, 0, 25)
    toggle.BackgroundTransparency = 1
    toggle.Parent = self.Container

    local label = Instance.new("TextLabel")
    label.Font = Enum.Font.SourceSans
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Text = name
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(0, 200, 1, 0)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = toggle

    createStroke(label, 1.25)

    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0, 20, 0, 20)
    toggleButton.Position = UDim2.new(1, -25, 0.5, -10)
    toggleButton.BackgroundColor3 = options.Default and Color3.fromRGB(212, 103, 38) or Color3.fromRGB(46, 46, 46)
    toggleButton.Text = ""
    toggleButton.Parent = toggle

    createStroke(toggleButton, 2)

    local state = options.Default or false

    toggleButton.MouseButton1Click:Connect(function()
        state = not state
        toggleButton.BackgroundColor3 = state and Color3.fromRGB(212, 103, 38) or Color3.fromRGB(46, 46, 46)
        if options.Callback then
            pcall(options.Callback, state)
        end
    end)

    return {
        Toggle = toggle,
        State = function()
            return state
        end
    }
end

function Section:AddSlider(name, options)
    options = options or {}
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(1, 0, 0, 40)
    sliderFrame.BackgroundTransparency = 1
    sliderFrame.Parent = self.Container

    local label = Instance.new("TextLabel")
    label.Font = Enum.Font.SourceSans
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Text = name
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(0, 200, 0, 22)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = sliderFrame

    createStroke(label, 1.25)

    local sliderBG = Instance.new("Frame")
    sliderBG.Size = UDim2.new(0, 200, 0, 7)
    sliderBG.Position = UDim2.new(0, 5, 0.5, 0)
    sliderBG.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    sliderBG.Parent = sliderFrame

    createStroke(sliderBG, 2)

    local sliderFill = Instance.new("Frame")
    local defaultValue = options.Default or options.Min or 0
    local normalized = (defaultValue - (options.Min or 0)) / ((options.Max or 100) - (options.Min or 0))
    normalized = math.clamp(normalized, 0, 1)
    sliderFill.Size = UDim2.new(0, normalized * 200, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(212, 103, 38)
    sliderFill.Parent = sliderBG

    createStroke(sliderFill, 2)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 10, 0, 10)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.Position = UDim2.new(0, (normalized * 200) - 5, 0.5, -5)
    knob.Parent = sliderBG

    createStroke(knob, 2)

    local valueLabel = Instance.new("TextLabel")
    valueLabel.Font = Enum.Font.SourceSans
    valueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    valueLabel.Text = tostring(defaultValue) .. (options.Suffix or "")
    valueLabel.BackgroundTransparency = 1
    valueLabel.Size = UDim2.new(0, 60, 0, 22)
    valueLabel.Position = UDim2.new(1, -65, -0.1, 0)
    valueLabel.TextXAlignment = Enum.TextXAlignment.Left
    valueLabel.Parent = sliderFill

    createStroke(valueLabel, 1.25)

    local dragging = false

    knob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = UserInputService:GetMouseLocation()
            local sliderPos = sliderBG.AbsolutePosition
            local relativeX = mousePos.X - sliderPos.X
            relativeX = math.clamp(relativeX, 0, 200)
            sliderFill.Size = UDim2.new(0, relativeX, 1, 0)
            knob.Position = UDim2.new(0, relativeX - 5, 0.5, -5)
            local value = math.floor((relativeX / 200) * ((options.Max or 100) - (options.Min or 0)) + (options.Min or 0))
            valueLabel.Text = tostring(value) .. (options.Suffix or "")
            if options.Callback then
                pcall(options.Callback, value)
            end
        end
    end)

    return {
        GetValue = function()
            local txt = valueLabel.Text
            return tonumber(txt:sub(1, #txt - (#(options.Suffix or "") > 0 and #(options.Suffix) or 0)))
        end
    }
end

function Section:AddDropdown(name, options)
    options = options or {}
    local Dropdown = Instance.new("Frame")
    Dropdown.Name = "Dropdown"
    Dropdown.BackgroundTransparency = 1
    Dropdown.Position = UDim2.new(0, 0, 0.198, 0)
    Dropdown.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Dropdown.Size = UDim2.new(0, 265, 0, 55)
    Dropdown.BorderSizePixel = 0
    Dropdown.BackgroundColor3 = Color3.fromRGB(42, 42, 42)
    Dropdown.Parent = self.Container

    local MainDropdownFrame = Instance.new("Frame")
    MainDropdownFrame.Name = "MainDropdownFrame"
    MainDropdownFrame.Position = UDim2.new(0, 0, 0.344, 0)
    MainDropdownFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
    MainDropdownFrame.Size = UDim2.new(0, 265, 0, 30)
    MainDropdownFrame.BorderSizePixel = 0
    MainDropdownFrame.BackgroundColor3 = Color3.fromRGB(42, 42, 42)
    MainDropdownFrame.Parent = Dropdown

    local Outline_MainDropdown = Instance.new("UIStroke")
    Outline_MainDropdown.Thickness = 2
    Outline_MainDropdown.LineJoinMode = Enum.LineJoinMode.Miter
    Outline_MainDropdown.Name = "Outline_MainDropdown"
    Outline_MainDropdown.Parent = MainDropdownFrame

    local DropdownOptions = Instance.new("Frame")
    DropdownOptions.Visible = false
    DropdownOptions.Name = "DropdownOptions"
    DropdownOptions.Size = UDim2.new(0, 265, 0, 30)
    DropdownOptions.BorderColor3 = Color3.fromRGB(0, 0, 0)
    DropdownOptions.BorderSizePixel = 0
    DropdownOptions.AutomaticSize = Enum.AutomaticSize.Y
    DropdownOptions.BackgroundColor3 = Color3.fromRGB(42, 42, 42)
    DropdownOptions.Parent = MainDropdownFrame

    local UIListLayout_Dropdown = Instance.new("UIListLayout")
    UIListLayout_Dropdown.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout_Dropdown.Parent = DropdownOptions

    local label = Instance.new("TextLabel")
    label.Font = Enum.Font.SourceSans
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Text = name
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(0, 200, 0, 15)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Position = UDim2.new(0, 0, 0, 0)
    label.Parent = Dropdown

    createStroke(label, 1.25)

    local mainDropdown = Instance.new("TextButton")
    mainDropdown.Size = UDim2.new(0, 250, 0, 30)
    mainDropdown.Position = UDim2.new(0, 0, 0, 20)
    mainDropdown.BackgroundColor3 = Color3.fromRGB(42, 42, 42)
    mainDropdown.Text = "Selected: " .. (options.Default or "None")
    mainDropdown.TextColor3 = Color3.fromRGB(165, 165, 165)
    mainDropdown.TextXAlignment = Enum.TextXAlignment.Left
    mainDropdown.AutoButtonColor = false
    mainDropdown.Parent = Dropdown

    createStroke(mainDropdown, 2)

    for index, item in ipairs(options.Items or {}) do
        local Option1Selected = Instance.new("TextButton")
        Option1Selected.Font = Enum.Font.SourceSans
        Option1Selected.TextColor3 = (item == options.Default) and Color3.fromRGB(227, 139, 81) or Color3.fromRGB(255, 255, 255)
        Option1Selected.BorderColor3 = Color3.fromRGB(0, 0, 0)
        Option1Selected.Text = item
        Option1Selected.AutoButtonColor = false
        Option1Selected.Name = "Option" .. index
        Option1Selected.Size = UDim2.new(0, 265, 0, 30)
        Option1Selected.BorderSizePixel = 0
        Option1Selected.TextSize = 13
        Option1Selected.BackgroundColor3 = (item == options.Default) and Color3.fromRGB(46, 46, 46) or Color3.fromRGB(42, 42, 42)
        Option1Selected.Parent = DropdownOptions

        createStroke(Option1Selected, 1.25)

        Option1Selected.MouseButton1Click:Connect(function()
            mainDropdown.Text = "Selected: " .. item
            DropdownOptions.Visible = false
            for _, btn in ipairs(DropdownOptions:GetChildren()) do
                if btn:IsA("TextButton") then
                    btn.TextColor3 = (btn.Text == item) and Color3.fromRGB(227, 139, 81) or Color3.fromRGB(255, 255, 255)
                    btn.BackgroundColor3 = (btn.Text == item) and Color3.fromRGB(46, 46, 46) or Color3.fromRGB(42, 42, 42)
                end
            end
            if options.Callback then
                pcall(options.Callback, item)
            end
        end)
    end

    mainDropdown.MouseButton1Click:Connect(function()
        DropdownOptions.Visible = not DropdownOptions.Visible
    end)

    return {
        GetSelected = function()
            return mainDropdown.Text:sub(11)
        end
    }
end

local Tab = {}
Tab.__index = Tab

function Tab.new(name, parent)
    local self = setmetatable({}, Tab)

    self.Name = name
    self.Sections = {}

    local tabButton = Instance.new("TextButton")
    tabButton.Size = UDim2.new(0, 80, 0, 30)
    tabButton.Text = name
    tabButton.TextColor3 = Color3.fromRGB(165, 165, 165)
    tabButton.BackgroundColor3 = Color3.fromRGB(46, 46, 46)
    tabButton.AutoButtonColor = false
    tabButton.Parent = parent.Tabs

    createStroke(tabButton, 1.25)

    self.Content = Instance.new("Frame")
    self.Content.Size = UDim2.new(1, -10, 1, -40)
    self.Content.Position = UDim2.new(0, 5, 0, 40)
    self.Content.BackgroundTransparency = 1
    self.Content.Parent = parent.Container

    self.LeftSection = Instance.new("Frame")
    self.LeftSection.Size = UDim2.new(0, 283, 1, -10)
    self.LeftSection.BackgroundTransparency = 1
    self.LeftSection.Parent = self.Content

    createStroke(self.LeftSection, 2)

    self.LeftUIList = Instance.new("UIListLayout")
    self.LeftUIList.Padding = UDim.new(0, 4)
    self.LeftUIList.SortOrder = Enum.SortOrder.LayoutOrder
    self.LeftUIList.Parent = self.LeftSection

    self.RightSection = Instance.new("Frame")
    self.RightSection.Size = UDim2.new(0, 283, 1, -10)
    self.RightSection.Position = UDim2.new(1, -286, 0, 0)
    self.RightSection.BackgroundTransparency = 1
    self.RightSection.Parent = self.Content

    createStroke(self.RightSection, 2)

    self.RightUIList = Instance.new("UIListLayout")
    self.RightUIList.Padding = UDim.new(0, 4)
    self.RightUIList.SortOrder = Enum.SortOrder.LayoutOrder
    self.RightUIList.Parent = self.RightSection

    tabButton.MouseButton1Click:Connect(function()
        parent:SetActiveTab(self.Name)
    end)

    self.Button = tabButton

    return self
end

function Tab:AddSection(side, name)
    local sectionContainer = side == "Left" and self.LeftSection or self.RightSection
    local newSection = Section.new(sectionContainer, name)
    table.insert(self.Sections, newSection)
    return newSection
end

local Overlay = {}
Overlay.__index = Overlay

function Overlay:CreateWindow(title)
    self.SGui = Instance.new("ScreenGui")
    self.SGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.SGui.Parent = CoreGui
    self.SGui.Name = randomString(8)

    spawn(function()
        while wait(0.75) do
            for _, instance in ipairs(self.SGui:GetDescendants()) do
                if instance:IsA("Instance") and instance ~= self.SGui then
                    instance.Name = randomString(8)
                end
            end
            self.SGui.Name = randomString(8)
        end
    end)

    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Size = UDim2.new(0, 600, 0, 500)
    self.MainFrame.Name = "MainFrame"
    self.MainFrame.BorderMode = Enum.BorderMode.Inset
    self.MainFrame.BorderColor3 = Color3.fromRGB(70, 70, 70)
    self.MainFrame.Position = UDim2.new(0.5, -300, 0.5, -250)
    self.MainFrame.BorderSizePixel = 2
    self.MainFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
    self.MainFrame.Parent = self.SGui

    createStroke(self.MainFrame, 2)

    local dragging = false
    local dragInput, mousePos, framePos

    local function update(input)
        local delta = input.Position - mousePos
        self.MainFrame.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
    end

    self.MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            mousePos = input.Position
            framePos = self.MainFrame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    self.MainFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)

    self.Title = Instance.new("TextLabel")
    self.Title.RichText = true
    self.Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    self.Title.Text = title or "chud<font color=\"rgb(212, 103, 38)\">vision</font>.net"
    self.Title.Name = "Title"
    self.Title.TextStrokeTransparency = 0
    self.Title.Size = UDim2.new(0, 143, 0, 22)
    self.Title.Position = UDim2.new(0.5, -275, 0.004, 0)
    self.Title.BackgroundTransparency = 1
    self.Title.TextXAlignment = Enum.TextXAlignment.Left
    self.Title.TextSize = 12
    self.Title.Parent = self.MainFrame

    createStroke(self.Title, 1.25)

    self.Tabs = Instance.new("Frame")
    self.Tabs.Name = "Tabs"
    self.Tabs.BackgroundTransparency = 1
    self.Tabs.Position = UDim2.new(0.25, 0, 0.025, -9)
    self.Tabs.Size = UDim2.new(0, 300, 0, 30)
    self.Tabs.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    self.Tabs.Parent = self.MainFrame

    createStroke(self.Tabs, 2)

    local tabsListLayout = Instance.new("UIListLayout")
    tabsListLayout.FillDirection = Enum.FillDirection.Horizontal
    tabsListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    tabsListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabsListLayout.Parent = self.Tabs

    self.Container = Instance.new("Frame")
    self.Container.Name = "Container"
    self.Container.Position = UDim2.new(0.5, -295, 0.5, -223)
    self.Container.Size = UDim2.new(0, 585, 0, 466)
    self.Container.BackgroundColor3 = Color3.fromRGB(33, 33, 33)
    self.Container.BackgroundTransparency = 1
    self.Container.Parent = self.MainFrame

    createStroke(self.Container, 2)

    local containerPadding = Instance.new("UIPadding")
    containerPadding.PaddingTop = UDim.new(0, 12)
    containerPadding.PaddingBottom = UDim.new(0, 6)
    containerPadding.PaddingRight = UDim.new(0, 6)
    containerPadding.PaddingLeft = UDim.new(0, 6)
    containerPadding.Parent = self.Container

    local containerListLayout = Instance.new("UIListLayout")
    containerListLayout.FillDirection = Enum.FillDirection.Horizontal
    containerListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    containerListLayout.Padding = UDim.new(0, 7)
    containerListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    containerListLayout.Parent = self.Container

    self.RightSection = Instance.new("Frame")
    self.RightSection.Size = UDim2.new(0, 283, 1, -10)
    self.RightSection.Position = UDim2.new(1, -286, 0, 0)
    self.RightSection.BackgroundTransparency = 1
    self.RightSection.Parent = self.Container

    createStroke(self.RightSection, 2)

    local rightUIList = Instance.new("UIListLayout")
    rightUIList.Padding = UDim.new(0, 4)
    rightUIList.SortOrder = Enum.SortOrder.LayoutOrder
    rightUIList.Parent = self.RightSection

    self.LeftSection = Instance.new("Frame")
    self.LeftSection.Size = UDim2.new(0, 283, 1, -10)
    self.LeftSection.BackgroundTransparency = 1
    self.LeftSection.Parent = self.Container

    createStroke(self.LeftSection, 2)

    local leftUIList = Instance.new("UIListLayout")
    leftUIList.Padding = UDim.new(0, 4)
    leftUIList.SortOrder = Enum.SortOrder.LayoutOrder
    leftUIList.Parent = self.LeftSection

    self.Sections = {}

    self.TabsList = {}
    self.ActiveTab = nil

    function Overlay:AddTab(name)
        local newTab = Tab.new(name, self)
        table.insert(self.TabsList, newTab)

        if #self.TabsList == 1 then
            self:SetActiveTab(name)
        end

        return newTab
    end

    function self:SetActiveTab(name)
        for _, tab in ipairs(self.TabsList) do
            if tab.Name == name then
                tab.Button.TextColor3 = Color3.fromRGB(215, 144, 89)
                tab.Button.BackgroundColor3 = Color3.fromRGB(33, 33, 33)
                tab.Content.Visible = true
                self.ActiveTab = tab.Name
            else
                tab.Button.TextColor3 = Color3.fromRGB(165, 165, 165)
                tab.Button.BackgroundColor3 = Color3.fromRGB(46, 46, 46)
                tab.Content.Visible = false
            end
        end
    end

    return self
end

return Overlay

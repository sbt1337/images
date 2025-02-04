local InputService = game:GetService('UserInputService')
local TextService = game:GetService('TextService')
local CoreGui = game:GetService('CoreGui')
local Teams = game:GetService('Teams')
local Players = game:GetService('Players')
local RunService = game:GetService('RunService')
local TweenService = game:GetService('TweenService')
local RenderStepped = RunService.RenderStepped
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local ProtectGui = protectgui or (syn and syn.protect_gui) or (function() end)
local ScreenGui = Instance.new('ScreenGui')
ProtectGui(ScreenGui)
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
ScreenGui.Parent = CoreGui
local Toggles = {}
local Options = {}
getgenv().Toggles = Toggles
getgenv().Options = Options
local Library = {
    Registry = {},
    RegistryMap = {},
    Windows = {},
    Connections = {},
    Instances = {},
    OpenedFrames = {},
    DependencyBoxes = {},
    Signals = {},
    ScreenGui = ScreenGui,
    OpenDropdown = nil,
    Keyboard = {
        Letters = {
            "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M",
            "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"
        },
        Modifiers = {
            ["`"] = "~",
            ["1"] = "!",
            ["2"] = "@",
            ["3"] = "#",
            ["4"] = "$",
            ["5"] = "%",
            ["6"] = "^",
            ["7"] = "&",
            ["8"] = "*",
            ["9"] = "(",
            ["0"] = ")",
            ["-"] = "_",
            ["="] = "+",
            ["["] = "{",
            ["]"] = "}",
            ["\\"] = "|",
            [";"] = ":",
            ["'"] = '"',
            [","] = "<",
            ["."] = ".",
            ["/"] = "?"
        },
        InputNames = {
            One = "1",
            Two = "2",
            Three = "3",
            Four = "4",
            Five = "5",
            Six = "6",
            Seven = "7",
            Eight = "8",
            Nine = "9",
            Zero = "0",
            LeftBracket = "[",
            RightBracket = "]",
            Semicolon = ";",
            BackSlash = "\\",
            Slash = "/",
            Minus = "-",
            Equals = "=",
            Return = "Enter",
            Backquote = "`",
            CapsLock = "Caps",
            LeftShift = "LShift",
            RightShift = "RShift",
            LeftControl = "LCtrl",
            RightControl = "RCtrl",
            LeftAlt = "LAlt",
            RightAlt = "RAlt",
            Backspace = "Back",
            Plus = "+",
            PageUp = "PgUp",
            PageDown = "PgDown",
            Delete = "Del",
            Insert = "Ins",
            NumLock = "NumL",
            Comma = ",",
            Period = "."
        }
    }
}
local Addons = {}
local BaseSection = {}
local UI = {}

function Library:CreateInstance(className, properties)
    local instance = type(className) == "string" and Instance.new(className) or className
    for prop, value in pairs(properties) do
        instance[prop] = value
    end
    return instance
end

function Library:MakeDraggable(instance, cutoff)
    instance.Active = true
    instance.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local objPos = Vector2.new(
                Mouse.X - instance.AbsolutePosition.X,
                Mouse.Y - instance.AbsolutePosition.Y
            )
            if objPos.Y > (cutoff or 40) then
                return
            end
            while InputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
                instance.Position = UDim2.new(
                    0,
                    Mouse.X - objPos.X + (instance.Size.X.Offset * instance.AnchorPoint.X),
                    0,
                    Mouse.Y - objPos.Y + (instance.Size.Y.Offset * instance.AnchorPoint.Y)
                )
                RenderStepped:Wait()
            end
        end
    end)
end

function Library:RemoveFromRegistry(instance)
    local data = Library.RegistryMap[instance]
    if data then
        for i = #Library.Registry, 1, -1 do
            if Library.Registry[i] == data then
                table.remove(Library.Registry, i)
            end
        end
        Library.RegistryMap[instance] = nil
    end
end

function UI:CreateWindow(title)
    local window = {}
    local MainFrame = Library:CreateInstance("Frame", {
        Size = UDim2.new(0, 600, 0, 500),
        Name = "MainFrame",
        BorderMode = Enum.BorderMode.Inset,
        BorderColor3 = Color3.fromRGB(70, 70, 70),
        Position = UDim2.new(0.5, -300, 0.5, -250),
        BorderSizePixel = 2,
        BackgroundColor3 = Color3.fromRGB(28, 28, 28),
        ZIndex = 1,
        Parent = Library.ScreenGui
    })
    Library:CreateInstance("UIStroke", {
        LineJoinMode = Enum.LineJoinMode.Miter,
        Name = "Outline",
        Parent = MainFrame
    })
    local TitleLabel = Library:CreateInstance("TextLabel", {
        RichText = true,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Text = title or "Window",
        Name = "Title",
        TextStrokeTransparency = 0,
        Size = UDim2.new(0, 143, 0, 22),
        Position = UDim2.new(0.5, -292, 0, 0),
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        BorderSizePixel = 0,
        FontFace = Font.new("rbxasset://fonts/families/Zekton.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
        TextSize = 12,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        ZIndex = 2,
        Parent = MainFrame
    })
    Library:CreateInstance("UIStroke", {
        Thickness = 1.25,
        LineJoinMode = Enum.LineJoinMode.Miter,
        Name = "Outline",
        Parent = TitleLabel
    })
    local Tabs = Library:CreateInstance("Frame", {
        Name = "Tabs",
        BackgroundTransparency = 1,
        Position = UDim2.new(0.25, 0, 0, -9),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Size = UDim2.new(0, 300, 0, 22),
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        ZIndex = 2,
        Parent = MainFrame
    })
    Library:CreateInstance("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalFlex = Enum.UIFlexAlignment.Fill,
        ItemLineAlignment = Enum.ItemLineAlignment.Stretch,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = Tabs
    })
    Library:CreateInstance("UIStroke", {
        Thickness = 2,
        LineJoinMode = Enum.LineJoinMode.Miter,
        Name = "Outline",
        Parent = Tabs
    })
    local Unselected1 = Library:CreateInstance("TextButton", {
        FontFace = Font.new("rbxasset://fonts/families/Zekton.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
        TextColor3 = Color3.fromRGB(165, 165, 165),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Text = "Visuals",
        TextStrokeTransparency = 0,
        Name = "Tab_Visuals",
        Size = UDim2.new(0, 50, 0, 19),
        BorderSizePixel = 2,
        AutoButtonColor = false,
        TextSize = 14,
        BackgroundColor3 = Color3.fromRGB(46, 46, 46),
        ZIndex = 3,
        Parent = Tabs
    })
    Library:CreateInstance("UIPadding", { Parent = Unselected1 })
    Library:CreateInstance("UIStroke", {
        Thickness = 1.25,
        LineJoinMode = Enum.LineJoinMode.Miter,
        Name = "Outline",
        Parent = Unselected1
    })
    local Unselected2 = Library:CreateInstance("TextButton", {
        FontFace = Font.new("rbxasset://fonts/families/Zekton.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
        TextColor3 = Color3.fromRGB(165, 165, 165),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Text = "Stats",
        TextStrokeTransparency = 0,
        Name = "Tab_Stats",
        Size = UDim2.new(0, 50, 0, 19),
        BorderSizePixel = 2,
        AutoButtonColor = false,
        TextSize = 14,
        BackgroundColor3 = Color3.fromRGB(46, 46, 46),
        ZIndex = 3,
        Parent = Tabs
    })
    Library:CreateInstance("UIPadding", { Parent = Unselected2 })
    Library:CreateInstance("UIStroke", {
        Thickness = 1.25,
        LineJoinMode = Enum.LineJoinMode.Miter,
        Name = "Outline",
        Parent = Unselected2
    })
    local SelectedTab = Library:CreateInstance("TextButton", {
        FontFace = Font.new("rbxasset://fonts/families/Zekton.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
        TextColor3 = Color3.fromRGB(215, 144, 89),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Text = "Misc",
        TextStrokeTransparency = 0,
        Selectable = false,
        Size = UDim2.new(0, 50, 0, 19),
        Name = "Tab_Misc",
        Interactable = false,
        BorderSizePixel = 2,
        AutoButtonColor = false,
        TextSize = 14,
        BackgroundColor3 = Color3.fromRGB(33, 33, 33),
        ZIndex = 3,
        Parent = Tabs
    })
    Library:CreateInstance("UIPadding", { Parent = SelectedTab })
    Library:CreateInstance("UIStroke", {
        Thickness = 1.25,
        LineJoinMode = Enum.LineJoinMode.Miter,
        Name = "Outline",
        Parent = SelectedTab
    })
    local Unselected3 = Library:CreateInstance("TextButton", {
        FontFace = Font.new("rbxasset://fonts/families/Zekton.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
        TextColor3 = Color3.fromRGB(165, 165, 165),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Text = "Aim",
        TextStrokeTransparency = 0,
        Size = UDim2.new(0, 50, 0, 19),
        Name = "Tab_Aim",
        Selectable = false,
        BorderSizePixel = 2,
        AutoButtonColor = false,
        TextSize = 14,
        BackgroundColor3 = Color3.fromRGB(46, 46, 46),
        ZIndex = 3,
        Parent = Tabs
    })
    Library:CreateInstance("UIPadding", { Parent = Unselected3 })
    Library:CreateInstance("UIStroke", {
        Thickness = 1.25,
        LineJoinMode = Enum.LineJoinMode.Miter,
        Name = "Outline",
        Parent = Unselected3
    })
    local SectionContainer = Library:CreateInstance("Frame", {
        Name = "SectionContainer",
        Position = UDim2.new(0.51, -295, 0.5, -223),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Size = UDim2.new(0, 585, 0, 466),
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(33, 33, 33),
        ZIndex = 2,
        Parent = MainFrame
    })
    Library:CreateInstance("UIPadding", {
        PaddingTop = UDim.new(0, 12),
        PaddingBottom = UDim.new(0, 6),
        PaddingRight = UDim.new(0, 6),
        PaddingLeft = UDim.new(0, 6),
        Parent = SectionContainer
    })
    Library:CreateInstance("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalFlex = Enum.UIFlexAlignment.Fill,
        Padding = UDim.new(0, 7),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = SectionContainer
    })
    local RightSection = Library:CreateInstance("Frame", {
        Size = UDim2.new(0, 283, 0, 448),
        Name = "RightSection",
        Position = UDim2.new(0.506, 0, 0.133, -50),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = Color3.fromRGB(28, 28, 28),
        ZIndex = 2,
        Parent = SectionContainer
    })
    Library:CreateInstance("UIStroke", {
        Thickness = 2,
        LineJoinMode = Enum.LineJoinMode.Miter,
        Name = "Outline",
        Parent = RightSection
    })
    local SectionNameRight = Library:CreateInstance("TextLabel", {
        FontFace = Font.new("rbxasset://fonts/families/Zekton.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
        TextColor3 = Color3.fromRGB(185, 185, 185),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Text = "Section",
        Name = "SectionName",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, -0.03, 0),
        Size = UDim2.new(0, 80, 0, 20),
        BorderSizePixel = 0,
        TextSize = 12,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        ZIndex = 3,
        Parent = RightSection
    })
    Library:CreateInstance("UIStroke", {
        Thickness = 1.25,
        LineJoinMode = Enum.LineJoinMode.Miter,
        Name = "Outline",
        Parent = SectionNameRight
    })
    local UIElementsRight = Library:CreateInstance("Frame", {
        Name = "UIElements",
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, -130, 0.5, -217),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Size = UDim2.new(0, 260, 0, 434),
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        ZIndex = 2,
        Parent = RightSection
    })
    Library:CreateInstance("UIListLayout", {
        Padding = UDim.new(0, 4),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = UIElementsRight
    })
    local LeftSection = Library:CreateInstance("Frame", {
        Size = UDim2.new(0, 283, 0, 448),
        Name = "LeftSection",
        Position = UDim2.new(0.01, 0, 0.133, -50),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = Color3.fromRGB(28, 28, 28),
        ZIndex = 2,
        Parent = SectionContainer
    })
    Library:CreateInstance("UIStroke", {
        Thickness = 2,
        LineJoinMode = Enum.LineJoinMode.Miter,
        Name = "Outline",
        Parent = LeftSection
    })
    local SectionNameLeft = Library:CreateInstance("TextLabel", {
        FontFace = Font.new("rbxasset://fonts/families/Zekton.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
        TextColor3 = Color3.fromRGB(185, 185, 185),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Text = "Section",
        Name = "SectionName",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, -0.03, 0),
        Size = UDim2.new(0, 80, 0, 20),
        BorderSizePixel = 0,
        TextSize = 12,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        ZIndex = 3,
        Parent = LeftSection
    })
    Library:CreateInstance("UIStroke", {
        Thickness = 1.25,
        LineJoinMode = Enum.LineJoinMode.Miter,
        Name = "Outline",
        Parent = SectionNameLeft
    })
    local UIElementsLeft = Library:CreateInstance("Frame", {
        Name = "UIElements",
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, -130, 0.5, -217),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Size = UDim2.new(0, 260, 0, 434),
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        ZIndex = 2,
        Parent = LeftSection
    })
    Library:CreateInstance("UIListLayout", {
        Padding = UDim.new(0, 4),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = UIElementsLeft
    })
    local Coverup = Library:CreateInstance("Frame", {
        Name = "Coverup",
        Position = UDim2.new(0.503, 0, 0.043, 0),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Size = UDim2.new(0, 73, 0, 5),
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(33, 33, 33),
        ZIndex = 4,
        Parent = MainFrame
    })
    Library:MakeDraggable(MainFrame)
    window.MainFrame = MainFrame
    window.LeftSection = LeftSection
    window.RightSection = RightSection
    window.Tabs = Tabs
    return window
end

local SectionFunctions = {}

function SectionFunctions:AddLabel(text, wrap)
    local label = Library:CreateInstance("TextLabel", {
        FontFace = Font.new("rbxasset://fonts/families/Zekton.json", 
            Enum.FontWeight.Regular, Enum.FontStyle.Normal),
        TextColor3 = Color3.fromRGB(255, 255, 255),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Text = text or "",
        TextStrokeTransparency = 0,
        Size = UDim2.new(0, 185, 0, 15),
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        BorderSizePixel = 2,
        TextSize = 13,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        ZIndex = 3,
        Parent = self.Parent
    })
    if wrap then
        label.TextWrapped = true
    end
    return label
end

function SectionFunctions:AddSlider(index, info)
    local sliderContainer = Library:CreateInstance("Frame", {
        Name = "Slider_" .. tostring(index),
        Size = UDim2.new(0, 260, 0, 30),
        BackgroundTransparency = 1,
        ZIndex = 3,
        Parent = self.Parent
    })
    local sliderLabel = Library:CreateInstance("TextLabel", {
        FontFace = Font.new("rbxasset://fonts/families/Zekton.json", 
            Enum.FontWeight.Regular, Enum.FontStyle.Normal),
        TextColor3 = Color3.fromRGB(255, 255, 255),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Text = info.Text or "Slider",
        TextStrokeTransparency = 0,
        Size = UDim2.new(0, 200, 0, 22),
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        BorderSizePixel = 0,
        TextSize = 13,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        ZIndex = 3,
        Parent = sliderContainer
    })
    local sliderBG = Library:CreateInstance("Frame", {
        Name = "SliderBG",
        Size = UDim2.new(0, 250, 0, 7),
        Position = UDim2.new(0, 0, 0, 25),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(46, 46, 46),
        ZIndex = 3,
        Parent = sliderContainer
    })
    local sliderFill = Library:CreateInstance("Frame", {
        Name = "SliderFill",
        Size = UDim2.new((info.Default or 0) / 100, 0, 1, 0),
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(215, 144, 89),
        ZIndex = 4,
        Parent = sliderBG
    })
    local sliderValue = Library:CreateInstance("TextLabel", {
        FontFace = Font.new("rbxasset://fonts/families/Zekton.json", 
            Enum.FontWeight.Regular, Enum.FontStyle.Normal),
        TextColor3 = Color3.fromRGB(255, 255, 255),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Text = tostring(info.Default or 0),
        Name = "SliderValue",
        Size = UDim2.new(0, 51, 0, 22),
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        BorderSizePixel = 0,
        TextSize = 12,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        ZIndex = 3,
        Parent = sliderContainer
    })
    sliderBG.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local connection
            connection = RenderStepped:Connect(function()
                local pos = math.clamp(Mouse.X - sliderBG.AbsolutePosition.X, 0, sliderBG.AbsoluteSize.X)
                sliderFill.Size = UDim2.new(pos / sliderBG.AbsoluteSize.X, 0, 1, 0)
                sliderValue.Text = tostring(math.floor(pos / sliderBG.AbsoluteSize.X * 100))
                if not InputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                    connection:Disconnect()
                end
            end)
        end
    end)
    return sliderContainer
end

function SectionFunctions:AddDropdown(index, info)
    local dropdownContainer = Library:CreateInstance("Frame", {
        Name = "Dropdown_" .. tostring(index),
        Size = UDim2.new(0, 265, 0, 30),
        BackgroundTransparency = 1,
        ZIndex = 3,
        Parent = self.Parent
    })
    local mainDropdownFrame = Library:CreateInstance("Frame", {
        Name = "MainDropdownFrame",
        Position = UDim2.new(0, 0, 0, 0),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Size = UDim2.new(0, 265, 0, 30),
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(42, 42, 42),
        ZIndex = 3,
        Parent = dropdownContainer
    })
    local dropdownOpener = Library:CreateInstance("TextButton", {
        RichText = true,
        TextColor3 = Color3.fromRGB(165, 165, 165),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Text = "Selected: <font color=\"rgb(255,255,255)\">" .. tostring(info.Default or info.Options[1]) .. "</font>",
        Name = "DropdownOpener",
        AutoButtonColor = false,
        Size = UDim2.new(0, 250, 0, 30),
        Position = UDim2.new(0.5, -125, 0.5, -15),
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        BorderSizePixel = 0,
        FontFace = Font.new("rbxasset://fonts/families/Zekton.json", 
            Enum.FontWeight.Regular, Enum.FontStyle.Normal),
        TextSize = 14,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        ZIndex = 5,
        Parent = mainDropdownFrame
    })
    dropdownOpener.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            if Library.OpenDropdown and Library.OpenDropdown ~= dropdownContainer then
                Library.OpenDropdown.Visible = false
            end
            local newVisibility = not mainDropdownFrame.DropdownOptions.Visible
            mainDropdownFrame.DropdownOptions.Visible = newVisibility
            Library.OpenDropdown = newVisibility and dropdownContainer or nil
            if newVisibility then
                mainDropdownFrame.ZIndex = 1000
            else
                mainDropdownFrame.ZIndex = 3
            end
        end
    end)
    local dropdownOptions = Library:CreateInstance("Frame", {
        Name = "DropdownOptions",
        Visible = false,
        Size = UDim2.new(0, 265, 0, 30),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = Color3.fromRGB(42, 42, 42),
        ZIndex = 4,
        Parent = mainDropdownFrame
    })
    local dropdownList = Library:CreateInstance("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = dropdownOptions
    })
    for i, option in ipairs(info.Options) do
        local optionButton = Library:CreateInstance("TextButton", {
            FontFace = Font.new("rbxasset://fonts/families/Zekton.json", 
                Enum.FontWeight.Regular, Enum.FontStyle.Normal),
            TextColor3 = (tostring(info.Default or "") == tostring(option))
                and Color3.fromRGB(227, 139, 81) or Color3.fromRGB(255, 255, 255),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Text = tostring(option),
            AutoButtonColor = false,
            Name = "Option" .. i,
            Size = UDim2.new(0, 265, 0, 30),
            BorderSizePixel = 0,
            TextSize = 13,
            BackgroundColor3 = (i % 2 == 0)
                and Color3.fromRGB(42, 42, 42) or Color3.fromRGB(46, 46, 46),
            ZIndex = 4,
            Parent = dropdownOptions
        })
        optionButton.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dropdownOpener.Text = "Selected: <font color=\"rgb(255,255,255)\">" .. tostring(option) .. "</font>"
                mainDropdownFrame.DropdownOptions.Visible = false
                Library.OpenDropdown = nil
                mainDropdownFrame.ZIndex = 3
            end
        end)
    end
    return dropdownContainer
end

function SectionFunctions:AddToggle(index, info)
    local toggleContainer = Library:CreateInstance("Frame", {
        Name = "Toggle_" .. tostring(index),
        Size = UDim2.new(0, 260, 0, 17),
        BackgroundTransparency = 1,
        ZIndex = 3,
        Parent = self.Parent
    })
    local toggleButton = Library:CreateInstance("TextButton", {
        FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", 
            Enum.FontWeight.Regular, Enum.FontStyle.Normal),
        TextColor3 = Color3.fromRGB(0, 0, 0),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Text = "",
        AutoButtonColor = false,
        Name = "ToggleButton",
        Size = UDim2.new(0, 10, 0, 10),
        BorderSizePixel = 0,
        TextSize = 14,
        BackgroundColor3 = Color3.fromRGB(13, 13, 13),
        ZIndex = 3,
        Parent = toggleContainer
    })
    Library:CreateInstance("UIStroke", {
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        LineJoinMode = Enum.LineJoinMode.Miter,
        Thickness = 2,
        ZIndex = 4,
        Parent = toggleButton
    })
    local toggleLabel = Library:CreateInstance("TextLabel", {
        FontFace = Font.new("rbxasset://fonts/families/Zekton.json", 
            Enum.FontWeight.Regular, Enum.FontStyle.Normal),
        TextColor3 = Color3.fromRGB(255, 255, 255),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Text = info.Name or "Toggle",
        TextStrokeTransparency = 0,
        Name = "ToggleLabel",
        Size = UDim2.new(0, 185, 0, 15),
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        BorderSizePixel = 2,
        TextSize = 13,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        ZIndex = 3,
        Parent = toggleContainer
    })
    toggleButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local newState = not (toggleButton.Selected or false)
            toggleButton.Selected = newState
            if info.Callback then
                info.Callback(newState)
            end
            toggleLabel.TextColor3 = newState and Color3.fromRGB(227, 139, 81) or Color3.fromRGB(255, 255, 255)
        end
    end)
    return toggleContainer
end

function SectionFunctions:AddButton(index, info)
    local button = Library:CreateInstance("TextButton", {
        Name = "Button_" .. tostring(index),
        Size = UDim2.new(0, 260, 0, 17),
        Text = info.Name or "Button",
        FontFace = Font.new("rbxasset://fonts/families/Zekton.json", 
            Enum.FontWeight.Regular, Enum.FontStyle.Normal),
        TextColor3 = Color3.fromRGB(255, 255, 255),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        TextStrokeTransparency = 0,
        AutoButtonColor = false,
        TextSize = 13,
        BackgroundColor3 = Color3.fromRGB(46, 46, 46),
        ZIndex = 3,
        Parent = self.Parent
    })
    button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            if info.Callback then
                info.Callback()
            end
        end
    end)
    return button
end

UI.__index = SectionFunctions
getgenv().UI = UI
getgenv().Library = Library
while true do
    RenderStepped:Wait()
end

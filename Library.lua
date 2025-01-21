local Library = {
    Name = 'LinoriaLibrary',
    Version = '1.0.0',
    Toggles = {},
    Options = {},
}

local RunService       = game:GetService('RunService')
local UserInputService = game:GetService('UserInputService')
local TweenService     = game:GetService('TweenService')

local Theme = {
    BackgroundColor = Color3.fromRGB(25, 25, 25),
    MainColor       = Color3.fromRGB(45, 45, 45),
    AccentColor     = Color3.fromRGB(0, 85, 255),
    OutlineColor    = Color3.fromRGB(50, 50, 50),
    TextColor       = Color3.fromRGB(255, 255, 255),
    BorderColor     = Color3.fromRGB(60, 60, 60)
}

local Utility = {
    Create = function(instanceType, properties)
        local instance = Instance.new(instanceType)
        for property, value in next, properties do
            instance[property] = value
        end
        return instance
    end
}

function Library:CreateWindow(options)
    options = options or {}
    local WindowName = options.Name or 'Linoria Library'
    
    local Window = Utility.Create('ScreenGui', {
        Name = 'Window',
        Parent = game.CoreGui
    })

    local Border = Utility.Create('Frame', {
        Name = 'Border',
        Parent = Window,
        BackgroundColor3 = Theme.BorderColor,
        Position = UDim2.new(0.5, -301, 0.5, -251),
        Size = UDim2.new(0, 602, 0, 502)
    })

    local Main = Utility.Create('Frame', {
        Name = 'Main',
        Parent = Border,
        BackgroundColor3 = Theme.BackgroundColor,
        BorderColor3 = Theme.OutlineColor,
        BorderSizePixel = 1,
        Position = UDim2.new(0, 1, 0, 1),
        Size = UDim2.new(1, -2, 1, -2)
    })

    local TitleBar = Utility.Create('Frame', {
        Name = 'TitleBar',
        Parent = Main,
        BackgroundColor3 = Theme.MainColor,
        BorderColor3 = Theme.OutlineColor,
        BorderSizePixel = 1,
        Size = UDim2.new(1, 0, 0, 30)
    })

    local TitleText = Utility.Create('TextLabel', {
        Name = 'Title',
        Parent = TitleBar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 0),
        Size = UDim2.new(1, -20, 1, 0),
        Font = Enum.Font.Gotham,
        Text = WindowName,
        TextColor3 = Theme.TextColor,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local ContentContainer = Utility.Create('Frame', {
        Name = 'ContentContainer',
        Parent = Main,
        BackgroundColor3 = Theme.MainColor,
        BorderColor3 = Theme.OutlineColor,
        BorderSizePixel = 1,
        Position = UDim2.new(0, 0, 0, 30),
        Size = UDim2.new(1, 0, 1, -30)
    })

    local TabContainer = Utility.Create('Frame', {
        Name = 'TabContainer',
        Parent = ContentContainer,
        BackgroundColor3 = Theme.MainColor,
        BorderColor3 = Theme.OutlineColor,
        BorderSizePixel = 1,
        Size = UDim2.new(0, 125, 1, 0)
    })

    local TabList = Utility.Create('ScrollingFrame', {
        Name = 'TabList',
        Parent = TabContainer,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 0
    })

    Utility.Create('UIListLayout', {
        Parent = TabList,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 2)
    })

    local TabContentArea = Utility.Create('Frame', {
        Name = 'TabContentArea',
        Parent = ContentContainer,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 125, 0, 0),
        Size = UDim2.new(1, -125, 1, 0)
    })

    local Dragging, DragStart, StartPosition = false, nil, nil

    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = true
            DragStart = input.Position
            StartPosition = Border.Position
        end
    end)

    TitleBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and Dragging then
            local Delta = input.Position - DragStart
            Border.Position = UDim2.new(
                StartPosition.X.Scale,
                StartPosition.X.Offset + Delta.X,
                StartPosition.Y.Scale,
                StartPosition.Y.Offset + Delta.Y
            )
        end
    end)

    local Window = { 
        Tabs = {},
        ActiveTab = nil,
        CreateTab = Window.CreateTab,
        CreateToggle = Window.CreateToggle,
        CreateSlider = Window.CreateSlider  -- Add this line
    }

    function Window:CreateToggle(tab, groupbox, name, default, callback)
        local Toggle = {
            Value = default or false,
            Callback = callback or function() end
        }

        local ToggleContainer = Utility.Create('Frame', {
            Name = name .. 'Toggle',
            Parent = groupbox,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 25)
        })

        local ToggleButton = Utility.Create('Frame', {
            Name = 'Button',
            Parent = ToggleContainer,
            BackgroundColor3 = Toggle.Value and Theme.AccentColor or Theme.MainColor,
            BorderColor3 = Theme.OutlineColor,
            BorderSizePixel = 1,
            Position = UDim2.new(0, 8, 0, 4),
            Size = UDim2.new(0, 16, 0, 16)
        })

        local ToggleText = Utility.Create('TextLabel', {
            Name = 'Text',
            Parent = ToggleContainer,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 32, 0, 0),
            Size = UDim2.new(1, -40, 1, 0),
            Font = Enum.Font.Gotham,
            Text = name,
            TextColor3 = Theme.TextColor,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left
        })

        ToggleButton.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                Toggle.Value = not Toggle.Value
                ToggleButton.BackgroundColor3 = Toggle.Value and Theme.AccentColor or Theme.MainColor
                Toggle.Callback(Toggle.Value)
            end
        end)

        Library.Toggles[name] = Toggle
        return Toggle
    end

    function Window:CreateTab(name)
        local Tab = {
            Name = name,
            GroupBoxes = {}
        }

        local TabButton = Utility.Create('TextButton', {
            Name = name .. 'Button',
            Parent = TabList,
            BackgroundColor3 = Theme.MainColor,
            BorderColor3 = Theme.OutlineColor,
            BorderSizePixel = 1,
            Size = UDim2.new(1, -4, 0, 30),
            Font = Enum.Font.Gotham,
            Text = name,
            TextColor3 = Theme.TextColor,
            TextSize = 12,
            AutoButtonColor = false
        })

        local TabContent = Utility.Create('Frame', {
            Name = name .. 'Content',
            Parent = TabContentArea,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Visible = false
        })

        local LeftColumn = Utility.Create('Frame', {
            Name = 'LeftColumn',
            Parent = TabContent,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 8, 0, 8),
            Size = UDim2.new(0.5, -12, 1, -16)
        })

        local RightColumn = Utility.Create('Frame', {
            Name = 'RightColumn',
            Parent = TabContent,
            BackgroundTransparency = 1,
            Position = UDim2.new(0.5, 4, 0, 8),
            Size = UDim2.new(0.5, -12, 1, -16)
        })

        TabButton.MouseButton1Click:Connect(function()
            for _, t in pairs(Window.Tabs) do
                t.Content.Visible = false
                t.Button.BackgroundColor3 = Theme.MainColor
            end
            TabContent.Visible = true
            TabButton.BackgroundColor3 = Theme.AccentColor
        end)

        Tab.Button = TabButton
        Tab.Content = TabContent
        Tab.LeftColumn = LeftColumn
        Tab.RightColumn = RightColumn

        table.insert(Window.Tabs, Tab)

        if #Window.Tabs == 1 then
            TabContent.Visible = true
            TabButton.BackgroundColor3 = Theme.AccentColor
        end

        function Window:CreateGroupbox(tab, name, side)
            local Column = side:lower() == 'left' and tab.LeftColumn or tab.RightColumn
    
            local GroupBox = Utility.Create('Frame', {
                Name = name .. 'GroupBox',
                Parent = Column,
                BackgroundColor3 = Theme.MainColor,
                BorderColor3 = Theme.OutlineColor,
                BorderSizePixel = 1,
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y
            })
    
            local Container = Utility.Create('Frame', {
                Name = 'Container',
                Parent = GroupBox,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 8, 0, 8),
                Size = UDim2.new(1, -16, 1, -16),
                AutomaticSize = Enum.AutomaticSize.Y
            })
    
            local UIListLayout = Utility.Create('UIListLayout', {
                Parent = Container,
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 4)
            })
    
            local TitleLabel = Utility.Create('TextLabel', {
                Name = 'Title',
                Parent = GroupBox,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 8, 0, -8),
                Size = UDim2.new(0, 0, 0, 16),
                Font = Enum.Font.Gotham,
                Text = name,
                TextColor3 = Theme.TextColor,
                TextSize = 12,
                AutomaticSize = Enum.AutomaticSize.X
            })
    
            local TitlePadding = Utility.Create('Frame', {
                Name = 'TitlePadding',
                Parent = TitleLabel,
                BackgroundColor3 = Theme.BackgroundColor,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 4, 1, 0),
                ZIndex = -1
            })
    
            return Container
        end

        return Tab
    end

    function Window:CreateSlider(groupbox, name, options)
        options = options or {}
        local Slider = {
            Value = options.default or options.min or 0,
            Min = options.min or 0,
            Max = options.max or 100,
            Decimals = options.decimals or 0,
            ValueName = options.valueName or "",
            Callback = options.callback or function() end
        }
    
        local SliderContainer = Utility.Create('Frame', {
            Name = name .. 'Slider',
            Parent = groupbox,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 32)
        })
    
        local SliderLabel = Utility.Create('TextLabel', {
            Name = 'Label',
            Parent = SliderContainer,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 0, 0, 0),
            Size = UDim2.new(1, 0, 0, 14),
            Font = Enum.Font.Gotham,
            Text = name,
            TextColor3 = Theme.TextColor,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left
        })
    
        local ValueLabel = Utility.Create('TextLabel', {
            Name = 'Value',
            Parent = SliderContainer,
            BackgroundTransparency = 1,
            Position = UDim2.new(1, -50, 0, 0),
            Size = UDim2.new(0, 50, 0, 14),
            Font = Enum.Font.Gotham,
            TextColor3 = Theme.TextColor,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Right
        })
    
        local SliderBack = Utility.Create('Frame', {
            Name = 'Back',
            Parent = SliderContainer,
            BackgroundColor3 = Theme.MainColor,
            BorderColor3 = Theme.OutlineColor,
            BorderSizePixel = 1,
            Position = UDim2.new(0, 0, 0, 20),
            Size = UDim2.new(1, 0, 0, 6)
        })
    
        local SliderFill = Utility.Create('Frame', {
            Name = 'Fill',
            Parent = SliderBack,
            BackgroundColor3 = Theme.AccentColor,
            BorderSizePixel = 0,
            Size = UDim2.new(0, 0, 1, 0)
        })
    
        local function SetValue(value)
            value = math.clamp(value, Slider.Min, Slider.Max)
            if Slider.Decimals > 0 then
                Slider.Value = math.floor(value * 10^Slider.Decimals) / 10^Slider.Decimals
            else
                Slider.Value = math.floor(value)
            end
    
            local percent = (Slider.Value - Slider.Min) / (Slider.Max - Slider.Min)
            SliderFill.Size = UDim2.new(percent, 0, 1, 0)
            ValueLabel.Text = tostring(Slider.Value) .. Slider.ValueName
            Slider.Callback(Slider.Value)
        end
    
        local Dragging = false
    
        SliderBack.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                Dragging = true
                local percentage = math.clamp((input.Position.X - SliderBack.AbsolutePosition.X) / SliderBack.AbsoluteSize.X, 0, 1)
                SetValue(Slider.Min + ((Slider.Max - Slider.Min) * percentage))
            end
        end)
    
        UserInputService.InputChanged:Connect(function(input)
            if Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local percentage = math.clamp((input.Position.X - SliderBack.AbsolutePosition.X) / SliderBack.AbsoluteSize.X, 0, 1)
                SetValue(Slider.Min + ((Slider.Max - Slider.Min) * percentage))
            end
        end)
    
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                Dragging = false
            end
        end)
    
        SetValue(Slider.Value)
        Library.Options[name] = Slider
        return Slider
    end

    return Window
end

return Library

local Library = {
    Name = 'LinoriaLibrary',
    Version = '1.0.0'
}

-- Services
local RunService = game:GetService('RunService')
local UserInputService = game:GetService('UserInputService')
local TweenService = game:GetService('TweenService')

-- Variables
local Toggles = {}
local Options = {}
local Tabs = {}

-- Theme
local Theme = {
    BackgroundColor = Color3.fromRGB(25, 25, 25),
    MainColor = Color3.fromRGB(45, 45, 45),
    AccentColor = Color3.fromRGB(0, 85, 255),
    OutlineColor = Color3.fromRGB(50, 50, 50),
    TextColor = Color3.fromRGB(255, 255, 255)
}

-- Utility Functions
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
    
    -- Main Window
    local Window = Utility.Create('ScreenGui', {
        Name = 'Window',
        Parent = game.CoreGui
    })

    -- Main Container
    local Main = Utility.Create('Frame', {
        Name = 'Main',
        Parent = Window,
        BackgroundColor3 = Theme.BackgroundColor,
        BorderColor3 = Theme.OutlineColor,
        BorderSizePixel = 1,
        Position = UDim2.new(0.5, -300, 0.5, -250),
        Size = UDim2.new(0, 600, 0, 500)
    })

    -- Title Bar
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

    -- Content Container
    local ContentContainer = Utility.Create('Frame', {
        Name = 'ContentContainer',
        Parent = Main,
        BackgroundColor3 = Theme.MainColor,
        BorderColor3 = Theme.OutlineColor,
        BorderSizePixel = 1,
        Position = UDim2.new(0, 0, 0, 30),
        Size = UDim2.new(1, 0, 1, -30)
    })

    -- Tab Container
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
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(1, 0, 1, 0),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 0
    })

    local TabListLayout = Utility.Create('UIListLayout', {
        Parent = TabList,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 2)
    })

    -- Tab Content Area
    local TabContentArea = Utility.Create('Frame', {
        Name = 'TabContentArea',
        Parent = ContentContainer,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 125, 0, 0),
        Size = UDim2.new(1, -125, 1, 0)
    })

    -- Dragging Functionality
    local Dragging = false
    local DragStart = nil
    local StartPosition = nil

    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = true
            DragStart = input.Position
            StartPosition = Main.Position
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
            Main.Position = UDim2.new(
                StartPosition.X.Scale,
                StartPosition.X.Offset + Delta.X,
                StartPosition.Y.Scale,
                StartPosition.Y.Offset + Delta.Y
            )
        end
    end)

    local Window = {
        Tabs = {}
    }

    function Window:CreateTab(name)
        local Tab = {
            Name = name,
            GroupBoxes = {}
        }

        -- Tab Button
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

        -- Tab Content
        local TabContent = Utility.Create('Frame', {
            Name = name .. 'Content',
            Parent = TabContentArea,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Visible = false
        })

        -- Left Column
        local LeftColumn = Utility.Create('Frame', {
            Name = 'LeftColumn',
            Parent = TabContent,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 8, 0, 8),
            Size = UDim2.new(0.5, -12, 1, -16)
        })

        -- Right Column
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

        -- Show first tab by default
        if #Window.Tabs == 1 then
            TabContent.Visible = true
            TabButton.BackgroundColor3 = Theme.AccentColor
        end

        function Tab:CreateGroupBox(name, side)
            side = side or 'left'
            local Column = side:lower() == 'left' and LeftColumn or RightColumn

            local GroupBox = Utility.Create('Frame', {
                Name = name .. 'GroupBox',
                Parent = Column,
                BackgroundColor3 = Theme.MainColor,
                BorderColor3 = Theme.OutlineColor,
                BorderSizePixel = 1,
                Size = UDim2.new(1, 0, 0, 100)
            })

            local GroupBoxTitle = Utility.Create('TextLabel', {
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

            return GroupBox
        end

        return Tab
    end

    return Window
end

return Library

local Library = {
    Registry = {},
    Tabs = {},
    SelectedTab = nil,
    DragStartPosition = nil,
    GuiPosition = nil,
    Dragging = false
}

-- Utility Functions
local function Create(className, properties)
    local instance = Instance.new(className)
    for property, value in pairs(properties or {}) do
        instance[property] = value
    end
    return instance
end

local function MakeDraggable(gui, handle)
    local UserInputService = game:GetService("UserInputService")
    local RunService = game:GetService("RunService")
    
    local dragStart
    local startPos
    local dragging = false
    
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = gui.Position
        end
    end)
    
    handle.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            local delta = input.Position - dragStart
            gui.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- Initialize Main UI
function Library:Init(title)
    if self.ScreenGui then
        self:Destroy()
    end

    self.ScreenGui = Create("ScreenGui", {
        Name = "UILibrary",
        Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui"),
        ResetOnSpawn = false
    })

    -- Main Container
    self.Main = Create("Frame", {
        Name = "Main",
        Parent = self.ScreenGui,
        BackgroundColor3 = Color3.fromRGB(56, 56, 56),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 5,
        Position = UDim2.new(0.2, 0, 0.2, 0),
        Size = UDim2.new(0, 600, 0, 450)
    })

    -- Title Bar (Draggable Handle)
    self.TitleBar = Create("Frame", {
        Name = "TitleBar",
        Parent = self.Main,
        BackgroundColor3 = Color3.fromRGB(57, 57, 57),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 2,
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(1, 0, 0, 30)
    })

    self.TitleText = Create("TextLabel", {
        Name = "Title",
        Parent = self.TitleBar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 0),
        Size = UDim2.new(1, -20, 1, 0),
        Font = Enum.Font.SourceSansBold,
        Text = title or "Library",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    -- Make UI draggable from title bar
    MakeDraggable(self.Main, self.TitleBar)

    -- Main Content Container
    self.ContentContainer = Create("Frame", {
        Name = "ContentContainer",
        Parent = self.Main,
        BackgroundColor3 = Color3.fromRGB(72, 72, 72),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Position = UDim2.new(0, 10, 0, 40),
        Size = UDim2.new(1, -20, 1, -80)
    })

    -- Tab Container (Left Side)
    self.TabContainer = Create("Frame", {
        Name = "TabContainer",
        Parent = self.ContentContainer,
        BackgroundColor3 = Color3.fromRGB(84, 84, 84),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(0.2, 0, 1, 0)
    })

    -- Tab Content Container (Right Side)
    self.TabContentContainer = Create("Frame", {
        Name = "TabContentContainer",
        Parent = self.ContentContainer,
        BackgroundColor3 = Color3.fromRGB(84, 84, 84),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Position = UDim2.new(0.2, 10, 0, 0),
        Size = UDim2.new(0.8, -10, 1, 0)
    })

    -- Create tab list layout
    self.TabList = Create("UIListLayout", {
        Parent = self.TabContainer,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 2)
    })

    return self
end

function Library:CreateTab(name)
    local tab = {
        Name = name,
        Groupboxes = {},
        Sections = {}
    }

    -- Create tab button (Linoria style)
    tab.TabButton = Create("TextButton", {
        Name = name .. "Button",
        Parent = self.TabContainer,
        BackgroundColor3 = Color3.fromRGB(91, 91, 91),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Size = UDim2.new(1, 0, 0, 30),
        Text = name,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.SourceSans,
        TextSize = 14,
        AutoButtonColor = false
    })

    -- Create tab content container
    tab.Container = Create("ScrollingFrame", {
        Name = name .. "Container",
        Parent = self.TabContentContainer,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Visible = false,
        ScrollBarThickness = 4,
        ScrollingDirection = Enum.ScrollingDirection.Y,
        CanvasSize = UDim2.new(0, 0, 2, 0)
    })

    -- Column containers
    tab.LeftColumn = Create("Frame", {
        Name = "LeftColumn",
        Parent = tab.Container,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(0.5, -5, 1, 0)
    })

    tab.RightColumn = Create("Frame", {
        Name = "RightColumn",
        Parent = tab.Container,
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 5, 0, 0),
        Size = UDim2.new(0.5, -5, 1, 0)
    })

    -- Tab button click handler
    tab.TabButton.MouseButton1Click:Connect(function()
        self:SelectTab(name)
    end)

    -- Add to registry
    self.Registry[name] = tab
    table.insert(self.Tabs, tab)

    -- Select first tab by default
    if #self.Tabs == 1 then
        self:SelectTab(name)
    end

    -- Create layouts for columns
    Create("UIListLayout", {
        Parent = tab.LeftColumn,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 5)
    })

    Create("UIListLayout", {
        Parent = tab.RightColumn,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 5)
    })

    return tab
end

function Library:SelectTab(name)
    local tab = self.Registry[name]
    if not tab then return end

    -- Hide all tabs
    for _, otherTab in pairs(self.Registry) do
        if otherTab.Container then
            otherTab.Container.Visible = false
        end
        if otherTab.TabButton then
            otherTab.TabButton.BackgroundColor3 = Color3.fromRGB(91, 91, 91)
            otherTab.TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        end
    end

    -- Show selected tab
    tab.Container.Visible = true
    tab.TabButton.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
    tab.TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    self.SelectedTab = tab
end

function Library:CreateGroupbox(tab, name, side)
    if not self.Registry[tab] then return end
    
    local parent = side == "Left" and self.Registry[tab].LeftColumn or self.Registry[tab].RightColumn
    
    local groupbox = {
        Elements = {}
    }
    
    groupbox.Container = Create("Frame", {
        Name = name .. "Groupbox",
        Parent = parent,
        BackgroundColor3 = Color3.fromRGB(72, 72, 72),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Size = UDim2.new(1, 0, 0, 100)
    })

    groupbox.Title = Create("TextLabel", {
        Name = "Title",
        Parent = groupbox.Container,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 5, 0, -10),
        Size = UDim2.new(1, -10, 0, 20),
        Font = Enum.Font.SourceSansBold,
        Text = name,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    return groupbox
end

function Library:Destroy()
    if self.ScreenGui then
        self.ScreenGui:Destroy()
    end
    
    self.Registry = {}
    self.Tabs = {}
    self.SelectedTab = nil
end

return Library

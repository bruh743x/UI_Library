local Library = {
    Registry = {},
    Tabs = {},
    SelectedTab = nil
}

-- Utility Functions
local function Create(className, properties)
    local instance = Instance.new(className)
    for property, value in pairs(properties or {}) do
        instance[property] = value
    end
    return instance
end

-- Initialize Main UI
function Library:Init(title)
    if self.ScreenGui then
        self:Destroy()
    end

    self.ScreenGui = Create("ScreenGui", {
        Name = "UILibrary",
        Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
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

    -- Container for tab content
    self.TabContainer = Create("Frame", {
        Name = "TabContainer",
        Parent = self.Main,
        BackgroundColor3 = Color3.fromRGB(84, 84, 84),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Position = UDim2.new(0.01, 0, 0.1, 0),
        Size = UDim2.new(0.98, 0, 0.8, 0)
    })

    -- Tab Button Container
    self.TabButtons = Create("Frame", {
        Name = "TabButtons",
        Parent = self.Main,
        BackgroundColor3 = Color3.fromRGB(84, 84, 84),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Position = UDim2.new(0.01, 0, 0.92, 0),
        Size = UDim2.new(0.98, 0, 0.06, 0)
    })

    return self
end

function Library:CreateTab(name)
    local tab = {
        Name = name,
        Groupboxes = {},
        Sections = {}
    }

    -- Create tab button
    local buttonWidth = 0.3
    local buttonCount = #self.Registry
    local xPosition = 0.05 + (buttonWidth + 0.02) * buttonCount

    tab.TabButton = Create("TextButton", {
        Name = name .. "Button",
        Parent = self.TabButtons,
        BackgroundColor3 = Color3.fromRGB(91, 91, 91),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Position = UDim2.new(xPosition, 0, 0, 0),
        Size = UDim2.new(buttonWidth, 0, 1, 0),
        Text = name,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.SourceSans,
        TextSize = 14
    })

    -- Create tab content container
    tab.Container = Create("Frame", {
        Name = name .. "Container",
        Parent = self.TabContainer,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Visible = false
    })

    -- Left and Right containers for groupboxes
    tab.LeftGroupbox = Create("Frame", {
        Name = "LeftGroupbox",
        Parent = tab.Container,
        BackgroundColor3 = Color3.fromRGB(84, 84, 84),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Position = UDim2.new(0.01, 0, 0.01, 0),
        Size = UDim2.new(0.48, 0, 0.98, 0)
    })

    tab.RightGroupbox = Create("Frame", {
        Name = "RightGroupbox",
        Parent = tab.Container,
        BackgroundColor3 = Color3.fromRGB(84, 84, 84),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Position = UDim2.new(0.51, 0, 0.01, 0),
        Size = UDim2.new(0.48, 0, 0.98, 0)
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
        end
    end

    -- Show selected tab
    tab.Container.Visible = true
    tab.TabButton.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
    self.SelectedTab = tab
end

function Library:CreateGroupbox(tab, name, side)
    if not self.Registry[tab] then return end
    
    local parent = side == "Left" and self.Registry[tab].LeftGroupbox or self.Registry[tab].RightGroupbox
    
    local groupbox = {
        Elements = {}
    }
    
    groupbox.Container = Create("Frame", {
        Name = name .. "Groupbox",
        Parent = parent,
        BackgroundColor3 = Color3.fromRGB(72, 72, 72),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Position = UDim2.new(0.05, 0, 0.02 + (#parent:GetChildren() * 0.1), 0),
        Size = UDim2.new(0.9, 0, 0.2, 0)
    })

    groupbox.Title = Create("TextLabel", {
        Name = "Title",
        Parent = groupbox.Container,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 5, 0, -10),
        Size = UDim2.new(0, 200, 0, 20),
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

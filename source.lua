--!strict
--[[
    Windows 11 "Settings" Fluent Mica UI Library
    Engineered for loadstring / GitHub hosting.
]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

-- Visual Palette & Mica Token Definitions
local Theme = {
    MicaBg = Color3.fromRGB(26, 26, 26),
    SidebarBg = Color3.fromRGB(32, 32, 32),
    CardBg = Color3.fromRGB(43, 43, 43),
    CardHover = Color3.fromRGB(48, 48, 48),
    CardSubtle = Color3.fromRGB(36, 36, 36),
    StrokeColor = Color3.fromRGB(255, 255, 255),
    StrokeTransparency = 0.92,
    Accent = Color3.fromRGB(96, 205, 255),
    AccentDark = Color3.fromRGB(0, 103, 192),
    TextPrimary = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(160, 160, 160),
    TextDisabled = Color3.fromRGB(110, 110, 110),
    ToggleOff = Color3.fromRGB(60, 60, 60),
    CloseHover = Color3.fromRGB(196, 43, 28),
    ControlBoxHover = Color3.fromRGB(45, 45, 45),
    CornerRadius = UDim.new(0, 8),
    ControlCorner = UDim.new(0, 4),
    FontFamily = Enum.Font.Gotham,
}

local Win11Lib = {}
Win11Lib.__index = Win11Lib

local function Tween(instance: Instance, duration: number, properties: { [string]: any })
    local tweenInfo = TweenInfo.new(duration or 0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local anim = TweenService:Create(instance, tweenInfo, properties)
    anim:Play()
    return anim
end

local function GetGuiContainer(): Instance
    local success, coreGui = pcall(function()
        return game:GetService("CoreGui")
    end)
    if success and coreGui then
        return coreGui
    end
    return LocalPlayer:WaitForChild("PlayerGui")
end

function Win11Lib.CreateWindow(config: { Title: string?, Subtitle: string?, Accent: Color3? })
    config = config or {}
    local currentAccent = config.Accent or Theme.Accent

    local Window = {
        _connections = {} :: { [number]: RBXScriptConnection },
        _tabs = {} :: { [string]: any },
        _activeTab = nil :: any,
        _isMinimized = false,
        _searchQuery = "",
    }

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "Win11Settings_" .. (config.Title or "Hub")
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = GetGuiContainer()

    local Shell = Instance.new("Frame")
    Shell.Name = "Shell"
    Shell.Size = UDim2.new(0, 860, 0, 560)
    Shell.Position = UDim2.new(0.5, -430, 0.5, -280)
    Shell.BackgroundColor3 = Theme.MicaBg
    Shell.BorderSizePixel = 0
    Shell.ClipsDescendants = false
    Shell.Parent = ScreenGui

    local ShellCorner = Instance.new("UICorner")
    ShellCorner.CornerRadius = Theme.CornerRadius
    ShellCorner.Parent = Shell

    local ShellStroke = Instance.new("UIStroke")
    ShellStroke.Color = Theme.StrokeColor
    ShellStroke.Transparency = Theme.StrokeTransparency
    ShellStroke.Thickness = 1
    ShellStroke.Parent = Shell

    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "Shadow"
    Shadow.BackgroundTransparency = 1
    Shadow.Position = UDim2.new(0, -15, 0, -15)
    Shadow.Size = UDim2.new(1, 30, 1, 30)
    Shadow.Image = "rbxassetid://1316045217"
    Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.ImageTransparency = 0.55
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    Shadow.ZIndex = 0
    Shadow.Parent = Shell

    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 40)
    TitleBar.BackgroundTransparency = 1
    TitleBar.Parent = Shell

    local AppIcon = Instance.new("ImageLabel")
    AppIcon.Size = UDim2.new(0, 18, 0, 18)
    AppIcon.Position = UDim2.new(0, 14, 0.5, -9)
    AppIcon.BackgroundTransparency = 1
    AppIcon.Image = "rbxassetid://7734053426"
    AppIcon.ImageColor3 = currentAccent
    AppIcon.Parent = TitleBar

    local AppLabel = Instance.new("TextLabel")
    AppLabel.Size = UDim2.new(0, 200, 1, 0)
    AppLabel.Position = UDim2.new(0, 40, 0, 0)
    AppLabel.BackgroundTransparency = 1
    AppLabel.Font = Theme.FontFamily
    AppLabel.TextSize = 13
    AppLabel.Text = config.Title or "Settings"
    AppLabel.TextColor3 = Theme.TextPrimary
    AppLabel.TextXAlignment = Enum.TextXAlignment.Left
    AppLabel.Parent = TitleBar

    local ControlBox = Instance.new("Frame")
    ControlBox.Name = "ControlBox"
    ControlBox.Size = UDim2.new(0, 138, 1, 0)
    ControlBox.Position = UDim2.new(1, -138, 0, 0)
    ControlBox.BackgroundTransparency = 1
    ControlBox.Parent = TitleBar

    local function CreateControlButton(name: string, pos: number, text: string)
        local btn = Instance.new("TextButton")
        btn.Name = name
        btn.Size = UDim2.new(0, 46, 1, 0)
        btn.Position = UDim2.new(0, pos, 0, 0)
        btn.BackgroundTransparency = 1
        btn.BackgroundColor3 = Theme.ControlBoxHover
        btn.Font = Enum.Font.GothamMedium
        btn.TextSize = 11
        btn.TextColor3 = Theme.TextSecondary
        btn.Text = text
        btn.BorderSizePixel = 0
        btn.Parent = ControlBox

        btn.MouseEnter:Connect(function()
            if name == "Close" then
                btn.BackgroundColor3 = Theme.CloseHover
                btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            else
                btn.BackgroundColor3 = Theme.ControlBoxHover
                btn.TextColor3 = Theme.TextPrimary
            end
            btn.BackgroundTransparency = 0
        end)
        btn.MouseLeave:Connect(function()
            btn.BackgroundTransparency = 1
            btn.TextColor3 = Theme.TextSecondary
        end)

        return btn
    end

    local MinBtn = CreateControlButton("Min", 0, "—")
    local _MaxBtn = CreateControlButton("Max", 46, "□")
    local CloseBtn = CreateControlButton("Close", 92, "✕")

    local isDragging = false
    local dragStart = Vector2.zero
    local frameStart = UDim2.new()

    table.insert(Window._connections, TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
            dragStart = Vector2.new(input.Position.X, input.Position.Y)
            frameStart = Shell.Position

            local endConn: RBXScriptConnection
            endConn = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    isDragging = false
                    endConn:Disconnect()
                end
            end)
        end
    end))

    table.insert(Window._connections, UserInputService.InputChanged:Connect(function(input)
        if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = Vector2.new(input.Position.X, input.Position.Y) - dragStart
            Shell.Position = UDim2.new(
                frameStart.X.Scale,
                frameStart.X.Offset + delta.X,
                frameStart.Y.Scale,
                frameStart.Y.Offset + delta.Y
            )
        end
    end))

    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 240, 1, -40)
    Sidebar.Position = UDim2.new(0, 0, 0, 40)
    Sidebar.BackgroundColor3 = Theme.SidebarBg
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = Shell

    local SidebarCorner = Instance.new("UICorner")
    SidebarCorner.CornerRadius = Theme.CornerRadius
    SidebarCorner.Parent = Sidebar

    local SidebarPatch = Instance.new("Frame")
    SidebarPatch.Size = UDim2.new(0, 10, 1, 0)
    SidebarPatch.Position = UDim2.new(1, -10, 0, 0)
    SidebarPatch.BackgroundColor3 = Theme.SidebarBg
    SidebarPatch.BorderSizePixel = 0
    SidebarPatch.Parent = Sidebar

    local SidebarTopPatch = Instance.new("Frame")
    SidebarTopPatch.Size = UDim2.new(1, 0, 0, 10)
    SidebarTopPatch.BackgroundColor3 = Theme.SidebarBg
    SidebarTopPatch.BorderSizePixel = 0
    SidebarTopPatch.Parent = Sidebar

    local ProfileBlock = Instance.new("Frame")
    ProfileBlock.Name = "ProfileBlock"
    ProfileBlock.Size = UDim2.new(1, -24, 0, 52)
    ProfileBlock.Position = UDim2.new(0, 12, 0, 6)
    ProfileBlock.BackgroundTransparency = 1
    ProfileBlock.Parent = Sidebar

    local Avatar = Instance.new("ImageLabel")
    Avatar.Name = "Avatar"
    Avatar.Size = UDim2.new(0, 36, 0, 36)
    Avatar.Position = UDim2.new(0, 2, 0.5, -18)
    Avatar.BackgroundColor3 = Theme.CardBg
    Avatar.Image = Players:GetUserThumbnailAsync(
        LocalPlayer.UserId,
        Enum.ThumbnailType.HeadShot,
        Enum.ThumbnailSize.Size48x48
    ) or ""
    Avatar.Parent = ProfileBlock

    local AvatarCorner = Instance.new("UICorner")
    AvatarCorner.CornerRadius = UDim.new(1, 0)
    AvatarCorner.Parent = Avatar

    local NameLabel = Instance.new("TextLabel")
    NameLabel.Size = UDim2.new(1, -48, 0, 18)
    NameLabel.Position = UDim2.new(0, 48, 0, 8)
    NameLabel.BackgroundTransparency = 1
    NameLabel.Font = Enum.Font.GothamMedium
    NameLabel.TextSize = 13
    NameLabel.Text = LocalPlayer.DisplayName
    NameLabel.TextColor3 = Theme.TextPrimary
    NameLabel.TextXAlignment = Enum.TextXAlignment.Left
    NameLabel.TextTruncate = Enum.TextTruncate.AtEnd
    NameLabel.Parent = ProfileBlock

    local SubLabel = Instance.new("TextLabel")
    SubLabel.Size = UDim2.new(1, -48, 0, 14)
    SubLabel.Position = UDim2.new(0, 48, 0, 26)
    SubLabel.BackgroundTransparency = 1
    SubLabel.Font = Theme.FontFamily
    SubLabel.TextSize = 11
    SubLabel.Text = config.Subtitle or ("@" .. LocalPlayer.Name)
    SubLabel.TextColor3 = Theme.TextSecondary
    SubLabel.TextXAlignment = Enum.TextXAlignment.Left
    SubLabel.Parent = ProfileBlock

    local SearchBoxContainer = Instance.new("Frame")
    SearchBoxContainer.Name = "SearchBoxContainer"
    SearchBoxContainer.Size = UDim2.new(1, -24, 0, 32)
    SearchBoxContainer.Position = UDim2.new(0, 12, 0, 62)
    SearchBoxContainer.BackgroundColor3 = Theme.CardBg
    SearchBoxContainer.BorderSizePixel = 0
    SearchBoxContainer.Parent = Sidebar

    local SearchBoxCorner = Instance.new("UICorner")
    SearchBoxCorner.CornerRadius = Theme.ControlCorner
    SearchBoxCorner.Parent = SearchBoxContainer

    local SearchBoxStroke = Instance.new("UIStroke")
    SearchBoxStroke.Color = Theme.StrokeColor
    SearchBoxStroke.Transparency = Theme.StrokeTransparency
    SearchBoxStroke.Thickness = 1
    SearchBoxStroke.Parent = SearchBoxContainer

    local SearchIcon = Instance.new("ImageLabel")
    SearchIcon.Size = UDim2.new(0, 14, 0, 14)
    SearchIcon.Position = UDim2.new(0, 9, 0.5, -7)
    SearchIcon.BackgroundTransparency = 1
    SearchIcon.Image = "rbxassetid://6031154871"
    SearchIcon.ImageColor3 = Theme.TextSecondary
    SearchIcon.Parent = SearchBoxContainer

    local SearchInput = Instance.new("TextBox")
    SearchInput.Size = UDim2.new(1, -30, 1, 0)
    SearchInput.Position = UDim2.new(0, 28, 0, 0)
    SearchInput.BackgroundTransparency = 1
    SearchInput.Font = Theme.FontFamily
    SearchInput.TextSize = 12
    SearchInput.PlaceholderText = "Find a setting"
    SearchInput.PlaceholderColor3 = Theme.TextSecondary
    SearchInput.Text = ""
    SearchInput.TextColor3 = Theme.TextPrimary
    SearchInput.ClearTextOnFocus = false
    SearchInput.TextXAlignment = Enum.TextXAlignment.Left
    SearchInput.Parent = SearchBoxContainer

    local NavScroll = Instance.new("ScrollingFrame")
    NavScroll.Name = "NavScroll"
    NavScroll.Size = UDim2.new(1, -12, 1, -106)
    NavScroll.Position = UDim2.new(0, 6, 0, 102)
    NavScroll.BackgroundTransparency = 1
    NavScroll.BorderSizePixel = 0
    NavScroll.ScrollBarThickness = 2
    NavScroll.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
    NavScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    NavScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    NavScroll.Parent = Sidebar

    local NavLayout = Instance.new("UIListLayout")
    NavLayout.Padding = UDim.new(0, 3)
    NavLayout.SortOrder = Enum.SortOrder.LayoutOrder
    NavLayout.Parent = NavScroll

    local ContentPanel = Instance.new("Frame")
    ContentPanel.Name = "ContentPanel"
    ContentPanel.Size = UDim2.new(1, -240, 1, -40)
    ContentPanel.Position = UDim2.new(0, 240, 0, 40)
    ContentPanel.BackgroundTransparency = 1
    ContentPanel.Parent = Shell

    local HeaderFrame = Instance.new("Frame")
    HeaderFrame.Name = "HeaderFrame"
    HeaderFrame.Size = UDim2.new(1, -48, 0, 60)
    HeaderFrame.Position = UDim2.new(0, 24, 0, 8)
    HeaderFrame.BackgroundTransparency = 1
    HeaderFrame.Parent = ContentPanel

    local Breadcrumb = Instance.new("TextLabel")
    Breadcrumb.Size = UDim2.new(1, 0, 0, 16)
    Breadcrumb.BackgroundTransparency = 1
    Breadcrumb.Font = Theme.FontFamily
    Breadcrumb.TextSize = 11
    Breadcrumb.Text = "Home"
    Breadcrumb.TextColor3 = Theme.TextSecondary
    Breadcrumb.TextXAlignment = Enum.TextXAlignment.Left
    Breadcrumb.Parent = HeaderFrame

    local SectionTitle = Instance.new("TextLabel")
    SectionTitle.Size = UDim2.new(1, 0, 0, 32)
    SectionTitle.Position = UDim2.new(0, 0, 0, 18)
    SectionTitle.BackgroundTransparency = 1
    SectionTitle.Font = Enum.Font.GothamBold
    SectionTitle.TextSize = 22
    SectionTitle.Text = "System"
    SectionTitle.TextColor3 = Theme.TextPrimary
    SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
    SectionTitle.Parent = HeaderFrame

    local PagesContainer = Instance.new("Frame")
    PagesContainer.Name = "PagesContainer"
    PagesContainer.Size = UDim2.new(1, -48, 1, -80)
    PagesContainer.Position = UDim2.new(0, 24, 0, 72)
    PagesContainer.BackgroundTransparency = 1
    PagesContainer.Parent = ContentPanel

    local fullHeight = Shell.Size.Y.Offset
    MinBtn.MouseButton1Click:Connect(function()
        Window._isMinimized = not Window._isMinimized
        if Window._isMinimized then
            Tween(Shell, 0.22, { Size = UDim2.new(Shell.Size.X.Scale, Shell.Size.X.Offset, 0, 40) })
            Sidebar.Visible = false
            ContentPanel.Visible = false
        else
            Tween(Shell, 0.22, { Size = UDim2.new(Shell.Size.X.Scale, Shell.Size.X.Offset, 0, fullHeight) })
            task.delay(0.12, function()
                Sidebar.Visible = true
                ContentPanel.Visible = true
            end)
        end
    end)

    CloseBtn.MouseButton1Click:Connect(function()
        Window:Destroy()
    end)

    SearchInput:GetPropertyChangedSignal("Text"):Connect(function()
        local query = SearchInput.Text:lower()
        Window._searchQuery = query

        for _, tab in pairs(Window._tabs) do
            local tabMatches = (query == "") or tab.Name:lower():find(query) ~= nil
            local anyChildMatches = false

            for _, card in ipairs(tab.Cards) do
                local title = card.TitleText:lower()
                local desc = card.DescText:lower()
                if query == "" or title:find(query) or desc:find(query) then
                    card.Instance.Visible = true
                    anyChildMatches = true
                else
                    card.Instance.Visible = false
                end
            end

            tab.NavButton.Visible = (query == "") or tabMatches or anyChildMatches
        end
    end)

    function Window:Destroy()
        for _, conn in ipairs(self._connections) do
            if conn.Connected then
                conn:Disconnect()
            end
        end
        ScreenGui:Destroy()
    end

    function Window:CreateTab(tabName: string, iconAsset: string?)
        local Tab = {
            Name = tabName,
            Cards = {} :: { [number]: { Instance: GuiObject, TitleText: string, DescText: string } },
            PageFrame = nil :: ScrollingFrame?,
            NavButton = nil :: TextButton?,
        }

        local Page = Instance.new("ScrollingFrame")
        Page.Name = tabName .. "_Page"
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.BorderSizePixel = 0
        Page.ScrollBarThickness = 3
        Page.ScrollBarImageColor3 = Color3.fromRGB(90, 90, 90)
        Page.CanvasSize = UDim2.new(0, 0, 0, 0)
        Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        Page.Visible = false
        Page.Parent = PagesContainer

        local PageLayout = Instance.new("UIListLayout")
        PageLayout.Padding = UDim.new(0, 5)
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        PageLayout.Parent = Page

        local PagePadding = Instance.new("UIPadding")
        PagePadding.PaddingRight = UDim.new(0, 8)
        PagePadding.PaddingBottom = UDim.new(0, 16)
        PagePadding.Parent = Page

        Tab.PageFrame = Page

        local NavBtn = Instance.new("TextButton")
        NavBtn.Name = tabName .. "_Nav"
        NavBtn.Size = UDim2.new(1, 0, 0, 36)
        NavBtn.BackgroundTransparency = 1
        NavBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        NavBtn.AutoButtonColor = false
        NavBtn.Text = ""
        NavBtn.Parent = NavScroll

        local NavBtnCorner = Instance.new("UICorner")
        NavBtnCorner.CornerRadius = Theme.ControlCorner
        NavBtnCorner.Parent = NavBtn

        local AccentPill = Instance.new("Frame")
        AccentPill.Name = "AccentPill"
        AccentPill.Size = UDim2.new(0, 3, 0, 16)
        AccentPill.Position = UDim2.new(0, 0, 0.5, -8)
        AccentPill.BackgroundColor3 = currentAccent
        AccentPill.BorderSizePixel = 0
        AccentPill.Visible = false
        AccentPill.Parent = NavBtn

        local PillCorner = Instance.new("UICorner")
        PillCorner.CornerRadius = UDim.new(1, 0)
        PillCorner.Parent = AccentPill

        local TabIcon = Instance.new("ImageLabel")
        TabIcon.Name = "TabIcon"
        TabIcon.Size = UDim2.new(0, 16, 0, 16)
        TabIcon.Position = UDim2.new(0, 12, 0.5, -8)
        TabIcon.BackgroundTransparency = 1
        TabIcon.Image = iconAsset or "rbxassetid://6034287594"
        TabIcon.ImageColor3 = Theme.TextSecondary
        TabIcon.Parent = NavBtn

        local TabLabel = Instance.new("TextLabel")
        TabLabel.Size = UDim2.new(1, -40, 1, 0)
        TabLabel.Position = UDim2.new(0, 36, 0, 0)
        TabLabel.BackgroundTransparency = 1
        TabLabel.Font = Theme.FontFamily
        TabLabel.TextSize = 12
        TabLabel.Text = tabName
        TabLabel.TextColor3 = Theme.TextPrimary
        TabLabel.TextXAlignment = Enum.TextXAlignment.Left
        TabLabel.Parent = NavBtn

        Tab.NavButton = NavBtn

        local function Select()
            if Window._activeTab == Tab then return end

            for _, t in pairs(Window._tabs) do
                t.PageFrame.Visible = false
                t.NavButton.AccentPill.Visible = false
                t.NavButton.TabIcon.ImageColor3 = Theme.TextSecondary
                Tween(t.NavButton, 0.15, { BackgroundTransparency = 1 })
            end

            Window._activeTab = Tab
            Page.Visible = true
            AccentPill.Visible = true
            TabIcon.ImageColor3 = currentAccent
            Tween(NavBtn, 0.15, { BackgroundTransparency = 0.94 })
            Breadcrumb.Text = "Home  >  " .. tabName
            SectionTitle.Text = tabName
        end

        NavBtn.MouseEnter:Connect(function()
            if Window._activeTab ~= Tab then
                Tween(NavBtn, 0.15, { BackgroundTransparency = 0.96 })
            end
        end)

        NavBtn.MouseLeave:Connect(function()
            if Window._activeTab ~= Tab then
                Tween(NavBtn, 0.15, { BackgroundTransparency = 1 })
            end
        end)

        NavBtn.MouseButton1Click:Connect(Select)

        local function CreateBaseCard(title: string, desc: string?, minHeight: number?)
            local Card = Instance.new("Frame")
            Card.Name = title .. "_Card"
            Card.Size = UDim2.new(1, 0, 0, minHeight or 54)
            Card.BackgroundColor3 = Theme.CardBg
            Card.BorderSizePixel = 0
            Card.Parent = Page

            local CardCorner = Instance.new("UICorner")
            CardCorner.CornerRadius = Theme.ControlCorner
            CardCorner.Parent = Card

            local CardStroke = Instance.new("UIStroke")
            CardStroke.Color = Theme.StrokeColor
            CardStroke.Transparency = Theme.StrokeTransparency
            CardStroke.Thickness = 1
            CardStroke.Parent = Card

            local LabelsFrame = Instance.new("Frame")
            LabelsFrame.Size = UDim2.new(0.65, -16, 1, 0)
            LabelsFrame.Position = UDim2.new(0, 16, 0, 0)
            LabelsFrame.BackgroundTransparency = 1
            LabelsFrame.Parent = Card

            local CardTitle = Instance.new("TextLabel")
            CardTitle.Name = "CardTitle"
            CardTitle.Size = UDim2.new(1, 0, 0, desc and 22 or 54)
            CardTitle.Position = UDim2.new(0, 0, 0, desc and 8 or 0)
            CardTitle.BackgroundTransparency = 1
            CardTitle.Font = Theme.FontFamily
            CardTitle.TextSize = 13
            CardTitle.Text = title
            CardTitle.TextColor3 = Theme.TextPrimary
            CardTitle.TextXAlignment = Enum.TextXAlignment.Left
            CardTitle.Parent = LabelsFrame

            if desc and desc ~= "" then
                local CardDesc = Instance.new("TextLabel")
                CardDesc.Name = "CardDesc"
                CardDesc.Size = UDim2.new(1, 0, 0, 18)
                CardDesc.Position = UDim2.new(0, 0, 0, 27)
                CardDesc.BackgroundTransparency = 1
                CardDesc.Font = Theme.FontFamily
                CardDesc.TextSize = 11
                CardDesc.Text = desc
                CardDesc.TextColor3 = Theme.TextSecondary
                CardDesc.TextXAlignment = Enum.TextXAlignment.Left
                CardDesc.Parent = LabelsFrame
            end

            table.insert(Tab.Cards, {
                Instance = Card,
                TitleText = title,
                DescText = desc or "",
            })

            return Card
        end

        function Tab:AddToggle(title: string, desc: string, defaultVal: boolean, callback: (boolean) -> ())
            local Card = CreateBaseCard(title, desc)
            local state = defaultVal or false

            local SwitchTrack = Instance.new("TextButton")
            SwitchTrack.Name = "SwitchTrack"
            SwitchTrack.Size = UDim2.new(0, 42, 0, 20)
            SwitchTrack.Position = UDim2.new(1, -58, 0.5, -10)
            SwitchTrack.BackgroundColor3 = state and currentAccent or Theme.ToggleOff
            SwitchTrack.BorderSizePixel = 0
            SwitchTrack.Text = ""
            SwitchTrack.AutoButtonColor = false
            SwitchTrack.Parent = Card

            local SwitchCorner = Instance.new("UICorner")
            SwitchCorner.CornerRadius = UDim.new(1, 0)
            SwitchCorner.Parent = SwitchTrack

            local Thumb = Instance.new("Frame")
            Thumb.Name = "Thumb"
            Thumb.Size = UDim2.new(0, 12, 0, 12)
            Thumb.Position = state and UDim2.new(1, -16, 0.5, -6) or UDim2.new(0, 4, 0.5, -6)
            Thumb.BackgroundColor3 = state and Color3.fromRGB(24, 24, 24) or Color3.fromRGB(220, 220, 220)
            Thumb.BorderSizePixel = 0
            Thumb.Parent = SwitchTrack

            local ThumbCorner = Instance.new("UICorner")
            ThumbCorner.CornerRadius = UDim.new(1, 0)
            ThumbCorner.Parent = Thumb

            local function SetState(val: boolean)
                state = val
                if state then
                    Tween(SwitchTrack, 0.15, { BackgroundColor3 = currentAccent })
                    Tween(Thumb, 0.15, {
                        Position = UDim2.new(1, -16, 0.5, -6),
                        BackgroundColor3 = Color3.fromRGB(24, 24, 24),
                    })
                else
                    Tween(SwitchTrack, 0.15, { BackgroundColor3 = Theme.ToggleOff })
                    Tween(Thumb, 0.15, {
                        Position = UDim2.new(0, 4, 0.5, -6),
                        BackgroundColor3 = Color3.fromRGB(220, 220, 220),
                    })
                end
                task.spawn(callback, state)
            end

            SwitchTrack.MouseButton1Click:Connect(function()
                SetState(not state)
            end)

            return { SetValue = SetState }
        end

        function Tab:AddButton(title: string, desc: string, buttonText: string, callback: () -> ())
            local Card = CreateBaseCard(title, desc)

            local ActionBtn = Instance.new("TextButton")
            ActionBtn.Name = "ActionBtn"
            ActionBtn.Size = UDim2.new(0, 100, 0, 28)
            ActionBtn.Position = UDim2.new(1, -116, 0.5, -14)
            ActionBtn.BackgroundColor3 = Theme.CardSubtle
            ActionBtn.BorderSizePixel = 0
            ActionBtn.Font = Theme.FontFamily
            ActionBtn.TextSize = 12
            ActionBtn.TextColor3 = Theme.TextPrimary
            ActionBtn.Text = buttonText or "Execute"
            ActionBtn.AutoButtonColor = false
            ActionBtn.Parent = Card

            local BtnCorner = Instance.new("UICorner")
            BtnCorner.CornerRadius = Theme.ControlCorner
            BtnCorner.Parent = ActionBtn

            local BtnStroke = Instance.new("UIStroke")
            BtnStroke.Color = Theme.StrokeColor
            BtnStroke.Transparency = Theme.StrokeTransparency
            BtnStroke.Thickness = 1
            BtnStroke.Parent = ActionBtn

            ActionBtn.MouseEnter:Connect(function()
                Tween(ActionBtn, 0.15, { BackgroundColor3 = Theme.CardHover })
            end)

            ActionBtn.MouseLeave:Connect(function()
                Tween(ActionBtn, 0.15, { BackgroundColor3 = Theme.CardSubtle })
            end)

            ActionBtn.MouseButton1Click:Connect(function()
                Tween(ActionBtn, 0.08, { BackgroundColor3 = Theme.AccentDark }):Completed:Wait()
                Tween(ActionBtn, 0.12, { BackgroundColor3 = Theme.CardHover })
                task.spawn(callback)
            end)
        end

        function Tab:AddSlider(title: string, desc: string, min: number, max: number, default: number, callback: (number) -> ())
            local Card = CreateBaseCard(title, desc)
            local currentVal = math.clamp(default or min, min, max)

            local SliderFrame = Instance.new("Frame")
            SliderFrame.Name = "SliderFrame"
            SliderFrame.Size = UDim2.new(0, 180, 0, 24)
            SliderFrame.Position = UDim2.new(1, -196, 0.5, -12)
            SliderFrame.BackgroundTransparency = 1
            SliderFrame.Parent = Card

            local ValueReadout = Instance.new("TextLabel")
            ValueReadout.Size = UDim2.new(0, 36, 1, 0)
            ValueReadout.Position = UDim2.new(1, -36, 0, 0)
            ValueReadout.BackgroundTransparency = 1
            ValueReadout.Font = Theme.FontFamily
            ValueReadout.TextSize = 11
            ValueReadout.TextColor3 = Theme.TextSecondary
            ValueReadout.Text = tostring(currentVal)
            ValueReadout.TextXAlignment = Enum.TextXAlignment.Right
            ValueReadout.Parent = SliderFrame

            local Track = Instance.new("TextButton")
            Track.Name = "Track"
            Track.Size = UDim2.new(1, -44, 0, 4)
            Track.Position = UDim2.new(0, 0, 0.5, -2)
            Track.BackgroundColor3 = Theme.ToggleOff
            Track.BorderSizePixel = 0
            Track.Text = ""
            Track.AutoButtonColor = false
            Track.Parent = SliderFrame

            local TrackCorner = Instance.new("UICorner")
            TrackCorner.CornerRadius = UDim.new(1, 0)
            TrackCorner.Parent = Track

            local Fill = Instance.new("Frame")
            Fill.Name = "Fill"
            Fill.Size = UDim2.new((currentVal - min) / (max - min), 0, 1, 0)
            Fill.BackgroundColor3 = currentAccent
            Fill.BorderSizePixel = 0
            Fill.Parent = Track

            local FillCorner = Instance.new("UICorner")
            FillCorner.CornerRadius = UDim.new(1, 0)
            FillCorner.Parent = Fill

            local Thumb = Instance.new("Frame")
            Thumb.Name = "Thumb"
            Thumb.Size = UDim2.new(0, 12, 0, 12)
            Thumb.Position = UDim2.new(1, -6, 0.5, -6)
            Thumb.BackgroundColor3 = Theme.TextPrimary
            Thumb.BorderSizePixel = 0
            Thumb.Parent = Fill

            local ThumbCorner = Instance.new("UICorner")
            ThumbCorner.CornerRadius = UDim.new(1, 0)
            ThumbCorner.Parent = Thumb

            local isDraggingSlider = false

            local function UpdateSlider(inputX: number)
                local absPos = Track.AbsolutePosition.X
                local absSize = Track.AbsoluteSize.X
                local percent = math.clamp((inputX - absPos) / absSize, 0, 1)
                local computed = math.floor(min + (max - min) * percent)

                Fill.Size = UDim2.new(percent, 0, 1, 0)
                ValueReadout.Text = tostring(computed)
                task.spawn(callback, computed)
            end

            Track.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    isDraggingSlider = true
                    UpdateSlider(input.Position.X)
                end
            end)

            table.insert(Window._connections, UserInputService.InputChanged:Connect(function(input)
                if isDraggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    UpdateSlider(input.Position.X)
                end
            end))

            table.insert(Window._connections, UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    isDraggingSlider = false
                end
            end))
        end

        function Tab:AddDropdown(title: string, desc: string, options: { string }, default: string?, callback: (string) -> ())
            local Card = CreateBaseCard(title, desc)
            local isOpen = false
            local currentChoice = default or options[1] or ""

            local DropdownBtn = Instance.new("TextButton")
            DropdownBtn.Name = "DropdownBtn"
            DropdownBtn.Size = UDim2.new(0, 140, 0, 28)
            DropdownBtn.Position = UDim2.new(1, -156, 0.5, -14)
            DropdownBtn.BackgroundColor3 = Theme.CardSubtle
            DropdownBtn.BorderSizePixel = 0
            DropdownBtn.Font = Theme.FontFamily
            DropdownBtn.TextSize = 12
            DropdownBtn.TextColor3 = Theme.TextPrimary
            DropdownBtn.Text = "  " .. currentChoice
            DropdownBtn.TextXAlignment = Enum.TextXAlignment.Left
            DropdownBtn.AutoButtonColor = false
            DropdownBtn.Parent = Card

            local DropCorner = Instance.new("UICorner")
            DropCorner.CornerRadius = Theme.ControlCorner
            DropCorner.Parent = DropdownBtn

            local DropStroke = Instance.new("UIStroke")
            DropStroke.Color = Theme.StrokeColor
            DropStroke.Transparency = Theme.StrokeTransparency
            DropStroke.Thickness = 1
            DropStroke.Parent = DropdownBtn

            local Chevron = Instance.new("TextLabel")
            Chevron.Size = UDim2.new(0, 20, 1, 0)
            Chevron.Position = UDim2.new(1, -22, 0, 0)
            Chevron.BackgroundTransparency = 1
            Chevron.Font = Theme.FontFamily
            Chevron.TextSize = 10
            Chevron.Text = "▼"
            Chevron.TextColor3 = Theme.TextSecondary
            Chevron.Parent = DropdownBtn

            local Popup = Instance.new("Frame")
            Popup.Name = "DropdownPopup"
            Popup.Size = UDim2.new(0, 140, 0, #options * 28 + 4)
            Popup.BackgroundColor3 = Theme.MicaBg
            Popup.BorderSizePixel = 0
            Popup.Visible = false
            Popup.ZIndex = 100
            Popup.Parent = ScreenGui

            local PopupCorner = Instance.new("UICorner")
            PopupCorner.CornerRadius = Theme.ControlCorner
            PopupCorner.Parent = Popup

            local PopupStroke = Instance.new("UIStroke")
            PopupStroke.Color = Theme.StrokeColor
            PopupStroke.Transparency = Theme.StrokeTransparency
            PopupStroke.Thickness = 1
            PopupStroke.Parent = Popup

            local PopupLayout = Instance.new("UIListLayout")
            PopupLayout.Padding = UDim.new(0, 2)
            PopupLayout.Parent = Popup

            local function UpdatePopupPosition()
                local absPos = DropdownBtn.AbsolutePosition
                local absSize = DropdownBtn.AbsoluteSize
                Popup.Position = UDim2.new(0, absPos.X, 0, absPos.Y + absSize.Y + 4)
            end

            for _, opt in ipairs(options) do
                local OptBtn = Instance.new("TextButton")
                OptBtn.Size = UDim2.new(1, 0, 0, 26)
                OptBtn.BackgroundColor3 = Theme.CardBg
                OptBtn.BackgroundTransparency = 1
                OptBtn.BorderSizePixel = 0
                OptBtn.Font = Theme.FontFamily
                OptBtn.TextSize = 12
                OptBtn.Text = "  " .. opt
                OptBtn.TextColor3 = Theme.TextPrimary
                OptBtn.TextXAlignment = Enum.TextXAlignment.Left
                OptBtn.ZIndex = 101
                OptBtn.Parent = Popup

                OptBtn.MouseEnter:Connect(function()
                    OptBtn.BackgroundTransparency = 0
                end)

                OptBtn.MouseLeave:Connect(function()
                    OptBtn.BackgroundTransparency = 1
                end)

                OptBtn.MouseButton1Click:Connect(function()
                    currentChoice = opt
                    DropdownBtn.Text = "  " .. currentChoice
                    isOpen = false
                    Popup.Visible = false
                    Chevron.Text = "▼"
                    task.spawn(callback, currentChoice)
                end)
            end

            DropdownBtn.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                if isOpen then
                    UpdatePopupPosition()
                    Popup.Visible = true
                    Chevron.Text = "▲"
                else
                    Popup.Visible = false
                    Chevron.Text = "▼"
                end
            end)
        end

        function Tab:AddKeybind(title: string, desc: string, defaultKey: Enum.KeyCode, callback: (Enum.KeyCode) -> ())
            local Card = CreateBaseCard(title, desc)
            local currentKey = defaultKey or Enum.KeyCode.RightControl
            local listening = false

            local BindBtn = Instance.new("TextButton")
            BindBtn.Name = "BindBtn"
            BindBtn.Size = UDim2.new(0, 90, 0, 28)
            BindBtn.Position = UDim2.new(1, -106, 0.5, -14)
            BindBtn.BackgroundColor3 = Theme.CardSubtle
            BindBtn.BorderSizePixel = 0
            BindBtn.Font = Theme.FontFamily
            BindBtn.TextSize = 11
            BindBtn.TextColor3 = Theme.TextPrimary
            BindBtn.Text = currentKey.Name
            BindBtn.AutoButtonColor = false
            BindBtn.Parent = Card

            local BindCorner = Instance.new("UICorner")
            BindCorner.CornerRadius = Theme.ControlCorner
            BindCorner.Parent = BindBtn

            local BindStroke = Instance.new("UIStroke")
            BindStroke.Color = Theme.StrokeColor
            BindStroke.Transparency = Theme.StrokeTransparency
            BindStroke.Thickness = 1
            BindStroke.Parent = BindBtn

            BindBtn.MouseButton1Click:Connect(function()
                listening = true
                BindBtn.Text = "..."
                BindStroke.Color = currentAccent
            end)

            table.insert(Window._connections, UserInputService.InputBegan:Connect(function(input)
                if listening and input.UserInputType == Enum.UserInputType.Keyboard then
                    listening = false
                    currentKey = input.KeyCode
                    BindBtn.Text = currentKey.Name
                    BindStroke.Color = Theme.StrokeColor
                    task.spawn(callback, currentKey)
                end
            end))
        end

        function Tab:AddTextInput(title: string, desc: string, placeholder: string, callback: (string) -> ())
            local Card = CreateBaseCard(title, desc)

            local TextBox = Instance.new("TextBox")
            TextBox.Name = "TextBox"
            TextBox.Size = UDim2.new(0, 140, 0, 28)
            TextBox.Position = UDim2.new(1, -156, 0.5, -14)
            TextBox.BackgroundColor3 = Theme.CardSubtle
            TextBox.BorderSizePixel = 0
            TextBox.Font = Theme.FontFamily
            TextBox.TextSize = 12
            TextBox.TextColor3 = Theme.TextPrimary
            TextBox.PlaceholderColor3 = Theme.TextSecondary
            TextBox.PlaceholderText = placeholder or "Type here..."
            TextBox.Text = ""
            TextBox.ClearTextOnFocus = false
            TextBox.Parent = Card

            local TextCorner = Instance.new("UICorner")
            TextCorner.CornerRadius = Theme.ControlCorner
            TextCorner.Parent = TextBox

            local TextStroke = Instance.new("UIStroke")
            TextStroke.Color = Theme.StrokeColor
            TextStroke.Transparency = Theme.StrokeTransparency
            TextStroke.Thickness = 1
            TextStroke.Parent = TextBox

            TextBox.Focused:Connect(function()
                Tween(TextStroke, 0.15, { Color = currentAccent, Transparency = 0 })
            end)

            TextBox.FocusLost:Connect(function(_enterPressed)
                Tween(TextStroke, 0.15, { Color = Theme.StrokeColor, Transparency = Theme.StrokeTransparency })
                task.spawn(callback, TextBox.Text)
            end)
        end

        function Tab:AddExpander(title: string, desc: string)
            local Card = CreateBaseCard(title, desc)
            local isExpanded = false

            local ChildContainer = Instance.new("Frame")
            ChildContainer.Name = "ChildContainer"
            ChildContainer.Size = UDim2.new(1, -32, 0, 0)
            ChildContainer.Position = UDim2.new(0, 16, 0, 54)
            ChildContainer.BackgroundTransparency = 1
            ChildContainer.ClipsDescendants = true
            ChildContainer.Parent = Card

            local ChildLayout = Instance.new("UIListLayout")
            ChildLayout.Padding = UDim.new(0, 4)
            ChildLayout.SortOrder = Enum.SortOrder.LayoutOrder
            ChildLayout.Parent = ChildContainer

            local Chevron = Instance.new("TextButton")
            Chevron.Name = "Chevron"
            Chevron.Size = UDim2.new(0, 28, 0, 28)
            Chevron.Position = UDim2.new(1, -44, 0, 13)
            Chevron.BackgroundTransparency = 1
            Chevron.Font = Theme.FontFamily
            Chevron.TextSize = 12
            Chevron.TextColor3 = Theme.TextSecondary
            Chevron.Text = "⌄"
            Chevron.Parent = Card

            local function RecalculateHeight()
                if isExpanded then
                    local targetChildHeight = ChildLayout.AbsoluteContentSize.Y
                    Tween(ChildContainer, 0.2, { Size = UDim2.new(1, -32, 0, targetChildHeight + 8) })
                    Tween(Card, 0.2, { Size = UDim2.new(1, 0, 0, 54 + targetChildHeight + 12) })
                end
            end

            Chevron.MouseButton1Click:Connect(function()
                isExpanded = not isExpanded
                if isExpanded then
                    Chevron.Text = "⌃"
                    RecalculateHeight()
                else
                    Chevron.Text = "⌄"
                    Tween(ChildContainer, 0.2, { Size = UDim2.new(1, -32, 0, 0) })
                    Tween(Card, 0.2, { Size = UDim2.new(1, 0, 0, 54) })
                end
            end)

            local ExpanderSubGroup = {}

            function ExpanderSubGroup:AddButton(subTitle: string, btnText: string, callback: () -> ())
                local SubItem = Instance.new("Frame")
                SubItem.Size = UDim2.new(1, 0, 0, 38)
                SubItem.BackgroundColor3 = Theme.CardSubtle
                SubItem.BorderSizePixel = 0
                SubItem.Parent = ChildContainer

                local SubCorner = Instance.new("UICorner")
                SubCorner.CornerRadius = Theme.ControlCorner
                SubCorner.Parent = SubItem

                local SubLabel = Instance.new("TextLabel")
                SubLabel.Size = UDim2.new(0.7, 0, 1, 0)
                SubLabel.Position = UDim2.new(0, 12, 0, 0)
                SubLabel.BackgroundTransparency = 1
                SubLabel.Font = Theme.FontFamily
                SubLabel.TextSize = 12
                SubLabel.Text = subTitle
                SubLabel.TextColor3 = Theme.TextPrimary
                SubLabel.TextXAlignment = Enum.TextXAlignment.Left
                SubLabel.Parent = SubItem

                local ActionBtn = Instance.new("TextButton")
                ActionBtn.Size = UDim2.new(0, 80, 0, 24)
                ActionBtn.Position = UDim2.new(1, -88, 0.5, -12)
                ActionBtn.BackgroundColor3 = Theme.CardBg
                ActionBtn.BorderSizePixel = 0
                ActionBtn.Font = Theme.FontFamily
                ActionBtn.TextSize = 11
                ActionBtn.TextColor3 = Theme.TextPrimary
                ActionBtn.Text = btnText or "Run"
                ActionBtn.Parent = SubItem

                local BtnCorner = Instance.new("UICorner")
                BtnCorner.CornerRadius = Theme.ControlCorner
                BtnCorner.Parent = ActionBtn

                ActionBtn.MouseButton1Click:Connect(callback)
                RecalculateHeight()
            end

            return ExpanderSubGroup
        end

        Window._tabs[tabName] = Tab

        if Window._activeTab == nil then
            Select()
        end

        return Tab
    end

    return Window
end

return Win11Lib

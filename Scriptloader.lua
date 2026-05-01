local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Player = Players.LocalPlayer

-- ============================================
-- MANUELLE SCRIPT LISTE 
-- ============================================
local SCRIPTS = {
    {
        name = "Knockout",
        loadstring = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/adrighg-scripts/Public-Scripts/refs/heads/main/Knockout.lua"))()',
        description = "Knockout Auto win Script"
    },
        {
        name = "Pet Simulator 99",
        loadstring = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/adrighg-scripts/Public-Scripts/refs/heads/main/zabhub.xyz/Exec"))()',
        description = "Zab Hub best PS99"
    },
}

-- GUI Settings
local isOpen = true
local guiSize = UDim2.new(0, 380, 0, 450)
local minimizedSize = UDim2.new(0, 380, 0, 35)

-- ============================================
-- GUI ERSTELLEN
-- ============================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ScriptLoader"
screenGui.Parent = Player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Enabled = false

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = guiSize
mainFrame.Position = UDim2.new(0.5, -190, 0.5, -225)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true -- WICHTIG: Verhindert dass Inhalte über den Rand ragen
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 35)
titleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = titleBar

local titleText = Instance.new("TextLabel")
titleText.Name = "TitleText"
titleText.Size = UDim2.new(1, -70, 1, 0)
titleText.Position = UDim2.new(0, 12, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "📁 My Scripts"
titleText.TextColor3 = Color3.fromRGB(220, 220, 255)
titleText.Font = Enum.Font.GothamSemibold
titleText.TextSize = 15
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Parent = titleBar

local buttonsFrame = Instance.new("Frame")
buttonsFrame.Size = UDim2.new(0, 55, 1, 0)
buttonsFrame.Position = UDim2.new(1, -60, 0, 0)
buttonsFrame.BackgroundTransparency = 1
buttonsFrame.Parent = titleBar

-- Minimize Button (mit korrektem Minus-Zeichen)
local minimizeButton = Instance.new("TextButton")
minimizeButton.Name = "MinimizeButton"
minimizeButton.Size = UDim2.new(0, 24, 0, 24)
minimizeButton.Position = UDim2.new(0, 0, 0.5, -12)
minimizeButton.BackgroundColor3 = Color3.fromRGB(55, 55, 65)
minimizeButton.Text = "−"  -- Korrektes Minus-Zeichen
minimizeButton.TextColor3 = Color3.fromRGB(220, 220, 255)
minimizeButton.TextSize = 20
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.Parent = buttonsFrame

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 4)
minCorner.Parent = minimizeButton

-- Close Button (mit korrektem X)
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 24, 0, 24)
closeButton.Position = UDim2.new(1, -24, 0.5, -12)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.Text = "✕"  -- Korrektes X-Symbol
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 16  -- Größe angepasst
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = buttonsFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 4)
closeCorner.Parent = closeButton

-- Content Frame (wird beim Minimieren ausgeblendet)
local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(1, 0, 1, -35)
contentFrame.Position = UDim2.new(0, 0, 0, 35)
contentFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
contentFrame.BorderSizePixel = 0
contentFrame.Parent = mainFrame

-- Search Frame
local searchFrame = Instance.new("Frame")
searchFrame.Name = "SearchFrame"
searchFrame.Size = UDim2.new(1, -20, 0, 36)
searchFrame.Position = UDim2.new(0, 10, 0, 10)
searchFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
searchFrame.BorderSizePixel = 0
searchFrame.Parent = contentFrame

local searchCorner = Instance.new("UICorner")
searchCorner.CornerRadius = UDim.new(0, 6)
searchCorner.Parent = searchFrame

local searchIcon = Instance.new("TextLabel")
searchIcon.Name = "SearchIcon"
searchIcon.Size = UDim2.new(0, 32, 1, 0)
searchIcon.BackgroundTransparency = 1
searchIcon.Text = "🔍"
searchIcon.TextColor3 = Color3.fromRGB(140, 140, 160)
searchIcon.TextSize = 16
searchIcon.Font = Enum.Font.GothamBold
searchIcon.Parent = searchFrame

local searchBox = Instance.new("TextBox")
searchBox.Name = "SearchBox"
searchBox.Size = UDim2.new(1, -32, 1, 0)
searchBox.Position = UDim2.new(0, 32, 0, 0)
searchBox.BackgroundTransparency = 1
searchBox.PlaceholderText = "Search scripts..."
searchBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 140)
searchBox.Text = ""
searchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
searchBox.TextSize = 14
searchBox.Font = Enum.Font.Gotham
searchBox.ClearTextOnFocus = false
searchBox.Parent = searchFrame

-- File List Frame
local listFrame = Instance.new("ScrollingFrame")
listFrame.Name = "FileList"
listFrame.Size = UDim2.new(1, -20, 1, -60)
listFrame.Position = UDim2.new(0, 10, 0, 56)
listFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
listFrame.BorderSizePixel = 0
listFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
listFrame.ScrollBarThickness = 4
listFrame.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 100)
listFrame.Parent = contentFrame

-- Loading Frame (für Animation)
local loadingFrame = Instance.new("Frame")
loadingFrame.Name = "LoadingFrame"
loadingFrame.Size = UDim2.new(1, 0, 1, 0)
loadingFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
loadingFrame.BackgroundTransparency = 0.5
loadingFrame.Visible = false
loadingFrame.Parent = contentFrame

local loadingSpinner = Instance.new("ImageLabel")
loadingSpinner.Name = "Spinner"
loadingSpinner.Size = UDim2.new(0, 30, 0, 30)
loadingSpinner.Position = UDim2.new(0.5, -15, 0.5, -15)
loadingSpinner.BackgroundTransparency = 1
loadingSpinner.Image = "rbxassetid://6034502866"
loadingSpinner.ImageColor3 = Color3.fromRGB(100, 150, 255)
loadingSpinner.Parent = loadingFrame

-- Notification Frame
local notificationFrame = Instance.new("Frame")
notificationFrame.Name = "NotificationFrame"
notificationFrame.Size = UDim2.new(1, -40, 0, 50)
notificationFrame.Position = UDim2.new(0, 20, 1, -70)
notificationFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
notificationFrame.BackgroundTransparency = 1
notificationFrame.Visible = false
notificationFrame.Parent = contentFrame
notificationFrame.ZIndex = 10

local notifCorner = Instance.new("UICorner")
notifCorner.CornerRadius = UDim.new(0, 8)
notifCorner.Parent = notificationFrame

local notifText = Instance.new("TextLabel")
notifText.Size = UDim2.new(1, -20, 1, 0)
notifText.Position = UDim2.new(0, 10, 0, 0)
notifText.BackgroundTransparency = 1
notifText.Text = ""
notifText.TextColor3 = Color3.fromRGB(255, 255, 255)
notifText.TextSize = 13
notifText.Font = Enum.Font.Gotham
notifText.TextWrapped = true
notifText.Parent = notificationFrame

-- ============================================
-- INTRO ANIMATION
-- ============================================
local introFrame = Instance.new("Frame")
introFrame.Name = "IntroFrame"
introFrame.Size = UDim2.new(1, 0, 1, 0)
introFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
introFrame.BackgroundTransparency = 1
introFrame.Parent = mainFrame
introFrame.ZIndex = 10

local introTitle = Instance.new("TextLabel")
introTitle.Size = UDim2.new(1, 0, 0, 80)
introTitle.Position = UDim2.new(0, 0, 0.5, -40)
introTitle.BackgroundTransparency = 1
introTitle.Text = "SCRIPT LOADER"
introTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
introTitle.TextStrokeTransparency = 0.5
introTitle.TextStrokeColor3 = Color3.fromRGB(100, 150, 255)
introTitle.Font = Enum.Font.GothamBold
introTitle.TextSize = 36
introTitle.TextTransparency = 1
introTitle.Parent = introFrame

local introSubtitle = Instance.new("TextLabel")
introSubtitle.Size = UDim2.new(1, 0, 0, 30)
introSubtitle.Position = UDim2.new(0, 0, 0.5, 30)
introSubtitle.BackgroundTransparency = 1
introSubtitle.Text = "by adrighg-scripts"
introSubtitle.TextColor3 = Color3.fromRGB(180, 180, 200)
introSubtitle.TextSize = 16
introSubtitle.TextTransparency = 1
introSubtitle.Parent = introFrame

local versionText = Instance.new("TextLabel")
versionText.Size = UDim2.new(1, 0, 0, 20)
versionText.Position = UDim2.new(0, 0, 1, -25)
versionText.BackgroundTransparency = 1
versionText.Text = "v2.0.0 • loading scripts..."
versionText.TextColor3 = Color3.fromRGB(100, 100, 120)
versionText.Font = Enum.Font.Gotham
versionText.TextSize = 11
versionText.TextTransparency = 1
versionText.Parent = introFrame

local progressBg = Instance.new("Frame")
progressBg.Size = UDim2.new(0.6, 0, 0, 2)
progressBg.Position = UDim2.new(0.2, 0, 0.7, 0)
progressBg.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
progressBg.BackgroundTransparency = 1
progressBg.Parent = introFrame

local progressBar = Instance.new("Frame")
progressBar.Size = UDim2.new(0, 0, 1, 0)
progressBar.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
progressBar.BackgroundTransparency = 1
progressBar.Parent = progressBg

-- ============================================
-- FUNKTIONEN
-- ============================================

local function showNotification(message, isError)
    notificationFrame.BackgroundTransparency = 0
    notificationFrame.Visible = true
    notifText.Text = message
    notifText.TextColor3 = isError and Color3.fromRGB(255, 100, 100) or Color3.fromRGB(100, 255, 100)
    
    task.wait(2)
    local tween = TweenService:Create(notificationFrame, TweenInfo.new(0.3), {BackgroundTransparency = 1})
    tween:Play()
    task.wait(0.3)
    notificationFrame.Visible = false
end

local function copyToClipboard(text)
    local clipboard = setclipboard or syn and syn.setclipboard or clipboard or function(t) warn("No clipboard function") end
    if clipboard then
        clipboard(text)
        showNotification("✅ Copied to clipboard!", false)
    else
        showNotification("❌ No clipboard function", true)
    end
end

local function executeLoadstring(loadstringCode, name)
    print("▶️ Executing: " .. name)
    showNotification("▶️ Running " .. name .. "...", false)
    
    local success, result = pcall(function()
        return loadstring(loadstringCode)()
    end)
    
    if success then
        print("✅ Success: " .. name)
        showNotification("✅ " .. name .. " executed!", false)
    else
        warn("❌ Error: " .. tostring(result))
        showNotification("❌ Error: " .. tostring(result):sub(1, 50), true)
    end
end

-- ============================================
-- FILTER FUNKTION (OHNE LÜCKEN)
-- ============================================
local function filterFiles()
    if not searchBox or not listFrame then 
        return 
    end
    
    local searchText = searchBox.Text:lower()
    local yPos = 0
    local visibleCount = 0
    
    -- Zuerst alle Frames unsichtbar machen
    for _, fileFrame in ipairs(listFrame:GetChildren()) do
        if fileFrame:IsA("Frame") then
            fileFrame.Visible = false
        end
    end
    
    -- Dann nur die passenden Frames anzeigen und neu positionieren
    for _, fileFrame in ipairs(listFrame:GetChildren()) do
        if fileFrame:IsA("Frame") then
            local nameLabel = fileFrame:FindFirstChild("ScriptName")
            
            if nameLabel and nameLabel:IsA("TextLabel") then
                -- Prüfen ob der Name den Suchtext enthält
                if searchText == "" or nameLabel.Text:lower():find(searchText, 1, true) then
                    -- Frame an die nächste freie Position setzen
                    fileFrame.Position = UDim2.new(0, 5, 0, yPos)
                    fileFrame.Visible = true
                    yPos = yPos + 64
                    visibleCount = visibleCount + 1
                end
            end
        end
    end
    
    -- CanvasSize anpassen (nur sichtbare Einträge)
    listFrame.CanvasSize = UDim2.new(0, 0, 0, yPos + 5)
    
    -- Nach oben scrollen
    listFrame.CanvasPosition = Vector2.new(0, 0)
end

-- ============================================
-- DISPLAY SCRIPTS
-- ============================================
local function displayScripts()
    for _, child in ipairs(listFrame:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    local yPos = 0
    
    for i, script in ipairs(SCRIPTS) do
        local fileFrame = Instance.new("Frame")
        fileFrame.Name = "Script_" .. i
        fileFrame.Size = UDim2.new(1, -10, 0, 60)
        fileFrame.Position = UDim2.new(0, 5, 0, yPos)
        fileFrame.BackgroundColor3 = i % 2 == 0 and Color3.fromRGB(30, 30, 36) or Color3.fromRGB(28, 28, 34)
        fileFrame.BorderSizePixel = 0
        fileFrame.Parent = listFrame
        
        local fileCorner = Instance.new("UICorner")
        fileCorner.CornerRadius = UDim.new(0, 6)
        fileCorner.Parent = fileFrame
        
        local icon = Instance.new("TextLabel")
        icon.Size = UDim2.new(0, 35, 1, 0)
        icon.Position = UDim2.new(0, 8, 0, 0)
        icon.BackgroundTransparency = 1
        icon.Text = "📜"
        icon.TextColor3 = Color3.fromRGB(100, 180, 255)
        icon.TextSize = 18
        icon.Font = Enum.Font.GothamBold
        icon.Parent = fileFrame
        
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Name = "ScriptName"
        nameLabel.Size = UDim2.new(1, -170, 0, 20)
        nameLabel.Position = UDim2.new(0, 48, 0, 6)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = script.name
        nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        nameLabel.TextSize = 13
        nameLabel.Font = Enum.Font.GothamSemibold
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        nameLabel.TextTruncate = Enum.TextTruncate.AtEnd
        nameLabel.Parent = fileFrame
        
        if script.description then
            local descLabel = Instance.new("TextLabel")
            descLabel.Name = "ScriptDescription"
            descLabel.Size = UDim2.new(1, -170, 0, 18)
            descLabel.Position = UDim2.new(0, 48, 0, 26)
            descLabel.BackgroundTransparency = 1
            descLabel.Text = script.description
            descLabel.TextColor3 = Color3.fromRGB(160, 160, 180)
            descLabel.TextSize = 11
            descLabel.Font = Enum.Font.Gotham
            descLabel.TextXAlignment = Enum.TextXAlignment.Left
            descLabel.TextTruncate = Enum.TextTruncate.AtEnd
            descLabel.Parent = fileFrame
        end
        
        local btnFrame = Instance.new("Frame")
        btnFrame.Size = UDim2.new(0, 110, 1, 0)
        btnFrame.Position = UDim2.new(1, -115, 0, 0)
        btnFrame.BackgroundTransparency = 1
        btnFrame.Parent = fileFrame
        
        local execBtn = Instance.new("TextButton")
        execBtn.Size = UDim2.new(0, 50, 0, 28)
        execBtn.Position = UDim2.new(0, 0, 0.5, -14)
        execBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 70)
        execBtn.Text = "RUN"
        execBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        execBtn.TextSize = 11
        execBtn.Font = Enum.Font.GothamBold
        execBtn.Parent = btnFrame
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 4)
        btnCorner.Parent = execBtn
        
        local copyBtn = Instance.new("TextButton")
        copyBtn.Size = UDim2.new(0, 50, 0, 28)
        copyBtn.Position = UDim2.new(1, -50, 0.5, -14)
        copyBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
        copyBtn.Text = "COPY"
        copyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        copyBtn.TextSize = 10
        copyBtn.Font = Enum.Font.GothamBold
        copyBtn.Parent = btnFrame
        
        local copyCorner = Instance.new("UICorner")
        copyCorner.CornerRadius = UDim.new(0, 4)
        copyCorner.Parent = copyBtn
        
        execBtn.MouseEnter:Connect(function()
            execBtn.BackgroundColor3 = Color3.fromRGB(80, 150, 80)
        end)
        execBtn.MouseLeave:Connect(function()
            execBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 70)
        end)
        
        copyBtn.MouseEnter:Connect(function()
            copyBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 120)
        end)
        copyBtn.MouseLeave:Connect(function()
            copyBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
        end)
        
        execBtn.MouseButton1Click:Connect(function()
            executeLoadstring(script.loadstring, script.name)
        end)
        
        copyBtn.MouseButton1Click:Connect(function()
            copyToClipboard(script.loadstring)
            copyBtn.Text = "✓"
            task.wait(0.5)
            copyBtn.Text = "COPY"
        end)
        
        yPos = yPos + 64
    end
    
    listFrame.CanvasSize = UDim2.new(0, 0, 0, yPos + 5)
end

-- ============================================
-- GUI FUNKTIONEN
-- ============================================
local function animateOpenClose(targetOpen)
    local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    
    if targetOpen then
        -- Beim Öffnen: ContentFrame wieder anzeigen
        local goal = { Size = guiSize }
        local tween = TweenService:Create(mainFrame, tweenInfo, goal)
        tween:Play()
        
        -- ContentFrame einblenden
        contentFrame.Visible = true
        isOpen = true
        minimizeButton.Text = "−"
    else
        -- Beim Schließen: ContentFrame ausblenden
        local goal = { Size = minimizedSize }
        local tween = TweenService:Create(mainFrame, tweenInfo, goal)
        tween:Play()
        
        -- ContentFrame ausblenden
        contentFrame.Visible = false
        isOpen = false
        minimizeButton.Text = "+"  -- Plus-Zeichen wenn minimiert
    end
end

-- Draggable
local dragging = false
local dragStart = nil
local startPos = nil

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)

titleBar.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            startPos.X.Scale, 
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

minimizeButton.MouseButton1Click:Connect(function()
    animateOpenClose(not isOpen)
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.RightControl then
        animateOpenClose(not isOpen)
    end
end)

-- ============================================
-- SEARCHBOX EVENTS SETUP
-- ============================================
local function setupSearchEvents()
    -- Kleine Verzögerung um sicherzustellen dass alles geladen ist
    task.wait(0.1)
    
    if searchBox then
        -- Echtzeit-Suche bei jedem Tastendruck
        searchBox.Changed:Connect(function(prop)
            if prop == "Text" then
                filterFiles()
            end
        end)
        
        -- Bei Enter oder Fokusverlust
        searchBox.FocusLost:Connect(function()
            filterFiles()
        end)
        
        -- Initialen Filter anwenden (falls schon Text drin steht)
        filterFiles()
    else
        warn("SearchBox konnte nicht gefunden werden! Suche nach...")
        
        -- Notfall: Suche nach der SearchBox im gesamten GUI
        local found = false
        for _, child in ipairs(contentFrame:GetChildren()) do
            if child.Name == "SearchFrame" then
                local box = child:FindFirstChild("SearchBox")
                if box then
                    searchBox = box
                    setupSearchEvents() -- Nochmal versuchen
                    found = true
                    break
                end
            end
        end
    end
end

-- ============================================
-- INTRO ANIMATION STARTEN
-- ============================================
local function playIntro()
    screenGui.Enabled = true
    
    local tweenInfo = TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    
    TweenService:Create(introTitle, tweenInfo, {TextTransparency = 0}):Play()
    task.wait(0.2)
    
    TweenService:Create(introSubtitle, tweenInfo, {TextTransparency = 0}):Play()
    task.wait(0.2)
    
    TweenService:Create(versionText, tweenInfo, {TextTransparency = 0}):Play()
    TweenService:Create(progressBg, tweenInfo, {BackgroundTransparency = 0.7}):Play()
    
    local progress = 0
    while progress < 1 do
        progress = progress + 0.02
        progressBar.Size = UDim2.new(progress, 0, 1, 0)
        progressBar.BackgroundTransparency = 0
        task.wait(0.03)
    end
    
    task.wait(0.3)
    
    local fadeOutInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    
    TweenService:Create(introTitle, fadeOutInfo, {TextTransparency = 1}):Play()
    TweenService:Create(introSubtitle, fadeOutInfo, {TextTransparency = 1}):Play()
    TweenService:Create(versionText, fadeOutInfo, {TextTransparency = 1}):Play()
    TweenService:Create(progressBar, fadeOutInfo, {BackgroundTransparency = 1}):Play()
    TweenService:Create(progressBg, fadeOutInfo, {BackgroundTransparency = 1}):Play()
    TweenService:Create(introFrame, fadeOutInfo, {BackgroundTransparency = 1}):Play()
    
    task.wait(0.5)
    introFrame:Destroy()
    
    -- Scripts anzeigen
    displayScripts()
    
    -- Jetzt erst die SearchBox Events verbinden (nachdem alles geladen ist)
    setupSearchEvents()
end

-- ============================================
-- START
-- ============================================
playIntro()

print("✨ My Scripts Loader started!")
print("📁 " .. #SCRIPTS .. " scripts loaded")
print("⌨️ RCtrl = Toggle window")

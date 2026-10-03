

local player = game.Players.LocalPlayer
local players = game:GetService("Players")
local userInput = game:GetService("UserInputService")

-- Helper Funktion für Style
local function styleUI(obj, corner, stroke)
    if corner then
        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, corner)
        c.Parent = obj
    end
    if stroke then
        local s = Instance.new("UIStroke")
        s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        s.Thickness = 1.2
        s.Color = Color3.fromRGB(80,80,80)
        s.Parent = obj
    end
end

-- Main GUI
local gui = Instance.new("ScreenGui")
gui.Name = "TeleportGui"
gui.Parent = player:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0.26,0,0.46,0)
frame.Position = UDim2.new(0.7,0,0.25,0)
frame.BackgroundColor3 = Color3.fromRGB(25,25,30)
frame.Parent = gui
frame.Active = true
frame.Draggable = true
styleUI(frame, 12, true)

-- Titelbar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1,0,0.15,0)
titleBar.BackgroundColor3 = Color3.fromRGB(40,40,50)
titleBar.Parent = frame
styleUI(titleBar, 12, false)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0.85,0,1,0)
title.Text = "Teleport Manager"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.BackgroundTransparency = 1
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0.15,0,1,0)
closeBtn.Position = UDim2.new(0.85,0,0,0)
closeBtn.BackgroundColor3 = Color3.fromRGB(150,60,60)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
closeBtn.TextScaled = true
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = titleBar
styleUI(closeBtn, 12, false)

-- Eigene Koordinaten-Anzeige
local myCoords = Instance.new("TextButton")
myCoords.Size = UDim2.new(1,0,0.08,0)
myCoords.Position = UDim2.new(0,0,0.15,0)
myCoords.Text = "Coords: 0,0,0"
myCoords.BackgroundColor3 = Color3.fromRGB(35,35,45)
myCoords.TextColor3 = Color3.fromRGB(200,200,200)
myCoords.TextScaled = true
myCoords.Font = Enum.Font.Gotham
myCoords.Parent = frame
styleUI(myCoords, 8, false)

-- Tabs (wandern etwas nach unten, weil Koords jetzt da sind)
local tabPlayers = Instance.new("TextButton")
tabPlayers.Size = UDim2.new(0.5,0,0.08,0)
tabPlayers.Position = UDim2.new(0,0,0.23,0)
tabPlayers.Text = "Players"
tabPlayers.BackgroundColor3 = Color3.fromRGB(60,60,90)
tabPlayers.TextColor3 = Color3.fromRGB(255,255,255)
tabPlayers.TextScaled = true
tabPlayers.Font = Enum.Font.GothamSemibold
tabPlayers.Parent = frame
styleUI(tabPlayers, 10, false)

local tabCoords = Instance.new("TextButton")
tabCoords.Size = UDim2.new(0.5,0,0.08,0)
tabCoords.Position = UDim2.new(0.5,0,0.23,0)
tabCoords.Text = "Coords"
tabCoords.BackgroundColor3 = Color3.fromRGB(90,60,60)
tabCoords.TextColor3 = Color3.fromRGB(255,255,255)
tabCoords.TextScaled = true
tabCoords.Font = Enum.Font.GothamSemibold
tabCoords.Parent = frame
styleUI(tabCoords, 10, false)

-- Player Page
local playerPage = Instance.new("ScrollingFrame")
playerPage.Size = UDim2.new(0.95,0,0.65,0)
playerPage.Position = UDim2.new(0.025,0,0.32,0)
playerPage.CanvasSize = UDim2.new(0,0,0,0)
playerPage.ScrollBarThickness = 6
playerPage.BackgroundColor3 = Color3.fromRGB(30,30,35)
playerPage.Parent = frame
styleUI(playerPage, 10, true)

local playerLayout = Instance.new("UIListLayout")
playerLayout.Parent = playerPage
playerLayout.SortOrder = Enum.SortOrder.LayoutOrder
playerLayout.Padding = UDim.new(0,3)

playerLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    playerPage.CanvasSize = UDim2.new(0,0,0,playerLayout.AbsoluteContentSize.Y)
end)

-- Coords Page
local coordPage = Instance.new("Frame")
coordPage.Size = UDim2.new(0.95,0,0.65,0)
coordPage.Position = UDim2.new(0.025,0,0.32,0)
coordPage.BackgroundColor3 = Color3.fromRGB(30,30,35)
coordPage.Parent = frame
coordPage.Visible = false
styleUI(coordPage, 10, true)

local coordBox = Instance.new("TextBox")
coordBox.Size = UDim2.new(0.9,0,0.3,0)
coordBox.Position = UDim2.new(0.05,0,0.1,0)
coordBox.PlaceholderText = "X, Y, Z eingeben..."
coordBox.BackgroundColor3 = Color3.fromRGB(40,40,50)
coordBox.TextColor3 = Color3.fromRGB(255,255,255)
coordBox.TextScaled = true
coordBox.Font = Enum.Font.Gotham
coordBox.Text = ""
coordBox.ClearTextOnFocus = false
coordBox.Parent = coordPage
styleUI(coordBox, 8, true)

local tpBtn = Instance.new("TextButton")
tpBtn.Size = UDim2.new(0.9,0,0.3,0)
tpBtn.Position = UDim2.new(0.05,0,0.55,0)
tpBtn.Text = "Teleport (T)"
tpBtn.BackgroundColor3 = Color3.fromRGB(60,120,60)
tpBtn.TextColor3 = Color3.fromRGB(255,255,255)
tpBtn.TextScaled = true
tpBtn.Font = Enum.Font.GothamBold
tpBtn.Parent = coordPage
styleUI(tpBtn, 8, false)

-- Player Entry Funktion
local function createPlayerEntry(plr)
    if plr == player then return end

    local entry = Instance.new("Frame")
    entry.Size = UDim2.new(1,0,0,26)
    entry.BackgroundColor3 = Color3.fromRGB(40,40,50)
    entry.Parent = playerPage
    styleUI(entry, 8, false)

    local nameBtn = Instance.new("TextButton")
    nameBtn.Size = UDim2.new(0.5,0,1,0)
    nameBtn.BackgroundColor3 = Color3.fromRGB(70,70,100)
    nameBtn.TextColor3 = Color3.fromRGB(255,255,255)
    nameBtn.TextScaled = true
    nameBtn.Font = Enum.Font.Gotham
    nameBtn.Text = plr.Name
    nameBtn.Parent = entry
    styleUI(nameBtn, 8, false)

    local coordBtn = Instance.new("TextButton")
    coordBtn.Size = UDim2.new(0.5,0,1,0)
    coordBtn.Position = UDim2.new(0.5,0,0,0)
    coordBtn.BackgroundColor3 = Color3.fromRGB(90,90,70)
    coordBtn.TextColor3 = Color3.fromRGB(255,255,255)
    coordBtn.TextScaled = true
    coordBtn.Font = Enum.Font.Gotham
    coordBtn.Text = "Coords: 0,0,0"
    coordBtn.Parent = entry
    styleUI(coordBtn, 8, false)

    -- Teleport
    nameBtn.MouseButton1Click:Connect(function()
        local myChar = player.Character or player.CharacterAdded:Wait()
        local hrp = myChar:WaitForChild("HumanoidRootPart")
        local targetChar = plr.Character
        if targetChar and targetChar:FindFirstChild("HumanoidRootPart") then
            hrp.CFrame = targetChar.HumanoidRootPart.CFrame + Vector3.new(0,3,0)
        end
    end)

    -- Copy Coords
    coordBtn.MouseButton1Click:Connect(function()
        local targetChar = plr.Character
        if targetChar and targetChar:FindFirstChild("HumanoidRootPart") then
            local pos = targetChar.HumanoidRootPart.Position
            local coords = string.format("%.1f, %.1f, %.1f", pos.X, pos.Y, pos.Z)
            if setclipboard then setclipboard(coords) end
        end
    end)

    -- Update Koords
    task.spawn(function()
        while entry.Parent do
            local targetChar = plr.Character
            if targetChar and targetChar:FindFirstChild("HumanoidRootPart") then
                local pos = targetChar.HumanoidRootPart.Position
                coordBtn.Text = string.format("Coords: %.0f, %.0f, %.0f", pos.X, pos.Y, pos.Z)
            else
                coordBtn.Text = "Coords: N/A"
            end
            task.wait(0.5)
        end
    end)

    -- Cleanup
    plr.AncestryChanged:Connect(function(_, parent)
        if not parent then entry:Destroy() end
    end)
end

-- Spieler laden
for _, plr in ipairs(players:GetPlayers()) do
    createPlayerEntry(plr)
end
players.PlayerAdded:Connect(createPlayerEntry)

-- Tabs Umschalten
tabPlayers.MouseButton1Click:Connect(function()
    playerPage.Visible = true
    coordPage.Visible = false
end)
tabCoords.MouseButton1Click:Connect(function()
    playerPage.Visible = false
    coordPage.Visible = true
end)

-- Teleport via Koordinaten
local function teleportToCoords()
    local input = coordBox.Text
    local parts = {}
    for value in string.gmatch(input, "([^, ]+)") do
        table.insert(parts, tonumber(value))
    end
    if #parts == 3 then
        local x,y,z = parts[1], parts[2], parts[3]
        local char = player.Character or player.CharacterAdded:Wait()
        local hrp = char:WaitForChild("HumanoidRootPart")
        hrp.CFrame = CFrame.new(x,y,z)
    else
        coordBox.Text = "❌ Ungültige Eingabe!"
        task.wait(1.5)
        coordBox.Text = ""
    end
end

tpBtn.MouseButton1Click:Connect(teleportToCoords)

-- Close Button
closeBtn.MouseButton1Click:Connect(function()
    frame.Visible = false
end)

-- R_CTRL Toggle (von L_CTRL geändert)
userInput.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.RightControl then
        frame.Visible = not frame.Visible
    end
end)

-- T-Taste für Teleport (wenn im Coord-Tab)
userInput.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.T then
        if coordPage.Visible then
            teleportToCoords()
        end
    end
end)

-- Eigene Koordinaten Updater
task.spawn(function()
    while gui.Parent do
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local pos = char.HumanoidRootPart.Position
            myCoords.Text = string.format("Coords: %.1f, %.1f, %.1f", pos.X, pos.Y, pos.Z)
        else
            myCoords.Text = "Coords: N/A"
        end
        task.wait(0.5)
    end
end)

-- Klick auf eigene Koords = kopieren
myCoords.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard(myCoords.Text:gsub("Coords: ", ""))
    end
end)

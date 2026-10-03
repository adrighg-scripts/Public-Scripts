local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera

local player = Players.LocalPlayer
local running = true

-- 🟥 Rewind System
local rewindTime = 3
local positionHistory = {}

-- Roter Marker
local marker = Instance.new("Part")
marker.Size = Vector3.new(10, 2, 10)
marker.Anchored = true
marker.CanCollide = false
marker.BrickColor = BrickColor.new("Bright red")
marker.Transparency = 0
marker.Shape = Enum.PartType.Ball
marker.Parent = Workspace

-- Positionen sammeln
RunService.Heartbeat:Connect(function()
    local char = player.Character
    if char then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            table.insert(positionHistory, {
                time = tick(),
                cframe = hrp.CFrame
            })
            while #positionHistory > 0 and tick() - positionHistory[1].time > rewindTime do
                table.remove(positionHistory, 1)
            end
            if #positionHistory > 0 then
                marker.Position = positionHistory[1].cframe.Position
            end
        end
    end
end)

-- 🟥 R / E → Rewind
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.R or input.KeyCode == Enum.KeyCode.E then
        local char = player.Character
        if char and #positionHistory > 0 then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = positionHistory[1].cframe
            end
        end
    end
end)

-- 🟦 Spieler suchen (nächster zur Bildschirmmitte)
local function getClosestEnemyToScreenCenter(maxDistance)
    local closestPlayer = nil
    local smallestDist = math.huge
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local myChar = player.Character
    if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return nil end

    for _, otherPlayer in ipairs(Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local humanoid = otherPlayer.Character:FindFirstChild("Humanoid")
            if humanoid and humanoid.Health > 0 then
                local dist = (myChar.HumanoidRootPart.Position - otherPlayer.Character.HumanoidRootPart.Position).Magnitude
                if dist <= maxDistance then
                    local head = otherPlayer.Character:FindFirstChild("Head")
                    if head then
                        local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
                        if onScreen then
                            local distFromCenter = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
                            if distFromCenter < smallestDist then
                                smallestDist = distFromCenter
                                closestPlayer = otherPlayer
                            end
                        end
                    end
                end
            end
        end
    end
    return closestPlayer
end

-- 🟩 Kamera-Lock Variablen
local cameraLockedTarget = nil
local cameraConn = nil

local function startCameraLock(targetHead)
    cameraLockedTarget = targetHead
    Camera.CameraType = Enum.CameraType.Scriptable

    if cameraConn then cameraConn:Disconnect() end
    cameraConn = RunService.RenderStepped:Connect(function()
        if cameraLockedTarget and cameraLockedTarget.Parent and cameraLockedTarget:IsDescendantOf(Workspace) then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, cameraLockedTarget.Position)
        else
            stopCameraLock()
        end
    end)
end

function stopCameraLock()
    cameraLockedTarget = nil
    if cameraConn then
        cameraConn:Disconnect()
        cameraConn = nil
    end
    Camera.CameraType = Enum.CameraType.Custom
end

-- Kamera-Lock abbrechen bei Maus oder Taste
UserInputService.InputBegan:Connect(function()
    if cameraLockedTarget then stopCameraLock() end
end)
UserInputService.InputChanged:Connect(function(input)
    if cameraLockedTarget and input.UserInputType == Enum.UserInputType.MouseMovement then
        stopCameraLock()
    end
end)

-- 🟩 F → Teleport + Kamera-Lock
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.F and running then
        local target = getClosestEnemyToScreenCenter(500)
        if target and target.Character and player.Character then
            local targetHRP = target.Character:FindFirstChild("HumanoidRootPart")
            local targetHead = target.Character:FindFirstChild("Head")
            local myHRP = player.Character:FindFirstChild("HumanoidRootPart")

            if targetHRP and myHRP then
                -- Teleport hinter Spieler
                local backOffset = targetHRP.CFrame.LookVector * -3
                local newPos = targetHRP.Position + backOffset
                myHRP.CFrame = CFrame.new(newPos, targetHRP.Position)

                -- Kamera auf Kopf fixieren
                if targetHead then
                    startCameraLock(targetHead)
                end

                StarterGui:SetCore("SendNotification", {
                    Title = "Teleported",
                    Text = "Zu " .. target.Name .. " teleportiert",
                    Duration = 3
                })
            end
        end
    end
end)

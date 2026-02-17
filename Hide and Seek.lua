local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- === สร้างเมนู GUI (Hide and Seek by most) ===
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MostHub"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 220, 0, 320)
Frame.Position = UDim2.new(0, 50, 0, 50)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Frame.BackgroundTransparency = 0.3 
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui
Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 15)
local stroke = Instance.new("UIStroke", Frame)
stroke.Color = Color3.new(1, 1, 1)
stroke.Transparency = 0.8

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -70, 0, 30)
titleLabel.Position = UDim2.new(0, 15, 0, 5)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "FM HUB"
titleLabel.TextColor3 = Color3.new(1, 1, 1)
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextSize = 16
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = Frame

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 25, 0, 25)
closeBtn.Position = UDim2.new(1, -33, 0, 8)
closeBtn.Text = "X"
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Parent = Frame
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 5)

local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, 0, 1, -45)
ContentFrame.Position = UDim2.new(0, 0, 0, 45)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = Frame
local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = ContentFrame
UIListLayout.Padding = UDim.new(0, 6)
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local function createBtn(text, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 190, 0, 34)
    btn.Text = text
    btn.BackgroundColor3 = color
    btn.BackgroundTransparency = 0.2
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 13
    btn.Parent = ContentFrame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    return btn
end

-- ปุ่มเมนู
local espBtn = createBtn("ESP: OFF", Color3.fromRGB(200, 60, 60))
local autoCreditBtn = createBtn("Auto Credit: OFF", Color3.fromRGB(200, 60, 60))
local selectPlayerBtn = createBtn("Select player: -", Color3.fromRGB(60, 60, 60))
local followBtn = createBtn("Follow Player: OFF", Color3.fromRGB(200, 60, 60))
local tpPlayerBtn = createBtn("TP to Player", Color3.fromRGB(100, 50, 180))
local tpPosBtn = createBtn("Win 100%", Color3.fromRGB(180, 140, 20))

-- ตัวแปรสถานะ
local running = true
_G.ESP_Enabled = false
_G.AutoFarm = false
_G.FollowEnabled = false
local targetPlayer = nil
local playerIndex = 1
local skeletons = {}

-- ฟังก์ชันล้าง Drawing ทิ้งถาวร
local function hardClearESP()
    for p, s in pairs(skeletons) do
        if s.H2T then s.H2T:Remove() end
        if s.DistInfo then s.DistInfo:Remove() end -- ลบระยะทาง
    end
    skeletons = {}
end

-- ระบบควบคุมปุ่ม
closeBtn.MouseButton1Click:Connect(function()
    running = false
    _G.ESP_Enabled = false
    hardClearESP()
    ScreenGui:Destroy()
end)

espBtn.MouseButton1Click:Connect(function()
    _G.ESP_Enabled = not _G.ESP_Enabled
    espBtn.Text = _G.ESP_Enabled and "ESP : ON" or "ESP : OFF"
    espBtn.BackgroundColor3 = _G.ESP_Enabled and Color3.fromRGB(60, 200, 60) or Color3.fromRGB(200, 60, 60)
    if not _G.ESP_Enabled then hardClearESP() end
end)

selectPlayerBtn.MouseButton1Click:Connect(function()
    local others = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then table.insert(others, p) end
    end
    if #others > 0 then
        if playerIndex > #others then playerIndex = 1 end
        targetPlayer = others[playerIndex]
        selectPlayerBtn.Text = "Player: " .. (targetPlayer.DisplayName or targetPlayer.Name)
        playerIndex = playerIndex + 1
    end
end)

followBtn.MouseButton1Click:Connect(function()
    if not targetPlayer then return end
    _G.FollowEnabled = not _G.FollowEnabled
    followBtn.Text = _G.FollowEnabled and "Follow Player: ON" or "Follow Player: OFF"
    followBtn.BackgroundColor3 = _G.FollowEnabled and Color3.fromRGB(60, 200, 60) or Color3.fromRGB(200, 60, 60)
end)

autoCreditBtn.MouseButton1Click:Connect(function()
    _G.AutoFarm = not _G.AutoFarm
    autoCreditBtn.Text = _G.AutoFarm and "Auto Credit: ON" or "Auto Credit: OFF"
    autoCreditBtn.BackgroundColor3 = _G.AutoFarm and Color3.fromRGB(60, 200, 60) or Color3.fromRGB(200, 60, 60)
end)

tpPlayerBtn.MouseButton1Click:Connect(function()
    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
    end
end)

tpPosBtn.MouseButton1Click:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(307, 162, -28.4)
    end
end)

-- Main Loop
RunService.RenderStepped:Connect(function()
    if not running then return end
    
    if _G.ESP_Enabled then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local head = p.Character:FindFirstChild("Head")
                local torso = p.Character:FindFirstChild("Torso") or p.Character:FindFirstChild("UpperTorso")
                local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                
                if head and torso and hrp then
                    local hP, hO = Camera:WorldToViewportPoint(head.Position)
                    local tP, tO = Camera:WorldToViewportPoint(torso.Position)
                    
                    if hO and tO then
                        if not skeletons[p] then
                            skeletons[p] = {
                                H2T = Drawing.new("Line"),
                                DistInfo = Drawing.new("Text") -- สร้างข้อความระยะทาง
                            }
                            skeletons[p].H2T.Thickness = 2
                            skeletons[p].H2T.Color = Color3.new(1, 0, 0)
                            skeletons[p].DistInfo.Size = 16
                            skeletons[p].DistInfo.Color = Color3.new(1, 0, 0)
                            skeletons[p].DistInfo.Outline = true
                            skeletons[p].DistInfo.Center = true
                        end
                        
                        local s = skeletons[p]
                        s.H2T.From = Vector2.new(hP.X, hP.Y); s.H2T.To = Vector2.new(tP.X, tP.Y); s.H2T.Visible = true
                        
                        -- คำนวณระยะทาง
                        local distance = 0
                        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            distance = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - hrp.Position).Magnitude)
                        end
                        
                        s.DistInfo.Position = Vector2.new(hP.X, hP.Y - 35); 
                        s.DistInfo.Text = "(" .. distance .. "m)"; -- **แก้ไขจุดนี้**: แสดงแค่เมตร
                        s.DistInfo.Visible = true
                    else
                        if skeletons[p] then skeletons[p].H2T.Visible = false; skeletons[p].DistInfo.Visible = false end
                    end
                end
            end
        end
        -- ลบคนออก
        for p, s in pairs(skeletons) do
            if not p.Parent then s.H2T:Remove(); s.DistInfo:Remove(); skeletons[p] = nil end
        end
    else
        if next(skeletons) ~= nil then hardClearESP() end
    end

    -- Follow Flight
    if _G.FollowEnabled and targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 5, 5)
        LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
    end
end)

-- Auto Farm
task.spawn(function()
    while running do
        task.wait(0.3)
        if _G.AutoFarm and LocalPlayer.Character then
            local gameObjects = workspace:FindFirstChild("GameObjects") or workspace
            for _, obj in pairs(gameObjects:GetDescendants()) do
                if not _G.AutoFarm then break end
                if obj.Name:lower():find("credit") then
                    local t = obj:IsA("BasePart") and obj or (obj:IsA("Model") and obj.PrimaryPart)
                    if t then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = t.CFrame * CFrame.new(0, 2, 0)
                        task.wait(0.3)
                    end
                end
            end
        end
    end
end)

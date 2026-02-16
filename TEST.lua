local players = game:GetService("Players")
local runService = game:GetService("RunService")
local localPlayer = players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")

local espEnabled = false -- เริ่มต้นที่ปิดไว้
local maxDistance = 9999999 

-- สร้าง GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ESPGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = playerGui

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 100, 0, 40)
button.Position = UDim2.new(0, 10, 0, 10)
button.Text = "ESP: OFF"
button.BackgroundColor3 = Color3.new(1, 0, 0)
button.TextColor3 = Color3.new(1, 1, 1)
button.Parent = ScreenGui

-- 

-- ฟังก์ชันจัดการ Highlight
local function applyESP(character)
    if not character then return end
    local highlight = character:FindFirstChild("ESPHighlight")
    
    if espEnabled then
        if not highlight then
            highlight = Instance.new("Highlight")
            highlight.Name = "ESPHighlight"
            highlight.FillColor = Color3.new(1, 0, 0)
            highlight.OutlineColor = Color3.new(1, 1, 1)
            highlight.FillTransparency = 0.5
            highlight.Adornee = character
            highlight.Parent = character
        end
        highlight.Enabled = true
    else
        if highlight then
            highlight.Enabled = false -- ปิดการมองเห็นแทนการ Destroy เพื่อประหยัดทรัพยากร
        end
    end
end

-- อัปเดต ESP ให้ทุกคน
local function updateAllESP()
    for _, player in pairs(players:GetPlayers()) do
        if player ~= localPlayer and player.Character then
            applyESP(player.Character)
        end
    end
end

-- ปุ่มเปิด/ปิด
button.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    button.Text = espEnabled and "ESP: ON" or "ESP: OFF"
    button.BackgroundColor3 = espEnabled and Color3.new(0, 0.8, 0) or Color3.new(1, 0, 0)
    updateAllESP()
end)

-- ตรวจสอบเมื่อตัวละครเกิดใหม่
players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        task.wait(0.5) -- รอให้ตัวละครโหลดเสร็จสมบูรณ์
        applyESP(character)
    end)
end)

-- จัดการคนที่อยู่ในเซิร์ฟเวอร์อยู่แล้ว
for _, player in pairs(players:GetPlayers()) do
    if player ~= localPlayer then
        player.CharacterAdded:Connect(function(character)
            applyESP(character)
        end)
        if player.Character then applyESP(player.Character) end
    end
end

-- ระบบลากปุ่ม (Drag System - แบบย่อให้เสถียรขึ้น)
local dragging, dragInput, dragStart, startPos
button.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = button.Position
    end
end)
button.InputChanged:Connect(function

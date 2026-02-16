local players = game:GetService("Players")
local localPlayer = players.LocalPlayer

-- สร้าง GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = localPlayer:WaitForChild("PlayerGui")

local espButton = Instance.new("TextButton")
local hitboxButton = Instance.new("TextButton")
local toggleButton = Instance.new("TextButton") -- ปุ่มย่อ
local buttonSize = UDim2.new(0, 150, 0, 50)
local toggleButtonSize = UDim2.new(0, 50, 0, 50) -- ขนาดปุ่มย่อ
local espEnabled = false
local hitboxEnabled = false
local buttonsVisible = true -- สถานะการแสดงปุ่ม

-- ฟังก์ชันในการสร้างปุ่ม
local function createButton(button, text, position, size)
    button.Parent = ScreenGui
    button.Size = size or buttonSize
    button.Position = position
    button.Text = text
    button.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    button.TextColor3 = Color3.new(1, 1, 1)

    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
    end)

    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    end)
end

createButton(espButton, "Toggle ESP", UDim2.new(0.5, -75, 0.1, 0))
createButton(hitboxButton, "Toggle Hitbox", UDim2.new(0.5, -75, 0.2, 0))

-- ปรับพื้นหลังปุ่มย่อให้โปร่งใส
toggleButton.BackgroundTransparency = 1
createButton(toggleButton, "☰", UDim2.new(0, 10, 0.1, 0), toggleButtonSize) -- ปุ่มย่ออยู่ซ้ายมือ

-- ฟังก์ชันเปิด/ปิดปุ่ม
toggleButton.MouseButton1Click:Connect(function()
    buttonsVisible = not buttonsVisible
    espButton.Visible = buttonsVisible
    hitboxButton.Visible = buttonsVisible
end)

-- ฟังก์ชันสำหรับสร้าง ESP
local function createESP(player)
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and not player.Character:FindFirstChildOfClass("Highlight") then
        local highlight = Instance.new("Highlight")
        highlight.Adornee = player.Character
        highlight.FillColor = Color3.new(1, 0, 0) -- สีแดง
        highlight.OutlineColor = Color3.new(1, 0, 0) -- สีแดง
        highlight.FillTransparency = 0.5
        highlight.Parent = player.Character
    end
end

-- ฟังก์ชันสำหรับลบ ESP
local function removeESP(player)
    local highlight = player.Character and player.Character:FindFirstChildOfClass("Highlight")
    if highlight then highlight:Destroy() end
end

-- ฟังก์ชันเปิด/ปิด ESP
espButton.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    for _, player in pairs(players:GetPlayers()) do
        if player ~= localPlayer then
            if espEnabled then
                createESP(player)
            else
                removeESP(player)
            end
        end
    end
end)

-- ฟังก์ชันสำหรับขยาย Hitbox
local function enlargeHitbox(player)
    local humanoidRootPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if humanoidRootPart then
        humanoidRootPart.Size = Vector3.new(15, 15, 15)
        humanoidRootPart.Transparency = 0.7
        humanoidRootPart.CanCollide = true
        humanoidRootPart.Massless = true
    end
end

-- ฟังก์ชันสำหรับรีเซ็ต Hitbox
local function resetHitbox(player)
    local humanoidRootPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if humanoidRootPart then
        humanoidRootPart.Size = Vector3.new(2, 2, 1)
        humanoidRootPart.Transparency = 1
        humanoidRootPart.CanCollide = true
        humanoidRootPart.Massless = false
    end
end

-- ฟังก์ชันเปิด/ปิด Hitbox
hitboxButton.MouseButton1Click:Connect(function()
    hitboxEnabled = not hitboxEnabled
    for _, player in pairs(players:GetPlayers()) do
        if player ~= localPlayer then
            if hitboxEnabled then
                enlargeHitbox(player)
            else
                resetHitbox(player)
            end
        end
    end
end)

-- ฟังก์ชันสำหรับผู้เล่นที่เข้าร่วมเกม
local function onPlayerAdded(player)
    player.CharacterAdded:Connect(function()
        createESP(player)
        enlargeHitbox(player)
    end)
end

-- ตรวจสอบผู้เล่นที่เข้าร่วมเกม
for _, player in pairs(players:GetPlayers()) do
    if player ~= localPlayer then
        if player.Character then
            createESP(player)
            enlargeHitbox(player)
        end
        onPlayerAdded(player) -- เชื่อมโยงฟังก์ชันสำหรับผู้เล่นที่เข้าร่วม
    end
end

-- เชื่อมโยงฟังก์ชันกับผู้เล่นที่เข้าร่วมใหม่
players.PlayerAdded:Connect(onPlayerAdded)

-- ลบ ESP และรีเซ็ต Hitbox เมื่อผู้เล่นออกจากเกม
players.PlayerRemoving:Connect(function(player)
    removeESP(player)
    resetHitbox(player)
end)

-- ปิดการทำงานทั้งหมดเมื่อเริ่มเกม
local function disableAll()
    espEnabled = false
    hitboxEnabled = false
    for _, player in pairs(players:GetPlayers()) do
        if player ~= localPlayer then
            removeESP(player)
            resetHitbox(player)
        end
    end
end

disableAll() -- เรียกใช้ฟังก์ชันเพื่อปิดการทำงานทั้งหมดเมื่อเริ่มเกม

local players = game:GetService("Players")
local localPlayer = players.LocalPlayer
local humanoid = localPlayer.Character and localPlayer.Character:FindFirstChild("Humanoid")

-- สร้าง GUI
local ScreenGui = Instance.new("ScreenGui")
local SliderFrame = Instance.new("Frame")
local Slider = Instance.new("TextButton")
local SpeedLabel = Instance.new("TextLabel")

ScreenGui.Parent = game.CoreGui

-- ตั้งค่าเฟรมของ Slider
SliderFrame.Parent = ScreenGui
SliderFrame.Size = UDim2.new(0, 300, 0, 50)
SliderFrame.Position = UDim2.new(0.5, -150, 0, 50)
SliderFrame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)

-- ตั้งค่า Slider
Slider.Parent = SliderFrame
Slider.Size = UDim2.new(0, 20, 1, 0)
Slider.Position = UDim2.new(0, 0, 0, 0)
Slider.BackgroundColor3 = Color3.new(1, 0, 0)
Slider.Text = ""

-- ตั้งค่าป้ายแสดงความเร็ว
SpeedLabel.Parent = ScreenGui
SpeedLabel.Size = UDim2.new(0, 100, 0, 50)
SpeedLabel.Position = UDim2.new(0.5, -50, 0, 110)
SpeedLabel.BackgroundColor3 = Color3.new(1, 1, 1)
SpeedLabel.TextColor3 = Color3.new(0, 0, 0)
SpeedLabel.Text = "Speed: 16"

-- ฟังก์ชันในการปรับ WalkSpeed ตามตำแหน่งของ Slider
local function updateWalkSpeed()
    local newWalkSpeed = 16 + ((Slider.Position.X.Scale) * 84) -- ตั้งค่า WalkSpeed ระหว่าง 16-100
    SpeedLabel.Text = "Speed: " .. math.floor(newWalkSpeed) -- อัปเดตป้ายแสดงความเร็ว
    if humanoid then
        humanoid.WalkSpeed = newWalkSpeed
    end
end

-- ฟังก์ชันที่ใช้สำหรับการลาก Slider
local dragging = false
Slider.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
    end
end)

Slider.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local scaleX = math.clamp((input.Position.X - SliderFrame.AbsolutePosition.X) / SliderFrame.AbsoluteSize.X, 0, 1)
        Slider.Position = UDim2.new(scaleX, 0, 0, 0)
        updateWalkSpeed()
    end
end)

-- ปรับความเร็วเมื่อผู้เล่นสร้างตัวละครใหม่
localPlayer.CharacterAdded:Connect(function(character)
    humanoid = character:WaitForChild("Humanoid")
    updateWalkSpeed()
end)

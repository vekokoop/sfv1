-- Street Life Remastered - Pro Edition V3 (Visual ESP + FOV Controls)
if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- تنضيف الرسم القديم
if Drawing then
    for _, v in pairs(Drawing:GetDrawings()) do
        if v then v:Remove() end
    end
end

local GUI_Parent = gethui and gethui() or CoreGui
if GUI_Parent:FindFirstChild("StreetLifeProV3") then GUI_Parent.StreetLifeProV3:Destroy() end

-- ==========================================
-- 1. دوائر الـ FOV (الرسم)
-- ==========================================
local SilentFOV_Radius = 120
local AimbotFOV_Radius = 150

local silentFovCircle = Drawing.new("Circle")
silentFovCircle.Visible = false
silentFovCircle.Radius = SilentFOV_Radius
silentFovCircle.Filled = false
silentFovCircle.Color = Color3.fromRGB(0, 255, 100) -- أخضر
silentFovCircle.Thickness = 2
silentFovCircle.Transparency = 0.8

local aimbotFovCircle = Drawing.new("Circle")
aimbotFovCircle.Visible = false
aimbotFovCircle.Radius = AimbotFOV_Radius
aimbotFovCircle.Filled = false
aimbotFovCircle.Color = Color3.fromRGB(255, 50, 50) -- أحمر
aimbotFovCircle.Thickness = 2
aimbotFovCircle.Transparency = 0.8

-- ==========================================
-- 2. بناء الواجهة (UI)
-- ==========================================
local ScreenGui = Instance.new("ScreenGui"); ScreenGui.Name = "StreetLifeProV3"; ScreenGui.Parent = GUI_Parent; ScreenGui.ResetOnSpawn = false
local FloatingIcon = Instance.new("TextButton"); FloatingIcon.Parent = ScreenGui; FloatingIcon.BackgroundColor3 = Color3.fromRGB(20, 20, 25); FloatingIcon.Position = UDim2.new(0, 35, 0, 150); FloatingIcon.Size = UDim2.new(0, 55, 0, 55); FloatingIcon.Font = Enum.Font.SourceSansBold; FloatingIcon.Text = "🔥"; FloatingIcon.TextColor3 = Color3.fromRGB(0, 255, 100); FloatingIcon.TextSize = 28
local IconCorner = Instance.new("UICorner"); IconCorner.CornerRadius = UDim.new(1, 0); IconCorner.Parent = FloatingIcon
local IconStroke = Instance.new("UIStroke"); IconStroke.Color = Color3.fromRGB(0, 255, 100); IconStroke.Thickness = 2.5; IconStroke.Parent = FloatingIcon

local MainFrame = Instance.new("Frame"); MainFrame.Name = "MainFrame"; MainFrame.Parent = ScreenGui; MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20); MainFrame.Position = UDim2.new(0.5, -210, 0.5, -230); MainFrame.Size = UDim2.new(0, 420, 0, 460); MainFrame.Visible = false
local MainCorner = Instance.new("UICorner"); MainCorner.CornerRadius = UDim.new(0, 16); MainCorner.Parent = MainFrame
local MainStroke = Instance.new("UIStroke"); MainStroke.Color = Color3.fromRGB(0, 255, 100); MainStroke.Thickness = 2; MainStroke.Parent = MainFrame

local TopBar = Instance.new("Frame"); TopBar.Parent = MainFrame; TopBar.BackgroundColor3 = Color3.fromRGB(22, 22, 30); TopBar.Size = UDim2.new(1, 0, 0, 50)
local TopCorner = Instance.new("UICorner"); TopCorner.CornerRadius = UDim.new(0, 16); TopCorner.Parent = TopBar
local Title = Instance.new("TextLabel"); Title.Parent = TopBar; Title.BackgroundTransparency = 1; Title.Position = UDim2.new(0, 20, 0, 0); Title.Size = UDim2.new(0.7, 0, 1, 0); Title.Font = Enum.Font.SourceSansBold; Title.Text = "STREET LIFE | Pro V3"; Title.TextColor3 = Color3.fromRGB(0, 255, 100); Title.TextSize = 16; Title.TextXAlignment = Enum.TextXAlignment.Left
local CloseXBtn = Instance.new("TextButton"); CloseXBtn.Parent = TopBar; CloseXBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50); CloseXBtn.Position = UDim2.new(1, -40, 0.5, -14); CloseXBtn.Size = UDim2.new(0, 28, 0, 28); CloseXBtn.Font = Enum.Font.SourceSansBold; CloseXBtn.Text = "X"; CloseXBtn.TextColor3 = Color3.fromRGB(255, 255, 255); CloseXBtn.TextSize = 14; CloseXBtn.AutoButtonColor = false
local XCorner = Instance.new("UICorner"); XCorner.CornerRadius = UDim.new(1, 0); XCorner.Parent = CloseXBtn

local TabsBar = Instance.new("Frame"); TabsBar.Parent = MainFrame; TabsBar.BackgroundTransparency = 1; TabsBar.Position = UDim2.new(0, 10, 0, 60); TabsBar.Size = UDim2.new(1, -20, 0, 35)
local TabsLayout = Instance.new("UIListLayout"); TabsLayout.Parent = TabsBar; TabsLayout.FillDirection = Enum.FillDirection.Horizontal; TabsLayout.SortOrder = Enum.SortOrder.LayoutOrder; TabsLayout.Padding = UDim.new(0, 8)
local ContentContainer = Instance.new("Frame"); ContentContainer.Parent = MainFrame; ContentContainer.BackgroundTransparency = 1; ContentContainer.Position = UDim2.new(0, 10, 0, 100); ContentContainer.Size = UDim2.new(1, -20, 1, -110)

local tabs = {}
local function createTabContent(name)
    local scrolling = Instance.new("ScrollingFrame"); scrolling.Name = name .. "Content"; scrolling.Parent = ContentContainer; scrolling.BackgroundTransparency = 1; scrolling.Size = UDim2.new(1, 0, 1, 0); scrolling.CanvasSize = UDim2.new(0, 0, 0, 0); scrolling.ScrollBarThickness = 4; scrolling.Visible = false
    local list = Instance.new("UIListLayout"); list.Parent = scrolling; list.HorizontalAlignment = Enum.HorizontalAlignment.Center; list.SortOrder = Enum.SortOrder.LayoutOrder; list.Padding = UDim.new(0, 10)
    list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() scrolling.CanvasSize = UDim2.new(0, 0, 0, list.AbsoluteContentSize.Y + 15) end)
    return scrolling
end

local function createTabButton(name, iconText)
    local btn = Instance.new("TextButton"); btn.Parent = TabsBar; btn.BackgroundColor3 = Color3.fromRGB(25, 25, 35); btn.Size = UDim2.new(0, 90, 1, 0); btn.Font = Enum.Font.SourceSansBold; btn.Text = iconText .. " " .. name; btn.TextColor3 = Color3.fromRGB(150, 150, 150); btn.TextSize = 13; btn.AutoButtonColor = false
    local corner = Instance.new("UICorner"); corner.CornerRadius = UDim.new(0, 8); corner.Parent = btn
    local stroke = Instance.new("UIStroke"); stroke.Color = Color3.fromRGB(45, 45, 60); stroke.Thickness = 1; stroke.Parent = btn
    local content = createTabContent(name)
    btn.Activated:Connect(function()
        for _, t in pairs(tabs) do t.content.Visible = false; t.btn.BackgroundColor3 = Color3.fromRGB(25, 25, 35); t.btn.TextColor3 = Color3.fromRGB(150, 150, 150); t.stroke.Color = Color3.fromRGB(45, 45, 60) end
        content.Visible = true; btn.BackgroundColor3 = Color3.fromRGB(35, 35, 50); btn.TextColor3 = Color3.fromRGB(0, 255, 100); stroke.Color = Color3.fromRGB(0, 255, 100)
    end)
    tabs[name] = {btn = btn, content = content, stroke = stroke}
    return content
end

local combatTab = createTabButton("Combat", "🎯")
local visualsTab = createTabButton("Visuals", "👁️")
local utilityTab = createTabButton("Utility", "📦")
tabs["Combat"].content.Visible = true; tabs["Combat"].btn.BackgroundColor3 = Color3.fromRGB(35, 35, 50); tabs["Combat"].btn.TextColor3 = Color3.fromRGB(0, 255, 100); tabs["Combat"].stroke.Color = Color3.fromRGB(0, 255, 100)

local function createFeatureToggle(parentTab, name, desc, callback)
    local btn = Instance.new("TextButton"); btn.Parent = parentTab; btn.BackgroundColor3 = Color3.fromRGB(22, 22, 30); btn.Size = UDim2.new(0.95, 0, 0, 50); btn.Text = ""; btn.AutoButtonColor = false
    local corner = Instance.new("UICorner"); corner.CornerRadius = UDim.new(0, 10); corner.Parent = btn
    local stroke = Instance.new("UIStroke"); stroke.Color = Color3.fromRGB(45, 45, 60); stroke.Thickness = 1.2; stroke.Parent = btn
    local nameLabel = Instance.new("TextLabel"); nameLabel.Parent = btn; nameLabel.BackgroundTransparency = 1; nameLabel.Position = UDim2.new(0, 15, 0, 8); nameLabel.Size = UDim2.new(0.7, 0, 0, 16); nameLabel.Font = Enum.Font.SourceSansBold; nameLabel.Text = name; nameLabel.TextColor3 = Color3.fromRGB(240, 240, 240); nameLabel.TextSize = 14; nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    local descLabel = Instance.new("TextLabel"); descLabel.Parent = btn; descLabel.BackgroundTransparency = 1; descLabel.Position = UDim2.new(0, 15, 0, 26); descLabel.Size = UDim2.new(0.7, 0, 0, 16); descLabel.Font = Enum.Font.SourceSans; descLabel.Text = desc; descLabel.TextColor3 = Color3.fromRGB(120, 120, 120); descLabel.TextSize = 11; descLabel.TextXAlignment = Enum.TextXAlignment.Left
    local statusBox = Instance.new("Frame"); statusBox.Parent = btn; statusBox.BackgroundColor3 = Color3.fromRGB(50, 50, 65); statusBox.Position = UDim2.new(1, -40, 0.5, -12); statusBox.Size = UDim2.new(0, 24, 0, 24)
    local boxCorner = Instance.new("UICorner"); boxCorner.CornerRadius = UDim.new(0, 6); boxCorner.Parent = statusBox
    local state = false
    btn.Activated:Connect(function()
        state = not state
        if state then statusBox.BackgroundColor3 = Color3.fromRGB(0, 255, 100); stroke.Color = Color3.fromRGB(0, 255, 100) else statusBox.BackgroundColor3 = Color3.fromRGB(50, 50, 65); stroke.Color = Color3.fromRGB(45, 45, 60) end
        callback(state)
    end)
    return btn
end

-- دوال أزرار الـ FOV (تكبير وتصغير)
local function createFovControl(parentTab, labelText, onMinus, onPlus)
    local frame = Instance.new("Frame"); frame.Parent = parentTab; frame.BackgroundColor3 = Color3.fromRGB(22, 22, 30); frame.Size = UDim2.new(0.95, 0, 0, 45)
    local corner = Instance.new("UICorner"); corner.CornerRadius = UDim.new(0, 10); corner.Parent = frame
    local stroke = Instance.new("UIStroke"); stroke.Color = Color3.fromRGB(45, 45, 60); stroke.Thickness = 1.2; stroke.Parent = frame
    local label = Instance.new("TextLabel"); label.Parent = frame; label.BackgroundTransparency = 1; label.Position = UDim2.new(0, 15, 0, 0); label.Size = UDim2.new(0.5, 0, 1, 0); label.Font = Enum.Font.SourceSansBold; label.Text = labelText; label.TextColor3 = Color3.fromRGB(200, 200, 200); label.TextSize = 14; label.TextXAlignment = Enum.TextXAlignment.Left
    
    local minusBtn = Instance.new("TextButton"); minusBtn.Parent = frame; minusBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 48); minusBtn.Position = UDim2.new(1, -80, 0.5, -12); minusBtn.Size = UDim2.new(0, 28, 0, 24); minusBtn.Font = Enum.Font.SourceSansBold; minusBtn.Text = "-"; minusBtn.TextColor3 = Color3.fromRGB(255, 255, 255); minusBtn.TextSize = 18
    local mCorner = Instance.new("UICorner"); mCorner.CornerRadius = UDim.new(0, 6); mCorner.Parent = minusBtn
    
    local plusBtn = Instance.new("TextButton"); plusBtn.Parent = frame; plusBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 48); plusBtn.Position = UDim2.new(1, -45, 0.5, -12); plusBtn.Size = UDim2.new(0, 28, 0, 24); plusBtn.Font = Enum.Font.SourceSansBold; plusBtn.Text = "+"; plusBtn.TextColor3 = Color3.fromRGB(255, 255, 255); plusBtn.TextSize = 18
    local pCorner = Instance.new("UICorner"); pCorner.CornerRadius = UDim.new(0, 6); pCorner.Parent = plusBtn

    minusBtn.Activated:Connect(function() onMinus(); label.Text = labelText .. ": " .. tostring(math.floor(onMinus())) end)
    plusBtn.Activated:Connect(function() onPlus(); label.Text = labelText .. ": " .. tostring(math.floor(onPlus())) end)
    return frame
end

-- المتغيرات
local silentEnabled, aimbotEnabled, espEnabled, autoFarmEnabled = false, false, false, false
local currentSpeed = 16

createFeatureToggle(combatTab, "Silent Aim", "يصوب تلقائي إذا دخل الهدف الدائرة", function(enabled) silentEnabled = enabled; silentFovCircle.Visible = enabled end)
createFeatureToggle(combatTab, "Aimbot", "يسحب الكاميرا نحو الهدف", function(enabled) aimbotEnabled = enabled; aimbotFovCircle.Visible = enabled end)
createFeatureToggle(visualsTab, "Pro ESP", "مربعات، أسماء، ومسافات", function(enabled) espEnabled = enabled end)
createFeatureToggle(utilityTab, "Auto Farm", "جمع الذهب والقمامة", function(enabled) autoFarmEnabled = enabled end)

-- أزرار التحكم بالـ FOV
createFovControl(combatTab, "Silent FOV", 
    function() SilentFOV_Radius = math.max(20, SilentFOV_Radius - 10); silentFovCircle.Radius = SilentFOV_Radius; return SilentFOV_Radius end,
    function() SilentFOV_Radius = math.min(600, SilentFOV_Radius + 10); silentFovCircle.Radius = SilentFOV_Radius; return SilentFOV_Radius end
)
createFovControl(combatTab, "Aimbot FOV", 
    function() AimbotFOV_Radius = math.max(20, AimbotFOV_Radius - 10); aimbotFovCircle.Radius = AimbotFOV_Radius; return AimbotFOV_Radius end,
    function() AimbotFOV_Radius = math.min(600, AimbotFOV_Radius + 10); aimbotFovCircle.Radius = AimbotFOV_Radius; return AimbotFOV_Radius end
)

-- ==========================================
-- 3. منطق السايلنت أيم والأيم بوت
-- ==========================================
local currentLockedTarget = nil; local cachedSilentTarget = nil

local function getClosestTarget(fovRadius, isAimbot)
    local closest = nil; local shortest = fovRadius
    local center = isAimbot and Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2) or UserInputService:GetMouseLocation()
    
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
            local part = p.Character:FindFirstChild("Head") or p.Character:FindFirstChild("HumanoidRootPart")
            if part then
                local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                    if dist < shortest then shortest = dist; closest = part end
                end
            end
        end
    end
    return closest
end

local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    if silentEnabled and not checkcaller() and (method == "Raycast" or method == "FindPartOnRay") and self == Workspace then
        if cachedSilentTarget and cachedSilentTarget.Parent then
            local args = {...}
            pcall(function()
                if method == "Raycast" and typeof(args[1]) == "Vector3" and typeof(args[2]) == "Vector3" then
                    args[2] = (cachedSilentTarget.Position - args[1]).Unit * args[2].Magnitude
                elseif method == "FindPartOnRay" and typeof(args[1]) == "Ray" then
                    args[1] = Ray.new(args[1].Origin, (cachedSilentTarget.Position - args[1].Origin).Unit * args[1].Direction.Magnitude)
                end
            end)
            return oldNamecall(self, unpack(args))
        end
    end
    return oldNamecall(self, ...)
end)

-- ==========================================
-- 4. نظام ESP الاحترافي (رسم المربعات)
-- ==========================================
local espCache = {}

local function createESP(player)
    if espCache[player] then return end
    espCache[player] = {
        Box = Drawing.new("Square"),
        Name = Drawing.new("Text"),
        Health = Drawing.new("Text"),
        Distance = Drawing.new("Text")
    }
end

local function removeESP(player)
    if espCache[player] then
        for _, drawing in pairs(espCache[player]) do
            if drawing then drawing:Remove() end
        end
        espCache[player] = nil
    end
end

-- تحديث الرسم والأهداف
RunService.RenderStepped:Connect(function()
    local camCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    silentFovCircle.Position = camCenter
    aimbotFovCircle.Position = camCenter

    -- تحديث الأهداف للقتال
    if silentEnabled then cachedSilentTarget = getClosestTarget(SilentFOV_Radius, false) else cachedSilentTarget = nil end
    if aimbotEnabled then
        pcall(function()
            local targetPart = getClosestTarget(AimbotFOV_Radius, true)
            if targetPart then Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, targetPart.Position), 0.3) end
        end)
    end

    -- تحديث الـ ESP
    if espEnabled then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
                if not espCache[p] then createESP(p) end
                local esp = espCache[p]
                local hrp = p.Character.HumanoidRootPart
                local hum = p.Character.Humanoid
                
                local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                local dist = (LocalPlayer.Character.HumanoidRootPart.Position - hrp.Position).Magnitude

                if onScreen and dist < 300 then
                    -- حساب حجم المربع
                    local size = (Camera:WorldToViewportPoint(hrp.Position + Vector3.new(0, 3, 0)).Y - Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0)).Y)
                    local boxPos = Vector2.new(pos.X - size / 2, pos.Y - size / 2)
                    
                    -- رسم المربع
                    esp.Box.Size = Vector2.new(size, size * 1.5)
                    esp.Box.Position = boxPos
                    esp.Box.Color = Color3.fromRGB(255, 50, 50) -- لون أحمر مثل الصورة
                    esp.Box.Thickness = 1.5
                    esp.Box.Visible = true

                    -- رسم الاسم
                    esp.Name.Text = p.Name
                    esp.Name.Size = 14
                    esp.Name.Center = true
                    esp.Name.Outline = true
                    esp.Name.Color = Color3.fromRGB(255, 255, 255)
                    esp.Name.Position = Vector2.new(pos.X, boxPos.Y - 18)
                    esp.Name.Visible = true

                    -- رسم المسافة
                    esp.Distance.Text = "[" .. math.floor(dist) .. "m]"
                    esp.Distance.Size = 12
                    esp.Distance.Center = true
                    esp.Distance.Outline = true
                    esp.Distance.Color = Color3.fromRGB(0, 255, 100)
                    esp.Distance.Position = Vector2.new(pos.X, boxPos.Y + (size * 1.5) + 2)
                    esp.Distance.Visible = true

                    -- رسم الصحة
                    esp.Health.Text = math.floor(hum.Health) .. " HP"
                    esp.Health.Size = 12
                    esp.Health.Center = true
                    esp.Health.Outline = true
                    esp.Health.Color = Color3.fromRGB(0, 255, 0)
                    esp.Health.Position = Vector2.new(pos.X, boxPos.Y + (size * 1.5) + 16)
                    esp.Health.Visible = true
                else
                    for _, v in pairs(esp) do v.Visible = false end
                end
            end
        end
        -- إخفاء ESP للاعبين اللي طلعوا
        for p, esp in pairs(espCache) do
            if not p.Character or not p.Character:FindFirstChild("HumanoidRootPart") or p.Character.Humanoid.Health <= 0 or (LocalPlayer.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude > 300 then
                for _, v in pairs(esp) do v.Visible = false end
            end
        end
    else
        for p, esp in pairs(espCache) do
            for _, v in pairs(esp) do v.Visible = false end
        end
    end
end)

-- ==========================================
-- 5. الأوتو فارم
-- ==========================================
local function getPromptByKeyword(keywords, maxDist)
    local char = LocalPlayer.Character; if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
    local hrp = char.HumanoidRootPart; local closest, shortest = nil, maxDist or 50
    local params = OverlapParams.new(); params.FilterDescendantsInstances = {char}; params.FilterType = Enum.RaycastFilterType.Exclude

    for _, part in pairs(Workspace:GetPartBoundsInRadius(hrp.Position, shortest, params)) do
        local prompt = part:FindFirstChildOfClass("ProximityPrompt")
        if prompt then
            local searchStr = (part.Name .. " " .. prompt.ActionText):lower()
            for _, kw in ipairs(keywords) do
                if searchStr:find(kw) then
                    local dist = (hrp.Position - part.Position).Magnitude
                    if dist < shortest then shortest = dist; closest = {prompt = prompt, part = part} end
                    break
                end
            end
        end
    end
    return closest
end

local isFarming = false
task.spawn(function()
    while task.wait(0.5) do
        if autoFarmEnabled and not isFarming then
            isFarming = true
            task.spawn(function()
                local data = getPromptByKeyword({"gold bar", "search trash", "claim reward"}, 50)
                if data then
                    local char = LocalPlayer.Character
                    if char and char:FindFirstChild("Humanoid") then
                        char.Humanoid:MoveTo(data.part.Position)
                        task.wait(0.5)
                        if (char.HumanoidRootPart.Position - data.part.Position).Magnitude < 10 then
                            data.prompt:InputHoldBegin(); task.wait(data.prompt.HoldDuration + 0.1); data.prompt:InputHoldEnd(); task.wait(1)
                        end
                    end
                end
                isFarming = false
            end)
        end
    end
end)

-- ==========================================
-- 6. حركة الأيقونة والواجهة
-- ==========================================
local dragging, dragStart, startPos
FloatingIcon.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true; dragStart = input.Position; startPos = FloatingIcon.Position end end)
UserInputService.InputChanged:Connect(function(input) if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then local delta = input.Position - dragStart; FloatingIcon.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end)
UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end end)
local function toggleMenu() MainFrame.Visible = not MainFrame.Visible end
FloatingIcon.Activated:Connect(toggleMenu)
CloseXBtn.Activated:Connect(toggleMenu)

print("Street Life Pro V3 - Loaded Successfully!")

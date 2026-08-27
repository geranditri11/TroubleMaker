local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local GuiService = game:GetService("GuiService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ====================================================
-- 1. SETUP MAIN GUI
-- ====================================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ThrowARockGui"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 999
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 220, 0, 250) 
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Parent = screenGui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 8)
frameCorner.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(1, -30, 0, 25)
titleLabel.Position = UDim2.new(0, 10, 0, 5)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Throw a Rock"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextSize = 16
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = mainFrame

local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 20, 0, 20)
closeButton.Position = UDim2.new(1, -25, 0, 5)
closeButton.BackgroundTransparency = 1
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(200, 50, 50)
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextSize = 16
closeButton.Parent = mainFrame

-- WATERMARK
local watermarkLabel = Instance.new("TextLabel")
watermarkLabel.Name = "WatermarkLabel"
watermarkLabel.Size = UDim2.new(0, 80, 0, 16)
watermarkLabel.Position = UDim2.new(1, -90, 1, -18)
watermarkLabel.BackgroundTransparency = 1
watermarkLabel.Text = "By TroubleMaker"
watermarkLabel.TextColor3 = Color3.fromRGB(100, 100, 100)
watermarkLabel.Font = Enum.Font.SourceSansBold
watermarkLabel.TextSize = 11
watermarkLabel.TextXAlignment = Enum.TextXAlignment.Right
watermarkLabel.Parent = mainFrame

local footerLabel = Instance.new("TextLabel")
footerLabel.Name = "FooterLabel"
footerLabel.Size = UDim2.new(0, 130, 0, 16)
footerLabel.Position = UDim2.new(0, 10, 1, -18)
footerLabel.BackgroundTransparency = 1
footerLabel.Text = "[RightShift] Hide/Show"
footerLabel.TextColor3 = Color3.fromRGB(130, 130, 130)
footerLabel.Font = Enum.Font.SourceSansItalic
footerLabel.TextSize = 11
footerLabel.TextXAlignment = Enum.TextXAlignment.Left
footerLabel.Parent = mainFrame

-- ====================================================
-- 2. MAIN MENU (BUTTONS)
-- ====================================================
local mainView = Instance.new("Frame")
mainView.Name = "MainView"
mainView.Size = UDim2.new(1, 0, 1, -45)
mainView.Position = UDim2.new(0, 0, 0, 30)
mainView.BackgroundTransparency = 1
mainView.Visible = true
mainView.Parent = mainFrame

local throwButton = Instance.new("TextButton")
throwButton.Name = "ThrowButton"
throwButton.Size = UDim2.new(0, 200, 0, 32)
throwButton.Position = UDim2.new(0, 10, 0, 15)
throwButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
throwButton.TextColor3 = Color3.fromRGB(255, 255, 255)
throwButton.Text = "Auto Throw: OFF"
throwButton.Font = Enum.Font.SourceSansBold
throwButton.TextSize = 14
throwButton.Parent = mainView
Instance.new("UICorner", throwButton).CornerRadius = UDim.new(0, 6)

local sellButton = Instance.new("TextButton")
sellButton.Name = "SellButton"
sellButton.Size = UDim2.new(0, 200, 0, 32)
sellButton.Position = UDim2.new(0, 10, 0, 55)
sellButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
sellButton.TextColor3 = Color3.fromRGB(255, 255, 255)
sellButton.Text = "Auto Sell: OFF"
sellButton.Font = Enum.Font.SourceSansBold
sellButton.TextSize = 14
sellButton.Parent = mainView
Instance.new("UICorner", sellButton).CornerRadius = UDim.new(0, 6)

-- POSISI LUCK DI ATAS VALUE
local upgradeLuckButton = Instance.new("TextButton")
upgradeLuckButton.Name = "UpgradeLuckButton"
upgradeLuckButton.Size = UDim2.new(0, 200, 0, 32)
upgradeLuckButton.Position = UDim2.new(0, 10, 0, 95)
upgradeLuckButton.BackgroundColor3 = Color3.fromRGB(50, 100, 200)
upgradeLuckButton.TextColor3 = Color3.fromRGB(255, 255, 255)
upgradeLuckButton.Text = "Upgrade Luck (Max)"
upgradeLuckButton.Font = Enum.Font.SourceSansBold
upgradeLuckButton.TextSize = 14
upgradeLuckButton.Parent = mainView
Instance.new("UICorner", upgradeLuckButton).CornerRadius = UDim.new(0, 6)

local upgradeValueButton = Instance.new("TextButton")
upgradeValueButton.Name = "UpgradeValueButton"
upgradeValueButton.Size = UDim2.new(0, 200, 0, 32)
upgradeValueButton.Position = UDim2.new(0, 10, 0, 135)
upgradeValueButton.BackgroundColor3 = Color3.fromRGB(50, 100, 200)
upgradeValueButton.TextColor3 = Color3.fromRGB(255, 255, 255)
upgradeValueButton.Text = "Upgrade Value (Max)"
upgradeValueButton.Font = Enum.Font.SourceSansBold
upgradeValueButton.TextSize = 14
upgradeValueButton.Parent = mainView
Instance.new("UICorner", upgradeValueButton).CornerRadius = UDim.new(0, 6)

-- ====================================================
-- 3. REMOTE EVENT & MAIN SYSTEM
-- ====================================================
local isScriptActive = true
local isThrowing = false
local isSelling = false

local remotes = ReplicatedStorage:WaitForChild("Remotes")
local throwRemote = remotes:WaitForChild("Throw")
local revealRemote = remotes:WaitForChild("RevealDone")
local sellRemote = remotes:WaitForChild("SellAll")
local buyUpgradeRemote = remotes:WaitForChild("BuyUpgrade")

-- Loop Auto Throw (Delay 3 Detik)
task.spawn(function()
	while isScriptActive do
		if isThrowing then
			pcall(function()
				throwRemote:InvokeServer()
				revealRemote:FireServer()
			end)
			task.wait(3) 
		else
			task.wait(0.1)
		end
	end
end)

-- Loop Auto Sell (Delay 20 Detik)
task.spawn(function()
	while isScriptActive do
		if isSelling then
			pcall(function()
				sellRemote:FireServer()
			end)
			task.wait(20)
		else
			task.wait(0.1)
		end
	end
end)

-- ANTI-AFK
task.spawn(function()
	local VirtualUser = game:GetService("VirtualUser")
	player.Idled:Connect(function()
		if isScriptActive then
			if getconnections then
				for _, connection in pairs(getconnections(player.Idled)) do
					if connection["Disable"] then
						connection["Disable"](connection)
					elseif connection["Disconnect"] then
						connection["Disconnect"](connection)
					end
				end
			else
				VirtualUser:CaptureController()
				VirtualUser:ClickButton2(Vector2.new())
			end
		end
	end)
end)

-- Tombol Event (Throw)
throwButton.MouseButton1Click:Connect(function()
	isThrowing = not isThrowing
	if isThrowing then
		throwButton.Text = "Auto Throw: ON"
		throwButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
	else
		throwButton.Text = "Auto Throw: OFF"
		throwButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
	end
end)

-- Tombol Event (Sell)
sellButton.MouseButton1Click:Connect(function()
	isSelling = not isSelling
	if isSelling then
		sellButton.Text = "Auto Sell: ON"
		sellButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
	else
		sellButton.Text = "Auto Sell: OFF"
		sellButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
	end
end)

-- Tombol Event (Upgrade Luck) - 1 Kali Klik
upgradeLuckButton.MouseButton1Click:Connect(function()
	pcall(function()
		local args = {"Gravity", "max"}
		buyUpgradeRemote:InvokeServer(unpack(args))
	end)
end)

-- Tombol Event (Upgrade Value) - 1 Kali Klik
upgradeValueButton.MouseButton1Click:Connect(function()
	pcall(function()
		local args = {"Density", "max"}
		buyUpgradeRemote:InvokeServer(unpack(args))
	end)
end)

-- ====================================================
-- 4. SISTEM DRAGGABLE, HOTKEY, & CLEANUP
-- ====================================================
local dragging, dragInput, dragStart, startPos
local dragConnection
local toggleConnection

local function update(input)
	local delta = input.Position - dragStart
	local targetX = (startPos.X.Scale * screenGui.AbsoluteSize.X) + startPos.X.Offset + delta.X
	local targetY = (startPos.Y.Scale * screenGui.AbsoluteSize.Y) + startPos.Y.Offset + delta.Y
	
	local halfWidth = mainFrame.AbsoluteSize.X / 2
	local halfHeight = mainFrame.AbsoluteSize.Y / 2
	
	local minX = halfWidth
	local maxX = screenGui.AbsoluteSize.X - halfWidth
	local minY = halfHeight
	local maxY = screenGui.AbsoluteSize.Y - halfHeight
	
	local clampedX = math.clamp(targetX, minX, maxX)
	local clampedY = math.clamp(targetY, minY, maxY)
	
	mainFrame.Position = UDim2.new(0, clampedX, 0, clampedY)
end

mainFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = mainFrame.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

mainFrame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

dragConnection = UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		update(input)
	end
end)

toggleConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.RightShift then
		screenGui.Enabled = not screenGui.Enabled
	end
end)

closeButton.MouseButton1Click:Connect(function()
	isScriptActive = false
	isThrowing = false
	isSelling = false
	
	if dragConnection then
		dragConnection:Disconnect()
		dragConnection = nil
	end
	
	if toggleConnection then
		toggleConnection:Disconnect()
		toggleConnection = nil
	end
	
	screenGui:Destroy()
end)

-- ====================================================
-- 5. AUTO RECONNECT
-- ====================================================
local isReconnecting = false

local function doReconnect()
	if isReconnecting then return end
	isReconnecting = true
	
	warn("Reconnecting...")
	
	task.wait(5)
	
	while true do
		pcall(function()
			TeleportService:Teleport(game.PlaceId, player)
		end)
		task.wait(5)
	end
end

GuiService.ErrorMessageChanged:Connect(function()
	doReconnect()
end)

pcall(function()
	local CoreGui = game:GetService("CoreGui")
	CoreGui.RobloxPromptGui.promptOverlay.ChildAdded:Connect(function(child)
		if child.Name == 'ErrorPrompt' then
			doReconnect()
		end
	end)
end)

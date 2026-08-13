local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local GuiService = game:GetService("GuiService")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local isScriptActive = true

-- State Toggles
local isThrowing = false
local isAutoSell = false
local isAutoLuck = false
local isAutoCash = false
local isAutoBuyCoin = false

-- ====================================================
-- LIST COIN (Urutan Murah ke Mahal)
-- ====================================================
local coinList = {
	"Basic Coin",
	"Copper Coin",
	"Fortune Coin",
	"Fire Coin",
	"Volt Coin",
	"Aether Coin",
	"Starlight Coin",
	"Galaxy Coin",
	"Void Coin",
	"Chronos Coin",
	"Eclipse Coin",
	"Mirage Coin",
	"Obsidian Coin",
	"Tempest Coin",
	"Soul Coin",
	"Paradox Coin",
	"Miracle Coin",
	"Nexus Coin",
	"Apex Coin",
	"Infinity Coin",
	"Grace Coin",
	"Dominion Coin",
	"Empyrean Coin",
	"Atlas Coin",
	"Judgement Coin",
	"Hercules Coin",
	"Helios Coin",
	"Nyx Coin",
	"Titan Coin",
	"Zeus Coin",
	"Runic Coin",
	"Amethyst Coin",
	"Merlin Coin",
	"Eldritch Coin",
	"Avalon Coin",
	"Dragonheart Coin",
	"Phoenix Coin",
}

-- ====================================================
-- 1. SETUP REMOTE EVENTS & COIN DETECTOR
-- ====================================================
local eventsFolder = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Events")

local coinEvent = eventsFolder:WaitForChild("CoinLanded")
local sellEvent = eventsFolder:WaitForChild("SellAll")
local upgradeEvent = eventsFolder:WaitForChild("RequestUpgrade")
local buyCoinEvent = eventsFolder:WaitForChild("BuyCoin")

local currentCoinName = coinList[1] -- Default ke "Basic Coin"
local coinConnection

local function getNextCoinName()
	for i, name in ipairs(coinList) do
		if name == currentCoinName then
			return coinList[i + 1]
		end
	end
	return nil
end

-- ====================================================
-- 2. SETUP MAIN GUI
-- ====================================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ThrowACoinGui"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 999

local parentTarget = (gethui and gethui()) or CoreGui or playerGui
screenGui.Parent = parentTarget

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 220, 0, 280)
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
titleLabel.Text = "Throw A Coin"
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

-- FOOTER & WATERMARK
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

-- ====================================================
-- 3. MAIN VIEW & AUTO LAYOUT
-- ====================================================
local mainView = Instance.new("Frame")
mainView.Name = "MainView"
mainView.Size = UDim2.new(1, -20, 1, -50)
mainView.Position = UDim2.new(0, 10, 0, 30)
mainView.BackgroundTransparency = 1
mainView.Parent = mainFrame

local listLayout = Instance.new("UIListLayout")
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, 5)
listLayout.Parent = mainView

-- Status Coin Real-time
local coinStatusLabel = Instance.new("TextLabel")
coinStatusLabel.Name = "CoinStatusLabel"
coinStatusLabel.Size = UDim2.new(1, 0, 0, 18)
coinStatusLabel.LayoutOrder = 1
coinStatusLabel.BackgroundTransparency = 1
coinStatusLabel.Text = "Current Coin: " .. currentCoinName
coinStatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
coinStatusLabel.Font = Enum.Font.SourceSans
coinStatusLabel.TextSize = 14
coinStatusLabel.Parent = mainView

-- Deteksi Label Koin di Background
task.spawn(function()
	local uiFolder = playerGui:WaitForChild("UiFolder", 10)
	local mainHUD = uiFolder and uiFolder:WaitForChild("Main", 5)
	local hud = mainHUD and mainHUD:WaitForChild("HUD", 5)
	local coinFolder = hud and hud:WaitForChild("Coin", 5)
	local mainCoin = coinFolder and coinFolder:WaitForChild("Main", 5)
	local coinLabelObj = mainCoin and mainCoin:WaitForChild("CoinName", 5)

	if coinLabelObj and isScriptActive then
		currentCoinName = coinLabelObj.Text
		coinStatusLabel.Text = "Current Coin: " .. currentCoinName
		
		coinConnection = coinLabelObj:GetPropertyChangedSignal("Text"):Connect(function()
			currentCoinName = coinLabelObj.Text
			coinStatusLabel.Text = "Current Coin: " .. currentCoinName
		end)
	end
end)

-- Helper Function Button
local function createButton(name, text, order, bgColor)
	local btn = Instance.new("TextButton")
	btn.Name = name
	btn.Size = UDim2.new(1, 0, 0, 28)
	btn.LayoutOrder = order
	btn.BackgroundColor3 = bgColor or Color3.fromRGB(200, 50, 50)
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Text = text
	btn.Font = Enum.Font.SourceSansBold
	btn.TextSize = 13
	btn.Parent = mainView
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
	return btn
end

-- Buttons
local throwButton = createButton("ThrowButton", "Auto Throw: OFF", 2)
local sellButton = createButton("SellButton", "Auto Sell: OFF", 3)
local luckButton = createButton("LuckButton", "Auto Luck: OFF", 4)
local cashButton = createButton("CashButton", "Auto Cash: OFF", 5)
local buyCoinButton = createButton("BuyCoinButton", "Auto Buy Coin: OFF", 6)

-- Helper Visual Button
local function setButtonState(btn, state, textPrefix)
	btn.Text = textPrefix .. (state and ": ON" or ": OFF")
	btn.BackgroundColor3 = state and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
end

-- ====================================================
-- 4. LOGIKA TOMBOL & LOOPS
-- ====================================================

throwButton.MouseButton1Click:Connect(function()
	isThrowing = not isThrowing
	setButtonState(throwButton, isThrowing, "Auto Throw")
end)

sellButton.MouseButton1Click:Connect(function()
	isAutoSell = not isAutoSell
	setButtonState(sellButton, isAutoSell, "Auto Sell")
end)

luckButton.MouseButton1Click:Connect(function()
	isAutoLuck = not isAutoLuck
	setButtonState(luckButton, isAutoLuck, "Auto Luck")
end)

cashButton.MouseButton1Click:Connect(function()
	isAutoCash = not isAutoCash
	setButtonState(cashButton, isAutoCash, "Auto Cash")
end)

buyCoinButton.MouseButton1Click:Connect(function()
	isAutoBuyCoin = not isAutoBuyCoin
	setButtonState(buyCoinButton, isAutoBuyCoin, "Auto Buy Coin")
end)

-- 1. Auto Throw Loop
task.spawn(function()
	while isScriptActive do
		if isThrowing then
			local args = {
				3,
				Vector3.new(-1160.4638671875, 0.7260000109672546, -176.9036102294922),
				currentCoinName
			}
			pcall(function()
				coinEvent:FireServer(unpack(args))
			end)
			task.wait(4)
		else
			task.wait(0.5)
		end
	end
end)

-- 2. Auto Sell Loop
task.spawn(function()
	while isScriptActive do
		if isAutoSell then
			pcall(function()
				sellEvent:FireServer()
			end)
			task.wait(5)
		else
			task.wait(0.5)
		end
	end
end)

-- 3. Auto Luck Loop
task.spawn(function()
	while isScriptActive do
		if isAutoLuck then
			pcall(function()
				upgradeEvent:FireServer("Luck Multiplier")
			end)
			task.wait(0.1)
		else
			task.wait(0.5)
		end
	end
end)

-- 4. Auto Cash Loop
task.spawn(function()
	while isScriptActive do
		if isAutoCash then
			pcall(function()
				upgradeEvent:FireServer("Value Multiplier")
			end)
			task.wait(0.1)
		else
			task.wait(0.5)
		end
	end
end)

-- 5. Auto Buy Coin Loop
task.spawn(function()
	while isScriptActive do
		if isAutoBuyCoin then
			local nextCoin = getNextCoinName()
			if nextCoin then
				pcall(function()
					buyCoinEvent:FireServer(nextCoin)
				end)
				task.wait(15)
			else
				task.wait(10)
			end
		else
			task.wait(1)
		end
	end
end)

-- ====================================================
-- 5. ANTI-AFK (AUTO JUMP 5 MENIT)
-- ====================================================
task.spawn(function()
	while isScriptActive do
		task.wait(300) -- Menunggu 5 menit (300 detik)
		if isScriptActive then
			pcall(function()
				local character = player.Character
				if character then
					local humanoid = character:FindFirstChildOfClass("Humanoid")
					if humanoid and humanoid.Health > 0 then
						humanoid.Jump = true
					end
				end
			end)
		end
	end
end)

-- ====================================================
-- 6. SISTEM DRAGGABLE, HOTKEY, & CLEANUP
-- ====================================================
local dragging = false
local dragInput, dragStart, startPos

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

local dragBeganConn = mainFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = mainFrame.Position
	end
end)

local dragEndedConn = UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = false
	end
end)

local dragChangedConn = UserInputService.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

local dragUpdateConn = UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		update(input)
	end
end)

local toggleConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.RightShift then
		screenGui.Enabled = not screenGui.Enabled
	end
end)

closeButton.MouseButton1Click:Connect(function()
	isScriptActive = false
	isThrowing = false
	isAutoSell = false
	isAutoLuck = false
	isAutoCash = false
	isAutoBuyCoin = false
	
	-- Cleanup Connections
	if dragBeganConn then dragBeganConn:Disconnect() end
	if dragEndedConn then dragEndedConn:Disconnect() end
	if dragChangedConn then dragChangedConn:Disconnect() end
	if dragUpdateConn then dragUpdateConn:Disconnect() end
	if toggleConnection then toggleConnection:Disconnect() end
	if coinConnection then coinConnection:Disconnect() end
	
	screenGui:Destroy()
end)

-- ====================================================
-- 7. AUTO RECONNECT
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
	CoreGui.RobloxPromptGui.promptOverlay.ChildAdded:Connect(function(child)
		if child.Name == 'ErrorPrompt' then
			doReconnect()
		end
	end)
end)

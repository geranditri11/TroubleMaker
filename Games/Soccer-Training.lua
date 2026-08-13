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
screenGui.Name = "SoccerTrainingGui"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 999
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 220, 0, 180) 
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
titleLabel.Text = "⚽ Soccer Training"
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

-- ====================================================
-- 2. VIEW 1: MAIN MENU (AUTO TRAINING)
-- ====================================================
local mainView = Instance.new("Frame")
mainView.Name = "MainView"
mainView.Size = UDim2.new(1, 0, 1, -45)
mainView.Position = UDim2.new(0, 0, 0, 30)
mainView.BackgroundTransparency = 1
mainView.Visible = true
mainView.Parent = mainFrame

local trainButton = Instance.new("TextButton")
trainButton.Name = "TrainButton"
trainButton.Size = UDim2.new(0, 200, 0, 32)
trainButton.Position = UDim2.new(0, 10, 0, 15)
trainButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
trainButton.TextColor3 = Color3.fromRGB(255, 255, 255)
trainButton.Text = "Auto Train: OFF"
trainButton.Font = Enum.Font.SourceSansBold
trainButton.TextSize = 14
trainButton.Parent = mainView
Instance.new("UICorner", trainButton).CornerRadius = UDim.new(0, 6)

local openHatchMenuBtn = Instance.new("TextButton")
openHatchMenuBtn.Name = "OpenHatchMenuBtn"
openHatchMenuBtn.Size = UDim2.new(0, 200, 0, 32)
openHatchMenuBtn.Position = UDim2.new(0, 10, 0, 55)
openHatchMenuBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 150)
openHatchMenuBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
openHatchMenuBtn.Text = "🥚 Hatch Menu"
openHatchMenuBtn.Font = Enum.Font.SourceSansBold
openHatchMenuBtn.TextSize = 14
openHatchMenuBtn.Parent = mainView
Instance.new("UICorner", openHatchMenuBtn).CornerRadius = UDim.new(0, 6)

-- ====================================================
-- 3. VIEW 2: SUB-MENU (HATCH EGG)
-- ====================================================
local hatchView = Instance.new("Frame")
hatchView.Name = "HatchView"
hatchView.Size = UDim2.new(1, 0, 1, -45)
hatchView.Position = UDim2.new(0, 0, 0, 30)
hatchView.BackgroundTransparency = 1
hatchView.Visible = false
hatchView.Parent = mainFrame

local backButton = Instance.new("TextButton")
backButton.Name = "BackButton"
backButton.Size = UDim2.new(0, 200, 0, 22)
backButton.Position = UDim2.new(0, 10, 0, 0)
backButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
backButton.TextColor3 = Color3.fromRGB(255, 255, 255)
backButton.Text = "⬅️ Back"
backButton.Font = Enum.Font.SourceSansBold
backButton.TextSize = 12
backButton.Parent = hatchView
Instance.new("UICorner", backButton).CornerRadius = UDim.new(0, 4)

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Name = "EggScrollFrame"
scrollFrame.Size = UDim2.new(0, 200, 0, 65)
scrollFrame.Position = UDim2.new(0, 10, 0, 26)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 4
scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(120, 120, 120)
scrollFrame.Parent = hatchView

local listLayout = Instance.new("UIListLayout")
listLayout.Parent = scrollFrame
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, 4)

local eggData = {
	{ ID = "Basic", Name = "Basic Egg", Label = "Basic (75)" },
	{ ID = "Dragon", Name = "Dragon Egg", Label = "Dragon (3 K)" },
	{ ID = "Bee", Name = "Bee Egg", Label = "Bee (200 K)" },
	{ ID = "Desert", Name = "Desert Egg", Label = "Desert (75 M)" },
	{ ID = "Pyramid", Name = "Pyramid Egg", Label = "Pyramid (20 B)" },
	{ ID = "Cactus", Name = "Cactus Egg", Label = "Cactus (1 T)" },
	{ ID = "Mystic", Name = "Mystic Egg", Label = "Mystic (1 Qd)" },
	{ ID = "WorldCup", Name = "World Cup Egg", Label = "World Cup (750 Qd)" },
	{ ID = "Dice", Name = "Dice Egg", Label = "Dice (150 Qn)" },
	{ ID = "Atlantis", Name = "Atlantis Egg", Label = "Atlantis (50 Sx)" },
	{ ID = "Kraken", Name = "Kraken Egg", Label = "Kraken (2 Sp)" },
	{ ID = "Abyss", Name = "Abyss Egg", Label = "Abyss (75 Sp)" },
	{ ID = "Space", Name = "Space Egg", Label = "Space (250 Oc)" },
	{ ID = "Alien", Name = "Alien Egg", Label = "Alien (100 No)" },
	{ ID = "Martian", Name = "Martian Egg", Label = "Martian (3.5 De)" },
	{ ID = "7.5M", Name = "7.5M Egg", Label = "7.5M (7.5 M)" },
}

local eggButtons = {}
local selectedEggID = nil
local isScriptActive = true
local isTraining = false

for i, data in ipairs(eggData) do
	local btn = Instance.new("TextButton")
	btn.Name = data.ID .. "Button"
	btn.Size = UDim2.new(1, -8, 0, 26)
	btn.LayoutOrder = i
	btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Text = data.Label .. ": OFF"
	btn.Font = Enum.Font.SourceSansBold
	btn.TextSize = 12
	btn.Parent = scrollFrame
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)

	eggButtons[data.ID] = { Button = btn, Data = data }
end

listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	scrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y)
end)

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
-- 4. REMOTE EVENT & MAIN SYSTEM
-- ====================================================
local knitServices = ReplicatedStorage:WaitForChild("Library"):WaitForChild("Knit"):WaitForChild("Services")
local trainEvent = knitServices:WaitForChild("TrainingService"):WaitForChild("RE"):WaitForChild("Train")
local hatchEvent = knitServices:WaitForChild("EggsService"):WaitForChild("RE"):WaitForChild("HatchEgg")

openHatchMenuBtn.MouseButton1Click:Connect(function()
	mainView.Visible = false
	hatchView.Visible = true
end)

backButton.MouseButton1Click:Connect(function()
	hatchView.Visible = false
	mainView.Visible = true
end)

task.spawn(function()
	while isScriptActive do
		if isTraining then
			for i = 1, 10 do
				pcall(function() trainEvent:FireServer() end)
			end
			task.wait(0.1)
		else
			task.wait(0.1)
		end
	end
end)

task.spawn(function()
	while isScriptActive do
		if selectedEggID and eggButtons[selectedEggID] then
			local eggName = eggButtons[selectedEggID].Data.Name
			pcall(function() hatchEvent:FireServer(eggName, "Octo") end)
			task.wait(1)
		else
			task.wait(0.2)
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

trainButton.MouseButton1Click:Connect(function()
	isTraining = not isTraining
	if isTraining then
		trainButton.Text = "Auto Train: ON"
		trainButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
	else
		trainButton.Text = "Auto Train: OFF"
		trainButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
	end
end)

local function selectEgg(targetID)
	if selectedEggID == targetID then
		selectedEggID = nil
	else
		selectedEggID = targetID
	end

	for id, item in pairs(eggButtons) do
		if id == selectedEggID then
			item.Button.Text = item.Data.Label .. ": ON"
			item.Button.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
		else
			item.Button.Text = item.Data.Label .. ": OFF"
			item.Button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
		end
	end
end

for id, item in pairs(eggButtons) do
	item.Button.MouseButton1Click:Connect(function()
		selectEgg(id)
	end)
end

-- ====================================================
-- 5. SISTEM DRAGGABLE, HOTKEY, & CLEANUP
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
	isTraining = false
	selectedEggID = nil
	
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
-- 6. AUTO RECONNECT
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

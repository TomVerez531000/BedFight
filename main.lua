-- services
local TweenService = game:GetService("TweenService")
local Uis = game:GetService("UserInputService")
local httpService = game:GetService("HttpService")

-- variables
local Gui = Instance.new("ScreenGui", game.CoreGui)
Gui.Name = "BedFights"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.Enabled = true

local Settings = {}
-- Auto Load Settings
if isfile("BedFightVortex.txt") then
	local data = readfile("BedFightVortex.txt")
	local dt = {}
	success,err = pcall(function()
		dt = httpService:JSONDecode(data)
	end)
	Settings = dt
end

-- main
local tab_index = 0
function create_tab(name)
	if not Settings[name] then
		Settings[name] = {}
	end
	
	local dragging = false
	local function connect_drag(TopFrame: TextButton)
		TopFrame.MouseButton1Down:Connect(function()
			local start_mouse_pos = Uis:GetMouseLocation()
			local start_frame_pos = TopFrame.Parent.Position
			
			dragging = true
			local connection
			connection = Uis.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					dragging = false
					connection:Disconnect()
				end
			end)
			
			local connec
			connec = game.Players.LocalPlayer:GetMouse().Move:Connect(function()
				if not dragging then connec:Disconnect() return end
				local mouse_pos = Uis:GetMouseLocation()
				local delta = mouse_pos - start_mouse_pos
				local new_pos = start_frame_pos+UDim2.new(0,delta.X,0,delta.Y)
				
				local tab = TopFrame.Parent
				tab.Position = new_pos
			end)
		end)
	end
	
	local tab = Instance.new("CanvasGroup", Gui)
	tab.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	tab.BackgroundTransparency = 0.5
	tab.Size = UDim2.new(0.21, 0,0.5, 0)
	tab.Position = UDim2.new(0.05+0.25*tab_index, 0, 0.1, 0)
	tab.Name = name
	tab_index += 1
	
	if Settings["Position"] then
		tab.Position = UDim2.new(0,Settings["Position"][1],0,Settings["Position"][2])
	end
	
	local corner = Instance.new("UICorner", tab)
	corner.CornerRadius = UDim.new(0, 8)
	
	local Top = Instance.new("TextButton", tab)
	Top.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	Top.BackgroundTransparency = 0.5
	Top.Size = UDim2.new(1, 0,0.11, 0)
	Top.Name = "Top"
	Top.Text = ""
	Top.AutoButtonColor = false
	
	local TopPadding = Instance.new("UIPadding", Top)
	TopPadding.PaddingTop = UDim.new(0,5)
	TopPadding.PaddingBottom = UDim.new(0,5)
	
	local Title = Instance.new("TextLabel", Top)
	Title.Text = name
	Title.BackgroundTransparency = 1
	Title.Size = UDim2.new(1,0,1,0)
	Title.TextColor3 = Color3.fromRGB(255,255,255)
	Title.TextScaled = true
	Title.FontFace.Weight = Enum.FontWeight.Bold
	Title.Name = "Title"
	
	local Container = Instance.new("Frame", tab)
	Container.BackgroundTransparency = 1
	Container.Size = UDim2.new(1, 0, 0.89, 0)
	Container.Position = UDim2.new(0, 0, 0.11, 0)
	Container.Name = "Container"
	
	local ContainerListLayout = Instance.new("UIListLayout", Container)
	ContainerListLayout.FillDirection = Enum.FillDirection.Vertical
	ContainerListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	ContainerListLayout.Padding = UDim.new(0,8)
	
	local ContainerPadding = Instance.new("UIPadding", Container)
	ContainerPadding.PaddingTop = UDim.new(0, 10)
	
	connect_drag(Top)
	
	return tab
end

function add_basic_button(tab, name, func)
	local function corner_item(item, corner)
		local c = Instance.new("UICorner", item)
		c.CornerRadius = corner
	end

	local button = Instance.new("TextButton", tab.Container)
	button.BackgroundColor3 = Color3.fromRGB(214, 214, 214)
	button.BackgroundTransparency = 0.85
	button.Size = UDim2.new(0.9, 0, 0, 40)
	button.Name = name
	button.Text = name
	button.TextScaled = true
	button.TextColor3 = Color3.fromRGB(255,255,255)
	corner_item(button, UDim.new(0, 5))

	local buttonStroke = Instance.new("UIStroke", button)
	buttonStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	buttonStroke.Color = Color3.fromRGB(184, 184, 184)
	buttonStroke.Thickness = 0.5
	buttonStroke.Transparency = 0.5

	local namePadding = Instance.new("UIPadding", button)
	namePadding.PaddingTop = UDim.new(0, 5)
	namePadding.PaddingBottom = UDim.new(0, 5)
	
	button.MouseButton1Click:Connect(func)
end

function add_button(tab, name, bind, func)
	if not Settings[tab.Name][name] then
		Settings[tab.Name][name] = {
			["Bind"] = false,
			["Enabled"] = false
		}
	end
	
	local State = Settings[tab.Name][name]["Enabled"] or false
	local Binding = false
	local Bind = nil
	
	if Settings[tab.Name][name]["Bind"] then
		Bind = Enum.KeyCode[Settings[tab.Name][name]["Bind"]]
	end
	
	local function animate(button, state)
		local fill = button.Checked
		local transparency = state and 0.3 or 1

		local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
		local tween = TweenService:Create(fill, tweenInfo, {Transparency = transparency})
		tween:Play()
	end
	
	local function corner_item(item, corner)
		local c = Instance.new("UICorner", item)
		c.CornerRadius = corner
	end
	
	local button = Instance.new("Frame", tab.Container)
	button.BackgroundColor3 = Color3.fromRGB(214, 214, 214)
	button.BackgroundTransparency = 0.85
	button.Size = UDim2.new(0.9, 0, 0, 40)
	button.Name = name
	
	local buttonStroke = Instance.new("UIStroke", button)
	buttonStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	buttonStroke.Color = Color3.fromRGB(184, 184, 184)
	buttonStroke.Thickness = 0.5
	buttonStroke.Transparency = 0.5
	
	corner_item(button, UDim.new(0, 5))
	
	local buttonName = Instance.new("TextLabel", button)
	buttonName.Text = name
	buttonName.Size = UDim2.new(1, -45, 1, 0)
	buttonName.Position = UDim2.new(0, 45, 0, 0)
	buttonName.BackgroundTransparency = 1
	buttonName.TextScaled = true
	buttonName.Name = "Title"
	buttonName.TextColor3 = Color3.fromRGB(255,255,255)
	
	local namePadding = Instance.new("UIPadding", buttonName)
	namePadding.PaddingTop = UDim.new(0, 5)
	namePadding.PaddingBottom = UDim.new(0, 5)
	
	local buttonToggle = Instance.new("TextButton", button)
	buttonToggle.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	buttonToggle.BackgroundTransparency = 0.8
	buttonToggle.Position = UDim2.new(0, 5, 0, 5)
	buttonToggle.Size = UDim2.new(0, 30, 0, 30)
	buttonToggle.Name = "Toggle"
	buttonToggle.Text = ""
	corner_item(buttonToggle, UDim.new(0, 5))
	
	local toggleStroke = Instance.new("UIStroke", buttonToggle)
	toggleStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	toggleStroke.Color = Color3.fromRGB(255,255,255)
	toggleStroke.Thickness = 0.5
	toggleStroke.Transparency = 0.5
	
	local toggleChecked = Instance.new("Frame", buttonToggle)
	toggleChecked.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
	toggleChecked.BackgroundTransparency = 1
	toggleChecked.AnchorPoint = Vector2.new(0.5, 0.5)
	toggleChecked.Position = UDim2.new(0.5, 0, 0.5, 0)
	toggleChecked.Size = UDim2.new(0.8, 0, 0.8, 0)
	toggleChecked.Name = "Checked"
	
	corner_item(toggleChecked, UDim.new(0, 5))
	
	local function toggle(State)
		Settings[tab.Name][name]["Enabled"] = State
		animate(button.Toggle, State)
		func(State)
	end
	toggle(State)

	buttonToggle.MouseButton1Click:Connect(function()
		State = not State
		toggle(State)
	end)
	
	local bindButton
	if bind then
		bindButton = buttonToggle:Clone()
		bindButton.Parent = button
		bindButton.Name = "Bind"
		bindButton.Size = UDim2.new(0,25,0,25)
		bindButton.Position = UDim2.new(1,-5,0.5,0)
		bindButton.AnchorPoint = Vector2.new(1,0.5)
		bindButton.Text = Bind and Bind.Name or "None"
		bindButton.TextColor3 = Color3.fromRGB(255,255,255)
		
		local padding = Instance.new("UIPadding", bindButton)
		padding.PaddingLeft = UDim.new(0,2)
		padding.PaddingRight = UDim.new(0,2)
		
		bindButton.MouseButton1Click:Connect(function()
			bindButton.Text = "..."
			Binding = true
		end)
	end
	
	Uis.InputBegan:Connect(function(Key, gameproc)
		if gameproc then return end
		
		if Binding then
			bindButton.Text = Key.KeyCode.Name
			Bind = Key.KeyCode
			Binding = false
			Settings[tab.Name][name]["Bind"] = Bind.Name
		elseif Key.KeyCode == Bind then
			State = not State
			toggle(State)
		end
	end)
	
	return button
end

-- modules
function create_killaura()
	local KillAura = {}

	function KillAura.get_closest_enemy()
		local closest = nil
		local closest_distance = math.huge
		for _,player in pairs(game.Players:GetPlayers()) do
			if player == game.Players.LocalPlayer then continue end
			if game.Players.LocalPlayer.Team ~= game.Teams.Spectators and (player.Team == game.Teams.Spectators or player.Team == game.Players.LocalPlayer.Team) then continue end
			if player.Character and (player.Character:GetPivot().Position-game.Players.LocalPlayer.Character:GetPivot().Position).Magnitude < closest_distance then
				closest = player
				closest_distance = (player.Character:GetPivot().Position-game.Players.LocalPlayer.Character:GetPivot().Position).Magnitude
			end
		end
		return closest
	end

	function KillAura.get_better_owned_sword()
		local inventory = game.Players.LocalPlayer:WaitForChild("Inventory")
		local swords = {"Wooden Sword", "Stone Sword", "Iron Sword", "Diamond Sword", "Emerald Sword"}

		local strongest = swords[1]
		for _,sword in pairs(swords) do
			if inventory:FindFirstChild(sword) then
				strongest = sword
			end
		end
		return strongest
	end

	KillAura.Enabled = false
	KillAura.AuraThread = coroutine.create(function()
		while task.wait() do
			if not KillAura.Enabled then
				coroutine.yield()
			end

			local closest = KillAura.get_closest_enemy()
			if closest then
				local sword = KillAura.get_better_owned_sword()

				local args = {
					closest.Character,
					sword
				}
				game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("ItemsRemotes"):WaitForChild("SwordHit"):FireServer(unpack(args))
			end
		end
	end)

	function KillAura:Enable()
		self.Enabled = true
		coroutine.resume(self.AuraThread)
	end

	function KillAura:Disable()
		self.Enabled = false
	end

	return KillAura
end

function create_movements()
	local Movements = {}

	local plr = game.Players.LocalPlayer
	Movements.Speed = 24
	Movements.SpeedEnabled = false

	Movements.JumpPower = 45
	Movements.HighJumpEnabled = false

	Movements.CFrameSpeed = 5
	Movements.CFrameSpeedEnabled = false
	Movements.SpeedThread = coroutine.create(function()
		local old = os.clock()
		while task.wait() do
			if not Movements.CFrameSpeedEnabled then coroutine.yield() end
			local char = plr.Character
			if not char then continue end
			local hrp = char:FindFirstChild("HumanoidRootPart")
			if not hrp then continue end
			local hum = char:FindFirstChild("Humanoid")
			if not hum then continue end
			local amount = (os.clock()-old)*Movements.CFrameSpeed
			old = os.clock()
			hrp.CFrame = CFrame.new(hrp.Position+(Vector3.new(hum.MoveDirection.X*amount, hum.MoveDirection.Y*amount, hum.MoveDirection.Z*amount)))
		end
	end)

	function Movements:ToggleCFrameSpeed(State)
		Movements.CFrameSpeedEnabled = State
		if Movements.CFrameSpeedEnabled then
			coroutine.resume(Movements.SpeedThread)
		end
	end

	local WalkSpeedConnec
	local JumpPowerConnec
	plr.CharacterAdded:Connect(function(Char)
		local hum = Char:WaitForChild("Humanoid")
		local TargetSpeed = Movements.SpeedEnabled and 16+Movements.Speed or 16
		local TargetPower = Movements.HighJumpEnabled and 45+Movements.JumpPower or 45
		hum.WalkSpeed = TargetSpeed
		hum.JumpPower = TargetPower
		WalkSpeedConnec = hum:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
			local TargetSpeed = Movements.SpeedEnabled and 16+Movements.Speed or 16
			if hum.WalkSpeed ~= TargetSpeed then
				hum.WalkSpeed = TargetSpeed
			end
		end)
		JumpPowerConnec = hum:GetPropertyChangedSignal("JumpPower"):Connect(function()
			local TargetPower = Movements.HighJumpEnabled and 45+Movements.JumpPower or 45
			if hum.JumpPower ~= TargetPower then
				hum.JumpPower = TargetPower
			end
		end)
	end)

	function Movements:ToggleSpeed(State)
		Movements.SpeedEnabled = State
		local char = plr.Character
		if not char then return end
		local hum = char:FindFirstChild("Humanoid")
		if not hum then return end
		local TargetSpeed = State and 16+Movements.Speed or 16
		hum.WalkSpeed = TargetSpeed
		if not WalkSpeedConnec then
			WalkSpeedConnec = hum:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
				local TargetSpeed = Movements.SpeedEnabled and 16+Movements.Speed or 16
				if hum.WalkSpeed ~= TargetSpeed then
					hum.WalkSpeed = TargetSpeed
				end
			end)
		end
	end

	function Movements:ToggleHighJump(State)
		Movements.HighJumpEnabled = State
		local char = plr.Character
		if not char then return end
		local hum = char:FindFirstChild("Humanoid")
		if not hum then return end
		local TargetPower = State and 45+Movements.JumpPower or 45
		hum.JumpPower = TargetPower
		if not JumpPowerConnec then
			JumpPowerConnec = hum:GetPropertyChangedSignal("JumpPower"):Connect(function()
				local TargetPower = State and 45+Movements.JumpPower or 45
				if hum.JumpPower ~= TargetPower then
					hum.JumpPower = TargetPower
				end
			end)
		end
	end

	return Movements
end

function create_clicktp()
	local ClickTP = {}

	local plr = game.Players.LocalPlayer
	local mouse = game.Players.LocalPlayer:GetMouse()
	local Uis = game:GetService("UserInputService")

	ClickTP.Enabled = false
	ClickTP.SecondKey = Enum.KeyCode.LeftAlt
	ClickTP.ClickConnection = mouse.Button1Down:Connect(function()
		if not ClickTP.Enabled then return end
		if not Uis:IsKeyDown(ClickTP.SecondKey) then return end
		local pos = mouse.Hit
		local char = plr.Character or plr.CharacterAdded:Wait()
		local Hrp = char:WaitForChild("HumanoidRootPart")

		Hrp.CFrame = pos
	end)

	function ClickTP:Toggle(State)
		ClickTP.Enabled = State
	end

	return ClickTP
end

function create_bedaura()
	local BedAura = {}

	BedAura.Enabled = false
	function BedAura.get_closest_bed()
		local closest = nil
		local closestdist = math.huge
		for _,bed in pairs(workspace.BedsContainer:GetChildren()) do
			local pos = bed:GetPivot().Position
			local dist = (pos-game.Players.LocalPlayer.Character:GetPivot().Position).Magnitude
			if dist < closestdist then
				closestdist = dist
				closest = bed
			end
		end
		return closest
	end

	function BedAura.get_best_owned_pickaxe()
		local Pickaxes = {"Wooden Pickaxe", "Stone Pickaxe", "Iron Pickaxe", "Diamond Pickaxe"}

		local inventory = game.Players.LocalPlayer:WaitForChild("Inventory")
		local best = "Wooden Pickaxe"
		for _,pickaxe in pairs(Pickaxes) do
			if inventory:FindFirstChild(pickaxe) then
				best = pickaxe
			end
		end

		return best
	end

	BedAura.Thread = coroutine.create(function()
		while task.wait() do
			if not BedAura.Enabled then
				coroutine.yield()
			end

			local bed = BedAura.get_closest_bed()
			if not bed then continue end
			local dist = (bed:GetPivot().Position-game.Players.LocalPlayer.Character:GetPivot().Position).Magnitude
			if dist > 20 then continue end
			local pickaxe = BedAura.get_best_owned_pickaxe()

			local MinePos = bed:GetPivot().Position+Vector3.new(0,bed:GetExtentsSize().Y+0.05,0)

			local args = {
				"Wooden Pickaxe",
				bed,
				bed:GetPivot().Position,
				MinePos,
				bed:GetPivot().Position-MinePos
			}
			game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("ItemsRemotes"):WaitForChild("MineBlock"):FireServer(unpack(args))
		end
	end)

	function BedAura:Toggle(State)
		BedAura.Enabled = State
		if BedAura.Enabled then
			coroutine.resume(BedAura.Thread)
		end
	end

	return BedAura
end

function create_autobridge()
	local AutoBridge = {}

	function AutoBridge.PlaceBlock(Block, Pos)
		local args = {
			Block,
			13,
			Pos
		}
		game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("ItemsRemotes"):WaitForChild("PlaceBlock"):FireServer(unpack(args))
	end

	AutoBridge.Enabled = false
	AutoBridge.Thread = coroutine.create(function()
		while task.wait() do
			if not AutoBridge.Enabled then
				coroutine.yield()
			end

			local char = game.Players.LocalPlayer.Character
			if not char then continue end
			local playercf = game.Players.LocalPlayer.Character:GetPivot()
			local playerdirection = playercf.LookVector
			local Pos1 = playercf.Position+Vector3.new(0,-3,0)+(playerdirection*3)
			local Pos2 = playercf.Position+Vector3.new(0,-3,0)+(playerdirection*6)

			local Block = game.Players.LocalPlayer.Team.Name.." Wool"
			AutoBridge.PlaceBlock(Block, Pos1)
			AutoBridge.PlaceBlock(Block, Pos2)
		end
	end)

	function AutoBridge:Toggle(State)
		AutoBridge.Enabled = State
		if AutoBridge.Enabled then
			coroutine.resume(AutoBridge.Thread)
		end
	end

	return AutoBridge
end

-- load modules
local Movements = create_movements()
local KillAura = create_killaura()
local ClickTP = create_clicktp()
local BedAura = create_bedaura()
local AutoBridge = create_autobridge()

-- code
Uis.InputBegan:Connect(function(Key, gameproc)
	if gameproc then return end
	if Key.KeyCode == Enum.KeyCode.F then
		Gui.Enabled = not Gui.Enabled
	end
end)

local CombatContainer = create_tab("Combat")
local KillAuraFrame = add_button(CombatContainer, "Killaura", true, function(State)
	if State then
		KillAura:Enable()
	else
		KillAura:Disable()
	end
end)

local MovementsContainer = create_tab("Movements")
local SpeedFrame = add_button(MovementsContainer, "CFrameSpeed", false, function(State)
	Movements:ToggleCFrameSpeed(State)
end)
local ClickTPFrame = add_button(MovementsContainer, "ClickTP", false, function(State)
	ClickTP:Toggle(State)
end)
local SpeedFrame = add_button(MovementsContainer, "Speed", false, function(State)
	Movements:ToggleSpeed(State)
end)
local HighJumpFrame = add_button(MovementsContainer, "HighJump", false, function(State)
	Movements:ToggleHighJump(State)
end)

local UtilityContainer = create_tab("Utility")
local BedAuraFrame = add_button(UtilityContainer, "Bed Aura", true, function(State)
	BedAura:Toggle(State)
end)
local AutoBridgeFrame = add_button(UtilityContainer, "Auto Bridge", true, function(State)
	AutoBridge:Toggle(State)
end)

local VisualContainer = create_tab("Visuals")
local ESPFrame = add_button(VisualContainer, "ESP", false, function(State)
	
end)
local SaveSettingsButton = add_basic_button(VisualContainer, "Save Settings", function()
	for tab,val in pairs(Settings) do
		val["Position"] = {Gui[tab].AbsolutePosition.X, Gui[tab].AbsolutePosition.Y}
	end
	local data = httpService:JSONEncode(Settings)
	writefile("BedFightVortex.txt", data)
end)



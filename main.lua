-- services
local TweenService = game:GetService("TweenService")
local Uis = game:GetService("UserInputService")

-- variables
local Gui = Instance.new("ScreenGui", game.CoreGui)
Gui.Name = "BedFights"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.Enabled = true

-- main
local tab_index = 0
function create_tab(name)
	local tab = Instance.new("CanvasGroup", Gui)
	tab.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	tab.BackgroundTransparency = 0.5
	tab.Size = UDim2.new(0.21, 0,0.5, 0)
	tab.Position = UDim2.new(0.1+0.25*tab_index, 0, 0.1, 0)
	tab.Name = name
	tab_index += 1
	
	local corner = Instance.new("UICorner", tab)
	corner.CornerRadius = UDim.new(0, 8)
	
	local Top = Instance.new("Frame", tab)
	Top.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	Top.BackgroundTransparency = 0.5
	Top.Size = UDim2.new(1, 0,0.11, 0)
	Top.Name = "Top"
	
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
	
	return tab
end


function add_button(tab, name, bind, func)
	local State = false
	local Binding = false
	local Bind = nil
	
	local function corner_item(item, corner)
		local c = Instance.new("UICorner", item)
		c.CornerRadius = corner
	end
	
	local function animate(button, state)
		local fill = button.Checked
		local transparency = state and 0.3 or 1

		local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
		local tween = TweenService:Create(fill, tweenInfo, {Transparency = transparency})
		tween:Play()
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
	
	buttonToggle.MouseButton1Click:Connect(function()
		State = not State
		animate(button.Toggle, State)
		func(State)
	end)
	
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
	
	local bindButton
	if bind then
		bindButton = buttonToggle:Clone()
		bindButton.Parent = button
		bindButton.Name = "Bind"
		bindButton.Size = UDim2.new(0,25,0,25)
		bindButton.Position = UDim2.new(1,-5,0.5,0)
		bindButton.AnchorPoint = Vector2.new(1,0.5)
		bindButton.Text = "None"
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
		elseif Key.KeyCode == Bind then
			State = not State
			animate(button.Toggle, State)
			func(State)
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
			local hrp = plr.Character.HumanoidRootPart
			local hum = plr.Character.Humanoid
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

	plr.CharacterAdded:Connect(function(Char)
		local hum = Char:WaitForChild("Humanoid")
		local TargetSpeed = Movements.SpeedEnabled and 16+Movements.Speed or 16
		local TargetPower = Movements.HighJumpEnabled and 45+Movements.JumpPower or 45
		hum.WalkSpeed = TargetSpeed
		hum.JumpPower = TargetPower
		hum:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
			local TargetSpeed = Movements.SpeedEnabled and 16+Movements.Speed or 16
			if hum.WalkSpeed ~= TargetSpeed then
				hum.WalkSpeed = TargetSpeed
			end
		end)
		hum:GetPropertyChangedSignal("JumpPower"):Connect(function()
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
		hum:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
			local TargetSpeed = Movements.SpeedEnabled and 16+Movements.Speed or 16
			if hum.WalkSpeed ~= TargetSpeed then
				hum.WalkSpeed = TargetSpeed
			end
		end)
	end

	function Movements:ToggleHighJump(State)
		Movements.HighJumpEnabled = State
		local char = plr.Character
		if not char then return end
		local hum = char:FindFirstChild("Humanoid")
		if not hum then return end
		local TargetPower = State and 45+Movements.JumpPower or 45
		hum.JumpPower = TargetPower
		hum:GetPropertyChangedSignal("JumpPower"):Connect(function()
			local TargetPower = State and 45+Movements.JumpPower or 45
			if hum.JumpPower ~= TargetPower then
				hum.JumpPower = TargetPower
			end
		end)
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
		local pos = mouse.Hit.Position
		local char = plr.Character or plr.CharacterAdded:Wait()
		local Hrp = char:WaitForChild("HumanoidRootPart")

		Hrp.CFrame = pos
	end)

	function ClickTP:Toggle(State)
		ClickTP.Enabled = State
	end

	return ClickTP
end

-- load modules
local Movements = create_movements()
local KillAura = create_killaura()
local ClickTP = create_clicktp()

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

local VisualContainer = create_tab("Visuals")
local ESPFrame = add_button(VisualContainer, "ESP", false, function(State)
	
end)

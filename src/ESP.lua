--[[

	Universal ESP Module by Exunys © CC0 1.0 Universal (2023 - 2024)
	https://github.com/Exunys

]]

--// Caching

local game = game
local assert, loadstring, select, next, type, typeof, pcall, xpcall, setmetatable, getmetatable, tick, warn = assert, loadstring, select, next, type, typeof, pcall, xpcall, setmetatable, getmetatable, tick, warn
local mathfloor, mathabs, mathcos, mathsin, mathrad, mathdeg, mathmin, mathmax, mathclamp, mathrandom = math.floor, math.abs, math.cos, math.sin, math.rad, math.deg, math.min, math.max, math.clamp, math.random
local stringformat, stringfind, stringchar = string.format, string.find, string.char
local unpack = table.unpack
local wait, spawn = task.wait, task.spawn
local getgenv, getrawmetatable, getupvalue, gethiddenproperty, cloneref, clonefunction = getgenv, getrawmetatable, debug.getupvalue, gethiddenproperty, cloneref or function(...)
	return ...
end, clonefunction or function(...)
	return ...
end

--// Custom Drawing Library

if not Drawing or not Drawing.new or not Drawing.Fonts then
	loadstring(game.HttpGet(game, "https://pastebin.com/raw/huyiRsK0"))()

	repeat
		wait(0)
	until Drawing and Drawing.new and type(Drawing.new) == "function" and Drawing.Fonts and type(Drawing.Fonts) == "table"
end

local ConfigLibrary = loadstring(game.HttpGet(game, "https://raw.githubusercontent.com/Exunys/Config-Library/main/Main.lua"))()

local Vector2new, Vector3zero, CFramenew = Vector2.new, Vector3.zero, CFrame.new
local Drawingnew, DrawingFonts = Drawing.new, Drawing.Fonts
local Color3fromRGB, Color3fromHSV = Color3.fromRGB, Color3.fromHSV
local WorldToViewportPoint, GetPlayers, GetMouseLocation

local GameMetatable = getrawmetatable and getrawmetatable(game) or {__index = function(self, Index)
	return self[Index] -- Aux / helper function - if the executor doesn't support "getrawmetatable"
end}

local __index = GameMetatable.__index

local _GetService = __index(game, "GetService")
local FindFirstChild, WaitForChild = __index(game, "FindFirstChild"), __index(game, "WaitForChild")
local IsA = __index(game, "IsA")

local GetService = function(Service)
	return cloneref(_GetService(game, Service))
end

local Workspace = GetService("Workspace")
local Players = GetService("Players")
local RunService = GetService("RunService")
local UserInputService = GetService("UserInputService")

local CurrentCamera = __index(Workspace, "CurrentCamera")
local LocalPlayer = __index(Players, "LocalPlayer")

local FindFirstChildOfClass = function(self, ...)
	return typeof(self) == "Instance" and self.FindFirstChildOfClass(self, ...)
end

local Cache = {
	WorldToViewportPoint = __index(CurrentCamera, "WorldToViewportPoint"),
	GetPlayers = __index(Players, "GetPlayers"),
	GetPlayerFromCharacter = __index(Players, "GetPlayerFromCharacter"),
	GetMouseLocation = __index(UserInputService, "GetMouseLocation")
}

local WorldToViewportPoint = function(...)
	return Cache.WorldToViewportPoint(CurrentCamera, ...)
end

local GetPlayers = function()
	return Cache.GetPlayers(Players)
end

local GetPlayerFromCharacter = function(...)
	return Cache.GetPlayerFromCharacter(Players, ...)
end

local GetMouseLocation = function()
	return Cache.GetMouseLocation(UserInputService)
end

local IsDescendantOf = function(self, ...)
	return typeof(self) == "Instance" and self.IsDescendantOf(self, ...)
end

--// Optimized functions / methods

local Connect, Disconnect, GetRenderProperty, SetRenderProperty = __index(game, "DescendantAdded").Connect

local Degrade = (function()
	if getrawmetatable and getupvalue then
		if not select(2, pcall(getrawmetatable(game).__index, Players, "LocalPlayer")) then
			local TemporaryDrawing = Drawingnew("Line")

			if TemporaryDrawing.__OBJECT then
				local __index_render = getupvalue(getmetatable(TemporaryDrawing).__index, 4)

				if __index_render and __index_render(TemporaryDrawing, "Thickness") == 1 then
					return false -- No degrading, meaning the exploit fully supports the optimizations for the module.
				end
			end
		end
	end

	return true
end)()

do
	local TemporaryConnection = Connect(__index(game, "DescendantAdded"), function() end)
	Disconnect = TemporaryConnection.Disconnect
	Disconnect(TemporaryConnection)
end

if not Degrade then
	local TemporaryDrawing = Drawingnew("Line")
	GetRenderProperty = getupvalue(getmetatable(TemporaryDrawing).__index, 4)
	SetRenderProperty = getupvalue(getmetatable(TemporaryDrawing).__newindex, 4)
	TemporaryDrawing.Remove(TemporaryDrawing)
else
	local DrawQuad = loadstring(game.HttpGet(game, "https://raw.githubusercontent.com/Exunys/Custom-Quad-Render-Object/main/Main.lua"))() -- Custom Quad Drawing Object
	local _Drawingnew = clonefunction(Drawing.new)

	local TemporaryDrawing = Drawingnew("Line")
	local Executor = identifyexecutor()
	local SupportsObject, RenderObjectMetatable = (stringfind(Executor, "Wave") or stringfind(Executor, "Synapse Z")) or TemporaryDrawing.__OBJECT

	TemporaryDrawing.Remove(TemporaryDrawing)

	Drawingnew = SupportsObject and _Drawingnew or function(...)
		return ({...})[1] == "Quad" and DrawQuad(...) or setmetatable({
			__OBJECT_EXISTS = true,
			__OBJECT = _Drawingnew(...),

			Remove = function(self)
				self.__OBJECT.Remove(self)
			end
		}, {
			__index = function(self, Index)
				return self[Index]
			end,

			__newindex = function(self, Index, Value)
				self[Index] = Value
			end
		})
	end

	TemporaryDrawing = Drawingnew("Line")
	RenderObjectMetatable = getmetatable(TemporaryDrawing)

	GetRenderProperty, SetRenderProperty = RenderObjectMetatable.__index, RenderObjectMetatable.__newindex -- Must use the "__OBJECT" element for either of these functions otherwise you get a stack overflow.

	TemporaryDrawing.Remove(TemporaryDrawing)

	warn("EXUNYS_ESP > Your exploit does not support this module's optimizations! The visuals might be laggy and decrease performance.")
end

--// Variables

local Inf, Nan, Loaded, CrosshairParts = 1 / 0, 0 / 0, false, {}

--// Checking for multiple processes

if ExunysDeveloperESP and ExunysDeveloperESP.Exit then
	ExunysDeveloperESP:Exit()
end

--// Settings

getgenv().ExunysDeveloperESP = {
	DeveloperSettings = {
		Path = "Exunys Developer/Exunys ESP/Configuration.cfg",
		UnwrapOnCharacterAbsence = false,
		UpdateMode = "RenderStepped",
		TeamCheckOption = "TeamColor",
		RainbowSpeed = 1, -- Bigger = Slower
		WidthBoundary = 1.5 -- Divisor - Smaller Value = Bigger Width
	},

	Settings = {
		Enabled = true,
		PartsOnly = false,
		TeamCheck = false,
		AliveCheck = true,
		LoadConfigOnLaunch = true,
		EnableTeamColors = false,
		TeamColor = Color3fromRGB(170, 170, 255)
	},

	Properties = {
		ESP = {
			Enabled = true,
			RainbowColor = false,
			RainbowOutlineColor = false,
			Offset = 10,

			Color = Color3fromRGB(255, 255, 255),
			Transparency = 1,
			Size = 14,
			Font = DrawingFonts.Plex, -- UI, System, Plex, Monospace

			OutlineColor = Color3fromRGB(0, 0, 0),
			Outline = true,

			DisplayDistance = true,
			DisplayHealth = false,
			DisplayName = false,
			DisplayDisplayName = true,
			DisplayTool = true
		},

		Tracer = {
			Enabled = true,
			RainbowColor = false,
			RainbowOutlineColor = false,
			Position = 1, -- 1 = Bottom; 2 = Center; 3 = Mouse

			Transparency = 1,
			Thickness = 1,
			Color = Color3fromRGB(255, 255, 255),

			Outline = true,
			OutlineColor = Color3fromRGB(0, 0, 0)
		},

		HeadDot = {
			Enabled = true,
			RainbowColor = false,
			RainbowOutlineColor = false,

			Color = Color3fromRGB(255, 255, 255),
			Transparency = 1,
			Thickness = 1,
			NumSides = 30,
			Filled = false,

			OutlineColor = Color3fromRGB(0, 0, 0),
			Outline = true
		},

		Box = {
			Enabled = true,
			RainbowColor = false,
			RainbowOutlineColor = false,

			Color = Color3fromRGB(255, 255, 255),
			Transparency = 1,
			Thickness = 1,
			Filled = false,

			OutlineColor = Color3fromRGB(0, 0, 0),
			Outline = true
		},

		HealthBar = {
			Enabled = true,
			RainbowOutlineColor = false,
			Offset = 4,
			Blue = 100,
			Position = 3, -- 1 = Top; 2 = Bottom; 3 = Left; 4 = Right

			Thickness = 1,
			Transparency = 1,

			OutlineColor = Color3fromRGB(0, 0, 0),
			Outline = true
		},

		Chams = {
			Enabled = false,
			RainbowColor = false,

			Color = Color3fromRGB(255, 255, 255),
			Transparency = 0.2,
			Thickness = 1,
			Filled = false
		},

		Crosshair = {
			Enabled = true,
			RainbowColor = false,
			RainbowOutlineColor = false,
			TStyled = false,
			Position = 1, -- 1 = Mouse; 2 = Center

			Size = 12,
			GapSize = 6,
			Rotation = 0,

			Rotate = false,
			RotateClockwise = true,
			RotationSpeed = 5,

			PulseGap = false,
			PulsingStep = 10,
			PulsingSpeed = 5,
			PulsingBounds = {4, 8}, -- {...}[1] => GapSize Min; {...}[2] => GapSize Max

			Color = Color3fromRGB(0, 255, 0),
			Thickness = 1,
			Transparency = 1,

			OutlineColor = Color3fromRGB(0, 0, 0),
			Outline = true,

			CenterDot = {
				Enabled = true,
				RainbowColor = false,
				RainbowOutlineColor = false,

				Radius = 2,

				Color = Color3fromRGB(0, 255, 0),
				Transparency = 1,
				Thickness = 1,
				NumSides = 60,
				Filled = false,

				OutlineColor = Color3fromRGB(0, 0, 0),
				Outline = true
			}
		}
	},

	UtilityAssets = {
		WrappedObjects = {},
		ServiceConnections = {}
	}
}

local Environment = getgenv().ExunysDeveloperESP

--// Functions

local function Recursive(Table, Callback)
	for Index, Value in next, Table do
		Callback(Index, Value)

		if type(Value) == "table" then
			Recursive(Value, Callback)
		end
	end
end

local CoreFunctions = {
	ConvertVector = function(Vector)
		return Vector2new(Vector.X, Vector.Y)
	end,

	GetColorFromHealth = function(Health, MaxHealth, Blue)
		return Color3fromRGB(255 - mathfloor(Health / MaxHealth * 255), mathfloor(Health / MaxHealth * 255), Blue or 0)
	end,

	GetRainbowColor = function()
		local RainbowSpeed = Environment.DeveloperSettings.RainbowSpeed

		return Color3fromHSV(tick() % RainbowSpeed / RainbowSpeed, 1, 1)
	end,

	GetLocalCharacterPosition = function()
		local LocalCharacter = __index(LocalPlayer, "Character")
		local LocalPlayerCheckPart = LocalCharacter and (__index(LocalCharacter, "PrimaryPart") or FindFirstChild(LocalCharacter, "Head"))

		return LocalPlayerCheckPart and __index(LocalPlayerCheckPart, "Position") or __index(CurrentCamera, "CFrame").Position
	end,

	GenerateHash = function(Bits)
		local Result = ""

		for _ = 1, Bits do
			Result ..= ("EXUNYS_ESP")[mathrandom(1, 2) == 1 and "upper" or "lower"](stringchar(mathrandom(97, 122)))
		end

		return Result
	end,

	CalculateParameters = function(Object)
		Object = type(Object) == "table" and Object.Object or Object

		local DeveloperSettings = Environment.DeveloperSettings
		local WidthBoundary = DeveloperSettings.WidthBoundary

		local IsAPlayer = IsA(Object, "Player")

		local Part = IsAPlayer and (FindFirstChild(Players, __index(Object, "Name")) and __index(Object, "Character"))
		Part = IsAPlayer and Part and (__index(Part, "PrimaryPart") or FindFirstChild(Part, "HumanoidRootPart")) or Object

		if not Part or IsA(Part, "Player") then
			return nil, nil, false
		end

		local PartCFrame, PartPosition, PartUpVector = __index(Part, "CFrame"), __index(Part, "Position")
		PartUpVector = PartCFrame.UpVector

		local RigType = FindFirstChild(__index(Part, "Parent"), "Torso") and "R6" or "R15"

		local CameraUpVector = __index(CurrentCamera, "CFrame").UpVector

		local Top, TopOnScreen = WorldToViewportPoint(PartPosition + (PartUpVector * (RigType == "R6" and 0.5 or 1.8)) + CameraUpVector)
		local Bottom, BottomOnScreen = WorldToViewportPoint(PartPosition - (PartUpVector * (RigType == "R6" and 4 or 2.5)) - CameraUpVector)

		local TopX, TopY = Top.X, Top.Y
		local BottomX, BottomY = Bottom.X, Bottom.Y

		local Width = mathmax(mathfloor(mathabs(TopX - BottomX)), 3)
		local Height = mathmax(mathfloor(mathmax(mathabs(BottomY - TopY), Width / 2)), 3)
		local BoxSize = Vector2new(mathfloor(mathmax(Height / (IsAPlayer and WidthBoundary or 1), Width)), Height)
		local BoxPosition = Vector2new(mathfloor(TopX / 2 + BottomX / 2 - BoxSize.X / 2), mathfloor(mathmin(TopY, BottomY)))

		return BoxPosition, BoxSize, (TopOnScreen and BottomOnScreen)
	end,

	GetColor = function(Player, DefaultColor)
		local Settings, TeamCheckOption = Environment.Settings, Environment.DeveloperSettings.TeamCheckOption

		return Settings.EnableTeamColors and __index(Player, TeamCheckOption) == __index(LocalPlayer, TeamCheckOption) and Settings.TeamColor or DefaultColor
	end,

	Calculate3DQuad = function(_CFrame, SizeVector, YVector)
		YVector = YVector or SizeVector

		return {

			--// Quad 1 - Front

			{
				WorldToViewportPoint(_CFrame * CFramenew(SizeVector.X, YVector.Y, SizeVector.Z).Position), -- Top Left
				WorldToViewportPoint(_CFrame * CFramenew(-SizeVector.X, YVector.Y, SizeVector.Z).Position), -- Top Right
				WorldToViewportPoint(_CFrame * CFramenew(SizeVector.X, -YVector.Y, SizeVector.Z).Position), -- Bottom Left
				WorldToViewportPoint(_CFrame * CFramenew(-SizeVector.X, -YVector.Y, SizeVector.Z).Position) -- Bottom Right
			},


			--// Quad 2 - Back

			{
				WorldToViewportPoint(_CFrame * CFramenew(SizeVector.X, YVector.Y, -SizeVector.Z).Position), -- Top Left
				WorldToViewportPoint(_CFrame * CFramenew(-SizeVector.X, YVector.Y, -SizeVector.Z).Position), -- Top Right
				WorldToViewportPoint(_CFrame * CFramenew(SizeVector.X, -YVector.Y, -SizeVector.Z).Position), -- Bottom Left
				WorldToViewportPoint(_CFrame * CFramenew(-SizeVector.X, -YVector.Y, -SizeVector.Z).Position) -- Bottom Right
			},

			--// Quad 3 - Top

			{
				WorldToViewportPoint(_CFrame * CFramenew(SizeVector.X, YVector.Y, SizeVector.Z).Position), -- Top Left
				WorldToViewportPoint(_CFrame * CFramenew(-SizeVector.X, YVector.Y, SizeVector.Z).Position), -- Top Right
				WorldToViewportPoint(_CFrame * CFramenew(SizeVector.X, YVector.Y, -SizeVector.Z).Position), -- Bottom Left
				WorldToViewportPoint(_CFrame * CFramenew(-SizeVector.X, YVector.Y, -SizeVector.Z).Position) -- Bottom Right
			},

			--// Quad 4 - Bottom

			{
				WorldToViewportPoint(_CFrame * CFramenew(SizeVector.X, -YVector.Y, SizeVector.Z).Position), -- Top Left
				WorldToViewportPoint(_CFrame * CFramenew(-SizeVector.X, -YVector.Y, SizeVector.Z).Position), -- Top Right
				WorldToViewportPoint(_CFrame * CFramenew(SizeVector.X, -YVector.Y, -SizeVector.Z).Position), -- Bottom Left
				WorldToViewportPoint(_CFrame * CFramenew(-SizeVector.X, -YVector.Y, -SizeVector.Z).Position) -- Bottom Right
			},

			--// Quad 5 - Right

			{
				WorldToViewportPoint(_CFrame * CFramenew(SizeVector.X, YVector.Y, SizeVector.Z).Position), -- Top Left
				WorldToViewportPoint(_CFrame * CFramenew(SizeVector.X, YVector.Y, -SizeVector.Z).Position), -- Top Right
				WorldToViewportPoint(_CFrame * CFramenew(SizeVector.X, -YVector.Y, SizeVector.Z).Position), -- Bottom Left
				WorldToViewportPoint(_CFrame * CFramenew(SizeVector.X, -YVector.Y, -SizeVector.Z).Position) -- Bottom Right
			},

			--// Quad 6 - Left

			{
				WorldToViewportPoint(_CFrame * CFramenew(-SizeVector.X, YVector.Y, SizeVector.Z).Position), -- Top Left
				WorldToViewportPoint(_CFrame * CFramenew(-SizeVector.X, YVector.Y, -SizeVector.Z).Position), -- Top Right
				WorldToViewportPoint(_CFrame * CFramenew(-SizeVector.X, -YVector.Y, SizeVector.Z).Position), -- Bottom Left
				WorldToViewportPoint(_CFrame * CFramenew(-SizeVector.X, -YVector.Y, -SizeVector.Z).Position) -- Bottom Right
			}
		}
	end
}

local UpdatingFunctions = {
	ESP = function(Entry, TopTextObject, BottomTextObject)
		local Settings = Environment.Properties.ESP

		local Position, Size, OnScreen = CoreFunctions.CalculateParameters(Entry)

		SetRenderProperty(TopTextObject, "Visible", OnScreen)
		SetRenderProperty(BottomTextObject, "Visible", OnScreen)

		if GetRenderProperty(TopTextObject, "Visible") then
			for Index, Value in next, Settings do
				if stringfind(Index, "Color") or stringfind(Index, "Display") then
					continue
				end

				if not pcall(GetRenderProperty, TopTextObject, Index) then
					continue
				end

				SetRenderProperty(TopTextObject, Index, Value)
				SetRenderProperty(BottomTextObject, Index, Value)
			end

			local GetColor = CoreFunctions.GetColor

			SetRenderProperty(TopTextObject, "Color", GetColor(Entry.Object, Settings.RainbowColor and CoreFunctions.GetRainbowColor() or Settings.Color))
			SetRenderProperty(TopTextObject, "OutlineColor", Settings.RainbowOutlineColor and CoreFunctions.GetRainbowColor() or Settings.OutlineColor)
			SetRenderProperty(BottomTextObject, "Color", GetColor(Entry.Object, Settings.RainbowColor and CoreFunctions.GetRainbowColor() or Settings.Color))
			SetRenderProperty(BottomTextObject, "OutlineColor", Settings.RainbowOutlineColor and CoreFunctions.GetRainbowColor() or Settings.OutlineColor)

			local Offset = mathclamp(Settings.Offset, 10, 30)

			local PositionX, PositionY = Position.X, Position.Y
			local SizeX, SizeY = Size.X, Size.Y

			SetRenderProperty(TopTextObject, "Position", Vector2new(PositionX + (SizeX / 2), PositionY - Offset * 2))
			SetRenderProperty(BottomTextObject, "Position", Vector2new(PositionX + (SizeX / 2), PositionY + SizeY + Offset / 2))

			local Content, Player, IsAPlayer = "", Entry.Object, Entry.IsAPlayer
			local Name, DisplayName = Entry.Name, Entry.DisplayName

			local Character = IsAPlayer and __index(Player, "Character") or Player
			local Humanoid = FindFirstChildOfClass(Character, "Humanoid")
			local Health, MaxHealth = Humanoid and __index(Humanoid, "Health") or Nan, Humanoid and __index(Humanoid, "MaxHealth") or Nan

			local Tool = Settings.DisplayTool and FindFirstChildOfClass(Character, "Tool")

			Content = ((Settings.DisplayDisplayName and Settings.DisplayName and DisplayName ~= Name) and stringformat("%s (%s)", DisplayName, Name) or (Settings.DisplayDisplayName and not Settings.DisplayName) and DisplayName or (not Settings.DisplayDisplayName and Settings.DisplayName) and Name or (Settings.DisplayName and Settings.DisplayDisplayName and DisplayName == Name) and Name) or Content
			Content = Settings.DisplayHealth and IsAPlayer and stringformat("[%s / %s] ", mathfloor(Health), MaxHealth)..Content or Content

			SetRenderProperty(TopTextObject, "Text", Content)

			local PlayerPosition = __index((IsAPlayer and (__index(Character, "PrimaryPart") or __index(Character, "Head")) or Character), "Position") or Vector3zero

			local Distance = Settings.DisplayDistance and mathfloor((PlayerPosition - CoreFunctions.GetLocalCharacterPosition()).Magnitude)

			Content = Distance and stringformat("%s Studs", Distance) or ""

			SetRenderProperty(BottomTextObject, "Text", Content..(Tool and ((Distance and "\n" or "")..__index(Tool, "Name")) or ""))
		end
	end,

	Tracer = function(Entry, TracerObject, TracerOutlineObject)
		local Settings = Environment.Properties.Tracer

		local Position, Size, OnScreen = CoreFunctions.CalculateParameters(Entry)

		SetRenderProperty(TracerObject, "Visible", OnScreen)
		SetRenderProperty(TracerOutlineObject, "Visible", OnScreen and Settings.Outline)

		if GetRenderProperty(TracerObject, "Visible") then
			for Index, Value in next, Settings do
				if Index == "Color" then
					continue
				end

				if not pcall(GetRenderProperty, TracerObject, Index) then
					continue
				end

				SetRenderProperty(TracerObject, Index, Value)
			end

			SetRenderProperty(TracerObject, "Color", CoreFunctions.GetColor(Entry.Object, Settings.RainbowColor and CoreFunctions.GetRainbowColor() or Settings.Color))

			local CameraViewportSize = __index(CurrentCamera, "ViewportSize")

			if Settings.Position == 1 then
				SetRenderProperty(TracerObject, "From", Vector2new(CameraViewportSize.X / 2, CameraViewportSize.Y))
			elseif Settings.Position == 2 then
				SetRenderProperty(TracerObject, "From", CameraViewportSize / 2)
			elseif Settings.Position == 3 then
				SetRenderProperty(TracerObject, "From", GetMouseLocation())
			else
				Settings.Position = 1
			end

			SetRenderProperty(TracerObject, "To", Vector2new(Position.X + (Size.X / 2), Position.Y + Size.Y))

			if Settings.Outline then
				SetRenderProperty(TracerOutlineObject, "Color", Settings.RainbowOutlineColor and CoreFunctions.GetRainbowColor() or Settings.OutlineColor)
				SetRenderProperty(TracerOutlineObject, "Thickness", Settings.Thickness + 1)
				SetRenderProperty(TracerOutlineObject, "Transparency", Settings.Transparency)

				SetRenderProperty(TracerOutlineObject, "From", GetRenderProperty(TracerObject, "From"))
				SetRenderProperty(TracerOutlineObject, "To", GetRenderProperty(TracerObject, "To"))
			end
		end
	end,

	HeadDot = function(Entry, CircleObject, CircleOutlineObject)
		local Settings = Environment.Properties.HeadDot

		local Character = Entry.IsAPlayer and __index(Entry.Object, "Character") or __index(Entry.Object, "Parent")
		local Head = Character and FindFirstChild(Character, "Head")

		if not Head then
			SetRenderProperty(CircleObject, "Visible", false)
			SetRenderProperty(CircleOutlineObject, "Visible", false)

			return
		end

		local HeadCFrame, HeadSize = __index(Head, "CFrame"), __index(Head, "Size")

		local Vector, OnScreen = WorldToViewportPoint(HeadCFrame.Position)
		local Top, Bottom = WorldToViewportPoint((HeadCFrame * CFramenew(0, HeadSize.Y / 2, 0)).Position), WorldToViewportPoint((HeadCFrame * CFramenew(0, -HeadSize.Y / 2, 0)).Position)

		SetRenderProperty(CircleObject, "Visible", OnScreen)
		SetRenderProperty(CircleOutlineObject, "Visible", OnScreen and Settings.Outline)

		if GetRenderProperty(CircleObject, "Visible") then
			for Index, Value in next, Settings do
				if stringfind(Index, "Color") then
					continue
				end

				if not pcall(GetRenderProperty, CircleObject, Index) then
					continue
				end

				SetRenderProperty(CircleObject, Index, Value)

				if Settings.Outline then
					SetRenderProperty(CircleOutlineObject, Index, Value)
				end
			end

			SetRenderProperty(CircleObject, "Color", CoreFunctions.GetColor(Entry.Object, Settings.RainbowColor and CoreFunctions.GetRainbowColor() or Settings.Color))

			SetRenderProperty(CircleObject, "Position", CoreFunctions.ConvertVector(Vector))
			SetRenderProperty(CircleObject, "Radius", mathabs((Top - Bottom).Y) - 3)

			if Settings.Outline then
				SetRenderProperty(CircleOutlineObject, "Color", Settings.RainbowOutlineColor and CoreFunctions.GetRainbowColor() or Settings.OutlineColor)

				SetRenderProperty(CircleOutlineObject, "Thickness", Settings.Thickness + 1)
				SetRenderProperty(CircleOutlineObject, "Transparency", Settings.Transparency)

				SetRenderProperty(CircleOutlineObject, "Position", GetRenderProperty(CircleObject, "Position"))
				SetRenderProperty(CircleOutlineObject, "Radius", GetRenderProperty(CircleObject, "Radius"))
			end
		end
	end,

	Box = function(Entry, BoxObject, BoxOutlineObject)
		local Settings = Environment.Properties.Box

		local Position, Size, OnScreen = CoreFunctions.CalculateParameters(Entry)

		SetRenderProperty(BoxObject, "Visible", OnScreen)
		SetRenderProperty(BoxOutlineObject, "Visible", OnScreen and Settings.Outline)

		if GetRenderProperty(BoxObject, "Visible") then
			SetRenderProperty(BoxObject, "Position", Position)
			SetRenderProperty(BoxObject, "Size", Size)

			for Index, Value in next, Settings do
				if Index == "Color" then
					continue
				end

				if not pcall(GetRenderProperty, BoxObject, Index) then
					continue
				end

				SetRenderProperty(BoxObject, Index, Value)
			end

			SetRenderProperty(BoxObject, "Color", CoreFunctions.GetColor(Entry.Object, Settings.RainbowColor and CoreFunctions.GetRainbowColor() or Settings.Color))

			if Settings.Outline then
				SetRenderProperty(BoxOutlineObject, "Position", Position)
				SetRenderProperty(BoxOutlineObject, "Size", Size)

				SetRenderProperty(BoxOutlineObject, "Color", Settings.RainbowOutlineColor and CoreFunctions.GetRainbowColor() or Settings.OutlineColor)

				SetRenderProperty(BoxOutlineObject, "Thickness", Settings.Thickness + 1)
				SetRenderProperty(BoxOutlineObject, "Transparency", Settings.Transparency)
			end
		end
	end,

	HealthBar = function(Entry, MainObject, OutlineObject, Humanoid)
		local Settings = Environment.Properties.HealthBar

		local Position, Size, OnScreen = CoreFunctions.CalculateParameters(Entry)

		SetRenderProperty(MainObject, "Visible", OnScreen)
		SetRenderProperty(OutlineObject, "Visible", OnScreen and Settings.Outline)

		if GetRenderProperty(MainObject, "Visible") then
			for Index, Value in next, Settings do
				if Index == "Color" then
					continue
				end

				if not pcall(GetRenderProperty, MainObject, Index) then
					continue
				end

				SetRenderProperty(MainObject, Index, Value)
			end

			Humanoid = Humanoid or FindFirstChildOfClass(__index(Entry.Object, "Character"), "Humanoid")

			local MaxHealth = Humanoid and __index(Humanoid, "MaxHealth") or 100
			local Health = Humanoid and mathclamp(__index(Humanoid, "Health"), 0, MaxHealth) or 0

			local Offset = mathclamp(Settings.Offset, 4, 12)

			SetRenderProperty(MainObject, "Color", CoreFunctions.GetColorFromHealth(Health, MaxHealth, Settings.Blue))

			if Settings.Position == 1 then
				SetRenderProperty(MainObject, "From", Vector2new(Position.X, Position.Y - Offset))
				SetRenderProperty(MainObject, "To", Vector2new(Position.X + (Health / MaxHealth) * Size.X, Position.Y - Offset))

				if Settings.Outline then
					SetRenderProperty(OutlineObject, "From", Vector2new(Position.X - 1, Position.Y - Offset))
					SetRenderProperty(OutlineObject, "To", Vector2new(Position.X + Size.X + 1, Position.Y - Offset))
				end
			elseif Settings.Position == 2 then
				SetRenderProperty(MainObject, "From", Vector2new(Position.X, Position.Y + Size.Y + Offset))
				SetRenderProperty(MainObject, "To", Vector2new(Position.X + (Health / MaxHealth) * Size.X, Position.Y + Size.Y + Offset))

				if Settings.Outline then
					SetRenderProperty(OutlineObject, "From", Vector2new(Position.X - 1, Position.Y + Size.Y + Offset))
					SetRenderProperty(OutlineObject, "To", Vector2new(Position.X + Size.X + 1, Position.Y + Size.Y + Offset))
				end
			elseif Settings.Position == 3 then
				SetRenderProperty(MainObject, "From", Vector2new(Position.X - Offset, Position.Y + Size.Y))
				SetRenderProperty(MainObject, "To", Vector2new(Position.X - Offset, GetRenderProperty(MainObject, "From").Y - (Health / MaxHealth) * Size.Y))

				if Settings.Outline then
					SetRenderProperty(OutlineObject, "From", Vector2new(Position.X - Offset, Position.Y + Size.Y + 1))
					SetRenderProperty(OutlineObject, "To", Vector2new(Position.X - Offset, (GetRenderProperty(OutlineObject, "From").Y - 1 * Size.Y) - 2))
				end
			elseif Settings.Position == 4 then
				SetRenderProperty(MainObject, "From", Vector2new(Position.X + Size.X + Offset, Position.Y + Size.Y))
				SetRenderProperty(MainObject, "To", Vector2new(Position.X + Size.X + Offset, GetRenderProperty(MainObject, "From").Y - (Health / MaxHealth) * Size.Y))

				if Settings.Outline then
					SetRenderProperty(OutlineObject, "From", Vector2new(Position.X + Size.X + Offset, Position.Y + Size.Y + 1))
					SetRenderProperty(OutlineObject, "To", Vector2new(Position.X + Size.X + Offset, (GetRenderProperty(OutlineObject, "From").Y - 1 * Size.Y) - 2))
				end
			else
				Settings.Position = 3
			end

			if Settings.Outline then
				SetRenderProperty(OutlineObject, "Color", Settings.RainbowOutlineColor and CoreFunctions.GetRainbowColor() or Settings.OutlineColor)

				SetRenderProperty(OutlineObject, "Thickness", Settings.Thickness + 1)
				SetRenderProperty(OutlineObject, "Transparency", Settings.Transparency)
			end
		end
	end,

	Chams = function(Entry, Part, Cham)
		local Settings = Environment.Properties.Chams

		if not (Part and Cham and Entry) then
			return
		end

		local ChamsEnabled, ESPEnabled = Settings.Enabled, Environment.Settings.Enabled
		local IsReady = Entry.Checks.Ready

		local ConvertVector = CoreFunctions.ConvertVector

		local _CFrame, PartSize = select(2, pcall(function()
			return __index(Part, "CFrame"), __index(Part, "Size") / 2
		end))

		if not (ChamsEnabled and ESPEnabled and IsReady and _CFrame and PartSize and select(2, WorldToViewportPoint(_CFrame.Position))) then
			for Index = 1, 6 do
				SetRenderProperty(Cham["Quad"..Index], "Visible", false)
			end

			return
		end

		local Quads = {
			Quad1Object = Cham.Quad1,
			Quad2Object = Cham.Quad2,
			Quad3Object = Cham.Quad3,
			Quad4Object = Cham.Quad4,
			Quad5Object = Cham.Quad5,
			Quad6Object = Cham.Quad6
		}

		for Index, Value in next, Settings do
			if Index == "Enabled" then
				Index, Value = "Visible", ChamsEnabled and ESPEnabled and IsReady
			elseif Index == "Color" then
				Value = CoreFunctions.GetColor(Entry.Object, Settings.RainbowColor and CoreFunctions.GetRainbowColor() or Settings.Color)
			end

			if not pcall(GetRenderProperty, Quads.Quad1Object, Index) then
				continue
			end

			for _, RenderObject in next, Quads do
				SetRenderProperty(RenderObject, Index, Value)
			end
		end

		local Indexes, Positions = {1, 3, 4, 2}, CoreFunctions.Calculate3DQuad(_CFrame, PartSize)

		for Index = 1, 6 do
			local RenderObject = Quads["Quad"..Index.."Object"]

			for _Index = 1, 4 do
				SetRenderProperty(RenderObject, "Point"..stringchar(_Index + 64), ConvertVector(Positions[Index][Indexes[_Index]]))
			end
		end
	end
}

local CreatingFunctions = {
	ESP = function(Entry)
		local Allowed = Entry.Allowed

		if type(Allowed) == "table" and type(Allowed.ESP) == "boolean" and not Allowed.ESP then
			return
		end

		local Settings = Environment.Properties.ESP

		local TopText = Drawingnew("Text")
		local TopTextObject = TopText.__OBJECT

		SetRenderProperty(TopTextObject, "ZIndex", 4)
		SetRenderProperty(TopTextObject, "Center", true)

		local BottomText = Drawingnew("Text")
		local BottomTextObject = BottomText.__OBJECT

		SetRenderProperty(BottomTextObject, "ZIndex", 4)
		SetRenderProperty(BottomTextObject, "Center", true)

		Entry.Visuals.ESP[1] = TopText
		Entry.Visuals.ESP[2] = BottomText

		Entry.Connections.ESP = Connect(__index(RunService, Environment.DeveloperSettings.UpdateMode), function()
			local Functionable, Ready = pcall(function()
				return Environment.Settings.Enabled and Settings.Enabled and Entry.Checks.Ready
			end)

			if not Functionable then
				pcall(TopText.Remove, TopText)
				pcall(BottomText.Remove, BottomText)

				return Disconnect(Entry.Connections.ESP)
			end

			if Ready then
				UpdatingFunctions.ESP(Entry, TopTextObject, BottomTextObject)
			else
				SetRenderProperty(TopTextObject, "Visible", false)
				SetRenderProperty(BottomTextObject, "Visible", false)
			end
		end)
	end,

	Tracer = function(Entry)
		local Allowed = Entry.Allowed

		if type(Allowed) == "table" and type(Allowed.Tracer) == "boolean" and not Allowed.Tracer then
			return
		end

		local Settings = Environment.Properties.Tracer

		local Tracer = Drawingnew("Line")
		local TracerObject = Tracer.__OBJECT

		SetRenderProperty(TracerObject, "ZIndex", Degrade and -2 or -1)

		local TracerOutline = Drawingnew("Line")
		local TracerOutlineObject = TracerOutline.__OBJECT

		SetRenderProperty(TracerObject, "ZIndex", Degrade and 1 or 0)

		Entry.Visuals.Tracer[1] = Tracer
		Entry.Visuals.Tracer[2] = TracerOutline

		Entry.Connections.Tracer = Connect(__index(RunService, Environment.DeveloperSettings.UpdateMode), function()
			local Functionable, Ready = pcall(function()
				return Environment.Settings.Enabled and Settings.Enabled and Entry.Checks.Ready
			end)

			if not Functionable then
				pcall(Tracer.Remove, Tracer)
				pcall(TracerOutline.Remove, TracerOutline)

				return Disconnect(Entry.Connections.Tracer)
			end

			if Ready then
				UpdatingFunctions.Tracer(Entry, TracerObject, TracerOutlineObject)
			else
				SetRenderProperty(TracerObject, "Visible", false)
				SetRenderProperty(TracerOutlineObject, "Visible", false)
			end
		end)
	end,

	HeadDot = function(Entry)
		local Allowed = Entry.Allowed

		if type(Allowed) == "table" and type(Allowed.HeadDot) == "boolean" and not Allowed.HeadDot then
			return
		end

		if not Entry.IsAPlayer and not Entry.PartHasCharacter then
			if not FindFirstChild(__index(Entry.Object, "Parent"), "Head") then
				return
			end
		end

		local Settings = Environment.Properties.HeadDot

		local Circle = Drawingnew("Circle")
		local CircleObject = Circle.__OBJECT

		SetRenderProperty(CircleObject, "ZIndex", 2)

		local CircleOutline = Drawingnew("Circle")
		local CircleOutlineObject = CircleOutline.__OBJECT

		SetRenderProperty(CircleOutlineObject, "ZIndex", 1)

		Entry.Visuals.HeadDot[1] = Circle
		Entry.Visuals.HeadDot[2] = CircleOutline

		Entry.Connections.HeadDot = Connect(__index(RunService, Environment.DeveloperSettings.UpdateMode), function()
			local Functionable, Ready = pcall(function()
				return Environment.Settings.Enabled and Settings.Enabled and Entry.Checks.Ready
			end)

			if not Functionable then
				pcall(Circle.Remove, Circle)
				pcall(CircleOutline.Remove, CircleOutline)

				return Disconnect(Entry.Connections.HeadDot)
			end

			if Ready then
				UpdatingFunctions.HeadDot(Entry, CircleObject, CircleOutlineObject)
			else
				SetRenderProperty(CircleObject, "Visible", false)
				SetRenderProperty(CircleOutlineObject, "Visible", false)
			end
		end)
	end,

	Box = function(Entry)
		local Allowed = Entry.Allowed

		if type(Allowed) == "table" and type(Allowed.Box) == "boolean" and not Allowed.Box then
			return
		end

		local Settings = Environment.Properties.Box

		local Box = Drawingnew("Square")
		local BoxObject = Box.__OBJECT

		SetRenderProperty(BoxObject, "ZIndex", 4)

		local BoxOutline = Drawingnew("Square")
		local BoxOutlineObject = BoxOutline.__OBJECT

		SetRenderProperty(BoxOutlineObject, "ZIndex", 3)

		Entry.Visuals.Box[1] = Box
		Entry.Visuals.Box[2] = BoxOutline

		Entry.Connections.Box = Connect(__index(RunService, Environment.DeveloperSettings.UpdateMode), function()
			local Functionable, Ready = pcall(function()
				return Environment.Settings.Enabled and Settings.Enabled and Entry.Checks.Ready
			end)

			if not Functionable then
				pcall(Box.Remove, Box)
				pcall(BoxOutline.Remove, BoxOutline)

				return Disconnect(Entry.Connections.Box)
			end

			if Ready then
				UpdatingFunctions.Box(Entry, BoxObject, BoxOutlineObject)
			else
				SetRenderProperty(BoxObject, "Visible", false)
				SetRenderProperty(BoxOutlineObject, "Visible", false)
			end
		end)
	end,

	HealthBar = function(Entry)
		local Allowed = Entry.Allowed

		if type(Allowed) == "table" and type(Allowed.HealthBar) == "boolean" and not Allowed.HealthBar then
			return
		end

		local Humanoid = FindFirstChildOfClass(__index(Entry.Object, "Parent"), "Humanoid")

		if not Entry.IsAPlayer and not Humanoid then
			return
		end

		local Settings = Environment.Properties.HealthBar

		local Main = Drawingnew("Line")
		local MainObject = Main.__OBJECT

		SetRenderProperty(MainObject, "ZIndex", 2)

		local Outline = Drawingnew("Line")
		local OutlineObject = Outline.__OBJECT

		SetRenderProperty(OutlineObject, "ZIndex", 1)

		Entry.Visuals.HealthBar[1] = Main
		Entry.Visuals.HealthBar[2] = Outline

		Entry.Connections.HealthBar = Connect(__index(RunService, Environment.DeveloperSettings.UpdateMode), function()
			local Functionable, Ready = pcall(function()
				return Environment.Settings.Enabled and Settings.Enabled and Entry.Checks.Ready
			end)

			if not Functionable then
				pcall(Main.Remove, Main)
				pcall(Outline.Remove, Outline)

				return Disconnect(Entry.Connections.HealthBar)
			end

			if Ready then
				UpdatingFunctions.HealthBar(Entry, MainObject, OutlineObject, Humanoid)
			else
				SetRenderProperty(MainObject, "Visible", false)
				SetRenderProperty(OutlineObject, "Visible", false)
			end
		end)
	end,

	Chams = function(self, Entry)
		local Allowed = Entry.Allowed

		if type(Allowed) == "table" and type(Allowed.Chams) == "boolean" and not Allowed.Chams then
			return
		end

		local Object = Entry.Object
		local RigType = Entry.RigType
		local IsAPlayer = Entry.IsAPlayer

		local ChamsEntry = {}

		local PlayerCharacter = IsAPlayer and __index(Object, "Character")

		local Settings = Environment.Properties.Chams

		local Cancel, UnconfirmedRigType = false, RigType == "N/A"

		if UnconfirmedRigType and PlayerCharacter then
			RigType = (FindFirstChild(PlayerCharacter, "UpperTorso") or WaitForChild(PlayerCharacter, "LowerTorso", Inf)) and "R15" or FindFirstChild(PlayerCharacter, "Torso") and "R6" or "N/A"
		end

		if RigType == "N/A" then
			ChamsEntry[__index(Object, "Name")] = {}
		else
			ChamsEntry = RigType == "R15" and {
				Head = {},
				UpperTorso = {}, LowerTorso = {},
				LeftLowerArm = {}, LeftUpperArm = {}, LeftHand = {},
				RightLowerArm = {}, RightUpperArm = {}, RightHand = {},
				LeftLowerLeg = {}, LeftUpperLeg = {}, LeftFoot = {},
				RightLowerLeg = {}, RightUpperLeg = {}, RightFoot = {}
			} or RigType == "R6" and {
				Head = {},
				Torso = {},
				["Left Arm"] = {},
				["Right Arm"] = {},
				["Left Leg"] = {},
				["Right Leg"] = {}
			}
		end

		Entry.Visuals.Chams = ChamsEntry

		local ChamsEntryObjects = {}

		for _Index, Value in next, ChamsEntry do
			ChamsEntryObjects[_Index] = {}

			for Index = 1, 6 do
				Value["Quad"..Index] = Drawingnew("Quad")
				ChamsEntryObjects[_Index]["Quad"..Index] = Value["Quad"..Index]
			end
		end

		local Visibility = function(Value)
			for _, _Value in next, ChamsEntryObjects do
				for Index = 1, 6 do
					SetRenderProperty(_Value["Quad"..Index], "Visible", Value)
				end
			end
		end

		Entry.Connections.Chams = Connect(__index(RunService, Environment.DeveloperSettings.UpdateMode), function()
			local Functionable, Ready = pcall(function()
				return Environment.Settings.Enabled and Settings.Enabled and Entry.Checks.Ready
			end)

			if not Functionable then
				for Index, Value in next, ChamsEntry do
					pcall(Value.Remove, Value)
				end

				return Disconnect(Entry.Connections.Chams)
			end

			if Ready then
				local Character = PlayerCharacter or __index(Object, "Parent")

				if Character and IsDescendantOf(Character, Workspace) then
					for Index, Value in next, ChamsEntryObjects do
						local Part = WaitForChild(Character, Index, Inf)

						if Part and IsDescendantOf(Part, Workspace) then
							UpdatingFunctions.Chams(Entry, Part, Value)
						else
							Visibility(false)
						end
					end
				else
					Visibility(false)
				end
			else
				Visibility(false)
			end
		end)
	end,

	Crosshair = function()
		if CrosshairParts.LeftLine then
			return
		end

		local ServiceConnections = Environment.UtilityAssets.ServiceConnections
		local DeveloperSettings = Environment.DeveloperSettings
		local Settings = Environment.Properties.Crosshair

		CrosshairParts = {
			LeftLine = Drawingnew("Line"),
			RightLine = Drawingnew("Line"),
			TopLine = Drawingnew("Line"),
			BottomLine = Drawingnew("Line"),
			CenterDot = Drawingnew("Circle"),

			OutlineLeftLine = Drawingnew("Line"),
			OutlineRightLine = Drawingnew("Line"),
			OutlineTopLine = Drawingnew("Line"),
			OutlineBottomLine = Drawingnew("Line"),
			OutlineCenterDot = Drawingnew("Circle")
		}

		local RenderObjects = {}

		for Index, Value in next, CrosshairParts do
			SetRenderProperty(Value.__OBJECT, "Visible", false) -- For some exploits, the parts are visible at the top left corner of the screen (when the crosshair is disabled upon execution).
			RenderObjects[Index] = Value.__OBJECT
		end

		for Index, Value in next, RenderObjects do
			SetRenderProperty(Value, "ZIndex", stringfind(Index, "Outline") and 9 or 10)
		end

		local Axis, Rotation, GapSize = GetMouseLocation(), Settings.Rotation, Settings.GapSize

		ServiceConnections.UpdateCrosshairProperties, ServiceConnections.UpdateCrosshair = Connect(__index(RunService, DeveloperSettings.UpdateMode), function()
			if Settings.Enabled and Environment.Settings.Enabled then
				if Settings.Position == 1 then
					Axis = GetMouseLocation()
				elseif Settings.Position == 2 then
					Axis = __index(CurrentCamera, "ViewportSize") / 2
				else
					Settings.Position = 1
				end

				if Settings.PulseGap then
					Settings.PulsingStep = mathclamp(Settings.PulsingStep, 0, 24)
					Settings.PulsingSpeed = mathclamp(Settings.PulsingSpeed, 1, 20)

					local PulsingStep = mathclamp(Settings.PulsingStep, unpack(Settings.PulsingBounds))

					GapSize = mathabs(mathsin(tick() * Settings.PulsingSpeed) * PulsingStep)
					GapSize = mathclamp(GapSize, unpack(Settings.PulsingBounds))
				else
					GapSize = Settings.GapSize
				end

				if Settings.Rotate then
					Settings.RotationSpeed = mathclamp(Settings.RotationSpeed, 1, 20)

					Rotation = mathdeg(tick() * Settings.RotationSpeed)
					Rotation = Settings.RotateClockwise and Rotation or -Rotation
				else
					Rotation = Settings.Rotation
				end

				GapSize = mathclamp(GapSize, 0, 24)
			end
		end), Connect(__index(RunService, DeveloperSettings.UpdateMode), function()
			if Environment.Settings.Enabled then
				local AxisX, AxisY, Size = Axis.X, Axis.Y, Settings.Size

				for ObjectName, RenderObject in next, RenderObjects do
					for Index, _ in next, {Color = true, Transparency = true, Thickness = true} do
						local Value = Settings[Index]

						if (Index == "Color" or Index == "Thickness") and (stringfind(ObjectName, "Outline") or stringfind(ObjectName, "CenterDot")) then
							continue
						end

						if Index == "Color" and not (stringfind(ObjectName, "Outline") or stringfind(ObjectName, "CenterDot")) then
							Value = Settings.RainbowColor and CoreFunctions.GetRainbowColor() or Value
						end

						if not pcall(GetRenderProperty, RenderObject, Index) then
							continue
						end

						SetRenderProperty(RenderObject, Index, Value)
					end
				end

				--// Left Line

				SetRenderProperty(RenderObjects.LeftLine, "Visible", Settings.Enabled)

				SetRenderProperty(RenderObjects.LeftLine, "From", Vector2new(AxisX - (mathcos(mathrad(Rotation)) * GapSize), AxisY - (mathsin(mathrad(Rotation)) * GapSize)))
				SetRenderProperty(RenderObjects.LeftLine, "To", Vector2new(AxisX - (mathcos(mathrad(Rotation)) * (Size + GapSize)), AxisY - (mathsin(mathrad(Rotation)) * (Size + GapSize))))

				--// Right Line

				SetRenderProperty(RenderObjects.RightLine, "Visible", Settings.Enabled)

				SetRenderProperty(RenderObjects.RightLine, "From", Vector2new(AxisX + (mathcos(mathrad(Rotation)) * GapSize), AxisY + (mathsin(mathrad(Rotation)) * GapSize)))
				SetRenderProperty(RenderObjects.RightLine, "To", Vector2new(AxisX + (mathcos(mathrad(Rotation)) * (Size + GapSize)), AxisY + (mathsin(mathrad(Rotation)) * (Size + GapSize))))

				--// Top Line

				SetRenderProperty(RenderObjects.TopLine, "Visible", Settings.Enabled and not Settings.TStyled)

				SetRenderProperty(RenderObjects.TopLine, "From", Vector2new(AxisX - (mathsin(mathrad(-Rotation)) * GapSize), AxisY - (mathcos(mathrad(-Rotation)) * GapSize)))
				SetRenderProperty(RenderObjects.TopLine, "To", Vector2new(AxisX - (mathsin(mathrad(-Rotation)) * (Size + GapSize)), AxisY - (mathcos(mathrad(-Rotation)) * (Size + GapSize))))

				--// Bottom Line

				SetRenderProperty(RenderObjects.BottomLine, "Visible", Settings.Enabled)

				SetRenderProperty(RenderObjects.BottomLine, "From", Vector2new(AxisX + (mathsin(mathrad(-Rotation)) * GapSize), AxisY + (mathcos(mathrad(-Rotation)) * GapSize)))
				SetRenderProperty(RenderObjects.BottomLine, "To", Vector2new(AxisX + (mathsin(mathrad(-Rotation)) * (Size + GapSize)), AxisY + (mathcos(mathrad(-Rotation)) * (Size + GapSize))))

				--// Outlines

				if Settings.Outline then
					local Table = {"LeftLine", "RightLine", "TopLine", "BottomLine"}

					for _Index = 1, 4 do
						local Index = Table[_Index]
						local Value, _Value = RenderObjects["Outline"..Index], RenderObjects[Index]

						SetRenderProperty(Value, "Visible", GetRenderProperty(_Value, "Visible"))
						SetRenderProperty(Value, "Thickness", GetRenderProperty(_Value, "Thickness") + 1)
						SetRenderProperty(Value, "Color", Settings.RainbowOutlineColor and CoreFunctions.GetRainbowColor() or Settings.OutlineColor)

						local From, To = GetRenderProperty(_Value, "From"), GetRenderProperty(_Value, "To")

						if not (Settings.Rotate and Settings.RotationSpeed <= 5) then
							if Index == "TopLine" then
								SetRenderProperty(Value, "From", Vector2new(From.X, From.Y + 1))
								SetRenderProperty(Value, "To", Vector2new(To.X, To.Y - 1))
							elseif Index == "BottomLine" then
								SetRenderProperty(Value, "From", Vector2new(From.X, From.Y - 1))
								SetRenderProperty(Value, "To", Vector2new(To.X, To.Y + 1))
							elseif Index == "LeftLine" then
								SetRenderProperty(Value, "From", Vector2new(From.X + 1, From.Y))
								SetRenderProperty(Value, "To", Vector2new(To.X - 1, To.Y))
							elseif Index == "RightLine" then
								SetRenderProperty(Value, "From", Vector2new(From.X - 1, From.Y))
								SetRenderProperty(Value, "To", Vector2new(To.X + 1, To.Y))
							end
						else
							SetRenderProperty(Value, "From", From)
							SetRenderProperty(Value, "To", To)
						end
					end
				else
					for _, Index in next, {"LeftLine", "RightLine", "TopLine", "BottomLine"} do
						SetRenderProperty(RenderObjects["Outline"..Index], "Visible", false)
					end
				end

				--// Center Dot

				local CenterDot = RenderObjects.CenterDot
				local CenterDotSettings = Settings.CenterDot

				SetRenderProperty(CenterDot, "Visible", Settings.Enabled and CenterDotSettings.Enabled)
				SetRenderProperty(RenderObjects.OutlineCenterDot, "Visible", Settings.Enabled and CenterDotSettings.Enabled and CenterDotSettings.Outline)

				if GetRenderProperty(CenterDot, "Visible") then
					for Index, Value in next, CenterDotSettings do
						if Index == "Color" then
							Value = CenterDotSettings.RainbowColor and CoreFunctions.GetRainbowColor() or Value
						end

						if not pcall(GetRenderProperty, CenterDot, Index) then
							continue
						end

						SetRenderProperty(CenterDot, Index, Value)

						if Index ~= "Color" or Index ~= "Thickness" then
							SetRenderProperty(RenderObjects.OutlineCenterDot, Index, Value)
						end
					end

					SetRenderProperty(CenterDot, "Position", Axis)

					if CenterDotSettings.Outline then
						SetRenderProperty(RenderObjects.OutlineCenterDot, "Thickness", GetRenderProperty(CenterDot, "Thickness") + 1)
						SetRenderProperty(RenderObjects.OutlineCenterDot, "Color", CenterDotSettings.RainbowOutlineColor and CoreFunctions.GetRainbowColor() or CenterDotSettings.OutlineColor)

						SetRenderProperty(RenderObjects.OutlineCenterDot, "Position", Axis)
					end
				end
			else
				for _, RenderObject in next, RenderObjects do
					SetRenderProperty(RenderObject, "Visible", false)
				end
			end
		end)
	end
}

local UtilityFunctions = {
	InitChecks = function(self, Entry)
		if not Entry.IsAPlayer and not Entry.PartHasCharacter and not Entry.RenderDistance then
			return
		end

		local Player = Entry.Object
		local Checks = Entry.Checks
		local Hash = Entry.Hash

		local IsAPlayer = Entry.IsAPlayer

		local Settings = Environment.Settings

		local DeveloperSettings = Environment.DeveloperSettings

		local LocalCharacterPosition = CoreFunctions.GetLocalCharacterPosition()

		Entry.Connections.UpdateChecks = Connect(__index(RunService, DeveloperSettings.UpdateMode), function()
			local RenderDistance = Entry.RenderDistance

			if not IsAPlayer and not Entry.PartHasCharacter then -- Part
				Checks.Ready = (__index(Player, "Position") - LocalCharacterPosition).Magnitude <= RenderDistance; return
			end

			local PartHumanoid = FindFirstChildOfClass(__index(Player, "Parent"), "Humanoid")

			if not IsAPlayer then -- NPC
				Checks.Ready = Entry.PartHasCharacter and PartHumanoid and IsDescendantOf(Player, Workspace)

				if not Checks.Ready then
					return self.UnwrapObject(Hash)
				end

				if Settings.AliveCheck then
					Checks.Alive = __index(PartHumanoid, "Health") > 0
				end

				local IsInDistance = (__index(PartHumanoid and __index(Player, "PrimaryPart"), "Position") - LocalCharacterPosition).Magnitude <= RenderDistance

				Checks.Ready = Checks.Ready and Checks.Alive and IsInDistance

				return
			end

			local Character = __index(Player, "Character")
			local Humanoid = Character and FindFirstChildOfClass(Character, "Humanoid")
			local Head = Character and FindFirstChild(Character, "Head")

			local IsInDistance

			if Character and IsDescendantOf(Character, Workspace) and Humanoid and Head then -- Player
				local TeamCheckOption = DeveloperSettings.TeamCheckOption

				Checks.Alive = true
				Checks.Team = true

				if Settings.AliveCheck then
					Checks.Alive = __index(Humanoid, "Health") > 0
				end

				if Settings.TeamCheck then
					Checks.Team = __index(Player, TeamCheckOption) ~= __index(LocalPlayer, TeamCheckOption)
				end

				IsInDistance = (__index(Head, "Position") - LocalCharacterPosition).Magnitude <= RenderDistance
			else
				Checks.Alive = false
				Checks.Team = false

				if DeveloperSettings.UnwrapOnCharacterAbsence then
					self.UnwrapObject(Hash)
				end
			end

			Checks.Ready = Checks.Alive and Checks.Team and not Settings.PartsOnly and IsInDistance

			if Checks.Ready then
				local Part = IsAPlayer and (FindFirstChild(Players, __index(Player, "Name")) and __index(Player, "Character"))
				Part = IsAPlayer and (Part and (__index(Part, "PrimaryPart") or FindFirstChild(Part, "HumanoidRootPart"))) or Player

				Entry.RigType = Humanoid and FindFirstChild(__index(Part, "Parent"), "Torso") and "R6" or "R15"
				Entry.RigType = Entry.RigType == "N/A" and Humanoid and (__index(Humanoid, "RigType") == 0 and "R6" or "R15") or "N/A" -- Deprecated method (might be faulty sometimes)
				Entry.RigType = Entry.RigType == "N/A" and Humanoid and (__index(Humanoid, "RigType") == Enum.HumanoidRigType.R6 and "R6" or "R15") or "N/A" -- Secondary check
			end
		end)
	end,

	GetObjectEntry = function(Object, Hash)
		Hash = type(Object) == "string" and Object or Hash

		for _, Value in next, Environment.UtilityAssets.WrappedObjects do
			if Hash and Value.Hash == Hash or Value.Object == Object then
				return Value
			end
		end
	end,

	WrapObject = function(self, Object, PseudoName, Allowed, RenderDistance)
		assert(self, "EXUNYS_ESP > UtilityFunctions.WrapObject - Internal error, unassigned parameter \"self\".")

		if pcall(gethiddenproperty, Object, "PrimaryPart") then
			Object = __index(Object, "PrimaryPart")
		end

		if not Object then
			return
		end

		local DeveloperSettings = Environment.DeveloperSettings
		local WrappedObjects = Environment.UtilityAssets.WrappedObjects

		for _, Value in next, WrappedObjects do
			if Value.Object == Object then
				return
			end
		end

		local Entry = {
			Hash = CoreFunctions.GenerateHash(0x100),

			Object = Object,
			Allowed = Allowed,
			Name = PseudoName or __index(Object, "Name"),
			DisplayName = PseudoName or __index(Object, (IsA(Object, "Player") and "Display" or "").."Name"),
			RenderDistance = RenderDistance or Inf,

			IsAPlayer = IsA(Object, "Player"),
			PartHasCharacter = false,
			RigType = "N/A",

			Checks = {
				Alive = true,
				Team = true,
				Ready = true
			},

			Visuals = {
				ESP = {},
				Tracer = {},
				Box = {},
				HealthBar = {},
				HeadDot = {},
				Chams = {}
			},

			Connections = {}
		}

		repeat wait(0) until Entry.IsAPlayer and FindFirstChildOfClass(__index(Entry.Object, "Character"), "Humanoid") or true

		if not Entry.IsAPlayer then
			if not pcall(function()
				return __index(Entry.Object, "Position"), __index(Entry.Object, "CFrame")
			end) then
				warn("EXUNYS_ESP > UtilityFunctions.WrapObject - Attempted to wrap object of an unsupported class type: \""..(__index(Entry.Object, "ClassName") or "N / A").."\"")
				return self.UnwrapObject(Entry.Hash)
			end

			Entry.Connections.UnwrapSignal = Connect(Entry.Object.Changed, function(Property)
				if Property == "Parent" and not IsDescendantOf(__index(Entry.Object, Property), Workspace) then
					self.UnwrapObject(nil, Entry.Hash)
				end
			end)
		end

		local Humanoid = Entry.IsAPlayer and FindFirstChildOfClass(__index(Entry.Object, "Character"), "Humanoid") or FindFirstChildOfClass(__index(Entry.Object, "Parent"), "Humanoid")

		Entry.PartHasCharacter = not Entry.IsAPlayer and Humanoid
		Entry.RigType = Humanoid and (__index(Humanoid, "RigType") == 0 and "R6" or "R15") or "N/A"

		self:InitChecks(Entry)

		spawn(function()
			repeat
				wait(0)
			until Entry.Checks.Ready

			CreatingFunctions.ESP(Entry)
			CreatingFunctions.Tracer(Entry)
			CreatingFunctions.HeadDot(Entry)
			CreatingFunctions.Box(Entry)
			CreatingFunctions.HealthBar(Entry)
			CreatingFunctions:Chams(Entry)

			WrappedObjects[Entry.Hash] = Entry

			Entry.Connections.PlayerUnwrapSignal = Connect(Entry.Object.Changed, function(Property)
				if DeveloperSettings.UnwrapOnCharacterAbsence and Property == "Parent" and not IsDescendantOf(__index(Entry.Object, (Entry.IsAPlayer and "Character" or Property)), Workspace) then
					self.UnwrapObject(nil, Entry.Hash)
				end
			end)

			return Entry.Hash
		end)
	end,

	UnwrapObject = function(Object, Hash)
		Hash = type(Object) == "string" and Object
		Object = type(Object) == "string" and nil

		for _, Value in next, Environment.UtilityAssets.WrappedObjects do
			if Value.Object == Object or Value.Hash == Hash then
				for _, _Value in next, Value.Connections do
					pcall(Disconnect, _Value)
				end

				Recursive(Value.Visuals, function(_, _Value)
					if type(_Value) == "table" and _Value.__OBJECT then
						pcall(_Value.Remove, _Value)
					end
				end)

				Environment.UtilityAssets.WrappedObjects[Hash] = nil; break
			end
		end
	end
}

local LoadESP = function()
	for _, Value in next, GetPlayers() do
		if Value == LocalPlayer then
			continue
		end

		UtilityFunctions:WrapObject(Value)
	end

	local ServiceConnections = Environment.UtilityAssets.ServiceConnections

	ServiceConnections.PlayerRemoving = Connect(__index(Players, "PlayerRemoving"), UtilityFunctions.UnwrapObject)

	ServiceConnections.CharacterAdded = Connect(__index(Workspace, "DescendantAdded"), function(Object)
		if not IsA(Object, "Model") then
			return
		end

		if not GetPlayerFromCharacter(Object) or not FindFirstChild(Players, __index(Object, "Name")) then
			return
		end

		for _, Value in next, GetPlayers() do
			local Player = nil

			for _, _Value in next, Environment.UtilityAssets.WrappedObjects do
				if not _Value.IsAPlayer then
					continue
				end

				if __index(_Value.Object, "Name") == __index(Value, "Name") then
					Player = _Value
				end
			end

			if not Player then
				UtilityFunctions:WrapObject(GetPlayerFromCharacter(Object))
			end
		end
	end)

	ServiceConnections.PlayerAdded = Connect(__index(Players, "PlayerAdded"), function(Player)
		local WrappedObjects = Environment.UtilityAssets.WrappedObjects
		local Hash = UtilityFunctions:WrapObject(Player)

		for _, Entry in next, WrappedObjects do
			if Entry.Hash ~= Hash then
				continue
			end

			Entry.Connections[__index(Player, "Name").."CharacterAdded"] = Connect(__index(Player, "CharacterAdded"), function(Object)
				for _, _Value in next, Environment.UtilityAssets.WrappedObjects do
					if not _Value.Name == __index(Object, "Name") then
						continue
					end

					UtilityFunctions:WrapObject(GetPlayerFromCharacter(Object))
				end
			end)
		end
	end)
end

setmetatable(Environment, {
	__call = function()
		if Loaded then
			return
		end

		Loaded = true
		return LoadESP(), CreatingFunctions.Crosshair()
	end
})

pcall(spawn, function()
	if Environment.Settings.LoadConfigOnLaunch then
		repeat wait(0) until Environment.LoadConfiguration

		Environment:LoadConfiguration()
	end
end)

--// Interactive User Functions

Environment.UnwrapPlayers = function() -- (<void>) => <boolean> Success Status
	local UtilityAssets = Environment.UtilityAssets

	local WrappedObjects = UtilityAssets.WrappedObjects
	local ServiceConnections = UtilityAssets.ServiceConnections

	for _, Entry in next, WrappedObjects do
		pcall(UtilityFunctions.UnwrapObject, Entry.Hash)
	end

	for _, ConnectionIndex in next, {"PlayerRemoving", "PlayerAdded", "CharacterAdded"} do
		pcall(Disconnect, ServiceConnections[ConnectionIndex])
	end

	return #WrappedObjects == 0
end

Environment.UnwrapAll = function(self) -- METHOD | (<void>) => <void>
	assert(self, "EXUNYS_ESP.UnwrapAll: Missing parameter #1 \"self\" <table>.")

	if self.UnwrapPlayers() and CrosshairParts.LeftLine then
		self.RemoveCrosshair()
	end

	return #self.UtilityAssets.WrappedObjects == 0 and not CrosshairParts.LeftLine
end

Environment.Restart = function(self) -- METHOD | (<void>) => <void>
	assert(self, "EXUNYS_ESP.Restart: Missing parameter #1 \"self\" <table>.")

	local Objects = {}

	for _, Value in next, self.UtilityAssets.WrappedObjects do
		Objects[#Objects + 1] = {Value.Hash, Value.Object, Value.Name, Value.Allowed, Value.RenderDistance}
	end

	for _, Value in next, Objects do
		self.UnwrapObject(Value[1])
	end

	for Index, Value in next, Objects do
		self.WrapObject(select(2, unpack(Value)))
	end

	if CrosshairParts.LeftLine then
		self.RemoveCrosshair()
		self.RenderCrosshair()
	end
end

Environment.Exit = function(self) -- METHOD | (<void>) => <void>
	assert(self, "EXUNYS_ESP.Exit: Missing parameter #1 \"self\" <table>.")

	if self:UnwrapAll() then
		for _, Connection in next, self.UtilityAssets.ServiceConnections do
			pcall(Disconnect, Connection)
		end

		for _, RenderObject in next, CrosshairParts do
			pcall(RenderObject.Remove, RenderObject)
		end

		for _, Table in next, {CoreFunctions, UpdatingFunctions, CreatingFunctions, UtilityFunctions} do
			for FunctionName, _ in next, Table do
				Table[FunctionName] = nil
			end

			Table = nil
		end

		for Index, _ in next, Environment do
			getgenv().ExunysDeveloperESP[Index] = nil
		end

		LoadESP = nil; Recursive = nil; Loaded = false

		getgenv().ExunysDeveloperESP = nil
	end
end

Environment.WrapObject = function(...) -- (<Instance> Object[, <string> Pseudo Name, <table> Allowed Visuals, <uint> Render Distance]) => <string> Hash
	return UtilityFunctions:WrapObject(...)
end

Environment.UnwrapObject = UtilityFunctions.UnwrapObject -- (<Instance/string> Object/Hash[, <string> Hash]) => <void>

Environment.RenderCrosshair = CreatingFunctions.Crosshair -- (<void>) => <void>

Environment.RemoveCrosshair = function() -- (<void>) => <void>
	if not CrosshairParts.LeftLine then
		return
	end

	local ServiceConnections = Environment.UtilityAssets.ServiceConnections

	Disconnect(ServiceConnections.UpdateCrosshairProperties)
	Disconnect(ServiceConnections.UpdateCrosshair)

	for _, RenderObject in next, CrosshairParts do
		pcall(RenderObject.Remove, RenderObject)
	end

	CrosshairParts = {}
end

Environment.WrapPlayers = LoadESP -- (<void>) => <void>

Environment.GetEntry = UtilityFunctions.GetObjectEntry -- (<Instance> Object[, <string> Hash]) => <table> Entry

Environment.Load = function() -- (<void>) => <void>
	if Loaded then
		return
	end

	LoadESP(); CreatingFunctions.Crosshair(); Loaded = true
end

Environment.UpdateConfiguration = function(DeveloperSettings, Settings, Properties) -- (<table> DeveloperSettings, <table> Settings, <table> Properties) => <table> New Environment
	assert(DeveloperSettings, "EXUNYS_ESP.UpdateConfiguration: Missing parameter #1 \"DeveloperSettings\" <table>.")
	assert(Settings, "EXUNYS_ESP.UpdateConfiguration: Missing parameter #2 \"Settings\" <table>.")
	assert(Properties, "EXUNYS_ESP.UpdateConfiguration: Missing parameter #3 \"Properties\" <table>.")

	getgenv().ExunysDeveloperESP.DeveloperSettings = DeveloperSettings
	getgenv().ExunysDeveloperESP.Settings = Settings
	getgenv().ExunysDeveloperESP.Properties = Properties

	Environment = getgenv().ExunysDeveloperESP

	return Environment
end

Environment.LoadConfiguration = function(self) -- METHOD | (<void>) => <void>
	assert(self, "EXUNYS_ESP.LoadConfiguration: Missing parameter #1 \"self\" <table>.")

	local Path = self.DeveloperSettings.Path

	if self:UnwrapAll() then
		pcall(function()
			local Configuration, Data = ConfigLibrary:LoadConfig(Path), {}

			for _, Index in next, {"DeveloperSettings", "Settings", "Properties"} do
				Data[#Data + 1] = ConfigLibrary:CloneTable(Configuration[Index])
			end

			self.UpdateConfiguration(unpack(Data))()
		end)
	end
end

Environment.SaveConfiguration = function(self) -- METHOD | (<void>) => <void>
	assert(self, "EXUNYS_ESP.SaveConfiguration: Missing parameter #1 \"self\" <table>.")

	local DeveloperSettings = self.DeveloperSettings

	ConfigLibrary:SaveConfig(DeveloperSettings.Path, {
		DeveloperSettings = DeveloperSettings,
		Settings = self.Settings,
		Properties = self.Properties
	})
end

return Environment

--@services
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local HTTPS = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")
local ServerScriptService = game:GetService("ServerScriptService")

--@constants
local IN_CLIENT = RunService:IsClient()

local parentModule = script.Parent

--@libraries
local fastSignal = require(parentModule:WaitForChild("fastSignal"))
local info = require(parentModule:WaitForChild("info"))

--@constants
local EXHAUST_TIME = info.settings.actorExhaustTime

--@instances
local actorsFolder = nil

--@folders
local parentModuleHelpers = parentModule:WaitForChild("helpers")
local helpers = script:WaitForChild("helpers")

--@helpers
local _newFolder = require(helpers:WaitForChild("newFolder"))
local _makeActorInstance = require(helpers:WaitForChild("makeActorInstance"))
local _moveActorInRegistry = require(parentModuleHelpers:WaitForChild("moveActorInRegistry"))

--decide what our folder will be
if IN_CLIENT then
	local player = Players.LocalPlayer
	local foundActorsFolder = player:FindFirstChild("PlayerScripts"):FindFirstChild("actors")
	if not foundActorsFolder then actorsFolder = _newFolder(player:FindFirstChild("PlayerScripts"), "actors") else actorsFolder = foundActorsFolder end
else
	if ServerScriptService:FindFirstChild("actors") then
		actorsFolder = ServerScriptService:FindFirstChild("actors")
	else
		actorsFolder = _newFolder(ServerScriptService, "actors")
	end
end

--@export
local actorClass = {}
actorClass.__index = actorClass

function actorClass.new(functionName)
	local self = setmetatable({}, actorClass)
	
	-- states
	self.running = false
	self.lastUsed = tick()
	
	-- instances
	self.functionToRun = functionName
	self.actorInstance = _makeActorInstance(actorsFolder, functionName, self)
	
	-- signals
	self.deleted = fastSignal.new()
	self.activityChanged = fastSignal.new()
	self.completed = fastSignal.new()
	self.functionListen = self.actorInstance.runSignal
	
	-- when the function finishes, fireback to the perpendicular handler
	self.functionListen.Event:Connect(function(pathway, ...)
		if pathway ~= "finished" then return end
		self.completed:Fire(...)
		task.wait(EXHAUST_TIME) -- allow the actor to 'breathe'
		self:setActivity(false)
	end)

	return self
end

function actorClass:runFunction(...)
	self:setActivity(true)
	self.functionListen:Fire("run", ...)
end

function actorClass:setActivity(boolean)
	self.running = boolean
	self.activityChanged:Fire(boolean)
end

function actorClass:destroy()
	-- remove actor from registry
	_moveActorInRegistry(nil, self)
	-- disconnect all signals
	self.deleted:Fire()
	self.deleted:DisconnectAll()
	self.activityChanged:DisconnectAll()
	self.completed:DisconnectAll()
	-- destroy actor instance
	Debris:AddItem(self.actorInstance, 0)
	-- clear the object
	setmetatable(self, nil)
	table.clear(self)
	table.freeze(self)
end

return actorClass

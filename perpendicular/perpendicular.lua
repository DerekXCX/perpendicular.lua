--!strict
-- xcx_derek : 04/23/2023
-- Copyright (c) 2023 Derek
-- PERPENDICULAR : EASY SUPPORT FOR PARALLEL LUA

--@libraries
local actorClass = require(script:WaitForChild("actorClass"))
local registry = require(script:WaitForChild("registry"))
local fastSignal = require(script:WaitForChild("fastSignal"))

--@folders
local helpers = script:WaitForChild("helpers")

--@helpers
local _moveActorInRegistry = require(helpers:WaitForChild("moveActorInRegistry"))
local _registerActor = require(helpers:WaitForChild("registerActor"))
local _getActor = require(helpers:WaitForChild("getActor"))

--@export
local perpendicular = {}
perpendicular.__index = perpendicular

function perpendicular.desyncFunction(functionToRun : string) -- returns : perpendicularObject
	-- functionToRun is REQUIRED, it determines what function we are 'desyncing'
	
	local self = setmetatable({}, perpendicular)

	self.completed = fastSignal.new()
	self.functionToRun = functionToRun
	
	return self
end

function perpendicular:run(...)
	-- ... is/are the arguments of the function we are running
	
	local actor = _getActor(self.functionToRun)
	actor:runFunction(...)

	self.listenForCompletion = actor.completed:Connect(function(...)
		self.completed:Fire(...)
		self:destroy()
	end)
end

function perpendicular:destroy()
	-- destroys the object, cleanup
	
	if self.listenForCompletion then self.listenForCompletion:Disconnect() end
	table.clear(self)
	setmetatable(self, nil)
	table.freeze(self)
end

return perpendicular
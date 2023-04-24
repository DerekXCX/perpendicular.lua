--@libraries
local parentModule = script.Parent.Parent
local registry = require(parentModule:WaitForChild("registry"))
local info = require(parentModule:WaitForChild("info"))

--@helpers
local parentHelpers = parentModule:WaitForChild("helpers")
local _moveActorInRegistry = require(parentHelpers:WaitForChild("moveActorInRegistry"))

--@settings
local maxIdleTime = info.settings.actorMaxIdleTime

--@tables
local registryStanding = registry.standing
local registryRunning = registry.running
local registryAll = registry.all

--@helpers
local function queueDeletion(actorObject, time)
	task.delay(time, function()
		local timeSinceUsed = tick() - actorObject.lastUsed
		if timeSinceUsed < maxIdleTime then 
			queueDeletion(actorObject, maxIdleTime - timeSinceUsed)
			return 
		end
		actorObject:destroy()
	end)
end

--@export
return function (actorObject)
	local isRunning = actorObject.running
	local functionToRun = actorObject.functionToRun

	-- add new tables in case that we haven't made any for the function we are running
	if not registryStanding[functionToRun] then
		registryStanding[functionToRun] = {}
	end
	if not registryRunning[functionToRun] then
		registryRunning[functionToRun] = {}
	end
	if not registryAll[functionToRun] then
		registryAll[functionToRun] = {}
	end
	
	-- register the actor
	registry.all[functionToRun][actorObject.id] = actorObject
	_moveActorInRegistry(isRunning, actorObject)
	
	-- check whenever the actor is set to running or standing
	actorObject.activityChanged:Connect(function(newActivity)
		_moveActorInRegistry(newActivity, actorObject)
		if not newActivity then return end
		actorObject.lastUsed = tick()
	end)
	
	-- queue our actor deletion
	queueDeletion(actorObject, maxIdleTime)
end
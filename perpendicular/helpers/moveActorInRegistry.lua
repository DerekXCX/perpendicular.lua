--@libraries
local parentModule = script.Parent.Parent
local registry = require(parentModule:WaitForChild("registry"))

--@helpers
local function clear(actorObject)
	local id = actorObject.id
	local functionToRun = actorObject.functionToRun

	-- get registry sub-registries
	local registryStanding = registry.standing[functionToRun]
	local registryRunning = registry.running[functionToRun]
	local registryAll = registry.all[functionToRun]
	
	-- clear any possible indexes of the actorObject
	local foundStanding = registryStanding[id] 
	if foundStanding then registryStanding[id] = nil end
	local foundRunning = registryRunning[id]
	if foundRunning then registryRunning[id] = nil end
	registryAll[id] = nil
end

--@export
return function (activity, actorObject)
	if activity == nil then clear(actorObject) return end -- nil would be to remove actorObject from the registry

	local runningOrStanding = if activity then "running" else "standing"
	local oppositeRunningOrStanding = if not activity then "running" else "standing"

	local id = actorObject.id
	local functionToRun = actorObject.functionToRun

	-- get registry 'sub-registries'
	local registryOppositeActivity = registry[oppositeRunningOrStanding]
	local registryOppositeActivityFunctions = registryOppositeActivity[functionToRun]
	local registryCurrentActivity = registry[runningOrStanding]
	local registryCurrentActivityFunctions = registryCurrentActivity[functionToRun]

	-- if its in the opposite table (one its not supposed to be in), remove it
	local foundInOpposite = registryOppositeActivityFunctions[id]
	if foundInOpposite then
		registryOppositeActivityFunctions[id] = nil
	end

	-- if its in current table, dont add it again
	local foundInCurrent = registryCurrentActivityFunctions[id]
	if foundInCurrent then return end

	-- add to correct table
	registryCurrentActivityFunctions[id] = 0 -- value itself doesn't matter, we just need the index because table.find/remove is very expensive
end
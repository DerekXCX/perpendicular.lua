--@libraries
local parentModule = script.Parent.Parent
local registry = require(parentModule:WaitForChild("registry"))

--@folders
local parentHelpers = parentModule:WaitForChild("helpers")
local actorHelpers = parentModule:WaitForChild("actorClass"):WaitForChild("helpers")

--@helpers
local actorClass = require(parentModule:WaitForChild("actorClass"))
local _registerActor = require(parentHelpers:WaitForChild("registerActor"))

local function getFirstValueFromTable(table)
	for index, v in table do
		return index, v
	end	
end

--@export
return function (functionToRun)
	-- check if there is an actor not being used
	local standingFunctionToRun = registry.standing[functionToRun]
	local foundIdOfFreeActor = if not standingFunctionToRun then false 
		else getFirstValueFromTable(standingFunctionToRun)
	if foundIdOfFreeActor then 
		local object = registry.all[functionToRun][foundIdOfFreeActor]
		return object 
	end
	
	-- create a new actor, as there wasn't an unused one
	local actorClass = actorClass.new(functionToRun)
	_registerActor(actorClass)

	return actorClass
end
--@services
local HTTPS = game:GetService("HttpService")

--@libraries
local parentModule = script.Parent.Parent.Parent
local functionsFolder = parentModule:WaitForChild("actorClass"):WaitForChild("functions")
local info = require(parentModule:WaitForChild("info"))

return function (actorsFolder, functionName, object)
	local functionNameAlreadyIndexed = info.cachedActorDirectories[functionName]
	local actorTemplate = if functionNameAlreadyIndexed then functionNameAlreadyIndexed else functionsFolder:FindFirstChild(functionName)

	local id = HTTPS:GenerateGUID(false)
	object.id = id

	local actor = actorTemplate:Clone()
	actor.Name = id
	actor.Parent = actorsFolder

	if not functionNameAlreadyIndexed then
		info.cachedActorDirectories[functionName] = actorTemplate
	end
	return actor
end
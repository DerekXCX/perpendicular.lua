# Perpendicular: Parallel LUAU Wrapper
Takes advantage of the parallel luau feature on ROBLOX, intended for easy use.

New function instances are made off of the perpendicular module which calls on the actorClass.

# DOCUMENTATION : PERPENDICULAR

``perpendicular.desyncFunction(functionName : string) : perpendicularObject``

Creates a parallel function which runs the predetermined function under the actorClass --> helpers folder. Returns a perpendicularObject.

``perpendicularObject:run()``

Runs the function, after its initial run the perpendicularObject is destroyed.

``perpendicularObject.completed : Event``

Fires as soon as the ran function returns a value.

## _Example Usage_

-- > Perpendicular
```lua
local perpendicular = require(perpendicularPath)

local newFunction = perpendicular.desyncFunction("thisIsAFunction!")
newFunction:run("return this string!")
newFunction.completed:Connect(function(message)
  print("newFunction has returned "..message)
end)
```

-- > thisIsAFunction!
```lua
local runSignal = script.Parent:WaitForChild("runSignal")

local function thisIsAFunction(returning)
	return returning
end

runSignal.Event:ConnectParallel(function(pathway, ...)
	if pathway ~= "run" then return end
	runSignal:Fire("finished", thisIsAFunction(...))
end)
```

-- > Output

>return this string!

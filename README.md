# Perpendicular: Parallel LUAU Wrapper
Takes advantage of the parallel luau feature on ROBLOX, intended for easy use. However easy, this module requires some pre-existing and extensive knowledge on Luau and Parallel Luau especially, I reccommend you check out [this youtube video, by Suphi Kaner,](https://www.youtube.com/watch?v=BbIPalpAfaI&ab_channel=SuphiKaner) if you are unfamiliar with the concept.

Brief Overview:
	New 'function instances' are made off of the perpendicular module which calls on the actorClass, actors are cached for a specified amount of time before they are eventually deleted. All optimizations (to my knowledge) have been made, however, if you spot any, feel free to let me know.

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
  print("newFunction has returned : "..message)
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

>newFunction has returned : return this string!

return {
	settings = {
		actorMaxIdleTime = 30, 
		-- how long before the actor 'expires', how long since it was last used before it gets deleted
		actorExhaustTime = 0, 
		-- how long an actor has before it can be usable again, 0 waits 1 frame while anything above waits that amount in seconds
		-- not sure why it would be any less than a frame, I reccommend to leave it like this
	},
	cachedActorDirectories = {}, 
	-- don't touch, cache so findfirstchild isn't called every time an actorinstance is made
}

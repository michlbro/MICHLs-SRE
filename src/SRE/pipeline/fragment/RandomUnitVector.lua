return function()
    local sqrt = math.sqrt(-2 * math.log(math.random()))
	local angle = 2 * math.pi * math.random()

	return Vector3.new(
		sqrt * math.cos(angle),
		sqrt * math.sin(angle),
		math.sqrt(-2 * math.log(math.random())) * math.cos(2 * math.pi * math.random())
	).Unit
end
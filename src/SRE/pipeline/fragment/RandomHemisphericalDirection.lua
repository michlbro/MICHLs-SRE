local RandomUnitVector = require(script.Parent.RandomUnitVector)

return function(normal)
    local direction = RandomUnitVector()--RandomUnitVector()
	return direction * math.sin(normal:Dot(direction))
end
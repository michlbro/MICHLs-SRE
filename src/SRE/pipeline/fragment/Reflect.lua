return function(dirIn, normal)
    return dirIn - 2 * dirIn:Dot(normal) * normal
end
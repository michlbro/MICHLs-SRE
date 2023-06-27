local colour = {}

function colour.New(r, g, b)
    return {r or 0, g or 0, b or 0}
end

function colour.Add(colourTbl, color3)
    colourTbl[1] += color3.R
    colourTbl[2] += color3.G
    colourTbl[3] += color3.B
end

function colour.Multiply(colourTbl, color3)
    colourTbl[1] *= color3.R
    colourTbl[2] *= color3.G
    colourTbl[3] *= color3.B
end

function colour.Subtract(colourTbl, color3, subtractByColourTable)
    if not subtractByColourTable then
        colourTbl[1] -= color3.R
        colourTbl[2] -= color3.G
        colourTbl[3] -= color3.B
        return colourTbl
    end
    local colour3Tbl = colour.new(color3.R, color3.G, color3.B)
    colour3Tbl[1] -= colourTbl[1]
    colour3Tbl[2] -= colourTbl[2]
    colour3Tbl[3] -= colourTbl[3]
    return colour3Tbl
end

function colour.Divide(colourTbl, color3, divideByColourTable)
    if not divideByColourTable then
        colourTbl[1] /= color3.R
        colourTbl[2] /= color3.G
        colourTbl[3] /= color3.B
        return colourTbl
    end
    local colour3Tbl = colour.new(color3.R, color3.G, color3.B)
    colour3Tbl[1] /= colourTbl[1]
    colour3Tbl[2] /= colourTbl[2]
    colour3Tbl[3] /= colourTbl[3]
    return colour3Tbl
end

function colour.ConvertToColor3(colourTbl)
    return Color3.new(colourTbl[1], colourTbl[2], colourTbl[3])
end

return colour
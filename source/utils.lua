function math.sign(x)
    return x > 0 and 1 or x < 0 and -1 or 0
end

function math.clamp(x, min, max)
    return math.max(min, math.min(x, max))
end

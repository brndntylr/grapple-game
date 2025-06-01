import "CoreLibs/graphics"
import "CoreLibs/object"

function math.sign(x)
    return x > 0 and 1 or x < 0 and -1 or 0
end

function math.clamp(x, min, max)
    return math.max(min, math.min(x, max))
end

local gfx <const> = playdate.graphics

function MakeNineSliceTiledImage(img, w, h, c)
    local imgW, imgH = img:getSize()
    local edgeW, edgeH = imgW - 2 * c, imgH - 2 * c

    -- Create a new image to draw onto
    local outImg = gfx.image.new(w, h)
    gfx.pushContext(outImg)

    -- Corners
    img:copy(0, 0, c, c):draw(0, 0) -- top-left
    img:copy(imgW-c, 0, c, c):draw(w-c, 0) -- top-right
    img:copy(0, imgH-c, c, c):draw(0, h-c) -- bottom-left
    img:copy(imgW-c, imgH-c, c, c):draw(w-c, h-c) -- bottom-right

    -- Top and bottom edges (tiled)
    for i = 0, w - 2 * c - 1, edgeW do
        local tileW = math.min(edgeW, w - 2 * c - i)
        img:copy(c, 0, tileW, c):draw(c + i, 0) -- top
        img:copy(c, imgH-c, tileW, c):draw(c + i, h - c) -- bottom
    end

    -- Left and right edges (tiled)
    for j = 0, h - 2 * c - 1, edgeH do
        local tileH = math.min(edgeH, h - 2 * c - j)
        img:copy(0, c, c, tileH):draw(0, c + j) -- left
        img:copy(imgW-c, c, c, tileH):draw(w - c, c + j) -- right
    end

    -- Center (tiled)
    for i = 0, w - 2 * c - 1, edgeW do
        local tileW = math.min(edgeW, w - 2 * c - i)
        for j = 0, h - 2 * c - 1, edgeH do
            local tileH = math.min(edgeH, h - 2 * c - j)
            img:copy(c, c, tileW, tileH):draw(c + i, c + j)
        end
    end

    gfx.popContext()
    return outImg
end
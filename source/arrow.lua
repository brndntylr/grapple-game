import "CoreLibs/sprites"

local pd <const> = playdate
local gfx <const> = pd.graphics
local geom <const> = pd.geometry

class('Arrow').extends(gfx.sprite)

function Arrow:init(x,y)
    Arrow.super.init(self)

    -- local pcx = self.x + (self.width/2)
    -- local pcy = self.y + (self.height/2)

    local arrow_image = gfx.image.new(10,30)
    gfx.pushContext(arrow_image)
        gfx.fillRect(0, 0, 10, 30)
    gfx.popContext()
    self:setImage(arrow_image)

    self:setZIndex(11)
    self:moveTo(x, y)
    
    -- Arrow = geom.polygon.new(x, y, x, y+50, x-10, y+50, x, y+60, x+10, y+50, x, y+50, x, y)
end

function Arrow:rotate()
    -- local t = geom.affineTransform.new()
    -- t:rotate(x, y, angle)
    -- t:translate(player_center_x, -(player_center_y+30))
    -- Arrowt = Arrow * t
    -- Arrowt = Arrow
end

function Arrow:update()
    Arrow.super.update(self)
end

function Arrow:collisionResponse(other)
    return "overlap"
end
import "CoreLibs/sprites"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('Floor').extends(gfx.sprite)

function Floor:init(x1, x2)
	Floor.super.init(self)
    
    self.type = "Platform"
    self.friction = 1

    local floor_image = gfx.image.new(x2-x1, 4)
    gfx.pushContext(floor_image)
        gfx.fillRect(0, 0, x2-x1, 4)
    gfx.popContext()
    self:setImage(floor_image)
    
	self:setCollideRect(0, 0, self:getSize())
    self:setGroups({1})
	self:setZIndex(10)
    self:moveTo((x1+x2)/2, 240)

    self:add()
end
import "CoreLibs/sprites"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('Floor').extends(gfx.sprite)

function Floor:init()
	Floor.super.init(self)
    
    self.type = "Platform"
    self.friction = 0.5

    local floor_image = gfx.image.new(400, 4)
    gfx.pushContext(floor_image)
        gfx.fillRect(0, 0, 400, 4)
    gfx.popContext()
    self:setImage(floor_image)
    
	self:setCollideRect(0, 0, self:getSize())
    self:setGroups({1})
	self:setZIndex(10)
    self:moveTo(200,236)

    self:add()
end
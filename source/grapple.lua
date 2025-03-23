import "CoreLibs/sprites"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('Grapple').extends(gfx.sprite)

function Grapple:init(x,y)
	Grapple.super.init(self)

    self.len = 4
    self.initial_speed = 4
    self.state = "None"

    local grapple_image = gfx.image.new(self.len, self.len)
    gfx.pushContext(grapple_image)
        gfx.fillRect(0, 0, self.len, self.len)
    gfx.popContext()
    self:setImage(grapple_image)

	self:setCollideRect(0, 0, self:getSize())
    self:setCollidesWithGroups(1)
	self:setZIndex(9)

    self:moveTo(x, y)

end

function Grapple:update()
    Grapple.super.update(self)
end

function Grapple:collisionResponse(other)
    if other.super.className == "Platform" then
        return "slide"
    elseif other.super.className == "Grapple_Surface" then
        return "freeze"
    end
end

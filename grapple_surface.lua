import "CoreLibs/sprites"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('Grapple_Surface').extends(gfx.sprite)

function Grapple_Surface:init(x, y, width, height)
	Grapple_Surface.super.init(self)

    local grapple_surface_image = gfx.drawRect(x, y, width, height)
    self:setImage(grapple_surface_image)

	self:setCollideRect(0, 0, self:getSize())
    self:setGroups(2)
	self:setZIndex(10)
end
import "CoreLibs/sprites"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('Platform').extends(gfx.sprite)

function Platform:init(x, y, height, width)
	Platform.super.init(self)

	-- Currently just a single image for the sprite but will add animation in the future
	local platform_image = gfx.image.new("images/dude-0001.png")
    self:setImage(platform_image)
	self:setCollideRect(0, 0, height, width)
	self:setZIndex(10)
    self:moveTo(x, y)
end
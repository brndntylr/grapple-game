import "CoreLibs/sprites"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('Platform').extends(gfx.sprite)

function Platform:init(x, y, width, height)
	Platform.super.init(self)

    local platform_image = gfx.image.new("images/platform-0001.png")
    local platform_width, platform_height = platform_image:getSize()
    self:setImage(platform_image)
    self:setScale(width/platform_width, height/platform_height)

    self.type = "Platform"
    self.friction = 0.5

	self:setCollideRect(0, 0, width, height)
    self:setGroups({1})
	self:setZIndex(10)
    self:moveTo(x, y)
    
    self:add()
end
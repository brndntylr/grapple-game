import "CoreLibs/sprites"
import "CoreLibs/graphics"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('EndFlag').extends(gfx.sprite)

function EndFlag:init(x, y)
    EndFlag.super.init(self)

    self.type = "EndFlag"
    local marker_image = gfx.image.new("images/flag-0001.png") -- Replace with your desired image
    self:setImage(marker_image)
    self:setCenter(0.5, 1.0)
    self:setCollideRect(0, 0, marker_image:getSize())
    self:setGroups({3}) -- Marker group
    self:setZIndex(20)
    self:moveTo(x, y)
    self:add()
end
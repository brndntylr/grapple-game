import "CoreLibs/sprites"
import "CoreLibs/graphics"
import "CoreLibs/nineslice"

local pd <const> = playdate
local gfx <const> = pd.graphics
local ns <const> = gfx.nineSlice

class('Platform').extends(gfx.sprite)

function Platform:init(x, y, width, height)
	Platform.super.init(self)

    self.type = "Platform"
    self.friction = 1
    self.width = width
    self.height = height

    self.nineSlice = ns.new("images/Platform-9Tile-0001.png", 4, 4, 4, 4) -- Adjust corner sizes as needed
    if not self.nineSlice then
        print("❌ Failed to load platform nine-slice image")
        return
    end
    
    local platformImage = gfx.image.new(width, height)
    if not platformImage then
        print("❌ Failed to create platform image")
        return
    end

    gfx.pushContext(platformImage)
    self.nineSlice:drawInRect(0, 0, width, height)
    gfx.popContext()

    self:setImage(platformImage)
    self:setCollideRect(0, 0, width, height)
    self:setGroups({1})
    self:setZIndex(10)
    self:moveTo(x-self.width/2, y-self.height/2)

    self:add()
end
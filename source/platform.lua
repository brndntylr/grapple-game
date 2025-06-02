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
    self.friction = 0.5
    self.width = width
    self.height = height

    -- local platform_image = gfx.image.new("images/platform-0001.png")
    -- if not platform_image then
    --     print("❌ Failed to load platform image")
    --     return
    -- end
    -- local platform_width, platform_height = platform_image:getSize()
    -- self:setImage(platform_image)
    -- self:setScale(width/platform_width, height/platform_height)

    -- local platform_image = gfx.image.new("images/Platform-9Tile-0001.png")
    -- if not platform_image then
    --     print("❌ Failed to load platform image")
    --     return
    -- end

    -- local cornerSize = 4 -- adjust to match your image design
    -- local tiledImage = MakeNineSliceTiledImage(platform_image, width, height, cornerSize)
    -- self:setImage(tiledImage)

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
    self:moveTo(x, y)

    self:add()
end
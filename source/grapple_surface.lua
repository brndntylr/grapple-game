import "CoreLibs/sprites"
import "CoreLibs/graphics"
import "CoreLibs/nineslice"

local pd <const> = playdate
local gfx <const> = pd.graphics
local ns <const> = gfx.nineSlice

class('Grapple_Surface').extends(gfx.sprite)

function Grapple_Surface:init(x, y, width, height)
    Grapple_Surface.super.init(self)

    self.nineSlice = ns.new("images/grapple_surface-9Tile-0001.png", 4, 4, 4, 4)
    if not self.nineSlice then
        print("❌ Failed to load grapple surface nine-slice image")
        return
    end

    local grappleSurfaceImage = gfx.image.new(width, height)
    if not grappleSurfaceImage then
        print("❌ Failed to create grapple surface image")
        return
    end

    -- Draw nine-slice onto the image
    gfx.pushContext(grappleSurfaceImage)
    self.nineSlice:drawInRect(0, 0, width, height)
    gfx.popContext()

    -- Set the sprite's image
    self:setImage(grappleSurfaceImage)
    self:setCollideRect(0, 0, width, height)
    self:setGroups({2})
    self:setZIndex(10)
    self:moveTo(x, y)
    
    self:add()
end
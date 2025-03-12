import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "player"
-- import "grapple"
-- import "platform"
-- import "grapple_surface"

playdate.display.setRefreshRate(30)

local pd = playdate
local gfx = pd.graphics
-- local spritelib = gfx.sprite
-- local screenWidth = pd.display.getWidth()
-- local screenHeight = pd.display.getHeight()

local function initialise()
    local player_sprite = Player(200, 120, 2, 6, 1)
    player_sprite:add()
end

initialise()

function pd.update()
    gfx.sprite.update()
end
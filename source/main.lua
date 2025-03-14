import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "player"
import "platform"
-- import "grapple"
-- import "grapple_surface"

playdate.display.setRefreshRate(30)

local pd = playdate
local gfx = pd.graphics

local function initialise()
    local player_sprite = Player(200, 120, 2, 6, 1)
    player_sprite:add()

    local platform_001 = Platform(200, 230, 400, 4)
    platform_001:add()

    local platform_002 = Platform(300, 200, 100, 4)
    platform_002:add()
    
end

initialise()

function pd.update()
    gfx.sprite.update()
end
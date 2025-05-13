import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/ui"
import "player"
import "platform"
import "grapple_surface"

playdate.display.setRefreshRate(30)

local pd <const> = playdate
local gfx <const> = pd.graphics
CrankInd = 0

local function initialise()
    local player_sprite = Player(200, 120, 2, 10, 1)
    player_sprite:add()

    local platform_001 = Platform(200, 230, 400, 4)
    platform_001:add()

    local platform_002 = Platform(300, 200, 100, 4)
    platform_002:add()

    local grapple_surface_001 = Grapple_Surface(200, 10, 100, 6)
    grapple_surface_001:add()

    local grapple_surface_002 = Grapple_Surface(200, 120, 100, 6)
    grapple_surface_001:add()
end

initialise()

function pd.update()
    gfx.sprite.update()
    if CrankInd == 1 then
        pd.ui.crankIndicator:draw()
    end
end
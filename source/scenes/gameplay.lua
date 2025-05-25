import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/ui"
import "player"
import "platform"
import "grapple_surface"

local pd <const> = playdate
local ds <const> = pd.datastore
local gfx <const> = pd.graphics

CrankInd = 0

class("Gameplay").extends(Room)

local classMap = {
    player = function(data)
        Player(data.x, data.y)
    end,
    platform = function(data)
        Platform(data.x, data.y, data.width, data.height, data.props)
    end,
    grapple_Surface = function(data)
        Grapple_Surface(data.x, data.y, data.width, data.height, data.props)
    end,
    -- Add more mappings here (e.g., enemies, pickups, etc.)
}

local function loadLevel(filename)
    local levelData = ds.read("levels/" .. filename)
    if not levelData then
        print("❌ Failed to load level:", filename)
        return
    end

    for _, comp in ipairs(levelData.components) do
        local handler = classMap[comp.type]
        if handler then
            handler(comp)
        else
            print("⚠️ Unknown component type: " .. comp.type)
        end
    end
end

function Gameplay:enter(previous, manager, filename)
	-- set up the level
    loadLevel(filename)
end

function Gameplay:update()
	-- update entities
    gfx.sprite.update()
    if CrankInd == 1 then
        pd.ui.crankIndicator:draw()
    end
end

function Gameplay:leave(next, ...)
	-- destroy entities and cleanup resources
end

function Gameplay:draw()
	-- draw the level
end
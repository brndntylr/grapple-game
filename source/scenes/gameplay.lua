import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/ui"
import "roomy-playdate"
import "scenes/level_end"
import "player"
import "platform"
import "grapple_surface"
import "floor"
import "end_flag"

local pd <const> = playdate
local ds <const> = pd.datastore
local gfx <const> = pd.graphics

CrankInd = 0

class("Gameplay").extends(Room)

local function getClassMap(gameplay)
    return {
        player = function(data)
            Player(data.x, data.y, function() gameplay:endLevel() end)
        end,
        platform = function(data)
            Platform(data.x, data.y, data.width, data.height, data.props)
        end,
        grapple_surface = function(data)
            Grapple_Surface(data.x, data.y, data.width, data.height, data.props)
        end,
        floor = function(data)
            Floor(data.x1, data.x2)
        end,
        end_flag = function(data)
            EndFlag(data.x, data.y)
        end
    }
end

local function loadLevel(classMap, filename)
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

function Gameplay:enter(previous, manager, levels, selected)
	-- set up the level
    gfx.clear()
    local classMap = getClassMap(self)
    self.manager = manager
    self.levels = levels
    self.selected = selected
    loadLevel(classMap, levels[selected].filename)
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
    gfx.sprite.removeAll()
end

function Gameplay:draw()
	-- draw the level
end

function Gameplay:endLevel()
    self.manager:enter(LevelEnd(), self.manager, self.levels, self.selected)
end
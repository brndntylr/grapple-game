-- scenes/LevelSelect.lua
-- LevelSelect.lua
import "CoreLibs/object"
import "CoreLibs/graphics"
import "roomy-playdate"
import "scenes/title"
import "scenes/gameplay"

local pd <const> = playdate
local ds <const> = pd.datastore
local gfx <const> = pd.graphics

class("LevelSelect").extends(Room)

-- local LevelSelect = {}
-- LevelSelect.__index = LevelSelect

-- function LevelSelect:new(manager)
--     self = LevelSelect()
--     self.manager = manager
-- end

function LevelSelect:enter(previous, manager)
    self.manager = manager
    self.levels = {}
    self.selected = 1
    self.scrollOffset = 0
    self.visibleItems = 5
    self.itemHeight = 20

    local levelData = ds.read("levels/level_overview")
    if not levelData or not levelData.levels then
        print("❌ Failed to load level data")
        return
    end
    self.levels = levelData.levels
end

function LevelSelect:exit()
end

function LevelSelect:update()
    if pd.buttonJustPressed(pd.kButtonUp) then
        if self.selected > 1 then
            self.selected -= 1
            if self.selected <= self.scrollOffset then
                self.scrollOffset -= 1
            end
        end
    elseif pd.buttonJustPressed(pd.kButtonDown) then
        if self.selected < #self.levels then
            self.selected += 1
            if self.selected > self.scrollOffset + self.visibleItems then
                self.scrollOffset += 1
            end
        end
    elseif pd.buttonJustPressed(pd.kButtonA) then
        -- local selectedLevel = self.levels[self.selected]
        self.manager:enter(Gameplay(), self.manager, self.levels, self.selected)
    elseif pd.buttonJustPressed(pd.kButtonB) then
        self.manager:enter(Title(), self.manager)
    end
end

function LevelSelect:draw()
    gfx.clear()
    gfx.drawText("Select a Level:", 100, 20)

    local startIndex = self.scrollOffset + 1
    local endIndex = math.min(startIndex + self.visibleItems - 1, #self.levels)

    for i = startIndex, endIndex do
        local y = 40 + (i - startIndex) * self.itemHeight
        local level = self.levels[i]
        local levelNumber = string.format("%d.", i)

        if i == self.selected then
            gfx.setColor(gfx.kColorBlack)
            gfx.fillRect(20, y - 2, 360, self.itemHeight)
            gfx.setImageDrawMode(gfx.kDrawModeInverted)
        end

        gfx.drawTextAligned(levelNumber, 30, y, kTextAlignment.left)
        gfx.drawTextAligned(level.name, 200, y, kTextAlignment.center)

        gfx.setImageDrawMode(gfx.kDrawModeCopy)
    end
end
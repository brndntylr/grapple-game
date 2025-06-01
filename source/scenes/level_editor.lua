local pd <const> = playdate
local gfx <const> = pd.graphics

class('LevelEditor').extends()

function LevelEditor:init()
    -- Grid settings
    self.gridSize = 32
    self.cursorX = 0
    self.cursorY = 0
    self.currentTile = 1
    self.tiles = {
        { name = "Platform", id = 1 },
        { name = "Grapple Point", id = 2 },
        -- Add more tile types as needed
    }
    self.placedTiles = {}
end

function LevelEditor:update()
    -- Move cursor with d-pad
    if playdate.buttonIsPressed(playdate.kButtonRight) then
        self.cursorX = self.cursorX + self.gridSize
    elseif playdate.buttonIsPressed(playdate.kButtonLeft) then
        self.cursorX = self.cursorX - self.gridSize
    end
    if playdate.buttonIsPressed(playdate.kButtonUp) then
        self.cursorY = self.cursorY - self.gridSize
    elseif playdate.buttonIsPressed(playdate.kButtonDown) then
        self.cursorY = self.cursorY + self.gridSize
    end

    -- Place tile with A button
    if playdate.buttonJustPressed(playdate.kButtonA) then
        self:placeTile()
    end

    -- Change tile type with B button
    if playdate.buttonJustPressed(playdate.kButtonB) then
        self.currentTile = (self.currentTile % #self.tiles) + 1
    end
end

function LevelEditor:draw()
    -- Draw grid
    for x = 0, 400, self.gridSize do
        gfx.drawLine(x, 0, x, 240)
    end
    for y = 0, 240, self.gridSize do
        gfx.drawLine(0, y, 400, y)
    end

    -- Draw placed tiles
    for _, tile in ipairs(self.placedTiles) do
        if tile.type == 1 then
            gfx.fillRect(tile.x, tile.y, self.gridSize, self.gridSize)
        elseif tile.type == 2 then
            gfx.fillCircleAtPoint(tile.x + self.gridSize/2, tile.y + self.gridSize/2, self.gridSize/4)
        end
    end

    -- Draw cursor
    gfx.drawRect(self.cursorX, self.cursorY, self.gridSize, self.gridSize)
    
    -- Draw UI
    gfx.drawText("Current Tile: " .. self.tiles[self.currentTile].name, 5, 5)
end

function LevelEditor:placeTile()
    table.insert(self.placedTiles, {
        x = self.cursorX,
        y = self.cursorY,
        type = self.currentTile
    })
end

function LevelEditor:saveLevelToFile(filename)
    local levelData = pd.json.encode(self.placedTiles)
    playdate.file.write(levelData, filename)
end
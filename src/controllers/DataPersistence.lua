local DataPersistence = {}
DataPersistence.__index = DataPersistence

function DataPersistence:new()
    local this = {
        bitser = require "libs.bitser.bitser",
        --[[ levelData is configured like, levelName => hight score--]]
        levelData = {level_1 = 0, level_2 = 0, level_3 = 0, level_4 = 0, level_5 = 0},
        alreadyLoaded = false;
    }
    if love.filesystem.getInfo('gamesave.dat') then
        this.levelData = this.bitser.loadLoveFile('gamesave.dat')
        this.alreadyLoaded = true;
    else
        this.bitser.dumpLoveFile('gamesave.dat', this.levelData)
    end
    return setmetatable(this, DataPersistence)
end

function DataPersistence:save(levelData)
    self.bitser.dumpLoveFile('gamesave.dat', levelData)
    self.alreadyLoaded = false;
end

function DataPersistence:load()
    if not self.alreadyLoaded then
        self.levelData = self.bitser.loadLoveFile('gamesave.dat')
        self.alreadyLoaded = true;
    end
    return self.levelData
end

return DataPersistence

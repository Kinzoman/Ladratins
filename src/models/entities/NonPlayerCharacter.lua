local NonPlayerCharacter = {}

NonPlayerCharacter.__index = NonPlayerCharacter

local function copsUpdate(dt)
end

local function citzenUpdate(dt)
end

function NonPlayerCharacter:new(characterType, world, x, y)
    local this = {
        characterType = characterType,
        state = 0,
        body = love.physics.newBody(world, x or 0, y or 0, "dynamic"),
        shape = love.physics.newCircleShape(16),
        fixture = nil,
        updateFunction = characterType == 0 and copsUpdate or citzenUpdate
    }
    this.fixture = love.physics.newFixture(this.body, this.shape)

    return setmetatable(this, NonPlayerCharacter)
end

function NonPlayerCharacter:callCops()
    gameDirector:getLibrary("EventQueue"):getInstance():announceEvent("callCops", {x = self.body:getX(), y = self.body:getY()})
end

function NonPlayerCharacter:update(dt)
    self.updateFunction(dt)
end

function NonPlayerCharacter:draw()
end

return NonPlayerCharacter

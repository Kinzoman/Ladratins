local NonPlayerCharacter = {}

NonPlayerCharacter.__index = NonPlayerCharacter

--[[local citzenSprite = love.graphics.newImage()
local copSprite = love.graphics.newImage()--]]

local function copsUpdate(dt)
end

local function citzenUpdate(dt)
end

local function saveCitzen(this, fixture)
    if love.physics.getDistance(this.fixture, fixture) <= 16 then
        this.state = 1
    end
end

function NonPlayerCharacter:new(characterType, world, x, y)
    local this = {
        characterType = characterType,
        state = 0,  --[[ IDLE (0) : FOLLOWING(1) --]]
        body = love.physics.newBody(world, x or 0, y or 0, "dynamic"),
        shape = love.physics.newCircleShape(16),
        fixture = nil,
        updateFunction = characterType == 0 and copsUpdate or citzenUpdate,
        stopTime = 0
    }
    this.fixture = love.physics.newFixture(this.body, this.shape)
    this.fixture:setCategory(2)
    this.fixture:setUserData(characterType == 0 and "Cop" or "Citzen")
    if characterType == 0 then
        gameDirector:getLibrary("EventQueue"):getInstance():listenEvent("callCops", function(fixture)
            saveCitzen(this, fixture)
        end)
    end

    return setmetatable(this, NonPlayerCharacter)
end

function NonPlayerCharacter:callCops()
    gameDirector:getLibrary("EventQueue"):getInstance():announceEvent("callCops", self.fixture)
    self.fixture:setUserData("Cop")
end

function NonPlayerCharacter:getFixture()
    return self.fixture
end

function NonPlayerCharacter:setStopTime(amount)
    self.stopTime = amount
end

function NonPlayerCharacter:update(dt)
    self.stopTime = self.stopTime - dt
    if self.stopTime <= 0 then
        self.stopTime = 0
        self.updateFunction(dt)
    end
end

function NonPlayerCharacter:draw()
    love.graphics.circle("fill" , self.body:getX(), self.body:getY(), 16)
end

return NonPlayerCharacter

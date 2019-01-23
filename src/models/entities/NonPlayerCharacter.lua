local NonPlayerCharacter = {}

NonPlayerCharacter.__index = NonPlayerCharacter

--[[local citzenSprite = love.graphics.newImage()
local copSprite = love.graphics.newImage()--]]

local function copsUpdate(this, dt)
    if not this.state then
        this.followPlayer()
    end
end

local function citzenUpdate(this, dt)
    if this.state then
        if this.elapsedTime <= 4 then
            if this.characterType == 1 then
                this.body:setLinearVelocity(120 * (this.movementType and 1 or -1), 0)
            else
                this.body:setLinearVelocity(0, 120 * (this.movementType and 1 or -1))
            end
        else
            this.elapsedTime = 0
            this.movementType = not this.movementType
            this.body:setLinearVelocity(0, 0)
        end
    else
        this:followPlayer()
    end
end

local function saveCitzen(this, fixture)
    if love.physics.getDistance(this.fixture, fixture) <= 16 then
        this.state = false
    end
end

function NonPlayerCharacter:new(characterType, world, x, y, getPlayerPosition)
    local this = {
        characterType = characterType,
        state = true,  --[[ IDLE (0) : FOLLOWING(1) --]]
        movementType = false,
        body = love.physics.newBody(world, x or 0, y or 0, "dynamic"),
        shape = love.physics.newCircleShape(24),
        getPlayerPosition = getPlayerPosition,
        fixture = nil,
        updateFunction = characterType == 0 and copsUpdate or citzenUpdate,
        stopTime = 0,
        elapsedTime = 0
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
    self.state = false
    self.body:setLinearVelocity(0, 0)
end

function NonPlayerCharacter:followPlayer()
    local playerX, playerY = self.getPlayerPosition()
    local x = 0; local y = 0
    if playerX < self.body:getX() then
        x = -70
    elseif playerX > self.body:getX() then
        x = 70
    end
    if playerY < self.body:getY() then
        y = -70
    elseif playerY > self.body:getY() then
        y = 70
    end
    self.body:setLinearVelocity(x, y)
end

function NonPlayerCharacter:getFixture()
    return self.fixture
end

function NonPlayerCharacter:setStopTime(amount)
    self.stopTime = amount
end

function NonPlayerCharacter:update(dt)
    self.stopTime = self.stopTime - dt
    self.elapsedTime = self.elapsedTime + dt
    if self.stopTime <= 0 then
        self.stopTime = 0
        self.updateFunction(self, dt)
    end
end

function NonPlayerCharacter:draw()
    love.graphics.circle("fill" , self.body:getX(), self.body:getY(), 24)
end

return NonPlayerCharacter

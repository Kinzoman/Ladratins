local HeadUpDisplay = {}

HeadUpDisplay.__index = HeadUpDisplay

function HeadUpDisplay:new(life)
    local this = {
        lifebar = gameDirector:getLibrary("ProgressBar"):new(40, 20, 250, 32, {1, 0, 0}, life, life),
        stalkersCounter = 0
    }
    this.lifebar:addImage(love.graphics.newImage("assets/sprites/lifebar.png"), nil, 50, 8)

    return setmetatable(this, HeadUpDisplay)
end

function HeadUpDisplay:updateComponent(name, value)
    if name == "lifebar" then
        self.lifebar:decrement(value)
    else
        self.stalkersCounter = self.stalkersCounter + value
    end
end

function HeadUpDisplay:draw()
    self.lifebar:draw()
    love.graphics.setNewFont(30)
    love.graphics.print(string.format("Stalkers: %d", self.stalkersCounter), 550, 20, 0)
    love.graphics.setNewFont(15)
end

return HeadUpDisplay

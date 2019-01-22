local Wall = {}

Wall.__index = Wall

function Wall:new(world, x, y, dimensions, image)
    local this = {
        image = image,
        body = love.physics.newBody(world, x or 0, y or 0, "static"),
        shape = love.physics.newRectangleShape(dimensions.w, dimensions.h),
        fixture = nil
    }
    this.fixture = love.physics.newFixture(this.body, this.shape)
    return setmetatable(this, Wall)
end

function Wall:draw()
    if self.image then
        love.graphics.draw(self.image, self.body:getX(), self.body:getY())
    else
        love.graphics.polygon("fill", self.body:getWorldPoints(self.shape:getPoints()))
    end
end

return Wall
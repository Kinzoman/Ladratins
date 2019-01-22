local NonPlayerCharacter = {}

NonPlayerCharacter.__index = NonPlayerCharacter

function NonPlayerCharacter:new(characterType, world, x, y)
    local this = {
        characterType = characterType,
        state = 0,
        body = love.physics.newBody(world, x or 0, y or 0, "dynamic")
    }

    return setmetatable(this, NonPlayerCharacter)
end

return NonPlayerCharacter

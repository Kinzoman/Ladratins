orientation = argument0
currentX = argument1
currentY = argument2
velocity = argument3

if orientation == 0 {
    currentX -= velocity
} else if orientation == 1 {
    currentX += velocity
} else if orientation == 2 {
    currentY -= velocity
} else {
    currentY += velocity
}

positions[0] = currentX
positions[1] = currentY

return positions


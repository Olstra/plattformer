--[[
    plattformer
    Author: olstra
    Date: Jan 2020
    as a part of 'edx course CS50g'
]]

Player = Class{}


function Player:init(def)
    -- position
    self.x = def.x
    self.y = def.y

    -- velocity
    self.dx = 0
    self.dy = 0

    -- dimensions
    self.w = def.w
    self.h = def.h

    self.texture = def.texture

    self.speed = 100
    self.jump_vel = -75

    self.direction = 'right'

    self.states = {'idle', 'moving', 'jumping', 'falling'}

    self.curr_state = 'idle'

    -- reference to the world map
    self.map = def.map

end


function Player:update(dt)

    if not(self:collidesBottom()) then
        self.y = self.y + 3
    end

    if love.keyboard.isDown('space') then
        if self:collidesBottom() then
            player.y = player.y + player.jump_vel
        end
    end

    -- move character left/right
    if love.keyboard.isDown('right') then
        if not(self:collidesRight()) then
            self.x = self.x + self.speed * dt
            self.direction = 'right'
        end
    elseif love.keyboard.isDown('left') then
        if not(self:collidesLeft()) then
            self.x = self.x - self.speed * dt -- update position
            self.direction = 'left'
        end
    end
    
end


function Player:render()
    local x_pos = math.floor(self.x / TILE_SIZE)
    local y_pos = math.floor(self.y / TILE_SIZE)

    love.graphics.draw( 
        gTextures[self.texture], 
        gFrames[self.texture][1],
        math.floor(self.x) + 8, 
        math.floor(self.y) + 10, 
        0, 
        self.direction == 'right' and 1 or -1, 
        1, 8, 10
    )
end


-- COLLISION DETECTION----------

function Player:collidesUp()
    -- test when player is in this state:
    -- jumping
    
    if self.curr_state == 'jumping' then
    end
end

-- kinda works... but not perfectly
function Player:collidesBottom()


    local x = 0
    local y = 0 
    local max_x = #self.map[1]
    local max_y = #self.map

    -- if next tile = solid -> collision    

    -- get position of lower left corner
    y = math.max( 1, math.floor( (self.y + self.h) / TILE_SIZE ) )
    x = math.max( 1, math.floor( (self.x + self.w) / TILE_SIZE ) ) -- add w so gameplay mor intuitive

    -- get next tile (without IOB)
    y = math.min( y +1, max_y )
    x = math.min( x, max_x )

    if self.map[y][x]['id'] == ID_GROUND then
        return true
    end


    -- get position of lower right corner        
    y = math.max( 1, math.floor( (self.y + self.h) / TILE_SIZE ) )
    x = math.max( 1, math.floor( (self.x + self.w + self.w/2) / TILE_SIZE ) )

    -- get next tile (without IOB)
    y = math.min( y +1, max_y )
    x = math.min( x, max_x )

    if self.map[y][x]['id'] == ID_GROUND then
        return true
    end

    return false    
    
end


function Player:collidesRight()

    local max_x = #self.map[1]
    local max_y = #self.map        
    local x = 0
    local y = 0

    -- get position of upper right corner
    y = math.floor( self.y / TILE_SIZE ) + 1 -- +1 cause lua 1 indexed
    y = (y < max_y) and y or max_y -- safety check

    x = math.floor( (self.x + self.w) / TILE_SIZE ) + 1
    x = (x < max_x) and x or max_x

    -- check if player overlaps with solid tile
    if self.map[y][x]['id'] == ID_GROUND then
        return true
    end

    -- check lower right corner
    y = math.max( 1, math.floor( (self.y + self.h) / TILE_SIZE ) )

    if self.map[y][x]['id'] == ID_GROUND then
        return true
    end

    return false
end


function Player:collidesLeft()
        
    local max_x = #self.map[1]
    local max_y = #self.map
    local x = 0
    local y = 0

    -- get position of upper left corner
    y = math.floor( self.y / TILE_SIZE ) + 1
    y = (y < max_y) and y or max_y

    x = math.floor( self.x / TILE_SIZE ) + 1
    x = (x < max_x) and x or max_x

    -- check for overlap
    if self.map[y][x]['id'] == ID_GROUND then
        return true
    end

    -- check lower left corner
    y = math.max(1, math.floor( (self.y + self.h) / TILE_SIZE ) )
    y = (y < max_y) and y or max_y

    if self.map[y][x]['id'] == ID_GROUND then
        return true
    end

    return false
end
--------------------------------
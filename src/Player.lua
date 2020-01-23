--[[
    plattformer
    Author: olstra
    Date: Jan 2020
    as a part of 'edx course CS50g'
]]

Player = Class{}


function Player:init(def)

    -- defaults

    -- dimensions
    self.w = CHARA_W
    self.h = CHARA_H

    -- position
    -- set at creation of level, in generateLevel()
    self.x = def.x --CHARA_H
    self.y = def.y --FLOOR_H * TILE_SIZE - CHARA_H

    -- velocity
    self.dx = 0
    self.dy = 0

    self.speed = 100
    
    self.jump_vel = -150

    self.alive = true

    self.texture = 'player'

    self.direction = 'right'

    self.curr_state = 'idle'

    self.score = 0


    -- set at runtime
    self.map = def.map    

    self.animation = def.animation

end


function Player:update(dt)

    self.animation:update(dt)

    if not(self:collidesBottom()) or self.curr_state == 'jumping' then
        -- check for lower edge of screen
        if self.y+self.h < VIRTUAL_H then
            self.dy = self.dy + GRAVITY
            self.y = self.y + self.dy * dt
        else
            self.y = VIRTUAL_H - self.h
            self.animation = ani_idle
            self.alive = false
        end
    end

    if self:collidesBottom() then
        self.curr_state = 'idle'
        self.animation = ani_idle
    end

    if love.keyboard.isDown('space') then
        if self:collidesBottom() then
            player.dy = player.jump_vel
            self.curr_state = 'jumping'
            self.animation = ani_jump
        end
    end

    -- move character left/right
    if love.keyboard.isDown('right') then
        if not(self:collidesRight()) then
            self.x = self.x + self.speed * dt
            self.direction = 'right'
            self.animation = ani_moving
        end
    elseif love.keyboard.isDown('left') then
        if not(self:collidesLeft()) then
            self.x = self.x - self.speed * dt -- update position
            self.direction = 'left'
            self.animation = ani_moving
        end
    end

    -- constrain player X no matter which state
    if self.x <= 0 then
        self.x = 0
    elseif self.x > TILE_SIZE * #self.map[1] - self.w then
        self.x = TILE_SIZE * #self.map[1]- self.w
    elseif self.y <= 0 then
        self.y = 0
    elseif self.y > TILE_SIZE * #self.map - self.h then
        self.y = TILE_SIZE * #self.map - self.h
    end
    
end


function Player:render()
    local x_pos = math.floor(self.x / TILE_SIZE)
    local y_pos = math.floor(self.y / TILE_SIZE)


    love.graphics.draw( 
        gTextures[self.texture], 
        gFrames[self.texture][self.animation:getCurrentFrame()],
        math.floor(self.x) + CHARA_W/2, 
        math.floor(self.y) + CHARA_H/2, 
        0, 
        self.direction == 'right' and 1 or -1, 
        1, 8, 10
    )
end


function Player:reset()
    self.alive = true
    self.curr_state = 'idle'
    self.score = 0

   -- position
   self.x = s_player_x
   self.y = s_player_y

   -- re-generate level 
   level.map = level:generateLevel(map_txt)

   --repoint map reference of player to new map
   self.map = level.map

   gSounds['death']:stop()
   gSounds['music']:play()
end

-- COLLISION DETECTION----------

function Player:collidesUp()
    -- test when player is in this state:
    -- jumping
    
    if self.curr_state == 'jumping' then
    end
end


-- kinda works... but not perfectly (1 tile-w gaps...)
function Player:collidesBottom()
    -- handles collision with lava

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

    if self.map[y][x]['collidable'] then
        if self.map[y][x]['deadly'] then
            self.alive = false
        elseif self.map[y][x]['id'] == ID_EXIT then
                self.curr_state = 'finish'
        elseif self.map[y][x]['id'] == 'cookie' then
            self.map[y][x]['id'] = ID_SKY
            self.map[y][x]['collidable'] = false
            gSounds['pickup']:play()
            
            self.score = self.score + 1
        end

        return true
    end


    -- get position of lower right corner        
    y = math.max( 1, math.floor( (self.y + self.h) / TILE_SIZE ) )
    x = math.max( 1, math.floor( (self.x + self.w + self.w/2) / TILE_SIZE ) )

    -- get next tile (without IOB)
    y = math.min( y +1, max_y )
    x = math.min( x, max_x )

    if self.map[y][x]['collidable'] then
        if self.map[y][x]['deadly'] then
            self.alive = false
        elseif self.map[y][x]['id'] == ID_EXIT then
                self.curr_state = 'finish'
        elseif self.map[y][x]['id'] == 'cookie' then
            self.map[y][x]['id'] = ID_SKY
            self.map[y][x]['collidable'] = false
            gSounds['pickup']:play()
            
            self.score = self.score + 1
        end

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
    y = math.max(1, math.floor( self.y / TILE_SIZE ) ) -- we never want a value bellow 0
    y = (y < max_y) and y or max_y -- safety check

    x = math.max(1, math.floor( (self.x + self.w) / TILE_SIZE ) )
    x = (x < max_x) and x or max_x

    -- check if player overlaps with solid tile
    if self.map[y][x]['collidable'] then
        if self.map[y][x]['id'] == ID_EXIT then
            self.curr_state = 'finish'
        elseif self.map[y][x]['id'] == 'cookie' then
            self.map[y][x]['id'] = ID_SKY
            self.map[y][x]['collidable'] = false
            gSounds['pickup']:play()
            
            self.score = self.score + 1
        end

        return true
    end

    -- check lower right corner
    y = math.max( 1, math.floor( (self.y + self.h) / TILE_SIZE ) )

    if self.map[y][x]['collidable'] then
        if self.map[y][x]['id'] == ID_EXIT then
            self.curr_state = 'finish'
        elseif self.map[y][x]['id'] == 'cookie' then
            self.map[y][x]['id'] = ID_SKY
            self.map[y][x]['collidable'] = false
            gSounds['pickup']:play()
            
            self.score = self.score + 1
        end

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
    y = math.max(1, math.floor( self.y / TILE_SIZE ) )
    y = (y < max_y) and y or max_y

    x = math.max(1, math.floor( self.x / TILE_SIZE ) )
    x = (x < max_x) and x or max_x

    -- check for overlap
    if self.map[y][x]['collidable'] then
        if self.map[y][x]['id'] == ID_EXIT then
            self.curr_state = 'finish'
        elseif self.map[y][x]['id'] == 'cookie' then
            self.map[y][x]['id'] = ID_SKY
            self.map[y][x]['collidable'] = false
            gSounds['pickup']:play()
            
            self.score = self.score + 1
        end

        return true
    end

    -- check lower left corner
    y = math.max(1, math.floor( (self.y + self.h) / TILE_SIZE ) )
    y = (y < max_y) and y or max_y

    if self.map[y][x]['collidable'] then
        if self.map[y][x]['id'] == ID_EXIT then
            self.curr_state = 'finish'
        elseif self.map[y][x]['id'] == 'cookie' then
            self.map[y][x]['id'] = ID_SKY
            self.map[y][x]['collidable'] = false
            gSounds['pickup']:play()
            
            self.score = self.score + 1
        end
        
        return true
    end

    return false
end
--------------------------------
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

    self.speed = 90
    
    self.jump_vel = -190

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
        if self.y + self.h < VIRTUAL_H then
            self.dy = self.dy + GRAVITY
            self.y = self.y + self.dy * dt
        else
            self.y = VIRTUAL_H - self.h
            self.alive = false
            self.animation = ani_idle
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
    
    -- constrain player X/Y no matter which state
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
    love.graphics.draw( 
        gTextures[self.texture], 
        gFrames[self.texture][self.animation:getCurrentFrame()],
        math.floor(self.x) +CHARA_W/2, -- use floor so no blur
        math.floor(self.y) +CHARA_H/2,
        0, 
        self.direction == 'left' and -1 or 1,
        1,
        CHARA_W/2, CHARA_H/2
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
    -- TODO...
end


-- kinda works... but not perfectly (1 tile-w gaps...)
function Player:collidesBottom()
    -- handles collision with lava
    -- if next tile = solid -> collision 

    local x = 0
    local y = 0 
    local max_x = #self.map[1]
    local max_y = #self.map
    
    -- check collision with tile underneath player

    -- calculate index of the tile player is in currently
    local curr_tile_x = math.floor(self.x / TILE_SIZE)

    y = math.max( 1, math.floor( self.y / TILE_SIZE ) + 1 ) -- lua is 1 idxed, so we never want a value <1
    -- get next tile under player (without IOB)
    y = math.min( y + 1, max_y )

    x = math.max( 1, math.floor( self.x / TILE_SIZE ) )
    
    if self.direction == 'right' then
        x = math.min(x+1, max_x) -- check next tile instead
    else
        x = math.min(x+2, max_x)
    end


    -- collision detection
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
    y = math.max(1, math.floor( self.y / TILE_SIZE ) +1) -- we never want a value bellow 0
    y = (y < max_y) and y or max_y -- safety check

    x = math.max(1, math.floor( self.x / TILE_SIZE )+1 ) -- +1 cause lua indxed
    x = (x+1 < max_x) and x+1 or max_x -- +1 cause we check tile to the right

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

    -- get position of upper right corner
    y = math.max(1, math.floor( self.y / TILE_SIZE ) +1) -- we never want a value bellow 0
    y = (y < max_y) and y or max_y -- safety check

    x = math.max(1, math.floor( (self.x / TILE_SIZE ) +1)) -- +1 cause lua indxed
    x = math.max(x, 1) -- +1 cause we check tile to the right

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
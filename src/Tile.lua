--[[
    plattformer
    Author: olstra
    Date: Jan 2020
    as a part of 'edx course CS50g'
]]

Tile = Class{}

function Tile:init(def) -- TODO re-add parameter topper, topperset, tileset
    self.x = def.x
    self.y = def.y

    self.width = TILE_SIZE
    self.height = TILE_SIZE

    self.id = def.id
    self.tileset = 1

    self.topper = def.topper

    self.collidable = def.collidable

    self.deadly = false
    --self.topperset = topperset
end

--[[
    Checks to see whether this ID is whitelisted as collidable in a global constants table.
]]
--[[ function Tile:collidable(target)
    for k, v in pairs(COLLIDABLE_TILES) do
        if v == self.id then
            return true
        end
    end

    return false
end ]]

function Tile:render()
    love.graphics.draw(
        gTextures['tiles'], 
        gFrames['tilesets'][self.tileset][self.id],
        (self.x - 1) * TILE_SIZE, 
        (self.y - 1) * TILE_SIZE
    )
end



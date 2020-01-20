--[[
    Plattformer

    -- Dependencies list --

    Author: olstra
    Date: Jan 2020
    as a part of 'edx course CS50g'
]]


--
-- libraries
--
Class = require 'lib/class'
push = require 'lib/push'

-- utility
require 'src/util'
require 'src/constants'

-- sources
require 'src/Player'
require 'src/Tile'
require 'src/Level'
require 'src/Animation'


gTextures = {
    ['tiles'] = love.graphics.newImage('graphics/tiles.png'),
    ['toppers'] = love.graphics.newImage('graphics/tile_tops.png'),
    ['backgrounds'] = love.graphics.newImage('graphics/backgrounds.png'),
    
    ['player'] = love.graphics.newImage('graphics/player.png')
}

gFrames = {
    ['tiles'] = GenerateQuads(gTextures['tiles'], TILE_SIZE, TILE_SIZE),
    ['toppers'] = GenerateQuads(gTextures['toppers'], TILE_SIZE, TILE_SIZE),
    ['backgrounds'] = GenerateQuads(gTextures['backgrounds'], 256, 128),

    ['player'] = GenerateQuads(gTextures['player'], CHARA_W, CHARA_H)
}

-- these need to be added after gFrames is initialized because they refer to gFrames from within
gFrames['tile_sets'] = GenerateTileSets( gFrames['tiles'], TILE_SETS_WIDE, TILE_SETS_TALL, TILE_SET_W, TILE_SET_H )
gFrames['topper_sets'] = GenerateTileSets( gFrames['toppers'], TOPPER_SETS_WIDE, TOPPER_SETS_TALL, TILE_SET_W, TILE_SET_H )


gFonts = {
    ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
    ['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
    ['large'] = love.graphics.newFont('fonts/font.ttf', 32),
    ['title'] = love.graphics.newFont('fonts/ArcadeAlternate.ttf', 32)
}
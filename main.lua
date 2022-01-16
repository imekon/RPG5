GROUND = ' '
GRASS = '.'
WALL = '#'
DOOR1 = '|'
DOOR2 = '-'
DOWNSTAIRS = '>'
UPSTAIRS = '<'
GOLD = '$'
MARKER = 'x'
TREES = 'T'
SINKHOLE = 's'
WARP = 'w'

shopLevel = 
{
  "..............................................................",
  "..................................#######...#######...........",
  "..................................#     #...#     #...........",
  ".....###########..................#     #####     #...........",
  ".....#         #..................#               #...........",
  ".....#         ####...............#            ####...........",
  ".....#            #               #            #..............",
  ".....#            |               |            #..............",
  ".....#            #               #            ####...........",
  ".....#         ####...............#               #...........",
  ".....#         #..................#               #...........",
  ".....######-####..................#               #...........",
  "..........   .....................#########-#######...........",
  "..........   .............................   .................",
  "..........   .............................   .................",
  "..........   .............................   .................",
  "..........   .............................   .................",
  "..........   .............................   .................",
  "..........   .............................   .................",
  "..........   .............................   .................",
  "..........   .............................   .................",
  "..........                                   .................",
  "..........                 x                 .................",
  "..........                                   .................",
  "..........................   .................................",
  "..........................   .................................",
  "..........................   .................................",
  "..........................   .................................",
  ".......T.T.............####-####..............................",
  "........TTTT...........#       #..............................",
  ".......TTTTTTT.........#   >   #..............................",
  "...........TT..........#       #..............................",
  ".......................#########..............................",
  ".............................................................."
}

level1 =
{
  "..............................................................",
  ".#########....##########......................##########......",
  ".#       ######        ########################        #......",
  ".#       |                                             #......",
  ".#       ######        #############-##########        #......",
  ".#########....##########...........# #........#        #......",
  "...................................# #........####-#####......",
  ".####################..............# #...........# #..........",
  ".#                  ################ #...........# #..........",
  ".#                  |                #...........# ##########.",
  ".#                  ################ #...........#          #.",
  ".####################..............# #...........########## #.",
  "...................................# #....................# #.",
  "......................##############-#####................# #.",
  "......................#                  #................# #.",
  "...###############....#                  ################## #.",
  "...#             #....#         x        |                | #.",
  "...#             #....#                  ################## #.",
  "...#             #....#                  #................# #.",
  "...#             #....#####-##############................# #.",
  "...#             #........# #.............................# #.",
  "...#             #........# #.............................# #.",
  "...##########-####........# #.......................####### #.",
  "............# #...........# #.......................#       #.",
  "............# ############# #.......................# #######.",
  "............#               #.......................# #.......",
  "............# ###############.......................# #.......",
  "............# #.....................................# #.......",
  ".....########-###########...............#############-#######.",
  ".....#                  #...............#                   #.",
  ".....#                  #################                   #.",
  ".....#                  |               |                   #.",
  ".....#                  #################                   #.",
  ".....#                  #...............#                   #.",
  ".....####################...............#####################.",
  ".............................................................."
}

function setLevel(lvl, name, lit)
  level.name = name
  level.data = lvl
  level.lit = lit
  level.width = string.len(lvl[1])
  level.height = #lvl
  level.doors = {}
end

function getLevelCell(x, y)
  if level.lit then
    return string.char(level.data[y + 1]:byte(x + 1))
  else
    return '+'
  end
end

function createPlayer()
  local player = {}
  player.mana = 100
  player.health = 100
  player.gold = 50
  player.x = 6
  player.y = 5
  player.graphics = love.graphics.newImage("images/player.png")
  return player
end

function love.load()
  camera = require "libraries/camera"
  cam = camera()
  
  require "levels"
  
  shopLevelData = createLevelFromDefn("Shops", shopLevel, MARKER)
  level1Data = createLevelFromDefn("Level 1", level1, MARKER)
  
  for y=1,shopLevelData.height do
    for x=1,shopLevelData.width do
      shopLevelData[y][x].lit = true
    end
  end
  
  level = shopLevelData

  player = createPlayer()
  player.x = level.marker.x
  player.y = level.marker.y
  
  grass = love.graphics.newImage("images/grass.png")
  ground = love.graphics.newImage("images/ground.png")
  wall = love.graphics.newImage("images/wall.png")
  gold = love.graphics.newImage("images/gold.png")
  trees = love.graphics.newImage("images/tree.png")
  door1 = love.graphics.newImage("images/door1.png")
  door2 = love.graphics.newImage("images/door2.png")
  downstairs = love.graphics.newImage("images/downstairs.png")
  upstairs = love.graphics.newImage("images/upstairs.png")
  
  love.keyboard.setKeyRepeat(true)
end

function love.keypressed(key)
  local x = player.x
  local y = player.y
  
  if key =="right" then
    x = x + 1
  end

  if key == "left" then
    x = x - 1
  end

  if key == "down" then
    y = y + 1
  end

  if key == "up" then
    y = y - 1
  end
  
  if key == '1' then
    level = level1Data
    player.x = level.marker.x
    player.y = level.marker.y
    return
  end

  if key == 's' then
    level = shopLevelData
    player.x = level.marker.x
    player.y = level.marker.y
    return
  end  
  
  if x < 1 then
    x = 1
  end
  
  if x > level.width then
    x = level.width
  end
  
  if y < 1 then
    y = 1
  end
  
  if y > level.height then
    y = level.height
  end
  
  target = level[y][x].contents
  
  if target == WALL then
    return
  end
  
  player.x = x
  player.y = y
  
  visitLevelRoom(level, x, y)
end

function love.update(dt)
  local x = player.x * 32
  local y = player.y * 32

  cam:lookAt(x, y)

  -- restrain camera top left border
  local w = love.graphics.getWidth()
  local h = love.graphics.getHeight()

  if cam.x < w/2 then
      cam.x = w/2
  end

  if cam.y < h/2 then
      cam.y = h/2
  end

  -- restrain camera bottom right border
  local mapW = level.width * 32
  local mapH = level.height * 32

  if cam.x > (mapW - w/2) then
      cam.x = mapW - w/2
  end

  if cam.y > (mapH - h/2) then
      cam.y = mapH - h/2
  end
end

function love.draw()
  -- camera drawn stuff
  cam:attach()
  for y = 1, level.height do
    for x = 1, level.width do
      if level[y][x].lit then
        ch = level[y][x].contents
        if ch == GROUND or ch == MARKER then
          love.graphics.draw(ground, (x - 1) * 32, (y - 1) * 32)
        elseif ch == GRASS then
          love.graphics.draw(grass, (x - 1) * 32, (y - 1) * 32)
        elseif ch == TREES then
          love.graphics.draw(trees, (x - 1) * 32, (y - 1) * 32)
        elseif ch == WALL then
          love.graphics.draw(wall, (x - 1) * 32, (y - 1) * 32)
        elseif ch == DOOR1 then
          love.graphics.draw(door1, (x - 1) * 32, (y - 1) * 32)
        elseif ch == DOOR2 then
          love.graphics.draw(door2, (x - 1) * 32, (y - 1) * 32)
        elseif ch == DOWNSTAIRS then
          love.graphics.draw(downstairs, (x - 1) * 32, (y - 1) * 32)
        end
      end
    end
  end
    
  love.graphics.draw(player.graphics, (player.x - 1) * 32, (player.y - 1) * 32)
  cam:detach()
  
  -- hud stuff (outside of camera)
  love.graphics.print(string.format("FPS: %d", love.timer.getFPS()), 10, 10)
  love.graphics.print(string.format("Player: %d, %d %s", player.x, player.y, level.name), 10, 30)
  love.graphics.print(string.format("Gold: %d", player.gold), 10, 50)
  love.graphics.print(string.format("Health: %d", player.health), 10, 70)
  love.graphics.print(string.format("Mana: %d", player.mana), 10, 90)
end


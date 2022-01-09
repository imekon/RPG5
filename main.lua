shopLevel = {
  "..............................................................",
  ".######################...........#################...........",
  ".#                    #...........#               #...........",
  ".#                    #...........#               #...........",
  ".#                    #...........#               #...........",
  ".#                    #...........#               #...........",
  ".#                    #...........#               #...........",
  ".#                    |           |               #...........",
  ".#                    #...........#               #...........",
  ".#                    #...........#               #...........",
  ".#                    #...........#               #...........",
  ".#                    #...........#               #...........",
  ".##########-###########...........#########-#######...........",
  "..........   .............................   .................",
  "..........   .............................   .................",
  "..........   .............................   .................",
  "..........                                   .................",
  "..........                                   .................",
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

function setLevel(lvl)
  level.data = lvl
  level.width = string.len(lvl[1])
  level.height = #lvl
end

function love.load()
  camera = require "libraries/camera"
  cam = camera()
  
  level = {}
  setLevel(shopLevel)
  --level.data = shopLevel
  --level.width = string.len(shopLevel[1])
  --level.height = #shopLevel

  player = {}
  player.x = 5
  player.y = 5
  player.graphics = love.graphics.newImage("images/player.png")
  
  grass = love.graphics.newImage("images/grass.png")
  ground = love.graphics.newImage("images/ground.png")
  wall = love.graphics.newImage("images/wall.png")
  trees = love.graphics.newImage("images/tree.png")
  door1 = love.graphics.newImage("images/door1.png")
  door2 = love.graphics.newImage("images/door2.png")
  downstairs = love.graphics.newImage("images/downstairs.png")
  
  mapWidth = string.len(shopLevel[1])
  mapHeight = #shopLevel
end

function love.keypressed(key)
  if key =="right" then
    player.x = player.x + 1
  end

  if key == "left" then
    player.x = player.x - 1
  end

  if key == "down" then
    player.y = player.y + 1
  end

  if key == "up" then
    player.y = player.y - 1
  end
  
  if player.x < 0 then
    player.x = 0
  end
  
  if player.x >= level.width then
    player.x = level.width - 1
  end
  
  if player.y < 0 then
    player.y = 0
  end
  
  if player.y >= level.height then
    player.y = level.height - 1
  end
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
  for y = 0, level.height - 1 do
    for x = 0, level.width - 1 do
      ch = string.char(level.data[y + 1]:byte(x + 1))
      if ch == ' ' then
        love.graphics.draw(ground, x * 32, y * 32)
      elseif ch == '.' then
        love.graphics.draw(grass, x * 32, y * 32)
      elseif ch == 'T' then
        love.graphics.draw(trees, x * 32, y * 32)
      elseif ch == '#' then
        love.graphics.draw(wall, x * 32, y * 32)
      elseif ch == '|' then
        love.graphics.draw(door1, x * 32, y * 32)
      elseif ch == '-' then
        love.graphics.draw(door2, x * 32, y * 32)
      elseif ch == '>' then
        love.graphics.draw(downstairs, x * 32, y * 32)
      end
    end
  end
    
  love.graphics.draw(player.graphics, player.x * 32, player.y * 32)
  cam:detach()
  
  -- hud stuff (outside of camera)
  love.graphics.print(string.format("FPS: %d", love.timer.getFPS()), 10, 10)
  love.graphics.print(string.format("Player: %d, %d", player.x, player.y), 10, 30)
end


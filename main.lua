function love.load()
  camera = require "libraries/camera"
  cam = camera()

  player = {}
  player.x = 5
  player.y = 5
  player.graphics = love.graphics.newImage("images/player.png")
  
  grass = love.graphics.newImage("images/grass.png")
  ground = love.graphics.newImage("images/ground.png")
  wall = love.graphics.newImage("images/wall.png")
  
  mapWidth = 50
  mapHeight = 40
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
  
  if player.x >= mapWidth then
    player.x = mapWidth - 1
  end
  
  if player.y < 0 then
    player.y = 0
  end
  
  if player.y >= mapHeight then
    player.y = mapHeight - 1
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
  local mapW = mapWidth * 32
  local mapH = mapHeight * 32

  if cam.x > (mapW - w/2) then
      cam.x = mapW - w/2
  end

  if cam.y > (mapH - h/2) then
      cam.y = mapH - h/2
  end
end

function love.draw()
  local start = love.timer.getTime()
  
  -- camera drawn stuff
  cam:attach()
  for y = 0,mapHeight - 1 do
    for x = 0,mapWidth - 1 do
      if (x + y) % 2 == 0 then
        love.graphics.draw(ground, x * 32, y * 32)
      else
        love.graphics.draw(wall, x * 32, y * 32)
      end
    end
  end
    
  love.graphics.draw(player.graphics, player.x * 32, player.y * 32)
  cam:detach()
  
  local length = love.timer.getTime() - start

  -- hud stuff (outside of camera)
  love.graphics.print(string.format("FPS: %d time: %1.2f s", love.timer.getFPS(), length), 10, 10)
end


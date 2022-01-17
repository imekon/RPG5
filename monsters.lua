function createMonster(x, y)
  local monster = {}
  monster.health = 100
  monster.mana = 100
  monster.awake = false
  monster.x = x
  monster.y = y
  monster.graphics = love.graphics.newImage("images/monster.png")
  return monster
end

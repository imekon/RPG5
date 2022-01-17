function createItem(type, x, y)
  local item = {}
  item.type = type
  item.x = x
  item.y = y
  return item
end

function createGold(value, x, y)
  local item = createItem('gold', x, y)
  item.value = value
  return item
end

function createTorch(x, y)
  local item = createItem('torch', x, y)
  item.counter = 10
  return item
end

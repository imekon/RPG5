function createLevel(name, width, height)
  local level = {}
  level.name = name
  for y=1,height do
    level[y] = {}
    for x=1,width do
	    local room = {}
	    room.lit = false
	    room.contents = '.'
	    room.monsters = {}
      room.items = {}
	    level[y][x] = room
    end
  end
  return level
end

function printLevel(level)
  local h = #level
  local w = #level[1]
  for y=1,h do
    local line = ''
    for x=1,w do
      if level[y][x].lit then
	    	line = line..level[y][x].contents
	    else
        line = line.."?"
	    end
    end
  print(line)
  end
end

function visitLevelRoom(level, _x, _y)
  local h = #level
  local w = #level[1]
  for y=_y-1,_y+1 do
    for x=_x-1,_x+1 do
      if x >= 1 and y >= 1 and
        x <= w and y <= h then
    	  level[y][x].lit = true
	    end
    end
  end
end

function readLevelDef(level, defn)
  local width = string.len(defn[1])
  local height = #defn

  for y=1,height do
    for x=1,width do
      local room = level[y][x]
      room.contents = string.char(defn.data[y]:byte(x))
    end
  end
end

function createVendor(x, y)
  local vendor = {}
  vendor.x = x
  vendor.y = y
  vendor.graphics = love.graphics.newImage("images/vendor.png")
  return vendor
end

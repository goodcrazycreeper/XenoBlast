
function make_crosshair()
    crosshair_image = love.graphics.newImage('images/ui/crosshair.png')
    love.mouse.setVisible(false)
end
function draw_crosshair()
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(crosshair_image,mx-crosshair_image:getWidth()/2,my-crosshair_image:getHeight()/2)
end

bg={}
function bg:init()
    self.on=true
    self.offset=0
    self.lines=10
end

function bg:update(dt)
    if self.on then
        self.offset = self.offset + 10 * dt
        if self.offset >= love.graphics.getWidth()/self.lines then
            self.offset = 0
        end
    end
end

function bg:draw()
    if self.on then
        for i=0, self.lines do
            love.graphics.setColor(0.1,0.1,0.1,0.5)
            love.graphics.rectangle('fill',i*love.graphics.getWidth()/self.lines+self.offset,0,10,love.graphics.getHeight())
        end
    end
end

function bg:stop()
    self.on=false
end
particles={}
function make_particle(x,y,dx,dy,color,life,size,da,ds)
    local particle = {

    x = x,
    y = y,
    dx = dx,
    dy = dy,
    life = life,
    size= size,
    first=true,
    color=color,


    update = function(self)
        
        self.x = self.x + self.dx
        self.y = self.y + self.dy
        self.life = self.life - global_dt
        self.size = self.size + ds * global_dt
        self.color[4] = self.color[4] + da * global_dt
        if self.first then
            self.first = false
        end

    end,

    draw = function(self)
        love.graphics.setColor(self.color[1],self.color[2],self.color[3],self.color[4])

        love.graphics.circle('fill',self.x,self.y,self.size)
    end
    }

    table.insert(particles,particle)

end

function update_particles()
    for i,v in ipairs(particles) do
        v:update()
        
        if v.life<=0 then
            table.remove(particles,i)
        end
    end
end

function draw_particles()
    for i,v in ipairs(particles) do
        v:draw()
    end
end
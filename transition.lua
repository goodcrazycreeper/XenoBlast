transition={}

function transition:init(goal)
    if not transition.on then
        transition.size=0
        transition.reached=false
        transition.on=true
        transition.goal=goal
    end
end

function transition:update(dt)
    if transition.on then
        if self.size >= (love.graphics.getWidth()/2)*1.3 then
            if self.reached==false then
                self.reached=true
                switch_state(self.goal)
            end
        end
        if self.reached then
            self.size = self.size - 700*dt
        else
            self.size = self.size + 800*dt
        end
        if self.size<=0 then
            if self.reached then
                self.on=false
                
            end
        end
    end
end

function transition:draw()
    if transition.on then
        love.graphics.setColor(0,0,0,1)
        love.graphics.circle("fill",love.graphics.getWidth()/2,love.graphics.getHeight()/2, self.size)
    end
end
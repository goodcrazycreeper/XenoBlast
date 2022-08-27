particles={}
function make_particle(type)
    local particle = {

    x = 100,
    y = 100,
    image=love.graphics.newImage('images/characters/character-6.png'),
    dist={0,0},

    update = function(self)

    end,

    draw = function(self)

    end
    }

    table.insert(particles,particle)

end

function update_particles()
    for i=1, #particles do
        particles[i]:update()
    end
end

function draw_particles()
    for i=1, #particles do
        particles[i]:draw()
    end
end
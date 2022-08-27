function state_update(dt) -- stands for current state
    if current_state=='intro' then
        logo_x = lerp(logo_x,40,1*dt)
        intro_timer=intro_timer- 1*dt
        if intro_timer<=0 then
            transition:init('menu')
        end
    elseif current_state=='menu' then
        --calculate positions
        rectangle_alpha = lerp(rectangle_alpha,0,5*dt)

        local spd = 30

        squash=lerp(squash,0,spd*dt)

        --animate
        character_frame_tick =character_frame_tick+ 1 * dt
        if character_frame_tick >= 0.1  then
            character_frame_tick = 0
            character_frame = character_frame + 1
            if character_frame > 4 then
                character_frame = 1
            end
        end
    
    elseif current_state=='game' then
        player:update(dt)
        update_enemies()
        
    elseif current_state=='pull' then
        shine_rot = shine_rot +  dt
        animated_character.x=window_width/2-(48/2)*animated_character.scale_x
    end
end
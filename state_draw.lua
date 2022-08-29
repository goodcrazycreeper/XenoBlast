function state_draw()
    if current_state=='intro' then
        
        love.graphics.setColor(0.1,0.1,0.1 , 1)
        love.graphics.print("Totally grape",400,window_height/2-40)
        love.graphics.setColor(0.7,0.3,0.1 , 1)
        love.graphics.rectangle("fill",0,0,logo_x+logo_image:getHeight()/2,window_height)
        love.graphics.setColor(1,1,1 , 1)
        love.graphics.draw(logo_image,logo_x,window_height/2-logo_image:getHeight()/2)

    elseif current_state=='menu' then -- menu
        --draws the top rect
        love.graphics.setBackgroundColor(0.6,0.5,0.6 , 1)
        love.graphics.setColor(0.58, 0.21, 0.78, 1)
        love.graphics.rectangle("fill",0,0,window_width,window_height/6)
        love.graphics.setColor(0.1,0.1,0.1, 1)
        love.graphics.rectangle("fill",0,window_height/6,window_width,10)
        --draws lines
        
        love.graphics.rectangle("fill",line_left-5,0,10,window_height/6)
        love.graphics.rectangle("fill",line_right-5,0,10,window_height/6)


        --draws selection box
        love.graphics.setColor(0.6, 0.6, 0.8, 1)
        love.graphics.rectangle("fill",selection_box.x,squash,selection_box.w,window_height/6-squash*2,25,25,20)
        love.graphics.setColor(0.1, 0.1, 0.1, 1)
        love.graphics.rectangle("line",selection_box.x,squash,selection_box.w,window_height/6-squash*2,25,25,20)
        
        --text drawing
        love.graphics.setFont(love.graphics.newFont('fonts/slkscr.ttf',60))
        love.graphics.print( "config",70,window_height/6/2-35)
        love.graphics.print( "play",window_width/2-100,window_height/6/2-35)
        love.graphics.print( "shop",window_width/3*2+110,window_height/6/2-35)

        if selected==0 then
            --text
            love.graphics.setColor(0.1, 0.1, 0.1, 1)
            love.graphics.setFont(love.graphics.newFont('fonts/slkscr.ttf',60))

            love.graphics.print("fullscreen\n\nmaster volume\nmusic volume\nsfx volume",20,200)
        elseif selected==1 then
            -- draw button
            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.draw(start_button_image,start_button[1],start_button[2])
            love.graphics.setColor(0.1, 0.1, 0.1, 1)
            love.graphics.setFont(love.graphics.newFont('fonts/slkscr.ttf',60))
            love.graphics.print( "deploy",start_button[1]+25,start_button[2]+20)
            


            --draw character animation 
            love.graphics.push()
            love.graphics.setColor(1,1,1,1)
            love.graphics.scale(5, 5)
            love.graphics.draw(my_character_images[tonumber(character_storage[menu_selected_character])], my_quads[character_frame], (window_width/2-120-100)/5, (window_height/2-120)/5)
            love.graphics.pop()

            --draw arrows
            if menu_selected_character == #character_storage then
                love.graphics.setColor(0.3,0.3,0.3,1)
            else
                love.graphics.setColor(1,1,1,1)
            end
            love.graphics.draw(right_arrow_image,window_width/2+window_width/6-100,window_height/2)

            if menu_selected_character == 1 then
                love.graphics.setColor(0.3,0.3,0.3,1)
            else
                love.graphics.setColor(1,1,1,1)
            end
            love.graphics.draw(left_arrow_image,window_width/2-window_width/6-left_arrow_image:getWidth()-100,window_height/2)
     
            --level upgrades
            local pos = {window_width/4*3+20,window_height/5-50} 
            love.graphics.setColor(0.1,0.1,0.1,1)
            love.graphics.rectangle('fill',900-10,200-10,540+20,415+20,25,25,25)
            love.graphics.setColor(0.58, 0.21, 0.78, 1)
            love.graphics.rectangle('fill',900,200,540,415,25,25,25)
            
            --draw icons
            love.graphics.setColor(1,1,1,1)
            
            local ih = icons[1]:getHeight()
            for i=1,3 do
                love.graphics.draw(circle_icon,pos[1]-70,pos[2]+(i*ih*1.1)-10)
                love.graphics.draw(icons[i],pos[1]-70,pos[2]+(i*ih*1.1)-10)
            end


            --draw boxes
            for i=1,3 do
                for j=1,3 do
                    love.graphics.draw(empty,pos[1]+(empty:getWidth()*1.5*j),pos[2]+(i*empty:getHeight()*1.3))
                    if character_stats[tonumber(character_storage[menu_selected_character])][i]>=j then
                        love.graphics.draw(full,pos[1]+(full:getWidth()*1.5*j),pos[2]+(i*full:getHeight()*1.3))
                    end
                end
            end

            --draw left box
            love.graphics.setColor(0.1,0.1,0.1,1)
            love.graphics.rectangle('fill',-30-10,200-10,250+20,415+20,25,25,25)
            love.graphics.setColor(0.58, 0.21, 0.78, 1)
            love.graphics.rectangle('fill',-30,200,250,415,25,25,25)

            love.graphics.setColor(1,1,1,1)
            love.graphics.setFont(love.graphics.newFont('fonts/slkscr.ttf',30))
            love.graphics.printf(character_info[tonumber(character_storage[menu_selected_character])][1],-30,220,250,'center')
            love.graphics.setColor(0.1,0.1,0.1,1)
            love.graphics.setFont(love.graphics.newFont('fonts/slkscr.ttf',20))
            love.graphics.printf(character_info[tonumber(character_storage[menu_selected_character])][2],10,280,200,'left')
            
            
            elseif selected==2  then
                

                love.graphics.setColor(0.1,0.1,0.1)
                for i=0 ,5 do
                    love.graphics.rectangle('fill',buy_button.x-i,buy_button.y-i,buy_button.w+i*2,buy_button.h+i*2,25,25,30)
                end
                love.graphics.setColor(1,1,1)
                love.graphics.rectangle('fill',buy_button.x,buy_button.y,buy_button.w,buy_button.h,25,25,30)
            end
            love.graphics.setColor(0.6,0.5,0.6,rectangle_alpha)
            love.graphics.rectangle('fill',0,0,window_width,window_height)


    elseif current_state=='game' then --game
        love.graphics.push()
            love.graphics.translate(-cam[1],-cam[2])
            draw_floor()
            draw_particles()
            player:draw()
            draw_enemies()
            
            draw_projectiles()
        love.graphics.pop()

    elseif current_state=='pull' then
        love.graphics.setBackgroundColor(pull_bg_color.r,pull_bg_color.g,pull_bg_color.b,1)
        

        local col = colors_table[chosen_rarity]

        love.graphics.setColor(col[1],col[2],col[3],shine.alpha)
        love.graphics.draw(shine_fx,window_width/2,window_height/2+50,shine_rot,2,2,shine_fx:getWidth()/2,shine_fx:getHeight()/2)


        love.graphics.push()
        love.graphics.setColor(animated_character.alpha,animated_character.alpha,animated_character.alpha,1)
        love.graphics.scale(animated_character.scale_x,animated_character.scale_y)



        if animated_character.scale_y<=3 then
            love.graphics.draw(my_character_images[chosen_pull],my_quads[1],animated_character.x/animated_character.scale_x,animated_character.y/animated_character.scale_y+(3-animated_character.scale_y)*27)
        else
            love.graphics.draw(my_character_images[chosen_pull],my_quads[1],animated_character.x/animated_character.scale_x,animated_character.y/animated_character.scale_y)
        end
        love.graphics.pop()

        love.graphics.setColor(0.2,0.2,0.2,animated_character.alpha)
        love.graphics.rectangle('fill',0,window_height/6/4-15,window_width,window_height/6+30)
        love.graphics.setColor(1,1,1,animated_character.alpha)
        love.graphics.rectangle('fill',0,window_height/6/4,window_width,window_height/6)
        love.graphics.setColor(0.2,0.2,0.2,animated_character.alpha)

        love.graphics.setFont(love.graphics.newFont('fonts/slkscr.ttf',100))
        love.graphics.printf(character_info[tonumber(chosen_pull)][1],0,window_height/6/4+10,window_width,'center')


        love.graphics.rectangle('fill',continue_button.x-10,continue_button.y-10,220,120,25,25,50)
        love.graphics.setColor(1,1,1,animated_character.alpha)
        love.graphics.rectangle('fill',continue_button.x,continue_button.y,200,100,25,25,50)
        love.graphics.setColor(0.1,0.1,0.1,animated_character.alpha)
        love.graphics.setFont(love.graphics.newFont('fonts/slkscr.ttf',30))
        love.graphics.printf('continue',continue_button.x,continue_button.y+35,200,'center')

    end
end

function draw_floor()
    for y=1,#floor_table do
        for x=1,#floor_table[1] do
            if (x*200+200)>cam[1] and (y*200+200)>cam[2]
            and (x*200)<cam[1]+window_width and (y*200)<cam[2]+window_height  then
                
            
            love.graphics.draw(desert_tiles[floor_table[y][x]],x*200,y*200)
            end
        end
    end
end
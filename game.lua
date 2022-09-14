gravity = 9.81

player = {}
player.x = 20
player.y = 96
player.w = 7
player.h = 7
-- player.h = 2 -- make the avatar height tiny until I deal with floor collisions
player.sprite = 0
player.speed = 2
player.moving = 0
player.anim_rate = 10 // as in 10 frames per movement
player.movement_counter = 0

function _init()
  last = time()
end

function isplatform(tile)
	if (tile>=48 and tile<=63) return true
	
	return false
end

function collide(vx,vy)
	local x1,x2,y1,y2

	-- we'll test two points:
	if vx!=0 then
        if vx>0 then
            x1=player.x+sgn(vx)*player.w
        else
            x1=player.x
        end
        x2 = x1

		y1=player.y-player.h
		y2=player.y+player.h
	end

    if vy!=0 then
        if vy>0 then
    		y1=player.y+sgn(vy)*player.h
        else
            y1=player.y
        end
		y2=y1
		
		x1=player.x
		x2=player.x+player.w
	end
	
	-- add our potential movement
	-- to our test points
	x1+=vx
	x2+=vx
	y1+=vy
	y2+=vy
	
	-- check for map-tile hits
	local tile1=mget(x1/8,y1/8)
	local tile2=mget(x2/8,y2/8)
  if isplatform(tile1) or isplatform(tile2) then
    if isplatform(tile1) then
        print("WALL 1!")
    end
    if isplatform(tile2) then
        print("WALL 2!")
    end
    return true
  end
    print("NO WALL!")
	return false
end

function moveanim()
    player.movement_counter += 1
    if player.movement_counter >= player.anim_rate then
        player.sprite += 1
        if player.sprite > 2 then
            player.sprite = 1
        end
        player.movement_counter = 0
    end
end

function _update()
    player.moving = 0
    fps = 1 / (time() - last)
    last = time()
    if (btn(0)) then
        player.moving = -1
        if not collide(-player.speed, 0) then
            player.x -= player.speed
            if player.x < -10 then
                player.x = 128
            end
        end
        moveanim()
    end
    if (btn(1)) then
        player.moving = 1
        if not collide(player.speed, 0) then
            player.x += player.speed
            if player.x > 128 then
                player.x = -10
            end
        end
        moveanim()
    end
    if (btn(2)) then
        if not collide(0, -player.speed) then
            player.y -= player.speed
        end
    end
    if (btn(3)) then
        if not collide(0, player.speed) then
            player.y += player.speed
        end
    end
    if player.moving == 0 then
        player.sprite = 0
    end
end

function _draw()
    cls()
    map(0,0,0,0,124,124)
    if player.moving < 0 then
        spr(player.sprite, player.x, player.y, 1, 1, true)
    else
        spr(player.sprite, player.x, player.y)
    end
    // print("dir: "..player.moving, 0, 0)
    // print("x: "..player.x..", y: "..player.y, 0, 0)
    // print("fps: "..fps)
    print(collide(0, player.speed))
    print(collide(0, -player.speed))
end
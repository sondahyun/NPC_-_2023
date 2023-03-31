-----------------------------------------------------------------------------------------
--
-- view1.lua
--
-----------------------------------------------------------------------------------------

local loadsave = require( "loadsave" )
local composer = require( "composer" )
local scene = composer.newScene()
local json = require( "json" ) 

function scene:create( event )
	local sceneGroup = self.view

	--physics.start()
	--physics.setDrawMode("hybrid")
	loadedEndings = loadsave.loadTable( "endings.json" )

	
	local background = display.newImageRect("image/pick/background.png",display.contentWidth, display.contentHeight) ---배경
	background.x, background.y = display.contentWidth/2, display.contentHeight/2
	background.alpha = 0.5
	sceneGroup:insert(background)
	
	local section = display.newRect(display.contentWidth/2, display.contentHeight*0.8, display.contentWidth, display.contentHeight*0.3)
	section:setFillColor(0.35, 0.35, 0.35, 0.35)
	sceneGroup:insert(section)
	
	local script = display.newText("게임방법\n제한 시간 이내에 물건을 클릭해서 주우세요!\n5점 이상 획득하면 CLEAR!\n\n생선뼈: -1점  폭타: GameOver  나머지 물건: +1점", section.x+30, section.y-100, native.systemFontBold)
	script.size = 30
	script:setFillColor(1)
	script.x, script.y = display.contentWidth/2, display.contentHeight*0.789
	sceneGroup:insert(script)

	local score = 0 
	local scoreImage = display.newImageRect("image/pick/score.png", 130, 130)
	scoreImage.x,scoreImage.y = display.contentWidth/11, display.contentHeight/5.5
	scoreImage.alpha = 0
	sceneGroup:insert(scoreImage)

 	local showScore = display.newText(score, display.contentWidth/11,display.contentHeight/5.555) 
	showScore:setFillColor(1,0,0) 
	showScore.size = 60
	showScore.alpha = 0
	sceneGroup:insert(showScore)

	local alarm = display.newImageRect("image/pick/alarm.png", 150, 150)
	alarm.x, alarm.y = display.contentWidth*0.9, display.contentHeight*0.2
	alarm.alpha = 0
	sceneGroup:insert(alarm)

	local time = display.newText(20, alarm.x+5, alarm.y+15)
	time.size = 50
	time:setFillColor(1, 0, 0)
	time.alpha = 0
	sceneGroup:insert(time)

	local home = audio.loadStream("music/music2.mp3")
    audio.setVolume( loadedEndings.logValue )--loadedEndings.logValue
 	--sceneGroup:insert(home)


	local function pagemove()
		if (score <= 4) then
			composer.setVariable("score1", -1)
		else
			composer.setVariable("score1", 5)
		end	
		audio.pause(home)
		composer.removeScene("view02_pick_game")
		composer.gotoScene("view02_pick_game_over")
	end

	local tapSound = audio.loadSound("music/tap.mp3")
	local function tapEventListener(event)	
    	audio.play(tapSound)
    	audio.setVolume(0.2)
		if (event.target.type == "food") then
			score = score + 1
			display.remove(event.target)
			showScore.text = score
		elseif (event.target.type == "trash") then
			score = score - 1
			display.remove(event.target)
			showScore.text = score
		else
			score = -1
			display.remove(event.target)
			pagemove()--게임오버
		end
	end

	local objectGroup = display.newGroup()
	local object = {}
	local objects = {"1", "2", "3", "4", "5"}
	local i = 1
	local x_differ = 0
	local function generate()
		local objIdx = math.random(#objects)
		local objName = objects[objIdx]
		object[i] = display.newImageRect(objectGroup, "image/pick/obj".. objName..".png", 110, 110)
		object[i].x, object[i].y = math.random(250, 1000), math.random(150, 600) 
		local obj = object[i] 
		local function remove(event)
			display.remove(obj)
		end
		timer3 = timer.performWithDelay(900, remove, 30, "removeTime")
		if (objIdx < 4) then
			object[i].type="food"
		elseif (objIdx == 4) then
			object[i].type="trash"
		else
			object[i].type="die"
		end

		sceneGroup:insert(object[i])
		object[i]:addEventListener("tap", tapEventListener)

		i = i + 1		
	end


	--샘플 볼륨 이미지
    -- local volumeButton = display.newImage("image/설정/설정.png")
    -- volumeButton.x,volumeButton.y = display.contentWidth * 0.87, display.contentHeight * 0.9
    

    local volumeButton = display.newImageRect("image/설정/설정.png", 100, 100)
    volumeButton.x,volumeButton.y = display.contentWidth * 0.9, display.contentHeight * 0.4
    volumeButton.alpha = 0
	sceneGroup:insert(volumeButton)

    --샘플볼륨함수--
    local function setVolume(event)
        composer.showOverlay( "StopGame", options )
    end
    volumeButton:addEventListener("tap",setVolume)


	--------------게임 시작--------------
	local function counter( event )
		audio.resume(home)
 		time.text = time.text - 1
	 	if(time.text == "-1") then
	 		time.alpha = 0
	 		pagemove()
 		end
 	end  
 	local function playGame(event) 	
 		audio.play(home)
 		timer1 = timer.performWithDelay(1000, counter, 21, "gameTime")
 		time.alpha = 1
 		background.alpha = 1
 		alarm.alpha = 1
 		volumeButton.alpha = 1
 		scoreImage.alpha = 1
		showScore.alpha = 1
		section.alpha = 0
		script.alpha = 0
		timer2 = timer.performWithDelay(870, generate, 30, "generateTime")
	end


	local options1 = {
        isModal = true
    }

 	local function showStop(event) 
 		audio.pause(home)
      	composer.showOverlay( "stopGame", options1 )
    end

	section:addEventListener("tap", playGame)
	stopButton:addEventListener("tap", showStop)
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
	end	
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end
end

function scene:destroy( event )
	local sceneGroup = self.view
	
	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene
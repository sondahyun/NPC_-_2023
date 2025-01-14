-----------------------------------------------------------------------------------------
--
-- schoolfood.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local physics = require("physics")
local scene = composer.newScene()
local loadsave = require( "loadsave" )
local json = require( "json" )

function scene:create( event )
	local sceneGroup = self.view
	
	---------1차시-------------

	composer.setVariable("gameName", "view07_schoolfood_game")
	
	local gametitle = display.newImageRect("image/climbing_the_tree/미니게임 타이틀.png", 587/1.2, 504/1.2)
	gametitle.x, gametitle.y = display.contentCenterX, display.contentCenterY 

	local foodGameName = display.newText("학식 받기 게임", 0, 0, "ttf/Galmuri7.ttf", 45)
	foodGameName:setFillColor(0)
	foodGameName.x, foodGameName.y=display.contentWidth/2, display.contentHeight*0.65

	local section = display.newRect(display.contentWidth/2, display.contentHeight*0.8, display.contentWidth*3, display.contentHeight*0.3)
	section:setFillColor(0.35, 0.35, 0.35, 0.35)
	section.alpha=0

	local script = display.newText("\n게임방법\n\n힌트를 보고\n30초 이내에 학식 메뉴를 골라주세요!", section.x+30, section.y-100, native.systemFontBold)
	script.size = 30
	script:setFillColor(1)
	script.x, script.y = display.contentWidth/2, display.contentHeight*0.789
	script.alpha=0


	local background = display.newImageRect("image/schoolfood/cafeteria.png", display.contentWidth*3, display.contentHeight)
	background.x = display.contentCenterX
    background.y = display.contentCenterY

	local pan = display.newImageRect("image/schoolfood/pan.png", display.contentWidth*2, display.contentHeight*1.5)--식판 이미지 650 650
 	pan.x, pan.y = display.contentCenterX, display.contentCenterY

 	local foodGroup = display.newGroup()--음식이미지 
 	local food = {}

 	for i = 1, 10 do
 		food[i] = display.newImageRect(foodGroup, "image/schoolfood/f (" .. i .. ").png", display.contentWidth/3.5, display.contentHeight/5.5)--90 90
 	end

 	for i = 1, 5 do--음식 위치 
 		food[i].x, food[i].y = display.contentCenterX*(-1.5), display.contentCenterY*(-0.05) + 90*i
 	end

 	for i = 6, 10 do
 		food[i].x, food[i].y = display.contentCenterX*3.5, display.contentCenterY*(-0.009) + 90*(i - 5)
 		--display.contentWidth*1.8, display.contentHeight*(-0.009) + 90*(i - 5)
 	end

 	local score = display.newText(0, display.contentWidth*(-0.5), display.contentHeight*0.1)--점수 입력 
 	score.size = 80

 	score:setFillColor(0)
 	score.alpha = 0.5

 	local time = display.newText(30, display.contentWidth*1.5, display.contentHeight*0.1)
 	time.size = 80
 	time:setFillColor(0)
 	time.alpha = 0.5

 	local home = audio.loadStream( "music/music13.mp3" )
    audio.setVolume( loadedEndings.logValue )--loadedEndings.logValue

    ----힌트 버튼 
    local hintBbg = display.newImageRect("image/schoolfood/hintButton.png", display.contentWidth/2.5, display.contentHeight/3.5)--힌트버튼 배경  150 150
 	hintBbg.x, hintBbg.y = display.contentCenterX*(-1.5), display.contentCenterY*0.07 
 	local hintButton = display.newText("hint", display.contentCenterX*(-1.5), display.contentCenterY*0.06)
 	hintButton.size = 30
 	hintButton:setFillColor(0.3)

 	function hintButton:tap( event )
 		composer.showOverlay('view08_schoolfood_setting')
 	end
 	hintButton:addEventListener("tap", hintButton)

  	local pick
 	local correct
 	local incorrect

 	----------2차시 event-------- 

  	local function dragCarrot( event )
 		if( event.phase == "began" ) then
 			display.getCurrentStage():setFocus( event.target )
 			event.target.isFocus = true
 			-- 드래그 시작할 때
 			event.target.initX = event.target.x
 			event.target.initY = event.target.y

 		elseif( event.phase == "moved" ) then

 			if ( event.target.isFocus ) then
 				-- 드래그 중일 때
			 	audio.play( pick )----------오디오 변경 
 				event.target.x = event.xStart + event.xDelta 
 				event.target.y = event.yStart + event.yDelta 
 			end

 		elseif ( event.phase == "ended" or event.phase == "cancelled") then
 			if ( event.target.isFocus ) then
 				display.getCurrentStage():setFocus( nil )
 				event.target.isFocus = false

 				-- 드래그 끝났을 때
 				if ( event.target.x > pan.x - 200 and event.target.x < pan.x + 200 --50 50 
 					and event.target.y > pan.y - 200 and event.target.y < pan.y + 200) then--- 50 50
 						if (event.target == food[1] or event.target == food[2] or event.target == food[5] or event.target == food[6] or event.target == food[9]) then
 							audio.play( correct )-----------오디오 변경 
							display.remove(event.target) -- 당근 삭제하기
 							score.text = score.text + 1 -- 점수 올리기

 							if(score.text == '5') then
 								score.text = '성공!'
 								time.alpha = 0
 								audio.pause(home)
								composer.removeScene("view07_schoolfood_game")--다현님
								composer.setVariable("score", 5)---다현님
								composer.gotoScene( "view09_schoolfood_view2" )---다현님 veiw2가 게임오버창 
 							end
 						else --싫어하는 음식일때는 제자리로
					 		audio.play( incorrect )-----오디오 변경 
 							event.target.x = event.target.initX
 							event.target.y = event.target.initY
 						end
 				else
 					event.target.x = event.target.initX
 					event.target.y = event.target.initY
 				end

 			else
 				display.getCurrentStage():setFocus( nil )
 				event.target.isFocus = false
 			end
 		end
 	end

 	for i = 1, 10 do
 		food[i]:addEventListener("touch", dragCarrot)
 	end --여기까지 

 	local function counter( event )
 		time.text = time.text - 1

 		if( time.text == '5' ) then
 			time:setFillColor(1, 0, 0)
 		end

 		if( time.text == '-1') then
 			time.alpha = 0

 			if( score.text ~= '성공!' ) then
 				score.text = '실패!'
 				audio.pause(home)
 				composer.removeScene("view07_schoolfood_game")---다현님코드 
				composer.setVariable("score", -1)---다현님 코드 
				composer.gotoScene("view09_schoolfood_view2")---다현님 코드 
 			
 				for i = 1, 10 do
 					if (food[i]) then
 						Runtime:removeEventListener("touch", dragCarrot)--오류해결 
 					end
 				end
 			end
 		end
	end

	pick = audio.loadSound( "soundEffect/pop.ogg" )--음식집을때  
        correct = audio.loadSound( "soundEffect/correct.wav" )--좋아하는 음식 잘 집어넣었을때 
        incorrect = audio.loadSound("soundEffect/incorrect.mp3") --싫어하는 음식 넣었을때 

 	-- by 지륜
	-- 게임 타이틀 클릭 시, 타이머 시작
 	--local timeAttack

 	local volumeButton = display.newImageRect("image/설정/설정.png", display.contentWidth/6.5, display.contentHeight/9.5)--50 50
    volumeButton.x,volumeButton.y = display.contentCenterX * 3.6, display.contentCenterY * 0.1 --3.56 0.09
   	
   	local options = {
        isModal = true
    }

    -- 2023.07.04 edit by jiruen // 샘플 볼륨 bgm
    local volumeBgm = audio.loadStream("soundEffect/263126_설정 클릭시 나오는 효과음(2).wav")


    --샘플볼륨함수--
    local function setVolume(event)
    	audio.play(volumeBgm)
        composer.showOverlay( "StopGame", options )
    end
    volumeButton:addEventListener("tap", setVolume)
	
	local musicOption = { 
    	loops = -1
	}

 	local function scriptremove(event)
 		audio.play(home, musicOption)
		section.alpha=0
		script.alpha=0
		timeAttack = timer.performWithDelay(1000, counter, 31, "gameTime")
		hintButton:addEventListener("tap", hintButton)
	end	

	local function titleremove(event)
		gametitle.alpha=0
		section.alpha=1
		script.alpha=1
		section:addEventListener("tap", scriptremove)
		display.remove(foodGameName)
	end

	gametitle:addEventListener("tap", titleremove)


	-----레이어 정리--깔리는 것부터 차례대로 
 	sceneGroup:insert(background)
 	sceneGroup:insert(pan)
 	sceneGroup:insert(foodGroup)
 	sceneGroup:insert(score)
 	sceneGroup:insert(time)
 	sceneGroup:insert(hintBbg)
 	sceneGroup:insert(hintButton)
 	sceneGroup:insert(volumeButton)

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

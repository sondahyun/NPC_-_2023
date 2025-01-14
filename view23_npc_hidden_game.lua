local composer = require( "composer" )
local scene = composer.newScene()
local loadsave = require( "loadsave" )

function scene:create( event )
	local sceneGroup = self.view

	local objectGroup = display.newGroup()

	local background = display.newImageRect("image/hidden/view03_background.jpg", display.contentWidth*3, display.contentHeight)
	background.x = display.contentCenterX
    background.y = display.contentCenterY

 	local npc = display.newImageRect("image/npc/npc1.png", display.contentWidth/1.5, display.contentHeight/3)
	npc.x, npc.y = display.contentWidth*0.85, display.contentHeight*0.8
	npc.xScale = -1

	local cat = display.newImageRect("image/npc/cat_back.png", display.contentWidth/2, display.contentHeight/2.5)
	cat.x, cat.y = display.contentWidth*0.4, display.contentHeight*0.88

	local speechbubble = display.newImageRect("image/npc/speechbubble.png", display.contentWidth, display.contentHeight/3.5)
	speechbubble.x, speechbubble.y = npc.x, npc.y-100

	speechbubble.alpha = 0

	local speechbubble_exmark = display.newImageRect("image/npc/speechbubble_exmark.png", display.contentWidth/2.5, display.contentHeight/3.5)
	speechbubble_exmark.x, speechbubble_exmark.y = npc.x, npc.y-120

	local speech = display.newText("", speechbubble.x, speechbubble.y-15, "font/DOSGothic.ttf")
	local accept = display.newText("", speechbubble.x, speechbubble.y - 60, "font/DOSGothic.ttf")

	local map = display.newImageRect("image/npc/map_goback.png", display.contentWidth/2.5, display.contentHeight/4)
	map.x, map.y = display.contentWidth*1.6, display.contentHeight*0.15

	local map_text = display.newText("맵 보기", map.x, map.y, "font/DOSGothic.ttf")
	map_text.size = 30
	
	local loadedSettings = loadsave.loadTable( "settings.json" )

	print("히든 게임 오픈")

	--성공플래그리셋
	if(loadedSettings.total_success % 5 == 0) then
		composer.setVariable("hiddengame_status", "renew")
	end

	--npc 말풍선 및 수락 텍스트
	local function talkWithNPC( event )
		speechbubble_exmark.alpha = 0
		speechbubble.alpha = 1
		speech.text = "힌트를 주자면..\n오늘의 날짜가 행운의 숫자야!"
		speech.size = 20
		speech:setFillColor(0)

		timer.performWithDelay( 1000, function() 
			accept.text = "말풍선을 눌러 수락하세요\n"
			accept.size = 20
			accept:setFillColor(1)
		end)
	end

	local function acceptQuest( event )
		--수락시 말풍선, 대화 사라짐
		speechbubble.alpha = 0
		speech.alpha = 0
		timer.performWithDelay( 500, function() 
			accept.alpha = 0
		end)

		--스크립트

		local section = display.newRect(display.contentWidth/2, display.contentHeight*0.9, display.contentWidth*3, display.contentWidth*0.9)
		section:setFillColor(0.35, 0.35, 0.35, 0.35)

		local script = display.newText("퀘스트를 수락했습니다.", section.x+30, section.y-100, "font/DOSGothic.ttf", 80)
		script.size = 30
		script:setFillColor(1)
		script.x, script.y = display.contentWidth/2, display.contentHeight*0.789

		objectGroup:insert(section)
		objectGroup:insert(script) 				

		--수락(말풍선)누르면 고양이가 말함
		local speechbubble2 = display.newImageRect("image/npc/speechbubble.png", display.contentWidth/1.5, display.contentHeight/7)
		speechbubble2.x, speechbubble2.y = cat.x, cat.y-100
		local speech2 = display.newText("날짜..! 잘 기억하자냥!\n", 
			speechbubble2.x, speechbubble2.y, "font/DOSGothic.ttf")
		speech2.size = 15
		speech2:setFillColor(0)
		--1초뒤 고양이 대화 사라짐
		timer.performWithDelay( 1000, function() 
			speechbubble2.alpha = 0
			speech2.alpha = 0
			composer.removeScene("view23_npc_hidden_game")
			composer.gotoScene("view23_hidden_game")
		end)
	end

	local function goBackToMap(event) 
		composer.gotoScene("view05_main_map")
	end

	if(composer.getVariable("hiddengame_status") == "success") then
		-- local tmp = composer.getVariable("can_cnt_global")
		-- composer.setVariable("can_cnt_global", tmp + 1)

		loadedSettings.openHiddenQuest = false
		loadedSettings.hiddenQuest_flag = false

		speechbubble_exmark.alpha = 0
		speech.alpha = 0
		accept.alpha = 0
		local speechbubble = display.newImageRect("image/npc/speechbubble.png", display.contentWidth/1.5, display.contentHeight/7)
		speechbubble.x, speechbubble.y = npc.x, npc.y-120
		local speech2 = display.newText("같이해서 재밌었어! ", 
			speechbubble.x, speechbubble.y-20, "font/DOSGothic.ttf")
		speech2.size = 15
		speech2:setFillColor(0)

		objectGroup:insert(speechbubble)
		objectGroup:insert(speech2)

		--npc 선물 / 고양이 선물 없을 경우
		local section = display.newRect(display.contentWidth/2, display.contentHeight*0.9, display.contentWidth*3, display.contentWidth*0.9)
		section:setFillColor(0.35, 0.35, 0.35, 0.35)

		local script = display.newText("히든 퀘스트를 완료하였습니다. \n 맵으로 돌아가세요 ", section.x+30, section.y-100, "font/DOSGothic.ttf", 80)
		script.size = 30
		script:setFillColor(1)
		script.x, script.y = display.contentWidth*0.2, display.contentHeight*0.789


		objectGroup:insert(section)
		objectGroup:insert(script)

		-- npc의선물/고양이 선물 있을 경우
		-- local present = display.newImageRect("image/goal.png", 100, 100)
 		-- present.x, present.y = npc.x-80, npc.y

 		-- local function presentTapEventListener(event)
 		-- 	present.alpha = 0

		-- 	local section = display.newRect(display.contentWidth/2, display.contentHeight*0.8, display.contentWidth, display.contentHeight*0.3)
		-- 	section:setFillColor(0.35, 0.35, 0.35, 0.35)

		-- 	local script = display.newText("퀘스트를 완료하였습니다. \n 맵으로 돌아가세요 ", section.x+30, section.y-100, "font/DOSGothic.ttf", 80)
		-- 	script.size = 30
		-- 	script:setFillColor(1)
		-- 	script.x, script.y = display.contentWidth/2, display.contentHeight*0.789

		-- 	objectGroup:insert(section)
		-- 	objectGroup:insert(script)
		-- end

		-- present:addEventListener("tap", presentTapEventListener)
		-- objectGroup:insert(present)
	end

	-- print(composer.getVariable("success"))


	speechbubble_exmark:addEventListener("tap", talkWithNPC)
	speechbubble:addEventListener("tap", acceptQuest)
	map:addEventListener("tap", goBackToMap)

	loadsave.saveTable(loadedSettings,"settings.json")

 	objectGroup:insert(npc)
 	objectGroup:insert(cat)
 	objectGroup:insert(speechbubble)
 	objectGroup:insert(speechbubble_exmark)
 	objectGroup:insert(speech)
 	objectGroup:insert(accept)
 	objectGroup:insert(map)
 	objectGroup:insert(map_text)

 	sceneGroup:insert(background)
 	sceneGroup:insert(objectGroup)

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
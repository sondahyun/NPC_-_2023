-----------------------------------------------------------------------------------------
--
-- pre_frontdoor with cop game
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local physics = require("physics")
local scene = composer.newScene()
local loadsave = require( "loadsave" )
local json = require( "json" )

function scene:create( event )
	local sceneGroup = self.view

	local objectGroup = display.newGroup()
	local scriptGroup = display.newGroup()


	local background = display.newImageRect("image/npc/place3.jpg", display.contentWidth, display.contentHeight)
 	background.x, background.y = display.contentWidth/2, display.contentHeight/2

 	local npc = display.newImageRect("image/npc/npc2.png", 200, 200)
	npc.x, npc.y = display.contentWidth*0.5, display.contentHeight*0.55
	npc.xScale = -1

	local cat = display.newImageRect("image/npc/cat_back.png", 200, 200)
	cat.x, cat.y = display.contentWidth*0.7, display.contentHeight*0.9
	cat.xScale = -1
	objectGroup:insert(cat)

	local speechbubble = display.newImageRect("image/npc/speechbubble.png", 300, 150)
	speechbubble.x, speechbubble.y = npc.x, npc.y - 150
	speechbubble.alpha = 0

	local speechbubble_exmark = display.newImageRect("image/npc/speechbubble_exmark.png", 150, 150)
	speechbubble_exmark.x, speechbubble_exmark.y = npc.x, display.contentHeight*0.35

	local speech = display.newText("", speechbubble.x, speechbubble.y-20, "font/DOSGothic.ttf")
	speech.size = 20
	speech:setFillColor(0)
	local accept = display.newText("", speechbubble.x, speechbubble.y - 60, "font/DOSGothic.ttf")

	local map = display.newImageRect("image/npc/map_goback.png", 150, 150)
	map.x, map.y = display.contentWidth*0.88, display.contentHeight*0.15

	local map_text = display.newText("맵 보기", map.x, map.y, "font/DOSGothic.ttf")
	map_text.size = 40


	--스크립트
	local section = display.newRect(display.contentWidth/2, display.contentHeight*0.8, display.contentWidth, display.contentHeight*0.3)
	section:setFillColor(0.35, 0.35, 0.35, 0.35)
	section.alpha = 0

	local script = display.newText("", display.contentWidth*0.2, display.contentHeight*0.789, "font/DOSGothic.ttf", 80)
	script.size = 30
	script:setFillColor(1)
	script.alpha = 0

	objectGroup:insert(section)
	objectGroup:insert(script) 

	--스크립트 속 선택지
	local gossip_click = display.newText("▼대화", display.contentWidth*0.15, display.contentHeight*0.8, "font/DOSGothic.ttf", 80)
	gossip_click.size = 30
	gossip_click:setFillColor(1)
	gossip_click.alpha = 0

	local game_click = display.newText("▼게임", display.contentWidth*0.15, display.contentHeight*0.88, "font/DOSGothic.ttf", 80)
	game_click.size = 30
	game_click:setFillColor(1)
	game_click.alpha = 0


	--게임 전체 변수(저장됨)
	local loadedSettings = loadsave.loadTable( "settings.json" )
	mainName = loadedSettings.name
	times = loadedSettings.talk[3]

	if(composer.getVariable("talk3_status") == "fin") then
		loadedSettings.talk[3] = 0 --0으로 초기화하기 위한 임시 코드
		loadedSettings.talk[3] = loadedSettings.talk[3] + 1
	end

	--오늘 완수한 게임 개수(4면 히든게임 등장)
	if(composer.getVariable("boongmake_status") == "success") then
		loadedSettings.today_success = loadedSettings.today_success + 1
	end

	local function acceptQuest( event )
		--수락시 말풍선, 대화 사라짐
		-- coin.alpha = 0
		scriptGroup.alpha = 0
		speechbubble.alpha = 0
		speech.alpha = 0
		accept.alpha = 0

		section.alpha = 1
		script.text = "퀘스트를 수락했습니다."
		script.alpha = 1			

		--수락(말풍선)누르면 고양이가 말함
		local speechbubble = display.newImageRect("image/npc/speechbubble.png", 200, 75)
		speechbubble.x, speechbubble.y = cat.x, cat.y-100
		local speech = display.newText("알았다냥!\n", speechbubble.x, speechbubble.y, "font/DOSGothic.ttf")
		speech.size = 20
		speech:setFillColor(0)

		objectGroup:insert(script)
		objectGroup:insert(speechbubble)
		objectGroup:insert(speech)

		--1초뒤 고양이 대화 사라짐
		timer.performWithDelay( 1000, function() 
			speechbubble.alpha = 0
			speech.alpha = 0
			composer.removeScene("view17_npc_boongmake_game")
			composer.gotoScene("view17_boongmake_game")
		end)
	end


	local function gossipOrGame(event)
		timer.performWithDelay( 1500, function() 
			scriptGroup.alpha = 1
			--스크립트
			local section = display.newRect(display.contentWidth/2, display.contentHeight*0.8, display.contentWidth, display.contentHeight*0.3)
			section:setFillColor(0.35, 0.35, 0.35, 0.35)

			local script = display.newText("어떤 것을 할까?", display.contentWidth*0.2, display.contentHeight*0.7, "font/DOSGothic.ttf", 80)
			script.size = 30
			script:setFillColor(1)

			gossip_click.alpha = 1
			game_click.alpha = 1

			objectGroup:insert(section)
			scriptGroup:insert(script)
			scriptGroup:insert(gossip_click)
			scriptGroup:insert(game_click)
			objectGroup:insert(scriptGroup)

			gossip_click:addEventListener("tap", function() --대화 클릭 시 페이지 이동
				if(composer.getVariable("talk3_status") == "fin") then
					script.text = "이미 대화를 끝냈습니다."
				else
					composer.removeScene("view17_npc_boongmake_game")
					composer.gotoScene("view17_talk_boongmake_game")
				end
			end)

			game_click:addEventListener("tap", function() 
				if(composer.getVariable("boongmake_status") == "success") then
					script.text = "이미 게임을 끝냈습니다."
				else 
					composer.removeScene("view17_npc_boongmake_game")
					composer.gotoScene("view17_boongmake_game")
				end
			end)
		end) --가상함수
	end 

	--npc 말풍선 및 수락 텍스트
	local function talkWithNPC( event )
		if(composer.getVariable("boongmake_status") == "success" and composer.getVariable("talk3_status") == "fin") then
			local section = display.newRect(display.contentWidth/2, display.contentHeight*0.8, display.contentWidth, display.contentHeight*0.3)
				section:setFillColor(0.35, 0.35, 0.35, 0.35)

			local script = display.newText("퀘스트를 완료하였습니다. ", display.contentWidth/2, display.contentHeight*0.789, "font/DOSGothic.ttf", 80)
				script.size = 30
				script:setFillColor(1)
			local scriptGroup = display.newGroup()

			scriptGroup:insert(section)
			scriptGroup:insert(script)
			objectGroup:insert(scriptGroup)

			section:addEventListener("tap", function() scriptGroup.alpha = 0 gossipOrGame() end)
		end

		speechbubble_exmark.alpha = 0
		speechbubble.alpha = 1
		speech.alpha = 1
		scriptGroup.alpha = 1

		if(composer.getVariable("boongmake_status") ~= "success") then			
			speech.text = "붕어빵 먹고싶다.."
		else
			speech.text = "노릇노릇하게 잘 됐다!\n너도 먹을래?"
		end
		speech.size = 20
		speech:setFillColor(0)

		if(composer.getVariable("boongmake_status") ~= "success" or composer.getVariable("talk3_status") ~= "fin") then
			gossipOrGame()
		end
	end

	--npc가 고양이에게 주는 선물 
	local gift = ''
	local giftFlag = 0
	if(composer.getVariable("boongmake_status") == "success" and giftFlag == 0) then
		giftFlag = 1

		speechbubble_exmark.alpha = 0
		speechbubble.alpha = 1
		speech.text = "고마워! 맛있겠다!\n너도 맛있는거 먹을래?"
		speech.alpha = 1
		speech:setFillColor(black)
		coin.alpha = 0

		gift = display.newImageRect("image/boong/붕어빵 완성.png", 100, 100)
 		gift.x, gift.y = npc.x-120, npc.y+10

 		objectGroup:insert(gift)
		gift:addEventListener("tap", function() gift.alpha = 0 speechbubble.alpha = 0 speech.alpha = 0 talkWithNPC() end)
	end


	local function goBackToMap(event) 
		composer.gotoScene("view05_main_map")
	end

	loadsave.saveTable(loadedSettings,"settings.json")

	speechbubble_exmark:addEventListener("tap", talkWithNPC)
	speechbubble:addEventListener("tap", acceptQuest)
	map:addEventListener("tap", goBackToMap)


 	objectGroup:insert(npc)
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
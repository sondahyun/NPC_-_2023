-----------------------------------------------------------------------------------------
--
-- view02_lost_stuId_game_over.lua -> 학생증 찾기 게임 후 종료된 화면입니다.
--
-----------------------------------------------------------------------------------------


local composer = require( "composer" )
local physics = require("physics")
local scene = composer.newScene()
local loadsave = require( "loadsave" )
local json = require( "json" )

function scene:create( event )
	local sceneGroup = self.view

	local loadedEndings = loadsave.loadTable( "endings.json" )
	local loadedSettings = loadsave.loadTable( "settings.json" )


	local background = display.newImageRect("image/lost_stuId/background.png", display.contentWidth*3, display.contentHeight)
	background.x = display.contentWidth/2
    background.y = display.contentHeight/2
	sceneGroup:insert(background)

	local background1 = display.newRect(display.contentWidth/2, display.contentHeight/2, display.contentWidth*3, display.contentHeight)
	
	background1:setFillColor(0)
	transition.to(background1,{alpha=0.5,time=1000}) -- 배경 어둡게
	sceneGroup:insert(background1)

	local result1 = composer.getVariable("result")
	-- local score3 = composer.getVariable("score")

	-- 2023.06.30 edit by jiruen // 게임 성공 & 실패 bgm
	local clearBgm = audio.loadStream("soundEffect/242855_게임 성공 시 효과음.ogg")
	local failBgm = audio.loadStream("soundEffect/253886_게임 실패 시 나오는 효과음.wav")


	local function backtogame(event) --실패할 경우 다시 게임으로 돌아가기
		if event.phase == "began" then
			composer.removeScene("view12_lost_stuId_game_over")
			composer.gotoScene("view11_lost_stuId_game_final")
		end
	end

	--close 버튼
	local clear_close = display.newImageRect("image/lost_stuId/확인,힌트 버튼.png", 768/5, 768/5)
	clear_close.x, clear_close.y = display.contentWidth/2, display.contentHeight*0.755
	clear_close.alpha = 0

	local clear_closeScript = display.newText("돌아가기", 0, 0, "ttf/font.ttf", 25)
	clear_closeScript:setFillColor(1)
	clear_closeScript.x, clear_closeScript.y=display.contentWidth/2, display.contentHeight*0.75
	clear_closeScript.alpha = 0

	
	local fail_close = display.newImageRect("image/lost_stuId/확인,힌트 버튼.png", 768/4, 768/4)
	fail_close:setFillColor(1)
	fail_close.x, fail_close.y=display.contentWidth/2, display.contentHeight*0.75
	fail_close.alpha = 0

	local fail_closeScript = display.newText("다시하기", 0, 0, "ttf/font.ttf", 28)
	fail_closeScript:setFillColor(1)
	fail_closeScript.x, fail_closeScript.y=display.contentWidth/2, display.contentHeight*0.74
	fail_closeScript.alpha = 0

	
	
	local function gomap(event) -- 게임 pass 후 넘어감
		if event.phase == "began" then--view20ring
			-- local bgMusic = audio.loadStream( "soundEffect/게임 성공.wav" )
		    -- audio.play(clearBgm)
		    -- audio.setVolume( 0.5 )

			loadedSettings.money = loadedSettings.money + 3
			composer.setVariable("successLost", "success")
			composer.removeScene("view12_lost_stuId_game_over")
			audio.stop()
			
			loadedSettings.total_success = loadedSettings.total_success + 1
			loadedSettings.total_success_names[loadedSettings.total_success] = "학생증 찾기"
			loadsave.saveTable(loadedSettings,"settings.json")

			composer.setVariable("stuId_status", "success")
			composer.gotoScene( "view10_npc_lost_stuId_game" )
		end
	end

	local backtomap =display.newImageRect("image/custom/cat_twinkle.png", 512/3, 512/3)--성공할 경우
	backtomap.x, backtomap.y = display.contentWidth/2, display.contentHeight/2
	backtomap.alpha = 0
	sceneGroup:insert(backtomap)

	local backtomap_text = display.newText("성공!", backtomap.x, backtomap.y - 300, "font/DOSGothic.ttf")
	backtomap_text:setFillColor(1)
	backtomap_text.size = 60
	sceneGroup:insert(backtomap_text)

	local backgame =display.newImageRect("image/lost_stuId/우는고ㅇ앵.png", 512/3, 512/3) --실패할 경우
	backgame.x, backgame.y = display.contentWidth/2, display.contentHeight/2
	backgame.alpha = 0
	sceneGroup:insert(backgame)


	print("result: ")
	print(result1)
	if result1 == 0 then
		backgame.alpha = 1
		backtomap_text.alpha=0
		fail_close.alpha = 1
		fail_closeScript.alpha = 1
		audio.play(failBgm) 
		fail_close:addEventListener("touch",backtogame)
	else
		backtomap.alpha = 1
		clear_close.alpha = 1
		clear_closeScript.alpha = 1
		backtomap_text.alpha = 1
		-- local bgMusic = audio.loadStream( "soundEffect/게임 성공.wav" )
	    -- audio.play(bgMusic)
	    -- audio.setVolume( 0.5 )
	    audio.play(clearBgm)
		clear_close:addEventListener("touch",gomap)

	end
	sceneGroup:insert(fail_close)
	sceneGroup:insert(clear_close)

	sceneGroup:insert(clear_closeScript)
	sceneGroup:insert(fail_closeScript)


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
		composer.removeScene("view12_lost_stuId_game_over")
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
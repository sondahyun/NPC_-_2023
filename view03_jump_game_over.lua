--fallgame 통과하는 게임 종료된 화면

local composer = require( "composer" )
local physics = require("physics")
local scene = composer.newScene()
local loadsave = require( "loadsave" )
local json = require( "json" )

function scene:create( event )
	local sceneGroup = self.view

	local loadedEndings = loadsave.loadTable( "endings.json" )
	local loadedSettings = loadsave.loadTable( "settings.json" )

	
	local background = display.newImageRect("image/jump/background_water.png", display.contentWidth*3, display.contentHeight)
	background.x = display.contentCenterX
    background.y = display.contentCenterY
	sceneGroup:insert(background)

	local background1 = display.newRect(display.contentCenterX, display.contentCenterY, background.width, background.height)	background1:setFillColor(0)
	transition.to(background1,{alpha=0.5,time=1000}) -- 배경 어둡게
	sceneGroup:insert(background1)

	--[[local board =display.newImageRect("이미지/미니게임/미니게임_게임완료창.png",display.contentWidth/3.6294896, display.contentHeight/2.83122739)
	board.x , board.y = display.contentWidth/2, display.contentHeight/2
	board.alpha = 0.5
	transition.to(board,{alpha=1,time=1000})
	sceneGroup:insert(board)]]

	local score1 = composer.getVariable("score1")
	score1 = -1
	-- 2023.07.04 edit by jiruen // 게임 성공 & 실패 bgm 추
	local clearBgm = audio.loadStream("soundEffect/242855_게임 성공 시 효과음.ogg")
	local failBgm = audio.loadStream("soundEffect/253886_게임 실패 시 나오는 효과음.wav")

	local function backtogame(event) --실패할 경우 다시 게임으로 돌아가기
		composer.removeScene("view03_jump_game_over")
		composer.gotoScene("view03_jump_game")
	end
	--close 버튼
	local close = display.newImageRect("image/jump/닫기.png", display.contentWidth/7, display.contentHeight/11)
	close.x, close.y = display.contentCenterX*3.7, display.contentCenterY*0.2
	close.alpha = 0

	local function gomap1(event) -- 게임 pass 후 넘어감
		loadedSettings.money = loadedSettings.money + 3
		composer.setVariable("jumpgame_status", "success")
		composer.setVariable("successJump", "success")
		composer.setVariable("successHiddenGame", "success")
		loadedSettings.total_success = loadedSettings.total_success + 1
		loadedSettings.total_success_names[loadedSettings.total_success] = "고양이 점프해서 츄르 찾기"
		loadsave.saveTable(loadedSettings,"settings.json")

		composer.removeScene("view03_jump_game_over")
		composer.gotoScene("view03_npc_jump_game")
	end

	local function gomap2(event) -- 게임 fail 후 넘어감
		composer.removeScene("view03_jump_game_over")
		composer.gotoScene("view05_main_map") --npc로
	end

	local backgame1 =display.newImageRect("image/jump/클리어창.png", display.contentWidth/1.1, display.contentHeight/1.6) --성공할 경우
	backgame1.x, backgame1.y = display.contentCenterX, display.contentCenterY
	backgame1.alpha = 0
	sceneGroup:insert(backgame1)

	local backgame2 =display.newImageRect("image/jump/실패창.png", display.contentWidth/1.1, display.contentHeight/1.6) --실패할 경우
	backgame2.x, backgame2.y = display.contentCenterX, display.contentCenterY
	backgame2.alpha = 0
	sceneGroup:insert(backgame2)

	local lastText = display.newText("게임을 다시 시작하려면 고양이를 클릭하세요!", display.contentCenterX, display.contentCenterY*0.25)
	lastText.size = 30
	lastText.alpha = 0

	if (score1 == -1) then --score1이 -1일 때 fail
		backgame2.alpha = 1
		close.alpha = 1
		lastText.alpha = 1
		-- 2023.07.04 edit by jiruen // 게임 실패 bgm 추가
		audio.play(failBgm) 
		close:addEventListener("tap", gomap2)
		backgame2:addEventListener("tap",backtogame)
	elseif(score1 == 1) then--score1이 1일 때 sucess
		backgame1.alpha = 1
		close.alpha = 1
		-- 2023.07.04 edit by jiruen // 게임 성공 bgm 추가
		audio.play(clearBgm)
		close:addEventListener("tap", gomap1)
	end

	sceneGroup:insert(close)
	sceneGroup:insert(lastText)

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
		composer.removeScene("view03_jump_game_over")
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



local composer = require( "composer" )
local physics = require("physics")
local scene = composer.newScene()
local loadsave = require( "loadsave" )
local json = require( "json" )

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

-- highscores.lua 엔딩화면 (성공하거나 실패했을때 나오는 화면 ) 성공일경우 버튼누르면 -> 메인화면으로 이동, 실패하면 -> 첫 play 화면으로 이동  

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen

    -- Load the previous scores
	
	local loadedEndings = loadsave.loadTable( "endings.json" )
	local loadedSettings = loadsave.loadTable( "settings.json" )

	local background = display.newImageRect("image/frontgate/gate.jpg", 960, 640) --엔딩화면 배경
	background.x = display.contentCenterX
    background.y = display.contentCenterY
	sceneGroup:insert(background)

	local background1 = display.newRect(display.contentWidth/2, display.contentHeight/2, 1280, 720) --display.contentWidth, display.contentHeight
	
	local objectGroup = display.newGroup()

	-- 2023.07.04 edit by jiruen // 게임 성공 & 실패 bgm 추가
	local clearBgm = audio.loadStream("soundEffect/242855_게임 성공 시 효과음.ogg")
	local failBgm = audio.loadStream("soundEffect/253886_게임 실패 시 나오는 효과음.wav")

	background1:setFillColor(0)
	transition.to(background1,{alpha=0.5,time=1000}) --배경 어둡게
	sceneGroup:insert(background1)

	local score3 = composer.getVariable("score")

	local function backtogame(event) --실패할 경우 다시 게임으로 돌아가기
		if event.phase == "began" then 
				composer.removeScene("view18_highscores_frontgate_game")
				composer.gotoScene("view18_menu_frontgate_game")--시작화면으로 
		end
	end

	--close 버튼
	local clear_close = display.newImageRect("image/frontgate/exit.png", 150, 150)--나가기 버튼 
	clear_close.x, clear_close.y = 900, 500  
	clear_close.alpha = 0
	

	local fail_close = display.newImageRect("image/frontgate/retry.png", 150, 150)--다시하기 버튼 
	fail_close.x, fail_close.y = 900, 500 
	fail_close.alpha = 0
	
	
	local function backtomap(event) -- 게임 pass 후 메인화면(맵)으로 넘어가기 
		if event.phase == "began" then
			composer.setVariable("successFront", "success")
			composer.setVariable("frontgate_status", "success")

			loadedSettings.money = loadedSettings.money + 3

			loadedSettings.total_success = loadedSettings.total_success + 1
			loadedSettings.total_success_names[loadedSettings.total_success] = "정문 지키기"
			loadsave.saveTable(loadedSettings,"settings.json")

			composer.removeScene("view18_highscores_frontgate_game")
			composer.gotoScene( "view18_npc_frontgate_game" )
		end
	end

	local backmap = display.newImage("image/custom/cat_twinkle.png") --성공할 경우
	backmap.x, backmap.y = display.contentWidth/2, display.contentHeight/2
	backmap.alpha = 0


	objectGroup:insert(backmap)
	
	

	local backgame = display.newImage("image/custom/cat_tear.png") --실패할 경우
	backgame.x, backgame.y = display.contentWidth/2, display.contentHeight/2
	backgame.alpha = 0

	objectGroup:insert(backgame)
	sceneGroup:insert(objectGroup)

	if score3 < 0 then
		backgame.alpha = 1
		fail_close.alpha = 1
		-- 2023.07.04 edit by jiruen // 게임 실패 bgm 추가
		audio.play(failBgm) 
		fail_close:addEventListener("touch", backtogame)--실패 
	else
		backmap.alpha = 1
		clear_close.alpha = 1
		-- 2023.07.04 edit by jiruen // 게임 성공 bgm 추가
		audio.play(clearBgm)
		clear_close:addEventListener("touch", backtomap)--성공 
	end
	sceneGroup:insert(fail_close)
	sceneGroup:insert(clear_close)

end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen

	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
		composer.removeScene( "view18_highscores_frontgate_game" )
	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view

end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene

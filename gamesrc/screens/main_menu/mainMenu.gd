extends Node2D
# Main Menu Script
var index = 0
var chapter_index = 0
onready var selectedNode = get_node("multiple_choice/chapter_select")
onready var leaderBoardNode = get_node("leaderboard")
onready var loginNode = get_node("login")
onready var newUserNode = get_node("create_new_user")
onready var passwordNode = get_node("chapter_password")
onready var chapterNode =  get_node("multiple_choice")
onready var alertNode = get_node("control_alerts")
var chapterSelectStartPos 
var chapterSelected = 0
var passwordEntered = false
var incorrectPassword = false
var passwordArray = [0,0,"hello",2,3,4,5,6,7,8,9,10,11] # passwords start at index 2

var time_delta = 0
var up = false
var down = false

func _ready():
	set_process_input(true)
	set_fixed_process(true)
	#Play the sound this also can be replaced by simply setting the autoplay property to true.
	#get_node("StreamPlayer").play()
	#Set window title
	get_node("multiple_choice").set_hidden(true)
	
	#SKIP LOGIN
	singleton.logged_in = true
	
	OS.set_window_title("Hope4Haiti")
	leaderBoardNode.set_hidden(true)
	if singleton.logged_in:
		loginNode.set_hidden(true)
	else:
		loginNode.set_hidden(false)
	newUserNode.set_hidden(true)
	#newUserNode.get_node("usernameEdit").set_cursor_pos(0)
	chapterSelectStartPos = get_node("multiple_choice/chapter_select").get_pos()
	#get_node("multiple_choice/chapter2").set_opacity(0.2)
	#Hide mouse.
	#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _unhandled_key_input(key_event):
	if key_event.is_action_pressed("ui_down"):
		down = true
	elif key_event.is_action_released("ui_down"):
		down = false
	if key_event.is_action_pressed("ui_up"):
		up = true
	elif key_event.is_action_released("ui_up"):
		up = false

func _input(event):
	#Login info probably not using anymore
#	if loginNode.is_visible():
#		if loginNode.get_node("button_enter").is_pressed():
#			if loginNode.get_node("usernameEdit").get_text() != "" and loginNode.get_node("passwordedit").get_text() != "":
#				loginNode.set_hidden(true)
#				singleton.logged_in = true
#		if loginNode.get_node("create_new_account").is_pressed():
#			loginNode.set_hidden(true)
#			newUserNode.set_hidden(false)
#		
#	if newUserNode.is_visible():
#		if newUserNode.get_node("button_enter").is_pressed():
#			if newUserNode.get_node("usernameEdit").get_text() != "" and newUserNode.get_node("passwordedit1").get_text() == newUserNode.get_node("passwordedit").get_text():
#				leaderBoardNode.get_node("player3").set_text(newUserNode.get_node("usernameEdit").get_text())
#				leaderBoardNode.get_node("score_label3").set_text("0")
#				newUserNode.set_hidden(true)
#		elif newUserNode.get_node("return").is_pressed():
#			loginNode.set_hidden(false)
#			newUserNode.set_hidden(true)
		
	if !chapterNode.is_visible() and !passwordNode.is_visible():
		if event.is_action("ui_up") && event.is_pressed() && !event.is_echo():
			if(index != 0):
				index -= 1
				var x = get_node("Selected").get_pos().x
				var y = get_node("Selected").get_pos().y - 75 #75 is hard coded distance between labels
				get_node("Selected").set_pos(Vector2(x,y))
		if event.is_action("ui_down") && event.is_pressed() && !event.is_echo():
			if(index != 2):
				index += 1
				var x = get_node("Selected").get_pos().x
				var y = get_node("Selected").get_pos().y + 75
				get_node("Selected").set_pos(Vector2(x,y))
		if event.is_action("ui_accept") && event.is_pressed() && !event.is_echo():
			if (index == 0): #chapters
				chapterNode.show()
			if (index == 1): # leaderboard
				print("Options")
			if (index == 2):
				OS.get_main_loop().quit()
				
	elif chapterNode.is_visible():
		if passwordNode.is_visible():
			chapterNode.set_hidden(true)
		if event.is_action("ui_up") && event.is_pressed() && !event.is_echo():
			if chapter_index == 0:
				selectedNode.set_pos(Vector2(selectedNode.get_pos().x, selectedNode.get_pos().y + (84 * 12)))
				chapter_index = 12
			else:
				selectedNode.set_pos(Vector2(selectedNode.get_pos().x, selectedNode.get_pos().y - 84))
				chapter_index -= 1

		if event.is_action("ui_down") && event.is_pressed() && !event.is_echo():
			if chapter_index == 12:
				chapter_index = 0
				selectedNode.set_pos(chapterSelectStartPos)
			else:
				selectedNode.set_pos(Vector2(selectedNode.get_pos().x, selectedNode.get_pos().y + 84))
				chapter_index += 1
		if event.is_action("ui_accept") && event.is_pressed() && !event.is_echo():
			if (chapter_index == 0):
				chapterSelected = 1
				get_tree().change_scene("res://chapters/chapter_01/inside_world.tscn")
			if (chapter_index == 1):
				chapterSelected = 2
				passwordNode.set_hidden(false)
				chapterNode.set_hidden(true)
			if (chapter_index == 2):
				chapterSelected = 3
				passwordNode.set_hidden(false)
				chapterNode.set_hidden(true)
				print("option3")
			if(chapter_index == 3):
				chapterSelected = 4
				passwordNode.set_hidden(false)
				chapterNode.set_hidden(true)
				print("option4")
			if(chapter_index== 4):
				chapterSelected = 5
				passwordNode.set_hidden(false)
				chapterNode.set_hidden(true)
				print("option5")
			if(chapter_index== 5):
				chapterSelected = 6
				passwordNode.set_hidden(false)
				chapterNode.set_hidden(true)
				print("option6")
			if(chapter_index== 6):
				chapterSelected = 7
				passwordNode.set_hidden(false)
				chapterNode.set_hidden(true)
				print("option7")
			if(chapter_index== 7):
				chapterSelected = 8
				passwordNode.set_hidden(false)
				chapterNode.set_hidden(true)
				print("option8")
			if(chapter_index== 8):
				chapterSelected = 9
				passwordNode.set_hidden(false)
				chapterNode.set_hidden(true)
				print("option9")
			if(chapter_index == 9):
				chapterSelected = 10
				passwordNode.set_hidden(false)
				chapterNode.set_hidden(true)
				print("option10")
			if(chapter_index == 10):
				chapterSelected = 11
				passwordNode.set_hidden(false)
				chapterNode.set_hidden(true)
				print("option11")
			if(chapter_index == 11):
				chapterSelected = 12
				passwordNode.set_hidden(false)
				chapterNode.set_hidden(true)
				print("option12")
			if (chapter_index == 12):
				get_node("multiple_choice/chapter_select").set_pos(chapterSelectStartPos)
				chapter_index = 0
				get_node("multiple_choice").hide()
	elif passwordNode.is_visible():
		if passwordNode.get_node("back").is_pressed():
			passwordNode.set_hidden(true)
			chapterNode.set_hidden(false)
		if passwordNode.get_node("passwordedit").get_text() != "" and passwordNode.get_node("button_enter").is_pressed() and !passwordEntered:
			passwordEntered = true
			_handle_password_input(passwordNode.get_node("passwordedit").get_text())
	
	if incorrectPassword and !alertNode.is_visible():
		incorrectPassword = false
		passwordNode.set_hidden(false)
		
#	elif leaderBoardNode.is_visible():
#		if event.is_action("ui_accept") && event.is_pressed() && !event.is_echo():
#			leaderBoardNode.set_hidden(true)
func _handle_password_input(password):
	if password == str(passwordArray[chapterSelected]):
		if chapterSelected == 2:
			get_tree().change_scene("res://chapters/chapter_02/outside_world_nouns.tscn")
		elif chapterSelected == 3:
			get_tree().change_scene("res://chapters/chapter_03/ch3_outside_possesive_noun.tscn")
	else:
		alertNode.set_hidden(false)
		passwordNode.get_node("passwordedit").set_text("")
		incorrectPassword = true
		passwordEntered = false
		
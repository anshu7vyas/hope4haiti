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
onready var controlsNode = get_node("control_layout")

var chapterSelectStartPos 
var chapterSelected = 0
var passwordEntered = false
var incorrectPassword = false

var passwordArray = [
0, #index0
0, #index1
"kNHzuS", #chapter2 index2
"Ye53We", #chapter3 index3
"Qba3yL", #chapter4 index4
"WGYgFY", #chapter5 index5
"meA2gR", #chapter6 index6
"RdEJJM", #chapter7 index7
"qQdgrj", #chapter8 index8
"xhJdm6", #chapter9 index9
"Rvu9m7", #chapter10 index10
"NVYV5r", #chapter11 index11
"t9z8bH"  #chapter12 index12
] # passwords start at index 2

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
	controlsNode.set_hidden(true)
	
	#SKIP LOGIN
	singleton.logged_in = true
	
	OS.set_window_title("Les Aventures de Marie-Thérèse")
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
		
	if !chapterNode.is_visible() and !passwordNode.is_visible() and !controlsNode.is_visible():
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
			if (index == 1):
				controlsNode.set_hidden(false)
			if (index == 2):
				OS.get_main_loop().quit()
				
	elif chapterNode.is_visible():
		if passwordNode.is_visible():
			chapterNode.set_hidden(true)
		if event.is_action("ui_up") && event.is_pressed() && !event.is_echo():
			if chapter_index == 0:
				selectedNode.set_pos(Vector2(selectedNode.get_pos().x, selectedNode.get_pos().y + (84 * 11)))
				chapter_index = 11
			else:
				selectedNode.set_pos(Vector2(selectedNode.get_pos().x, selectedNode.get_pos().y - 84))
				chapter_index -= 1

		if event.is_action("ui_down") && event.is_pressed() && !event.is_echo():
			if chapter_index == 11:
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
			if (chapter_index == 11):
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
	
	elif controlsNode.is_visible():
		if controlsNode.get_node("back1").is_pressed():
			controlsNode.set_hidden(true)
		if event.is_action("ui_accept") && event.is_pressed() && !event.is_echo():
			controlsNode.set_hidden(true)
	
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
		elif chapterSelected == 4:
			get_tree().change_scene("res://chapters/chapter_04/inside_world_pronouns.tscn")
		elif chapterSelected == 5:
			get_tree().change_scene("res://chapters/chapter_05/ch5_classroom_world.tscn")
		elif chapterSelected == 6:
			get_tree().change_scene("res://chapters/chapter_06/ch6_inside_world.tscn")
		elif chapterSelected == 7:
			get_tree().change_scene("res://chapters/chapter_07/ch7_inside_world_verbs.tscn")
		elif chapterSelected == 8:
			get_tree().change_scene("res://chapters/chapter_08/ch_8outside_world_prepasitions.tscn")
		elif chapterSelected == 9:
			get_tree().change_scene("res://chapters/chapter_09/ch9_inside_world_adverbs.tscn")
		elif chapterSelected == 10:
			get_tree().change_scene("res://chapters/chapter_10/ch10_soccer_world.tscn")
		elif chapterSelected == 11:
			get_tree().change_scene("res://chapters/chapter_11/ch11_inside_world_tenses.tscn")
	else:
		alertNode.set_hidden(false)
		passwordNode.get_node("passwordedit").set_text("")
		incorrectPassword = true
		passwordEntered = false
		
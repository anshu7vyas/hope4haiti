extends Node2D
# Main Menu Script
var index = 0
var chapter_index = 0
onready var selectedNode = get_node("multiple_choice/chapter_select")
onready var leaderBoardNode = get_node("leaderboard")
onready var loginNode = get_node("login")
onready var newUserNode = get_node("create_new_user")
var chapter_select_start

var time_delta = 0


func _ready():
	set_process_input(true)
	set_fixed_process(true)
	#Play the sound this also can be replaced by simply setting the autoplay property to true.
	#get_node("StreamPlayer").play()
	#Set window title
	OS.set_window_title("Hope4Haiti")
	leaderBoardNode.set_hidden(true)
	loginNode.set_hidden(false)
	newUserNode.set_hidden(true)
	#newUserNode.get_node("usernameEdit").set_cursor_pos(0)
	chapter_select_start = get_node("multiple_choice/chapter_select").get_pos()
	get_node("multiple_choice/chapter2").set_opacity(0.2)
	get_node("multiple_choice/chapter3").set_opacity(0.2)
	get_node("multiple_choice/chapter4").set_opacity(0.2)
	get_node("multiple_choice/chapter5").set_opacity(0.2)
	get_node("multiple_choice/chapter6").set_opacity(0.2)
	get_node("multiple_choice/chapter7").set_opacity(0.2)
	get_node("multiple_choice/chapter8").set_opacity(0.2)
	#get_node("multiple_choice/RichTextLabel").append_bbcode("[center]Les chapitres sont divisés par les parties du discours[/center]")
	#Hide mouse.
	#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _input(event):
	if loginNode.get_node("button_enter").is_pressed():
		if loginNode.get_node("usernameEdit").get_text() != "" and loginNode.get_node("passwordedit").get_text() != "":
			loginNode.set_hidden(true)
	if loginNode.get_node("create_new_account").is_pressed():
		loginNode.set_hidden(true)
		newUserNode.set_hidden(false)
		
	if newUserNode.is_visible():
		if newUserNode.get_node("button_enter").is_pressed():
			if newUserNode.get_node("usernameEdit").get_text() != "" and newUserNode.get_node("passwordedit1").get_text() == newUserNode.get_node("passwordedit").get_text():
				leaderBoardNode.get_node("player3").set_text(newUserNode.get_node("usernameEdit").get_text())
				leaderBoardNode.get_node("score_label3").set_text("0")
				newUserNode.set_hidden(true)
		elif newUserNode.get_node("return").is_pressed():
			loginNode.set_hidden(false)
			newUserNode.set_hidden(true)
				
	if (event.type==InputEvent.MOUSE_BUTTON):
		print("Mouse Click/Unclick at: ",event.pos)
		
	if !get_node("multiple_choice").is_visible() and !leaderBoardNode.is_visible() and !loginNode.is_visible() and !newUserNode.is_visible():
		if event.is_action("ui_up") && event.is_pressed() && !event.is_echo():
			if(index != 0):
				index -= 1
				var x = get_node("Selected").get_pos().x
				var y = get_node("Selected").get_pos().y - 69 #75 is hard coded distance between labels
				get_node("Selected").set_pos(Vector2(x,y))
		if event.is_action("ui_down") && event.is_pressed() && !event.is_echo():
			if(index != 3):
				index += 1
				var x = get_node("Selected").get_pos().x
				var y = get_node("Selected").get_pos().y + 69
				get_node("Selected").set_pos(Vector2(x,y))
		if event.is_action("ui_accept") && event.is_pressed() && !event.is_echo():
			if (index == 0): #chapters
				get_node("multiple_choice").show()
			if (index == 1): # leaderboard
				leaderBoardNode.set_hidden(false)
				print("leaderboard")
			if (index == 2):
				print("Options")
			if(index == 3):
				OS.get_main_loop().quit()
	elif get_node("multiple_choice").is_visible():
		if event.is_action("ui_up") && event.is_pressed() && !event.is_echo():
			if(chapter_index != 0):
				chapter_index -= 1
				var x = selectedNode.get_pos().x
				var y = selectedNode.get_pos().y - 96 #69 is hard coded distance between labels
				selectedNode.set_pos(Vector2(x,y))
		if event.is_action("ui_down") && event.is_pressed() && !event.is_echo():
			if(chapter_index != 8):
				chapter_index += 1
				var x = selectedNode.get_pos().x
				var y = selectedNode.get_pos().y + 96
				selectedNode.set_pos(Vector2(x,y))
		if event.is_action("ui_accept") && event.is_pressed() && !event.is_echo():
			if (chapter_index == 0):
				get_tree().change_scene("res://chapters/chapter_01/inside_world.tscn")
				print("option1")
			if (chapter_index == 1):
				print("option2")
			if (chapter_index == 2):
				print("option3")
			if(chapter_index == 3):
				print("option4")
			if(chapter_index== 4):
				print("option5")
			if(chapter_index== 5):
				print("option6")
			if(chapter_index== 6):
				print("option7")
			if(chapter_index== 7):
				print("option8")
			if(chapter_index== 8):
				get_node("multiple_choice/chapter_select").set_pos(chapter_select_start)
				chapter_index = 0
				get_node("multiple_choice").hide()
				print("option9 back")
	elif leaderBoardNode.is_visible():
		if event.is_action("ui_accept") && event.is_pressed() && !event.is_echo():
			leaderBoardNode.set_hidden(true)


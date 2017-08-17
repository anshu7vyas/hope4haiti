extends Node2D
# Main Menu Script
var index = 0
var chapter_index = 0
onready var selectedNode = get_node("multiple_choice/chapter_select")
var chapter_select_start


func _ready():
	set_process_input(true)
	set_fixed_process(true)
	#Play the sound this also can be replaced by simply setting the autoplay property to true.
	#get_node("StreamPlayer").play()
	#Set window title
	OS.set_window_title("Hope4Haiti")
	chapter_select_start = get_node("multiple_choice/chapter_select").get_pos()
	#get_node("multiple_choice/RichTextLabel").append_bbcode("[center]Les chapitres sont divisés par les parties du discours[/center]")
	#Hide mouse.
	#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _input(event):
	if !get_node("multiple_choice").is_visible():
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
			if (index == 0):
				get_node("multiple_choice").show()
			if (index == 1):
				get_tree().change_scene("res://chapters/chapter_01/inside_world.tscn")
				print("New Game")
			if (index == 2):
				print("Options")
			if(index == 3):
				OS.get_main_loop().quit()
	else:
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

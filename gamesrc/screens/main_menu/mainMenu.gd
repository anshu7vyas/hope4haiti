extends Node2D
# Main Menu Script
var index = 0
func _ready():
	set_process_input(true)
	set_fixed_process(true)
	#Play the sound this also can be replaced by simply setting the autoplay property to true.
	#get_node("StreamPlayer").play()
	#Set window title
	OS.set_window_title("Hope4Haiti")
	#Hide mouse.
	#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _input(event):
	if event.is_action("ui_up") && event.is_pressed() && !event.is_echo():
		if(index != 0):
			index -= 1
			var x = get_node("Selected").get_pos().x
			var y = get_node("Selected").get_pos().y - 69 #69 is hard coded distance between labels
			get_node("Selected").set_pos(Vector2(x,y))
	if event.is_action("ui_down") && event.is_pressed() && !event.is_echo():
		if(index != 3):
			index += 1
			var x = get_node("Selected").get_pos().x
			var y = get_node("Selected").get_pos().y + 69
			get_node("Selected").set_pos(Vector2(x,y))
	if event.is_action("ui_accept") && event.is_pressed() && !event.is_echo():
		if (index == 0):
			get_tree().change_scene("res://chapters/chapter_01/inside_world.tscn")
		if (index == 1):
			print("New Game")
		if (index == 2):
			print("Options")
		if(index == 3):
			OS.get_main_loop().quit()

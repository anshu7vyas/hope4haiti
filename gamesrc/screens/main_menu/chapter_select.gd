extends PopupDialog
# main menu chapter select

var index = 0
onready var selectedNode = get_node("chapter_select")
func _ready():
	set_process_input(true)
	set_fixed_process(true)

func _input(event):
	if self.is_visible():
		if event.is_action("ui_up") && event.is_pressed() && !event.is_echo():
			if(index != 0):
				index -= 1
				var x = selectedNode.get_pos().x
				var y = selectedNode.get_pos().y - 96 #69 is hard coded distance between labels
				selectedNode.set_pos(Vector2(x,y))
		if event.is_action("ui_down") && event.is_pressed() && !event.is_echo():
			if(index != 8):
				index += 1
				var x = selectedNode.get_pos().x
				var y = selectedNode.get_pos().y + 96
				selectedNode.set_pos(Vector2(x,y))
		if event.is_action("ui_accept") && event.is_pressed() && !event.is_echo():
			if (index == 0):
				print("option1")
			if (index == 1):
				print("option2")
			if (index == 2):
				print("option3")
			if(index == 3):
				print("option4")
			if(index== 4):
				print("option5")
			if(index== 5):
				print("option6")
			if(index== 6):
				print("option7")
			if(index== 7):
				print("option8")
			if(index== 8):
				self.queue_free()
				print("option9 back")



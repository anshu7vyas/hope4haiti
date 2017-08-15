extends PopupDialog

onready var pointerNode = get_node("pointer")
var index = 0

func _ready():
	set_process_input(true)
	set_fixed_process(true)


func _input(event):
	if event.is_action("ui_up") && event.is_pressed() && !event.is_echo():
		if(index != 0):
			index -= 1
			get_node("pointer")
			var x = pointerNode.get_pos().x
			var y = pointerNode.get_pos().y - 25 #69 is hard coded distance between labels
			pointerNode.set_pos(Vector2(x,y))
	if event.is_action("ui_down") && event.is_pressed() && !event.is_echo():
		if(index != 2):
			index += 1
			var x = pointerNode.get_pos().x
			var y = pointerNode.get_pos().y + 25
			pointerNode.set_pos(Vector2(x,y))
	if event.is_action("ui_accept") && event.is_pressed() && !event.is_echo():
		if (index == 0):
			singleton.index_selected = 0
		if (index == 1):
			singleton.index_selected = 1
		if (index == 2):
			singleton.index_selected = 2

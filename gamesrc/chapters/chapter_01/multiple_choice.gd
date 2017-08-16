extends PopupDialog

onready var pointerNode = get_node("pointer")
onready var worldNode = get_parent()

var correct_selected = false
var index = 0
var interact
var player_pos
var correctIndex = -1

func _ready():
	set_process_input(true)
	set_fixed_process(true)

func _input(event):
	if self.is_visible():
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
			player_pos = worldNode.get_node("Player").get_pos()
			worldNode.get_node("control_alerts").set_pos(Vector2(player_pos.x-76, player_pos.y-20))
			if (index == correctIndex):
				worldNode.get_node("control_alerts")._print_alert(4)
				worldNode.get_node("control_alerts").show()
				self.hide()
				singleton.multiple_choice_complete = true
			else:
				worldNode.get_node("control_alerts")._print_alert(3)
				worldNode.get_node("control_alerts").show()
				self.hide()
				singleton.wrong_choice = true
			#if (index == 1):
			#	worldNode.get_node("control_alerts")._print_alert(3)
			#	worldNode.get_node("control_alerts").show()
			#	self.hide()
			#	singleton.wrong_choice = true
			#if (index == 2):
			#	worldNode.get_node("control_alerts")._print_alert(3)
			#	worldNode.get_node("control_alerts").show()
			#	self.hide()
			#	singleton.wrong_choice = true

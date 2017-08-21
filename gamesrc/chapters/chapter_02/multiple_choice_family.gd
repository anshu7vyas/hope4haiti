extends PopupDialog

onready var pointerNode = get_node("pointer")
onready var worldNode = get_parent()
onready var alert_box = get_parent().get_node("control_alerts")

var correct_selected = false
var index = 0
var interact
var player_pos
var correctIndex = 0
var questionNumber = 0

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
			if(index != 4):
				index += 1
				var x = pointerNode.get_pos().x
				var y = pointerNode.get_pos().y + 25
				pointerNode.set_pos(Vector2(x,y))
		if event.is_action("ui_accept") && event.is_pressed() && !event.is_echo():
			#alert_box.set_pos(Vector2(player_pos.x-76, player_pos.y-20))
			get_parent().multipleChoiceSelected = true
			if questionNumber < 5:
				correctIndex = worldNode.multipleChoiceCorrectIndex[questionNumber]
			if (index == correctIndex):
				if questionNumber == 4:
					worldNode.multipleChoiceDone = true
				get_parent().correctMultipleChoice = true
				questionNumber += 1
			else:
				get_parent().correctMultipleChoice = false

			

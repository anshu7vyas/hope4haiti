extends PopupDialog

onready var pointerNode = get_node("pointer")
onready var worldNode = get_parent()
onready var alert_box = get_parent().get_node("control_alerts")

var correct_selected = false
var index = 0
var interact
var player_pos
var correctIndex = -1
var startPos

func _ready():
	set_process_input(true)
	set_fixed_process(true)
	startPos = pointerNode.get_pos()

func _input(event):
	if self.is_visible():
		if event.is_action("ui_up") && event.is_pressed() && !event.is_echo():
			if(index != 0):
				index -= 1
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
			alert_box.set_pos(Vector2(player_pos.x-76, player_pos.y-20))
			if (index == correctIndex):
				correct_popup()
				pointerNode.set_pos(startPos)
				index = 0
				self.hide()
				singleton.multiple_choice_complete = true
			else:
				self.hide()
				incorrect_popup()
				singleton.wrong_choice = true

func correct_popup():
	delete_alert_box_text() #reset alert
	alert_box.set_title("Alerte")
	alert_box._print_alert_string("\n")
	alert_box.get_node("Label1").set_text("")
	alert_box.get_node("Label2").set_text("Très bien! A est correct")
	alert_box.get_node("Label3").set_text("")
	alert_box.show()
	singleton.correct_answer_chosen = true

func incorrect_popup():
	delete_alert_box_text() #reset alert
	alert_box.set_title("Alerte")
	alert_box._print_alert_string("\n")
	alert_box.get_node("Label1").set_text("")
	alert_box.get_node("Label2").set_text("Non, ce n'est pas le cas. Réessayer!")
	alert_box.get_node("Label3").set_text("")
	alert_box.show()

func delete_alert_box_text():
	alert_box._print_alert_string("\n")
	alert_box.get_node("Label1").set_text("")
	alert_box.get_node("Label2").set_text("")
	alert_box.get_node("Label3").set_text("")

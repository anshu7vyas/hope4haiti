extends Node2D

onready var alertNode = get_node("control_alerts")
onready var directionNode = get_node("direction_arrow")
onready var compassNode = get_node("compassBG")
onready var playerNode = get_node("Player")
onready var multipleChoiceBox = get_node("multiple_choice")
onready var dialogueBox = get_node("dialogue_box")

var time_delta = 0
var initial_popup_complete = false
var neighbor_dialogue_done = false
var instruction_started = false
var instruction_done = false
var multiple_choice_box = false
var multiple_choice_started = false
#print("here")

var player_pos
var interact = false

func _ready():
	set_process_input(true)
	set_fixed_process(true)
	#get_node("Player").canMove = false
	enable_movements()
	directionNode.hide()
	compassNode.hide()
	singleton.wrong_choice = false
	singleton.multiple_choice_complete = false
	get_node("multiple_choice").correctIndex = 2

func _input(event):
	if event.is_action_pressed("ui_interact"): #tab press to dismiss alert boxes and progress dialogue
		interact = true
	elif event.is_action_released("ui_interact"):
		interact = false

func _fixed_process(delta):
	time_delta += delta
	if time_delta > 0.1 and !initial_popup_complete:
		disable_movements()
		prepositions_intro_popup()
		initial_popup_complete = true
	
	if neighbor_dialogue_done and singleton.message_done and !instruction_started:
		instruction_alert()
		instruction_started = true
	
	if instruction_done and singleton.message_done and !multiple_choice_box:
		multiple_choice_box = true
		multiple_choice_started = true

	if interact: # space bar pressed
		if singleton.wrong_choice:
			print("wrong choice")
			alertNode.hide()
			multiple_choice_challenge()
		if singleton.multiple_choice_complete: # SCENE DONE: DO STUFF HERE
			print("right choice")
			multipleChoiceBox.hide()
			alertNode.hide()
		if multiple_choice_started and !alertNode.is_visible():
			print("here2")
			print("start challenge")
			delete_alert_box_text()
			disable_movements()
			multiple_choice_challenge()
			multiple_choice_started = false

	
	if alertNode.is_visible() or multipleChoiceBox.is_visible() or dialogueBox.is_visible():
		disable_movements()
	else:
		enable_movements()

func multiple_choice_challenge():
	player_pos = playerNode.get_pos()
	multipleChoiceBox.set_pos(Vector2(player_pos.x-76, player_pos.y-45))
	multipleChoiceBox.show()
	singleton.wrong_choice = false

func instruction_alert():
	player_pos = get_node("Player").get_pos() #get position of the player to place the dialogue box
	alertNode.set_pos(Vector2(player_pos.x-76, player_pos.y-20))
	alertNode._print_alert_string("\n\n")
	alertNode.get_node("Label1").set_text("qqch qui utilise ")
	alertNode.get_node("Label2").set_text('"before" and "after" and "between"')
	alertNode.get_node("Label3").set_text('qqch qui utilise "from" and "at"')
	alertNode.show()
	instruction_done = true
	
func neighbor_dialogue_predicate():
	# Set Mother's sprite direction facing
	if get_node("Player").get_pos().x < 328:
		get_node("neighbor_body/Sprite").set_frame(10)
	else:
		get_node("neighbor_body/Sprite").set_frame(4)

	player_pos = get_node("Player").get_pos() #get position of the player to place the dialogue box
	get_node("dialogue_box").set_pos(Vector2(player_pos.x-76, player_pos.y+31)) #hardcoded distance to position middle bottom
	get_node("dialogue_box").set_hidden(false)
	get_node("dialogue_box")._print_dialogue(get_node("dialogeObj1/StaticBody2D/dialogue").text) 
	neighbor_dialogue_done = true

func prepositions_intro_popup():
	alertNode.set_title("Alerte")
	alertNode._print_alert_string("\n\n\n")
	alertNode.get_node("Label1").set_text("Dans sa section:")
	alertNode.get_node("Label2").set_text("Nous allons voir comment les")
	alertNode.get_node("Label3").set_text("PRÉPOSITIONS sont utilisées en anglais")
	alertNode.show()

func delete_alert_box_text():
	alertNode._print_alert_string("\n")
	alertNode.get_node("Label1").set_text("")
	alertNode.get_node("Label2").set_text("")
	alertNode.get_node("Label3").set_text("")

func disable_movements():
	directionNode.hide()
	compassNode.hide()
	playerNode.canMove = false

func enable_movements():
	directionNode.show()
	compassNode.show()
	playerNode.canMove = true
extends Node2D

onready var alertNode = get_node("control_alerts")
onready var directionNode = get_node("direction_arrow")
onready var compassNode = get_node("compassBG")
onready var playerNode = get_node("Player")
onready var multipleChoiceBox = get_node("multiple_choice")
onready var dialogueBox = get_node("startup_dialoge")


var time_delta = 0
var initial_popup_complete = false
var mother_dialogue_done = false
var multiple_choice_box = false
var final_challenge_start = false
var scene_complete = false

var player_pos
var interact = false

func _ready():
	set_process_input(true)
	set_fixed_process(true)
	get_node("Player").canMove = false
	get_node("sad_emote").hide()
	directionNode.hide()
	compassNode.hide()
	singleton.wrong_choice = false
	singleton.multiple_choice_complete = false
	get_node("multiple_choice").correctIndex = 1

func _input(event):
	if event.is_action_pressed("ui_interact"): #tab press to dismiss alert boxes and progress dialogue
		interact = true
	elif event.is_action_released("ui_interact"):
		interact = false

func _fixed_process(delta):
	time_delta += delta
	if time_delta > 0.1 and !initial_popup_complete:
		get_node("Player").canMove = false
		verbs_intro_popup()
		initial_popup_complete = true
	
	if time_delta > 0.1 and !alertNode.is_visible() and !mother_dialogue_done:
		directionNode.show()
		compassNode.show()
	
	if get_node("startup_dialoge").currentText == 2:
		disable_movements()
		player_pos = get_node("Player").get_pos()
		get_node("sad_emote").set_pos(Vector2(player_pos.x+10, player_pos.y-25))
		get_node("sad_emote").show()
	else:
		get_node("sad_emote").hide()
	
	if mother_dialogue_done and singleton.message_done and !multiple_choice_box:
		disable_movements()
		multiple_choice_box = true
		final_challenge_start = true
	
	
	if interact: # space bar pressed
		if singleton.wrong_choice:
			disable_movements()
			print("wrong choice")
			alertNode.hide()
			multiple_choice_challenge()
		if singleton.multiple_choice_complete: # SCENE DONE: DO STUFF HERE
			disable_movements()
			print("right choice")
			scene_complete = true
			multipleChoiceBox.hide()
			alertNode.hide()
		if final_challenge_start:
			print("start challenge")
			delete_alert_box_text()
			disable_movements()
			multiple_choice_challenge()
			final_challenge_start = false
	
	if alertNode.is_visible() or multipleChoiceBox.is_visible() or dialogueBox.is_visible():
		disable_movements()

func disable_movements():
	directionNode.hide()
	compassNode.hide()
	playerNode.canMove = false

func enable_movements():
	directionNode.show()
	compassNode.show()
	playerNode.canMove = true

func multiple_choice_challenge():
	disable_movements()
	player_pos = playerNode.get_pos()
	multipleChoiceBox.set_pos(Vector2(player_pos.x-76, player_pos.y-45))
	multipleChoiceBox.show()
	singleton.wrong_choice = false

func delete_alert_box_text():
	alertNode._print_alert_string("\n")
	alertNode.get_node("Label1").set_text("")
	alertNode.get_node("Label2").set_text("")
	alertNode.get_node("Label3").set_text("")

func verbs_intro_popup():
	alertNode.set_title("Alerte")
	alertNode._print_alert_string("\n\n\n")
	alertNode.get_node("Label1").set_text("Dans sa section:")
	alertNode.get_node("Label2").set_text("Nous allons voir comment les")
	alertNode.get_node("Label3").set_text("VERBES sont utilisés en anglais")
	alertNode.show()

func mother_dialogue():
	disable_movements()
	# Set Mother's sprite direction facing
	if get_node("Player").get_pos().y < get_node("area_mother/Sprite").get_pos().y:
		get_node("area_mother/Sprite").set_frame(4)
	else:
		get_node("area_mother/Sprite").set_frame(7)
	
	directionNode.hide()
	compassNode.hide()
	player_pos = get_node("Player").get_pos() #get position of the player to place the dialogue box
	get_node("startup_dialoge").set_pos(Vector2(player_pos.x-76, player_pos.y+31)) #hardcoded distance to position middle bottom
	get_node("startup_dialoge").set_hidden(false)
	get_node("startup_dialoge")._print_dialogue(get_node("dialogueObj/StaticBody2D/Interact").text) 
	mother_dialogue_done = true

# Chapter 1 - Scene 2 Outside Script (Entire World)
extends Node2D

onready var alertBox = get_node("control_alerts")
onready var directionNode = get_node("direction_arrow")
onready var destinationNode = get_node("destinationObj")
onready var compassNode = get_node("compassBG")
onready var multipleChoiceBox = get_node("multiple_choice")
onready var playerNode = get_node("Player")
onready var greetingsScreenNode = get_node("lesson_plan")
onready var dialogueNode = get_node("dialogue_box")

var alert_done = false
var merchant_alerted = false
var scene_complete = false
var interact = false
var left_trigger = false
var right_trigger = false
var time_delta = 0
var lesson_plan_page = 0
var playerPos

var lesson_plan_bottomtext = singleton.grettingsLessonPlanText

func _ready():
	set_process_input(true)
	set_fixed_process(true)
	destinationNode.set_pos(Vector2(136,8))
	directionNode.show()
	compassNode.show()
	greetingsScreenNode.set_hidden(false)
	get_node("multiple_choice").correctIndex = 0
	singleton.message_done = true
	singleton.wrong_choice = false
	singleton.multiple_choice_complete = false
	set_up_lesson_plan()

	
func set_up_lesson_plan():
	lesson_plan_bottomtext = singleton.grettingsLessonPlanText
	greetingsScreenNode.get_node("title1").set_text("Les Salutations")
	greetingsScreenNode.get_node("intro_text").set_hidden(true)
	greetingsScreenNode.get_node("describing_text").set_bbcode(lesson_plan_bottomtext[0])
	

func _input(event):
	if event.is_action_pressed("ui_interact"): #tab press to dismiss alert boxes and progress dialogue
		interact = true
	elif event.is_action_released("ui_interact"):
		interact = false
	if event.is_action_pressed("ui_right"):
		right_trigger = true
	elif event.is_action_released("ui_right"):
		right_trigger = false
	if event.is_action_pressed("ui_left"):
		left_trigger = true
	elif event.is_action_released("ui_left"):
		left_trigger = false

func _fixed_process(delta):
	print(dialogueNode.currentText)
	time_delta += delta
	if interact: # space bar pressed
		if greetingsScreenNode.is_visible():
			greetingsScreenNode.set_hidden(true)
	# Block movements when an popup/dialogue box is open
	if singleton.message_done:
		if alertBox.is_visible() or multipleChoiceBox.is_visible() or greetingsScreenNode.is_visible():
			disable_movements()
		else:
			enable_movements()
	else:
		disable_movements()
	
	if merchant_alerted:
		if dialogueNode.currentText == 5:
			get_node("banana").set_pos(Vector2(440, -168))
		elif dialogueNode.currentText == 7:
			get_node("banana").set_pos(Vector2(440, -152))
		if singleton.message_done:
			get_node("banana").set_hidden(true)
			merchant_alerted = false
	

			
	
func delete_alert_box_text():
	alertBox._print_alert_string("\n")
	alertBox.get_node("Label1").set_text("")
	alertBox.get_node("Label2").set_text("")
	alertBox.get_node("Label3").set_text("")

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
	playerPos = playerNode.get_pos()
	multipleChoiceBox.set_pos(Vector2(playerPos.x-76, playerPos.y-45))
	multipleChoiceBox.show()
	singleton.wrong_choice = false

func neighbor1_dialogue():
	if playerNode.get_pos().x < 110:
		get_node("Area2D/neighbor1").set_frame(10)
	elif playerNode.get_pos().x > 120:
		get_node("Area2D/neighbor1").set_frame(4)
	playerPos = playerNode.get_pos() #get position of the player to place the dialogue box
	get_node("dialogue_box").set_pos(Vector2(playerPos.x-76, playerPos.y+31)) #hardcoded distance to position middle bottom
	get_node("dialogue_box").set_hidden(false)
	get_node("dialogue_box")._print_dialogue(get_node("dialogeObj1/StaticBody2D/dialogue").text) 
	destinationNode.set_pos(Vector2(440,-136))

func merchant_dialogue():
	get_node("merchant/merchant").set_frame(7)
	playerPos = playerNode.get_pos() #get position of the player to place the dialogue box
	get_node("dialogue_box").set_pos(Vector2(playerPos.x-76, playerPos.y+31)) #hardcoded distance to position middle bottom
	get_node("dialogue_box").set_hidden(false)
	get_node("dialogue_box")._print_dialogue(get_node("dialogeObj2/StaticBody2D/dialogue").text) 
	merchant_alerted = true


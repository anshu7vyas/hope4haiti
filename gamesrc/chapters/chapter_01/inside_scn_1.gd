extends Node2D
#world 1 start up scene

onready var alert_box = get_node("control_alerts")
onready var directionNode = get_node("direction_arrow")
onready var compassNode = get_node("compassBG")
onready var playerNode = get_node("Player")
onready var dialogueBox = get_node("startup_dialoge")
onready var playerDialogueBox = get_node("Player/Camera2D/dialogue_box")

var time_seconds = 0 #skip for now
var dialogue_wait_secs = 1
var alert_wait_secs = 2

var interact  = false
var intro_dialogue_complete = false
var timer_done = false
var alert_done = false
var alert2_done = false

func _ready():
	set_process_input(true)
	set_fixed_process(true)
	directionNode.hide()
	compassNode.hide()
	
	#skip intro for debugging
	#skip_intro()
	#singleton.isNewGame == false
	#if !singleton.isNewGame: #will be used when saving user data

func _input(event):
	if event.is_action_pressed("ui_interact"): #tab press to dismiss alert boxes and progress dialogue
		interact = true
	elif event.is_action_released("ui_interact"):
		interact = false

func _fixed_process(delta): #running process
	time_seconds += delta #count how long the scene has been running
	if interact and alert_box.is_visible(): #dismiss alertbox
		alert_box.hide()
		if alert2_done:
			directionNode.show()
			compassNode.show()
	if time_seconds > dialogue_wait_secs and !timer_done: #pause for 1s then start intro dialogue
		intro_dialogue()
		timer_done = true #dont run this block again
	if time_seconds > alert_wait_secs and !alert_done: #show 1st alert box after 2s
		alert_box._print_alert(0) #print text at index 0 of alerts[]
		alert_box.show() #show alert box
		alert_done = true #dont run this block again
	if singleton.message_done and !alert2_done: #show 2nd alert box after dialoge is complete
		#singleton.message_done = false #set the message bool back to false
		alert_box._print_alert(1) 
		alert_box.show() 
		interact = false #bug fix so alert box is not immediatly dismssed
		OS.delay_msec(50) #allow "interact = false" to register
		alert2_done = true 
	if !singleton.message_done: #dont allopw walking during dialogue or alerts
		get_node("Player").canMove = false
	
	if dialogueBox.is_visible() or alert_box.is_visible() or playerDialogueBox.is_visible():
		disable_movements()
	else:
		enable_movements()
	
	

func intro_dialogue():
	var player_pos = get_node("Player").get_pos() #get position of the player to place the dialogue box
	get_node("startup_dialoge").set_pos(Vector2(player_pos.x-76, player_pos.y+31)) #hardcoded distance to position middle bottom
	get_node("startup_dialoge").set_hidden(false)
	get_node("startup_dialoge")._print_dialogue(get_node("intoObj/StaticBody2D/introduction_dialogue").text) 

func skip_intro():
	singleton.message_done = true
	time_seconds = 6
	intro_dialogue_complete = true
	timer_done = true
	alert_done = true
	alert2_done = true

func disable_movements():
	directionNode.hide()
	compassNode.hide()
	playerNode.canMove = false

func enable_movements():
	directionNode.show()
	compassNode.show()
	playerNode.canMove = true


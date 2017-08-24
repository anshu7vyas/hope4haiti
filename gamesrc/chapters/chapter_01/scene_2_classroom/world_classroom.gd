extends Node2D
#classroom scene

onready var playerNode = get_node("Player")
onready var dialogueBox = get_node("dialogue_box")
onready var directionNode = get_node("direction_arrow")
onready var compassNode = get_node("compassBG")
onready var destinationNode = get_node("destinationObj")
onready var tie = get_node("teacher_dialogue/TextInterfaceEngine")
onready var endPopupNode = get_node("end_chapter_challenge")
var do_once = false
var interact
var player_pos
var seat_diag_done = false
var teacher_dialogue_done = false
var time_delta = 0



var lesson_plan_toptext = singleton.nounsLessonPlanTop
var lesson_plan_bottomtext = singleton.nounsLessonPlanBottom

func _ready():
	set_process_input(true)
	set_fixed_process(true)
	destinationNode.set_pos(Vector2(-120,-88))
	directionNode.show()
	compassNode.show()
	#endPopupNode.set_hidden(false)
	get_node("end_chapter_challenge").questions = singleton.nounsQuestions


func _input(event):
	if event.is_action_pressed("ui_interact"): #tab press to dismiss alert boxes and progress dialogue
		interact = true
	elif event.is_action_released("ui_interact"):
		interact = false

func _fixed_process(delta):
#	if time_delta > 0.2:
#		print(singleton.changingScene)
#		time_delta = 0
#	if singleton.changingScene:
#		singleton.changingScene = false
#		print("changing scene")
#		get_tree().change_scene("res://chapters/chapter_01/inside_world.tscn")
	time_delta += delta
	if seat_diag_done and !singleton.message_done:
		if time_delta > 2:
			player_pos = playerNode.get_pos()
			get_node("seat_obj/sadEmote").set_pos(Vector2(player_pos.x-50, player_pos.y-55))
			get_node("seat_obj/sadEmote").show()
			get_node("neighbor/Sprite").set_frame(10) # turn left
			get_node("Player/Sprite").set_frame(7) # turn right
	if seat_diag_done and singleton.message_done and !do_once:
		get_node("seat_obj/sadEmote").hide()
		do_once = true
		OS.delay_msec(100)
		player_pos = playerNode.get_pos()
		endPopupNode.set_pos(Vector2(player_pos.x-100, player_pos.y-75))
		endPopupNode.set_hidden(false)
	
	if dialogueBox.is_visible() or endPopupNode.is_visible():
		disable_movements()
	else:
		enable_movements()


func teacher_dialogue():
	player_pos = playerNode.get_pos() #get position of the player to place the dialogue box
	get_node("dialogue_box").set_pos(Vector2(player_pos.x-76, player_pos.y+31)) #hardcoded distance to position middle bottom
	get_node("dialogue_box").set_hidden(false)
	get_node("dialogue_box")._print_dialogue(get_node("teacher_obj/StaticBody2D/teacher_dialogue").text) 
	teacher_dialogue_done = true
	

func seat_dialogue():
	player_pos = playerNode.get_pos() #get position of the player to place the dialogue box
	get_node("dialogue_box").set_pos(Vector2(player_pos.x-76, player_pos.y+31)) #hardcoded distance to position middle bottom
	get_node("dialogue_box").set_hidden(false)
	get_node("dialogue_box")._print_dialogue(get_node("seat_obj/StaticBody2D/seat_dialogue").text) 
	seat_diag_done = true
	time_delta = 0

func disable_movements():
	directionNode.hide()
	compassNode.hide()
	playerNode.canMove = false

func enable_movements():
	directionNode.show()
	compassNode.show()
	playerNode.canMove = true
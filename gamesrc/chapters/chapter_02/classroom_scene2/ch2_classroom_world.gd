extends Node2D
#classroom scene

#The currently active scene
var currentScene = null

onready var alertBox = get_node("control_alerts")
onready var playerNode = get_node("Player")
onready var dialogueBox = get_node("dialogue_box")
onready var directionNode = get_node("direction_arrow")
onready var compassNode = get_node("compassBG")
onready var destinationNode = get_node("destinationObj")
onready var multipleChoiceBox = get_node("multiple_choice")
onready var nounsScreenNode = get_node("lesson_plan")
onready var endPopupNode = get_node("end_chapter_challenge")
onready var rightSideClose = get_node("right_side")
onready var leftSideClose = get_node("left_side")

var do_once = false
var interact
var player_pos
var animateRight
var animateLeft
var seat_diag_done = false
var teacher_dialogue_done = false
var time_delta = 0
var in_multiple_choice = false
var first_multiple_choice_section_done = false
var animationStarted = false
var changin_scene = false

var chapter_score = 100
var lesson_plan_page = 0
var lesson_plan_bottomtext = singleton.nounsLessonPlanBottom
var question_count = 0
var question_answers = 0
var multipleChoiceQuestion = singleton.nounsMultipleChoiceQuestions
var multipleChoiceAnswers = singleton.nounsMultipleChoiceAnswers
var multipleChoiceCorrectIndex = singleton.nounsMultipleChoiceCorrectIndices

func _ready():
	#On load set the current scene to the last scene available
	currentScene = get_tree().get_root().get_child(get_tree().get_root().get_child_count() -1)
	set_process_input(true)
	set_fixed_process(true)
	destinationNode.set_pos(Vector2(-120,-88))
	directionNode.show()
	compassNode.show()
	multipleChoiceQuestion = singleton.nounsMultipleChoiceQuestions
	multipleChoiceAnswers = singleton.nounsMultipleChoiceAnswers
	multipleChoiceCorrectIndex = singleton.nounsMultipleChoiceCorrectIndices
	get_node("multiple_choice").correctIndex = multipleChoiceCorrectIndex[0]
	singleton.message_done = true
	singleton.wrong_choice = false
	singleton.multiple_choice_complete = false
	set_up_lesson_plan()
	
	rightSideClose.set_hidden(true)
	leftSideClose.set_hidden(true)
	animateRight = get_node("left_side/AnimationPlayer")
	animateLeft = get_node("right_side/AnimationPlayer")
	
	
	#endPopupNode.set_hidden(false)
	#get_node("end_chapter_challenge").questions = singleton.nounsQuestions


func _input(event):
	if event.is_action_pressed("ui_interact"): #tab press to dismiss alert boxes and progress dialogue
		interact = true
	elif event.is_action_released("ui_interact"):
		interact = false

func _fixed_process(delta):
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
		multiple_choice_question_setup()
		multiple_choice_challenge()
		in_multiple_choice = true
	# if question answered wrong and alert bubble has been dismissed -> retry same question
	if in_multiple_choice and singleton.wrong_choice and !alertBox.is_visible(): 
		singleton.wrong_choice = false
		singleton.chapter_2_score -= 4
		multiple_choice_question_setup()
		multiple_choice_challenge()
	# if question is correct and alert bubble dismissed -> go to next question
	if !alertBox.is_visible() and singleton.correct_answer_chosen and in_multiple_choice:
		singleton.correct_answer_chosen = false
		question_count += 1
		question_answers += 3 # greetingsAnswers (in singleton) move to next set of answers (every 3)
		if question_count < 2: #still questions left -> go to next question
			multiple_choice_question_setup()
			multiple_choice_challenge()
		elif !first_multiple_choice_section_done: #done with first section of multiple choice questions
			first_multiple_choice_section_done = true
			in_multiple_choice = false
	
	if first_multiple_choice_section_done and !alertBox.is_visible() and !animationStarted:
		animationStarted = true
		disable_movements()
		rightSideClose.set_hidden(false)
		leftSideClose.set_hidden(false)
		animateRight.play("move_in_right")
		animateLeft.play("move_in_left")
		changin_scene = true
		time_delta = 0
	
	if time_delta > 1 and changin_scene: # 
		get_tree().change_scene("res://chapters/chapter_02/inside_scene3/inside_world_nouns.tscn")

	
	if dialogueBox.is_visible() or multipleChoiceBox.is_visible() or endPopupNode.is_visible() or changin_scene or animationStarted:
		disable_movements()
	else:
		enable_movements()

func setScene(scene):
	#clean up the current scene
	currentScene.queue_free()
	#load the file passed in as the param "scene"
	var s = ResourceLoader.load(scene)
	#create an instance of our scene
	currentScene = s.instance()
	# add scene to root
	get_tree().get_root().add_child(currentScene)

func multiple_choice_challenge():
	disable_movements()
	player_pos = playerNode.get_pos()
	multipleChoiceBox.set_pos(Vector2(player_pos.x-76, player_pos.y-45))
	multipleChoiceBox.show()
	singleton.wrong_choice = false

func multiple_choice_question_setup():
	multipleChoiceBox.get_node("RichTextLabel").set_bbcode(multipleChoiceQuestion[question_count])
	multipleChoiceBox.get_node("Label1").set_text(multipleChoiceAnswers[question_answers])
	multipleChoiceBox.get_node("Label2").set_text(multipleChoiceAnswers[question_answers+1])
	multipleChoiceBox.get_node("Label3").set_text(multipleChoiceAnswers[question_answers+2])
	get_node("multiple_choice").correctIndex = multipleChoiceCorrectIndex[question_count]

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

func set_up_lesson_plan():
	lesson_plan_bottomtext = singleton.nounsLessonPlanBottom
	nounsScreenNode.get_node("title1").set_text("Les Noms")
	nounsScreenNode.get_node("intro_text").set_hidden(true)
	nounsScreenNode.get_node("describing_text").set_bbcode(lesson_plan_bottomtext[0])
extends Node2D
# Pronouns inside world script - inside_world_pronouns.gd

var lesson_plan_bottomtext = singleton.conjunctionLessonPlanText

var interact = false
var left_trigger = false
var right_trigger = false
var time_delta = 0
var lesson_plan_page = 0
var player_pos
var wrong_choice = false
var q2_redo = false
var q3_redo = false
var multiple_choice_started = false
var familyDialogueStarted = false
var familyDialogueDone = false
var multipleChoiceStarted = false
var multipleChoiceSelected = false
var correctMultipleChoice = false
var multipleChoiceDone = false
var endOfChapterStart = false
var endPersonSelect = false
var startFinalMultipleChoice = false
var lastQuestionStarted = false
var chapterChallegeBegin = false
var finalQuestionStart = false
var endChapterChallenge = false
var startMatching = false
var multiple_choice_begin = false
var wrong_answer = false
var first_multiple_choice_done = false
var end_first_multiple_choice = false
var wrong_answer_popup_shown = false
var chapter_score = 100
var chapter_done = false
var multipleChoiceSprite = 0
var multipleChoiceCorrectIndex = [4, 0, 2, 1, 3] #correct multiple choice answers


onready var conjuctionScreenNode = get_node("lesson_plan")
onready var playerNode = get_node("Player")
onready var alertNode = get_node("control_alerts")
onready var directionNode = get_node("direction_arrow")
onready var destinationNode = get_node("destinationObj")
onready var compassNode = get_node("compassBG")
onready var multipleChoiceBox = get_node("multiple_choice")
onready var dialogueBox = get_node("dialogue_box")
onready var scorePopupNode = get_node("chapter_score")



func _ready():
	set_process_input(true)
	set_fixed_process(true)
	directionNode.show()
	compassNode.show()

	conjuctionScreenNode.set_hidden(false)
	get_node("happy_pat").hide()
	get_node("happy_mt").hide()
	multipleChoiceBox.set_hidden(true)
	set_up_lesson_plan()

	
	multipleChoiceBox.correctIndex = 2
	singleton.message_done = true
	singleton.wrong_choice = false
	singleton.multiple_choice_complete = false

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
	time_delta += delta
	if interact: # space bar pressed
		if conjuctionScreenNode.is_visible():
			conjuctionScreenNode.set_hidden(true)
	
	if dialogueBox.currentText == 1 and dialogueBox.is_visible():
		disable_movements()
		player_pos = get_node("Player").get_pos()
		get_node("happy_mt").set_pos(Vector2(player_pos.x-10, player_pos.y-15))
		get_node("happy_mt").show()
	elif dialogueBox.currentText == 2 and dialogueBox.is_visible():
		get_node("happy_pat").show()
	elif dialogueBox.currentText > 2 and dialogueBox.is_visible():
		get_node("happy_pat").hide()
		get_node("happy_mt").hide()
		multiple_choice_begin = true
			
			
	# Block movements when an popup/dialogue box is open
	if alertNode.is_visible() or multipleChoiceBox.is_visible() or conjuctionScreenNode.is_visible() or dialogueBox.is_visible():
		disable_movements()
	else:
		enable_movements()

	if multiple_choice_begin and !dialogueBox.is_visible():
		multiple_choice_begin = false
		multiple_choice_challenge()
		multiple_choice_started = true

	if multiple_choice_started:
		player_pos = playerNode.get_pos()
		alertNode.set_pos(Vector2(player_pos.x-76, player_pos.y-45))
		if singleton.wrong_choice:
			chapter_score -= 25
			singleton.wrong_choice = false
			alertNode.set_hidden(false)
			multipleChoiceBox.set_hidden(true)
			wrong_answer = true
		elif singleton.correct_answer_chosen:
			singleton.correct_answer_chosen = false
			alertNode.set_hidden(false)
			multiple_choice_started = false
			first_multiple_choice_done = true
			end_first_multiple_choice = true
			#multipleChoiceBox.queue_free()
	if wrong_answer and !alertNode.is_visible() and !end_first_multiple_choice:
		multipleChoiceBox.set_hidden(false)
		interact = false
		wrong_answer = false
		
	
	if first_multiple_choice_done and !alertNode.is_visible():
		score_popup()
		first_multiple_choice_done = false


	if scorePopupNode.is_visible():
		# score < 80 and resart chapter pressed
		if scorePopupNode.get_node("restart_chapter_level").is_pressed() and !chapter_done:
			chapter_done = true # do block once
			get_tree().change_scene("res://chapters/chapter_10/ch10_soccer_world.tscn")
		# score >= 80 and next chapter button pressed
		if scorePopupNode.get_node("next_chapter_button").is_pressed() and !chapter_done:
			chapter_done = true
			get_tree().change_scene("res://screens/main_menu/startUp.tscn")
	

func multiple_choice_challenge():
	disable_movements()
	player_pos = playerNode.get_pos()
	multipleChoiceBox.set_pos(Vector2(player_pos.x-76, player_pos.y-45))
	multipleChoiceBox.show()
	singleton.wrong_choice = false


func patrick_dialogue():
	get_node("area_patrick/Sprite").set_frame(7)
	directionNode.hide()
	compassNode.hide()
	player_pos = get_node("Player").get_pos() #get position of the player to place the dialogue box
	get_node("dialogue_box").set_pos(Vector2(player_pos.x-76, player_pos.y+31)) #hardcoded distance to position middle bottom
	get_node("dialogue_box").set_hidden(false)
	get_node("dialogue_box")._print_dialogue(get_node("dialogueObj/StaticBody2D/Interact").text) 


func correct_popup():
	delete_alert_box_text() #reset alert
	player_pos = playerNode.get_pos()
	alertNode.set_pos(Vector2(player_pos.x-76, player_pos.y-20))
	alertNode.set_title("Alerte")
	alertNode._print_alert_string("\n")
	alertNode.get_node("Label1").set_text("")
	alertNode.get_node("Label2").set_text("Très bien! A est correct")
	alertNode.get_node("Label3").set_text("")
	alertNode.show()

func incorrect_popup():
	delete_alert_box_text() #reset alert
	player_pos = playerNode.get_pos()
	alertNode.set_pos(Vector2(player_pos.x-76, player_pos.y-20))
	alertNode.set_title("Alerte")
	alertNode._print_alert_string("\n")
	alertNode.get_node("Label1").set_text("")
	alertNode.get_node("Label2").set_text("Non, ce n'est pas le cas. Réessayer!")
	alertNode.get_node("Label3").set_text("")
	alertNode.show()
	
func delete_alert_box_text():
	alertNode._print_alert_string("\n")
	alertNode.get_node("Label1").set_text("")
	alertNode.get_node("Label2").set_text("")
	alertNode.get_node("Label3").set_text("")


func set_up_lesson_plan():
	lesson_plan_bottomtext = singleton.conjunctionLessonPlanText
	conjuctionScreenNode.get_node("title1").set_text("Les conjonctions")
	conjuctionScreenNode.get_node("intro_text").set_hidden(true)
	conjuctionScreenNode.get_node("describing_text").set_bbcode(lesson_plan_bottomtext[0])
	
func disable_movements():
	directionNode.hide()
	compassNode.hide()
	playerNode.canMove = false

func enable_movements():
	directionNode.show()
	compassNode.show()
	playerNode.canMove = true

func score_popup():
	player_pos = playerNode.get_pos()
	scorePopupNode.set_pos(Vector2(player_pos.x-100, player_pos.y-75))
	scorePopupNode.set_hidden(false)
	if chapter_score < 1:
		chapter_score = 0
	scorePopupNode.get_node("score_label").set_text(str(chapter_score) + " points!")
	# Display the correct options if they passed or not
	if chapter_score < 80:
		scorePopupNode.get_node("failed_notes").set_hidden(false)
		scorePopupNode.get_node("restart_chapter_level").set_hidden(false)
		scorePopupNode.get_node("pass_chapter_notes").set_hidden(true)
		scorePopupNode.get_node("next_chapter_button").set_hidden(true)
	else:
		scorePopupNode.get_node("failed_notes").set_hidden(true)
		scorePopupNode.get_node("restart_chapter_level").set_hidden(true)
		scorePopupNode.get_node("pass_chapter_notes").set_hidden(false)
		scorePopupNode.get_node("next_chapter_button").set_hidden(false)

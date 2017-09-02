extends Node2D

onready var alertNode = get_node("control_alerts")
onready var directionNode = get_node("direction_arrow")
onready var compassNode = get_node("compassBG")
onready var playerNode = get_node("Player")
onready var multipleChoiceBox = get_node("multiple_choice")
onready var dialogueBox = get_node("startup_dialoge")
onready var lessonPlanNode = get_node("lesson_plan")
onready var scorePopupNode = get_node("chapter_score")
onready var menuNode = get_node("Player/Camera2D/menu")
onready var matchingBox = get_node("matching")

var time_delta = 0
var wrong_answer_count = 0
var initial_popup_complete = false
var mother_dialogue_done = false
var multiple_choice_started = false
var final_challenge_start = false
var scene_complete = false
var wrong_answer = false
var first_multiple_choice_done = false
var end_first_multiple_choice = false
var chapter_done_popup = false
var chapter_done = false
var intro_shown = false
var in_multiple_choice = false
var first_multiple_choice_section_done = false
var doc_dialogue_done = false
var matching_shown = false
var matching_box_done = false

var player_pos
var interact = false

var chapter_score = 100
var lesson_plan_page = 0
var question_count = 0
var question_answers = 0
var lesson_plan_text = singleton.tensesLessonPlanText
var multipleChoiceQuestion = singleton.tensesMultipleChoiceQuestions
var multipleChoiceAnswers = singleton.tensesMultipleChoiceAnswers
var multipleChoiceCorrectIndex = singleton.tensesMultipleChoiceCOrrectIndices

func _ready():
	set_process_input(true)
	set_fixed_process(true)
	get_node("Player").canMove = false
	directionNode.hide()
	compassNode.hide()
	singleton.wrong_choice = false
	singleton.multiple_choice_complete = false
	get_node("multiple_choice").correctIndex = multipleChoiceCorrectIndex[0]
	set_up_lesson_plan()
	lessonPlanNode.set_hidden(false)
	menuNode.set_hidden(true)
	menuNode.lesson_plan_shown = false
	menuNode.chapterIsChanging = false
	multipleChoiceQuestion = singleton.tensesMultipleChoiceQuestions
	multipleChoiceAnswers = singleton.tensesMultipleChoiceAnswers
	multipleChoiceCorrectIndex = singleton.tensesMultipleChoiceCOrrectIndices

func _input(event):
	if event.is_action_pressed("ui_interact"): #tab press to dismiss alert boxes and progress dialogue
		interact = true
	elif event.is_action_released("ui_interact"):
		interact = false

func _fixed_process(delta):
	time_delta += delta
	if interact and lessonPlanNode.is_visible():
		interact = false
		lessonPlanNode.set_hidden(true)
		if !intro_shown:
			_intro_popup()
			intro_shown = true
	
	if doc_dialogue_done and !dialogueBox.is_visible() and !multiple_choice_started:
		multiple_choice_started = true
		multiple_choice_question_setup()
		multiple_choice_challenge()
		in_multiple_choice = true
	
	# if question answered wrong and alert bubble has been dismissed -> retry same question
	if in_multiple_choice and singleton.wrong_choice and !alertNode.is_visible(): 
		singleton.wrong_choice = false
		chapter_score -= 3
		multiple_choice_question_setup()
		multiple_choice_challenge()
	# if question is correct and alert bubble dismissed -> go to next question
	if !alertNode.is_visible() and singleton.correct_answer_chosen and in_multiple_choice:
		singleton.correct_answer_chosen = false
		question_count += 1
		question_answers += 3 # greetingsAnswers (in singleton) move to next set of answers (every 3)
		if question_count < 3: #still questions left -> go to next question
			multiple_choice_question_setup()
			multiple_choice_challenge()
		elif !first_multiple_choice_section_done: #done with first section of multiple choice questions
			first_multiple_choice_section_done = true
			in_multiple_choice = false
	
	if first_multiple_choice_section_done and !alertNode.is_visible() and !matching_shown:
		matching_shown = true
		player_pos = playerNode.get_pos()
		matchingBox.set_pos(Vector2(player_pos.x-100, player_pos.y-75))
		matchingBox.set_hidden(false)
	
	if !matching_box_done and matchingBox.get_node("OK").is_pressed():
		matchingBox.set_hidden(true)
		matching_box_done = true
		score_popup()

	if scorePopupNode.is_visible():
		# score < 80 and resart chapter pressed
		if scorePopupNode.get_node("restart_chapter_level").is_pressed() and !chapter_done:
			chapter_done = true # do block once
			get_tree().change_scene("res://chapters/chapter_11/ch11_inside_world_tenses.tscn")
		# score >= 80 and next chapter button pressed
		if scorePopupNode.get_node("next_chapter_button").is_pressed() and !chapter_done:
			#scorePopupNode.get_node("next_chapter_pw").set_text("NVYV5r")
			chapter_done = true
			get_tree().change_scene("res://screens/main_menu/startUp.tscn")
			
	if scorePopupNode.is_visible() or matchingBox.is_visible() or menuNode.is_visible() or alertNode.is_visible() or multipleChoiceBox.is_visible() or dialogueBox.is_visible() or lessonPlanNode.is_visible():
		disable_movements()
	else:
		enable_movements()
		
func set_up_lesson_plan():
	lesson_plan_text = singleton.tensesLessonPlanText
	lessonPlanNode.get_node("title1").set_text("Les Temps")
	lessonPlanNode.get_node("intro_text").set_hidden(true)
	lessonPlanNode.get_node("describing_text").set_bbcode(lesson_plan_text[0])

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

func multiple_choice_question_setup():
	multipleChoiceBox.get_node("RichTextLabel").set_bbcode(multipleChoiceQuestion[question_count])
	multipleChoiceBox.get_node("Label1").set_text(multipleChoiceAnswers[question_answers])
	multipleChoiceBox.get_node("Label2").set_text(multipleChoiceAnswers[question_answers+1])
	multipleChoiceBox.get_node("Label3").set_text(multipleChoiceAnswers[question_answers+2])
	get_node("multiple_choice").correctIndex = multipleChoiceCorrectIndex[question_count]

func delete_alert_box_text():
	alertNode._print_alert_string("\n")
	alertNode.get_node("Label1").set_text("")
	alertNode.get_node("Label2").set_text("")
	alertNode.get_node("Label3").set_text("")

func _intro_popup():
	alertNode.set_title("Alerte")
	alertNode._print_alert_string("\n\n\n")
	alertNode.get_node("Label1").set_text("Marie-Thérèse ne se sent pas bien,")
	alertNode.get_node("Label2").set_text("alors sa mère a appelé une")
	alertNode.get_node("Label3").set_text("infirmière pour la vérifier")
	alertNode.show()

func doctor_dialogue():
	disable_movements()
	# Set Mother's sprite direction facing
	if get_node("Player").get_pos().y < get_node("area_doctor/Sprite").get_pos().y:
		get_node("area_doctor/Sprite").set_frame(4)
	else:
		get_node("area_doctor/Sprite").set_frame(7)
	directionNode.hide()
	compassNode.hide()
	player_pos = get_node("Player").get_pos() #get position of the player to place the dialogue box
	get_node("startup_dialoge").set_pos(Vector2(player_pos.x-76, player_pos.y+31)) #hardcoded distance to position middle bottom
	get_node("startup_dialoge").set_hidden(false)
	get_node("startup_dialoge")._print_dialogue(get_node("dialogueObj/StaticBody2D/Interact").text) 
	doc_dialogue_done = true

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

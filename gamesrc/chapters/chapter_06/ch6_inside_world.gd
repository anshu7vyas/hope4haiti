extends Node2D
#classroom scene ch 6

onready var alertBox = get_node("control_alerts")
onready var playerNode = get_node("Player")
onready var dialogueBox = get_node("dialogue_box")
onready var directionNode = get_node("direction_arrow")
onready var compassNode = get_node("compassBG")
onready var destinationNode = get_node("destinationObj")
onready var multipleChoiceBox = get_node("multiple_choice")
onready var adjectivesScreenNode = get_node("lesson_plan")
onready var school_text = get_node("emotion_challenge/TextInterfaceEngine")
onready var emotionChallengeBox = get_node("emotion_challenge")
onready var adjectivesBox = get_node("adjective_lesson")
onready var scorePopupNode = get_node("chapter_score")
onready var matchingBox = get_node("matching")
onready var menuNode = get_node("Player/Camera2D/menu")

var do_once = false
var interact
var player_pos
var time_delta = 0
var wrong_answer_count = 0
var comb_dialogue_started = false
var multiple_choice_started  = false
var first_multiple_choice_done = false
var end_first_multiple_choice = false
var begin_multiple_choice = false
var grabbed_brush = false
var show_lesson_info = false
var wrong_answer = false
var chapter_done = false
var chapter_done_popup = false
var info_popup_done = false
var matching_box_shown = false

var chapter_score = 100
var lesson_plan_page = 0
var lesson_plan_text = singleton.possAdjectivesLessonPlanText

func _ready():
	set_process_input(true)
	set_fixed_process(true)
	directionNode.show()
	compassNode.show()
	get_node("multiple_choice").correctIndex = 0
	singleton.message_done = true
	singleton.wrong_choice = false
	singleton.multiple_choice_complete = false
	set_up_lesson_plan()
	adjectivesScreenNode.set_hidden(false)
	menuNode.set_hidden(true)
	menuNode.lesson_plan_shown = false
	menuNode.chapterIsChanging = false

			
func _input(event):
	if event.is_action_pressed("ui_interact"): #tab press to dismiss alert boxes and progress dialogue
		interact = true
	elif event.is_action_released("ui_interact"):
		interact = false

func _fixed_process(delta):
	time_delta += delta
	if interact and adjectivesScreenNode.is_visible():
		adjectivesScreenNode.set_hidden(true)
	
#	if start_q4 and !chapter_done_popup and !alertBox.is_visible() and first_multiple_choice_done:
#		score_popup()
#		chapter_done_popup = true
	if comb_dialogue_started and time_delta > 0.3 and !grabbed_brush:
		grabbed_brush = true
		playerNode.get_node("Sprite").set_frame(1)
		get_node("brush").set_pos(player_pos)
	
	if grabbed_brush and singleton.message_done and !begin_multiple_choice:
		begin_multiple_choice = true
		multiple_choice_started = true
		multiple_choice_challenge()
	
	if first_multiple_choice_done and !alertBox.is_visible() and !show_lesson_info:
		interact = false
		show_lesson_info = true
		player_pos = get_tree().get_current_scene().get_node("Player").get_pos()
		adjectivesBox.set_pos(Vector2(player_pos.x-100, player_pos.y-75))
		adjectivesBox.set_hidden(false)
	
	if adjectivesBox.is_visible() and interact:
		interact = false
		adjectivesBox.set_hidden(true)
		info_popup_done = true
	
	if info_popup_done:
		info_popup_done = false
		player_pos = playerNode.get_pos()
		matchingBox.set_pos(Vector2(player_pos.x-98, player_pos.y-65))
		matchingBox.set_hidden(false)
		matching_box_shown = true
	
	if matching_box_shown and matchingBox.get_node("OK").is_pressed():
		matchingBox.set_hidden(true)
		matching_box_shown = false
		score_popup()
		
	if scorePopupNode.is_visible():
		# score < 80 and resart chapter pressed
		if scorePopupNode.get_node("restart_chapter_level").is_pressed() and !chapter_done:
			chapter_done = true # do block once
			get_tree().change_scene("res://chapters/chapter_06/ch6_inside_world.tscn")
			#not sure if i need to free this scene
			self.queue_free()
		# score >= 80 and next chapter button pressed
		if scorePopupNode.get_node("next_chapter_button").is_pressed() and !chapter_done:
			scorePopupNode.get_node("next_chapter_pw").set_text(singleton.chapter_passwords[5])
			chapter_done = true
			#set to a random scene for now. This will be to chapter 2
			get_tree().change_scene("res://chapters/chapter_07/ch7_inside_world_verbs.tscn")
			
	if multiple_choice_started:
		player_pos = playerNode.get_pos()
		alertBox.set_pos(Vector2(player_pos.x-76, player_pos.y-45))
		if singleton.wrong_choice:
			chapter_score -= 11
			singleton.wrong_choice = false
			alertBox.set_hidden(false)
			multipleChoiceBox.set_hidden(true)
			wrong_answer = true
		elif singleton.correct_answer_chosen:
			singleton.correct_answer_chosen = false
			alertBox.set_hidden(false)
			multiple_choice_started = false
			first_multiple_choice_done = true
			end_first_multiple_choice = true
			#multipleChoiceBox.queue_free()
	if wrong_answer and !alertBox.is_visible() and !end_first_multiple_choice:
		multipleChoiceBox.set_hidden(false)
		interact = false
		wrong_answer = false

	if menuNode.is_visible() or matchingBox.is_visible() or adjectivesBox.is_visible() or adjectivesScreenNode.is_visible() or scorePopupNode.is_visible() or dialogueBox.is_visible() or multipleChoiceBox.is_visible() or alertBox.is_visible():
		disable_movements()
	else:
		enable_movements()


func comb_dialogue():
	player_pos = playerNode.get_pos() #get position of the player to place the dialogue box
	get_node("dialogue_box").set_pos(Vector2(player_pos.x-76, player_pos.y+31)) #hardcoded distance to position middle bottom
	get_node("dialogue_box").set_hidden(false)
	get_node("dialogue_box")._print_dialogue(get_node("dialogeObj/StaticBody2D/dialogue").text) 
	comb_dialogue_started = true
	time_delta = 0

func multiple_choice_challenge():
	disable_movements()
	player_pos = playerNode.get_pos()
	multipleChoiceBox.set_pos(Vector2(player_pos.x-76, player_pos.y-45))
	multipleChoiceBox.show()
	singleton.wrong_choice = false


func set_up_lesson_plan():
	lesson_plan_text = singleton.possAdjectivesLessonPlanText
	adjectivesScreenNode.get_node("title1").set_text("Les adjectifs possessifs")
	adjectivesScreenNode.get_node("intro_text").set_hidden(true)
	adjectivesScreenNode.get_node("describing_text").set_bbcode(lesson_plan_text[0])

func delete_alert_box_text():
	alertBox._print_alert_string("\n")
	alertBox.get_node("Label1").set_text("")
	alertBox.get_node("Label2").set_text("")
	alertBox.get_node("Label3").set_text("")

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
		scorePopupNode.get_node("next_chapter_pw").set_hidden(true)
		scorePopupNode.get_node("next_chapter_button").set_hidden(true)
	else:
		scorePopupNode.get_node("failed_notes").set_hidden(true)
		scorePopupNode.get_node("restart_chapter_level").set_hidden(true)
		scorePopupNode.get_node("pass_chapter_notes").set_hidden(false)
		scorePopupNode.get_node("next_chapter_pw").set_hidden(false)
		scorePopupNode.get_node("next_chapter_button").set_hidden(false)

func disable_movements():
	directionNode.hide()
	compassNode.hide()
	playerNode.canMove = false

func enable_movements():
	directionNode.show()
	compassNode.show()
	playerNode.canMove = true
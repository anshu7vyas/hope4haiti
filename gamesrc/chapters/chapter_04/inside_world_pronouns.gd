extends Node2D
# Pronouns inside world script - inside_world_pronouns.gd

var lesson_plan_text = singleton.pronounsLessonPlanText

var interact = false
var left_trigger = false
var right_trigger = false
var time_delta = 0
var lesson_plan_page = 0
var player_pos
var wrong_choice = false
var q2_redo = false
var q3_redo = false
var introSceneDone = false
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
var chapter_score = 100
var chapter_done = false
var multipleChoiceSprite = 0
var multipleChoiceCorrectIndex = [4, 0, 2, 1, 3] #correct multiple choice answers

onready var pronounsScreenNode = get_node("lesson_plan")
onready var playerNode = get_node("Player")
onready var alertNode = get_node("control_alerts")
onready var directionNode = get_node("direction_arrow")
onready var destinationNode = get_node("destinationObj")
onready var compassNode = get_node("compassBG")
onready var multipleChoiceBox = get_node("multiple_choice")
onready var dialogueBox = get_node("dialogue_box")
onready var matchingBox = get_node("matching")
onready var scorePopupNode = get_node("chapter_score")
onready var menuNode = get_node("Player/Camera2D/menu")

func _ready():
	set_process_input(true)
	set_fixed_process(true)
	directionNode.show()
	compassNode.show()
	pronounsScreenNode.get_node("title1").set_text("Les pronoms")
	pronounsScreenNode.set_hidden(false)
	multipleChoiceBox.set_hidden(true)
	set_up_lesson_plan()
	menuNode.set_hidden(true)
	menuNode.lesson_plan_shown = false
	menuNode.chapterIsChanging = false
	multipleChoiceBox.correctIndex = 0
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
		if pronounsScreenNode.is_visible():
			pronounsScreenNode.set_hidden(true)
			introSceneDone = true
	
	if introSceneDone:
		intro_dialgogue_pronouns()
		introSceneDone = false
	
	if familyDialogueStarted and dialogueBox.is_visible():
		if dialogueBox.currentText == 2:
			get_node("exclamation_mother").set_hidden(false)
		elif dialogueBox.currentText == 4:
			get_node("exclamation_father").set_hidden(false)
		elif dialogueBox.currentText == 6:
			get_node("exclamation_brother").set_hidden(false)
			get_node("area_brother/Sprite").set_frame(7)
		elif dialogueBox.currentText == 8:
			get_node("exclamation_grandma").set_hidden(false)
			get_node("area_grandma/Sprite").set_frame(7)
		elif dialogueBox.currentText == 10:
			get_node("exclamation_cousin").set_hidden(false)
			get_node("area_cousin/Sprite").set_frame(7)
		else:
			get_node("exclamation_brother").set_hidden(true)
			get_node("exclamation_mother").set_hidden(true)
			get_node("exclamation_father").set_hidden(true)
			get_node("exclamation_cousin").set_hidden(true)
			get_node("exclamation_grandma").set_hidden(true)
	if get_node("exclamation_cousin").is_visible() and !dialogueBox.is_visible():
		get_node("exclamation_cousin").set_hidden(true)
		familyDialogueDone = true
		time_delta = 0
	
	if time_delta > 0.2 and familyDialogueDone:
		familyDialogueDone = false
		player_pos = playerNode.get_pos()
		multipleChoiceBox.set_pos(Vector2(player_pos.x-76, player_pos.y-45))
		multipleChoiceBox.get_node("grandma").set_hidden(false)
		multipleChoiceStarted = true
		multipleChoiceBox.show()

	
	if pronounsScreenNode.is_visible(): # navigate the lesson plan
		if right_trigger or pronounsScreenNode.get_node("right_button").is_pressed():
			if lesson_plan_page < lesson_plan_text.size()-1: 
				lesson_plan_page += 1
				pronounsScreenNode.get_node("describing_text").set_bbcode(lesson_plan_text[lesson_plan_page])
				OS.delay_msec(150) #pause so it doesnt skip to the next screen
			right_trigger = false
		elif left_trigger or pronounsScreenNode.get_node("left_button").is_pressed():
			if lesson_plan_page > 0:
				lesson_plan_page -= 1
				pronounsScreenNode.get_node("describing_text").set_bbcode(lesson_plan_text[lesson_plan_page])
				OS.delay_msec(150)
			left_trigger = false 
			
			
	# Block movements when an popup/dialogue box is open
	if scorePopupNode.is_visible() or get_node("dialogue_box").is_visible() or menuNode.is_visible() or alertNode.is_visible() or matchingBox.is_visible() or get_node("multiple_choice2").is_visible() or get_node("multiple_choice3").is_visible() or multipleChoiceBox.is_visible() or pronounsScreenNode.is_visible() or dialogueBox.is_visible() or get_node("pronouns_alert").is_visible():
		disable_movements()
	else:
		enable_movements()
	
	if multipleChoiceSelected:
		if correctMultipleChoice:
			_handle_next_question()
			multipleChoiceSelected = false
	if multipleChoiceDone:
		multipleChoiceBox.set_hidden(true)
		correct_popup()
		endOfChapterStart = true
		multipleChoiceDone = false
	interact = false
	
	if !alertNode.is_visible() and endOfChapterStart:
		player_pos = playerNode.get_pos()
		get_node("pronouns_alert").set_title("Alerte")
		get_node("pronouns_alert").set_pos(Vector2(player_pos.x-76, player_pos.y-58))
		get_node("pronouns_alert").set_hidden(false)
		endOfChapterStart = false

	if get_node("pronouns_alert").is_visible() and !endPersonSelect:
		endPersonSelect = true
		startFinalMultipleChoice = true
	
	if startFinalMultipleChoice and !get_node("pronouns_alert").is_visible():
		startFinalMultipleChoice = false
		player_pos = playerNode.get_pos()
		get_node("multiple_choice2").correctIndex = 1
		get_node("multiple_choice2").set_pos(Vector2(player_pos.x-76, player_pos.y-45))
		get_node("multiple_choice2").set_hidden(false)
		lastQuestionStarted = true
	
	if !get_node("multiple_choice2").is_visible() and lastQuestionStarted:
		lastQuestionStarted = false
		if singleton.multiple_choice_complete:
			correct_popup()
			chapterChallegeBegin = true
			singleton.multiple_choice_complete = false
		elif !wrong_choice:
			chapter_score -= 4
			incorrect_popup()
			wrong_choice = true
			q2_redo = true
			lastQuestionStarted = true
	
	if wrong_choice and !alertNode.is_visible():
		wrong_choice = false
		if q2_redo:
			q2_redo = false
			lastQuestionStarted = true
			get_node("multiple_choice2").set_hidden(false)
		if q3_redo:
			q3_redo = false
			finalQuestionStart = true
			get_node("multiple_choice3").set_hidden(false)

	
			
	if !alertNode.is_visible() and chapterChallegeBegin:
		chapterChallegeBegin = false
		get_node("multiple_choice3").correctIndex = 0
		get_node("multiple_choice3").set_pos(Vector2(player_pos.x-76, player_pos.y-45))
		get_node("multiple_choice3").set_hidden(false)
		finalQuestionStart = true
	
	if !get_node("multiple_choice3").is_visible() and finalQuestionStart:
		finalQuestionStart = false
		if singleton.multiple_choice_complete:
			correct_popup()
			endChapterChallenge = true
			singleton.multiple_choice_complete = false
		elif !wrong_choice:
			chapter_score -= 4
			incorrect_popup()
			wrong_choice = true
			q3_redo = true
			finalQuestionStart = false

	if endChapterChallenge and !alertNode.is_visible() and !startMatching:
		startMatching = true
		player_pos = playerNode.get_pos()
		matchingBox.set_pos(Vector2(player_pos.x-76, player_pos.y-65))
		matchingBox.set_hidden(false)
	
	if matchingBox.get_node("OK").is_pressed():
		matchingBox.set_hidden(true)
		score_popup()

	if scorePopupNode.is_visible():
		# score < 80 and resart chapter pressed
		if scorePopupNode.get_node("restart_chapter_level").is_pressed() and !chapter_done:
			chapter_done = true # do block once
			get_tree().change_scene("res://chapters/chapter_04/inside_world_pronouns.tscn")
			#not sure if i need to free this scene
			self.queue_free()
		# score >= 80 and next chapter button pressed
		if scorePopupNode.get_node("next_chapter_button").is_pressed() and !chapter_done:
			scorePopupNode.get_node("next_chapter_pw").set_text(singleton.chapter_passwords[3])
			chapter_done = true
			#set to a random scene for now. This will be to chapter 2
			get_tree().change_scene("res://chapters/chapter_05/ch5_classroom_world.tscn")
	#if !get_node("multiple_choice3").is_visible() and finalQuestionStart:
		#finalQuestionStart = false
		#if singleton.multiple_choice_complete:
		#	correct_popup()
		#	singleton.multiple_choice_complete = false
		#	endChapterChallenge = true
		#else:
		#	get_node("multiple_choice3").set_hidden(false)
		#	finalQuestionStart = true
		
		
	#if !alertNode.is_visible() and endChapterChallenge:
		#endChapterChallenge = false
func score_popup():
	player_pos = playerNode.get_pos()
	scorePopupNode.set_pos(Vector2(player_pos.x-100, player_pos.y-75))
	scorePopupNode.set_hidden(false)
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
		

func _handle_next_question():
	if multipleChoiceSprite == 0:
		multipleChoiceBox.get_node("grandma").hide()
		multipleChoiceBox.get_node("mother").show()
	elif multipleChoiceSprite == 1:
		multipleChoiceBox.get_node("mother").hide()
		multipleChoiceBox.get_node("brother").show()
	elif multipleChoiceSprite == 2:
		multipleChoiceBox.get_node("brother").hide()
		multipleChoiceBox.get_node("father").show()
	elif multipleChoiceSprite == 3:
		multipleChoiceBox.get_node("father").hide()
		multipleChoiceBox.get_node("cousin").show()
	else:
		multipleChoiceBox.get_node("grandma").hide()
		multipleChoiceBox.get_node("mother").hide()
		multipleChoiceBox.get_node("father").hide()
		multipleChoiceBox.get_node("brother").hide()
		multipleChoiceBox.get_node("cousin").hide()
	multipleChoiceSprite += 1

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

func intro_dialgogue_pronouns():
	player_pos = playerNode.get_pos() #get position of the player to place the dialogue box
	dialogueBox.set_pos(Vector2(player_pos.x-76, player_pos.y+31)) #hardcoded distance to position middle bottom
	dialogueBox.set_hidden(false)
	dialogueBox._print_dialogue(get_node("dialogueObj/StaticBody2D/Interact").text) 

func family_dialgogue_pronouns():
	player_pos = playerNode.get_pos() #get position of the player to place the dialogue box
	dialogueBox.set_pos(Vector2(player_pos.x-76, player_pos.y+31)) #hardcoded distance to position middle bottom
	dialogueBox.set_hidden(false)
	dialogueBox._print_dialogue(get_node("dialogueObj1/StaticBody2D/Interact").text) 

func set_up_lesson_plan():
	lesson_plan_text = singleton.pronounsLessonPlanText
	pronounsScreenNode.get_node("title1").set_text("Les pronoms")
	pronounsScreenNode.get_node("intro_text").set_hidden(true)
	pronounsScreenNode.get_node("describing_text").set_bbcode(lesson_plan_text[0])
	
func disable_movements():
	directionNode.hide()
	compassNode.hide()
	playerNode.canMove = false

func enable_movements():
	directionNode.show()
	compassNode.show()
	playerNode.canMove = true

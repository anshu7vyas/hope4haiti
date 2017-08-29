extends Node2D
# Pronouns inside world script - inside_world_pronouns.gd

var lesson_plan_bottomtext = singleton.pronounsLessonPlanText

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
onready var scorePopupNode = get_node("chapter_score")



func _ready():
	set_process_input(true)
	set_fixed_process(true)
	directionNode.show()
	compassNode.show()
	
	
	pronounsScreenNode.get_node("title1").set_text("Les pronoms")
	pronounsScreenNode.set_hidden(false)
	

	multipleChoiceBox.set_hidden(true)
	set_up_lesson_plan()

	
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
	print(chapter_score)
	if interact: # space bar pressed
		if pronounsScreenNode.is_visible():
			pronounsScreenNode.set_hidden(true)
			introSceneDone = true
	
	if introSceneDone:
		intro_dialgogue_pronouns()
		introSceneDone = false
	

	
	if time_delta > 0.2 and familyDialogueDone:
		familyDialogueDone = false
		player_pos = playerNode.get_pos()
		multipleChoiceBox.set_pos(Vector2(player_pos.x-76, player_pos.y-45))
		multipleChoiceBox.get_node("grandma").set_hidden(false)
		multipleChoiceStarted = true
		multipleChoiceBox.show()

	
	if pronounsScreenNode.is_visible(): # navigate the lesson plan
		if right_trigger or pronounsScreenNode.get_node("right_button").is_pressed():
			if lesson_plan_page < lesson_plan_bottomtext.size()-1: 
				lesson_plan_page += 1
				pronounsScreenNode.get_node("describing_text").set_bbcode(lesson_plan_bottomtext[lesson_plan_page])
				OS.delay_msec(150) #pause so it doesnt skip to the next screen
			right_trigger = false
		elif left_trigger or pronounsScreenNode.get_node("left_button").is_pressed():
			if lesson_plan_page > 0:
				lesson_plan_page -= 1
				pronounsScreenNode.get_node("describing_text").set_bbcode(lesson_plan_bottomtext[lesson_plan_page])
				OS.delay_msec(150)
			left_trigger = false 
			
			
	# Block movements when an popup/dialogue box is open
	if singleton.message_done:
		if alertNode.is_visible() or multipleChoiceBox.is_visible() or pronounsScreenNode.is_visible() or dialogueBox.is_visible():
			disable_movements()
		else:
			enable_movements()
	else:
		disable_movements()
		
	
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
	


	if scorePopupNode.is_visible():
		# score < 80 and resart chapter pressed
		if scorePopupNode.get_node("restart_chapter_level").is_pressed() and !chapter_done:
			chapter_done = true # do block once
			print("her")
			get_tree().change_scene("res://chapters/chapter_03/ch3_outside_possesive_noun.tscn")
			#not sure if i need to free this scene
			self.queue_free()
		# score >= 80 and next chapter button pressed
		if scorePopupNode.get_node("next_chapter_button").is_pressed() and !chapter_done:
			scorePopupNode.get_node("next_chapter_pw").set_text("f5hi2x")
			chapter_done = true
			#set to a random scene for now. This will be to chapter 2
			print("her4")
			get_tree().change_scene("res://chapters/chapter_02/outside_world_nouns.tscn")


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

func set_up_lesson_plan():
	lesson_plan_bottomtext = singleton.pronounsLessonPlanText
	pronounsScreenNode.get_node("title1").set_text("Les pronoms")
	pronounsScreenNode.get_node("intro_text").set_hidden(true)
	pronounsScreenNode.get_node("describing_text").set_bbcode(lesson_plan_bottomtext[0])
	
func disable_movements():
	directionNode.hide()
	compassNode.hide()
	playerNode.canMove = false

func enable_movements():
	directionNode.show()
	compassNode.show()
	playerNode.canMove = true

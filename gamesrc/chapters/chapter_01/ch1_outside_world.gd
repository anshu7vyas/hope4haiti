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
onready var endPopupNode = get_node("end_alert")
onready var scorePopupNode = get_node("chapter_score")

var alert_done = false
var neighbor_1_alerted = false
var neighbor_1_done = false
var in_multiple_choice = false
var first_multiple_choice_section_done = false
var second_multiple_choice_done = false
var merchant_alerted = false
var merchant_done = false 
var end_pop_up_shown = false
var in_multiple_choice2 = false
var scene_complete = false
var interact = false
var left_trigger = false
var right_trigger = false
var time_delta = 0
var lesson_plan_page = 0
var chapter_score = 60
var chapter_done = false

var playerPos

var lesson_plan_bottomtext = singleton.grettingsLessonPlanText
var question_count = 0
var question_answers = 0
var multipleChoiceQuestion = singleton.greetingsMultipleChoiceQuestions
var multipleChoiceAnswers = singleton.greetingsMultipleChoiceAnswers
var multipleChoiceCorrectIndex = singleton.greetingsMultipleChoiceCorrectIndices

func _ready():
	set_process_input(true)
	set_fixed_process(true)
	destinationNode.set_pos(Vector2(136,8))
	directionNode.show()
	compassNode.show()
	greetingsScreenNode.set_hidden(false)
	multipleChoiceQuestion = singleton.greetingsMultipleChoiceQuestions
	multipleChoiceAnswers = singleton.greetingsMultipleChoiceAnswers
	multipleChoiceCorrectIndex = singleton.greetingsMultipleChoiceCorrectIndices
	get_node("multiple_choice").correctIndex = multipleChoiceCorrectIndex[0]
	singleton.message_done = true
	singleton.wrong_choice = false
	singleton.multiple_choice_complete = false
	set_up_lesson_plan()

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
		if greetingsScreenNode.is_visible():
			greetingsScreenNode.set_hidden(true) #dismiss lesson plan shown at start of the scene
			
	# Fix Neighbor facing direction
	if singleton.message_done and neighbor_1_alerted:
		neighbor_1_alerted = false
		neighbor_1_done = true
		get_node("Area2D/neighbor1").set_frame(1)
	# Neighbor dialogue done -> start questions
	if neighbor_1_done:
		neighbor_1_done = false
		multiple_choice_question_setup()
		multiple_choice_challenge()
		in_multiple_choice = true
	
	# if question answered wrong and alert bubble has been dismissed -> retry same question
	if in_multiple_choice and singleton.wrong_choice and !alertBox.is_visible(): 
		singleton.wrong_choice = false
		multiple_choice_question_setup()
		multiple_choice_challenge()
	# if question is correct and alert bubble dismissed -> go to next question
	if !alertBox.is_visible() and singleton.correct_answer_chosen and in_multiple_choice:
		singleton.correct_answer_chosen = false
		question_count += 1
		question_answers += 3 # greetingsAnswers (in singleton) move to next set of answers (every 3)
		if question_count < 4: #still questions left -> go to next question
			multiple_choice_question_setup()
			multiple_choice_challenge()
		elif !first_multiple_choice_section_done: #done with first section of multiple choice questions
			first_multiple_choice_section_done = true
			in_multiple_choice = false
	
	if merchant_alerted:
		if dialogueNode.currentText == 5: #move banana when text reaches this line
			get_node("banana").set_pos(Vector2(440, -168))
		elif dialogueNode.currentText == 7: # move to Player
			get_node("banana").set_pos(Vector2(440, -152))
		if singleton.message_done: #hide the banana when convo done
			get_node("banana").set_hidden(true)
			merchant_alerted = false
			merchant_done = true
	
	# After merchant dialogue done show a popup
	if merchant_done:
		merchant_done = false
		end_merchant_popup()
	# After popup dismissed start multiple choice questions
	if end_pop_up_shown and !endPopupNode.is_visible():
		end_pop_up_shown = false
		question_count = 4 #start index of new questions
		question_answers = 12 #start index of question answers
		multiple_choice_question_setup()
		multiple_choice_challenge()
		in_multiple_choice2 = true
	
	# Same style as first questions -> if wrong -> dismiss popup and try again
	if in_multiple_choice2 and singleton.wrong_choice and !alertBox.is_visible():
		singleton.wrong_choice = false
		multiple_choice_question_setup()
		multiple_choice_challenge()
	# if correct -> next question
	if !alertBox.is_visible() and singleton.correct_answer_chosen and in_multiple_choice2:
		singleton.correct_answer_chosen = false
		question_count += 1
		question_answers += 3
		if question_count < 8: 
			print("hereee")
			multiple_choice_question_setup()
			multiple_choice_challenge()
		elif !second_multiple_choice_done:
			second_multiple_choice_done = true
			in_multiple_choice2 = false
			
	# When second multiple choice questions done -> show end of chapter score
	if !alertBox.is_visible() and second_multiple_choice_done:
		score_popup()
	
	if scorePopupNode.is_visible():
		# score < 80 and resart chapter pressed
		if scorePopupNode.get_node("restart_chapter_level").is_pressed() and !chapter_done:
			chapter_done = true # do block once
			singleton.scene_1_restart = true #ignore info alerts in the inside scene this time
			get_tree().change_scene("res://chapters/chapter_01/inside_world.tscn")
			#not sure if i need to free this scene
			self.queue_free()
		# score >= 80 and next chapter button pressed
		if scorePopupNode.get_node("next_chapter_button").is_pressed() and !chapter_done:
			chapter_done = true
			#set to a random scene for now. This will be to chapter 2
			get_tree().change_scene("res://chapters/chapter_02/inside_world_verbs.tscn")
			

	# Block movements when an popup/dialogue box is open
	if singleton.message_done:
		if alertBox.is_visible() or multipleChoiceBox.is_visible() or greetingsScreenNode.is_visible() or endPopupNode.is_visible() and !scorePopupNode.is_visible():
			disable_movements()
		else:
			enable_movements()
	else:
		disable_movements()


func set_up_lesson_plan():
	lesson_plan_bottomtext = singleton.grettingsLessonPlanText
	greetingsScreenNode.get_node("title1").set_text("Les Salutations")
	greetingsScreenNode.get_node("intro_text").set_hidden(true)
	greetingsScreenNode.get_node("describing_text").set_bbcode(lesson_plan_bottomtext[0])

func score_popup():
	playerPos = playerNode.get_pos()
	scorePopupNode.set_pos(Vector2(playerPos.x-100, playerPos.y-75))
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


func end_merchant_popup():
	playerPos = get_node("Player").get_pos()
	endPopupNode.set_pos(Vector2(playerPos.x-76, playerPos.y-45))
	endPopupNode.show()
	end_pop_up_shown = true

func multiple_choice_challenge():
	disable_movements()
	playerPos = playerNode.get_pos()
	multipleChoiceBox.set_pos(Vector2(playerPos.x-76, playerPos.y-45))
	multipleChoiceBox.show()
	singleton.wrong_choice = false

func multiple_choice_question_setup():
	multipleChoiceBox.get_node("RichTextLabel").set_bbcode(multipleChoiceQuestion[question_count])
	multipleChoiceBox.get_node("Label1").set_text(multipleChoiceAnswers[question_answers])
	multipleChoiceBox.get_node("Label2").set_text(multipleChoiceAnswers[question_answers+1])
	multipleChoiceBox.get_node("Label3").set_text(multipleChoiceAnswers[question_answers+2])
	get_node("multiple_choice").correctIndex = multipleChoiceCorrectIndex[question_count]
	
func neighbor1_dialogue():
	if playerNode.get_pos().x < 110:
		get_node("Area2D/neighbor1").set_frame(10)
	elif playerNode.get_pos().x > 120:
		get_node("Area2D/neighbor1").set_frame(4)
	playerPos = playerNode.get_pos() #get position of the player to place the dialogue box
	get_node("dialogue_box").set_pos(Vector2(playerPos.x-76, playerPos.y+31)) #hardcoded distance to position middle bottom
	get_node("dialogue_box").set_hidden(false)
	get_node("dialogue_box")._print_dialogue(get_node("dialogeObj1/StaticBody2D/dialogue").text) 
	neighbor_1_alerted = true
	destinationNode.set_pos(Vector2(440,-136))

func merchant_dialogue():
	get_node("merchant/merchant").set_frame(7)
	playerPos = playerNode.get_pos() #get position of the player to place the dialogue box
	get_node("dialogue_box").set_pos(Vector2(playerPos.x-76, playerPos.y+31)) #hardcoded distance to position middle bottom
	get_node("dialogue_box").set_hidden(false)
	get_node("dialogue_box")._print_dialogue(get_node("dialogeObj2/StaticBody2D/dialogue").text) 
	merchant_alerted = true

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

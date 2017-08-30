# Chapter 1 - Scene 2 Outside Script (Entire World)
extends Node2D

onready var alertBox = get_node("control_alerts")
onready var directionNode = get_node("direction_arrow")
onready var compassNode = get_node("compassBG")
onready var multipleChoiceBox = get_node("multiple_choice")
onready var playerNode = get_node("Player")
onready var possesiveNounsScreenNode = get_node("lesson_plan")
onready var dialogueNode = get_node("dialogue_box")
onready var endPopupNode = get_node("end_alert")
onready var scorePopupNode = get_node("chapter_score")
onready var sentenceInfoBox = get_node("sentance_info")


var alert_done = false
var stranger_alerted = false
var stranger_part1_done = false
var multiple_choice_started = false
var first_multiple_choice_done = false
var end_first_multiple_choice = false
var second_multiple_choice_done = false
var end_chapter_popup_visible = false
var sentence_info_text_done = false
var stranger_alerted2 = false
var showing_mp_1 = false
var info_label_done = false
var wrong_answer = false
var scene_complete = false
var question_3_started = false
var question_4_started = false
var interact = false
var time_delta = 0
var lesson_plan_page = 0
var chapter_score = 100
var chapter_done = false


var playerPos

var lesson_plan_bottomtext = singleton.possesiveNounLessonPlanText
var question_count = 0
var question_answers = 0
var multipleChoiceQuestion = singleton.possNounsMultipleChoiceQuestions
var multipleChoiceAnswers = singleton.possNounsMultipleChoiceAnswers
var multipleChoiceCorrectIndex = singleton.possNounsMultipleChoiceCorrectIndices

func _ready():
	set_process_input(true)
	set_fixed_process(true)
	singleton.currentChapter = 2
	directionNode.show()
	compassNode.show()
	possesiveNounsScreenNode.set_hidden(false)
	multipleChoiceQuestion = singleton.possNounsMultipleChoiceQuestions
	multipleChoiceAnswers = singleton.possNounsMultipleChoiceAnswers
	multipleChoiceCorrectIndex = singleton.possNounsMultipleChoiceCorrectIndices
	get_node("multiple_choice").correctIndex = multipleChoiceCorrectIndex[0]
	singleton.message_done = true
	singleton.wrong_choice = false
	singleton.multiple_choice_complete = false
	get_node("exclamation").set_hidden(true)
	set_up_lesson_plan()

func _input(event):
	if event.is_action_pressed("ui_interact"): #tab press to dismiss alert boxes and progress dialogue
		interact = true
	elif event.is_action_released("ui_interact"):
		interact = false
		
func show_sentence_structure_info():
	disable_movements()
	playerPos = playerNode.get_pos()
	sentenceInfoBox.set_pos(Vector2(playerPos.x-76, playerPos.y-48))
	sentenceInfoBox.show()
	sentence_info_text_done = true
	

func multiple_choice_challenge():
	disable_movements()
	playerPos = playerNode.get_pos()
	multipleChoiceBox.set_pos(Vector2(playerPos.x-76, playerPos.y-45))
	multipleChoiceBox.show()
	singleton.wrong_choice = false
	
func _fixed_process(delta):
	if first_multiple_choice_done and !alertBox.is_visible() and !showing_mp_1:
		showing_mp_1 = true 
		show_sentence_structure_info()
		first_multiple_choice_done = false
		interact = false
	
	if  sentenceInfoBox.is_visible() and interact and !info_label_done:
		info_label_done = true
		interact = false
		sentenceInfoBox.set_hidden(true)
		stranger_dialogue2()
	
	if question_3_started and first_multiple_choice_done and !alertBox.is_visible():
		question_3_started = false
		question_count += 1
		question_answers += 3
		multiple_choice_question_setup()
		multiple_choice_challenge()
		multiple_choice_started = true
		end_first_multiple_choice = false
		question_4_started = true
		
	
		
	if singleton.message_done and stranger_part1_done:
		stranger_part1_done = false
		multiple_choice_question_setup()
		multiple_choice_challenge()
		multipleChoiceBox.special_correct_popup = true
		multiple_choice_started = true
	
	if singleton.message_done and stranger_alerted2:
		stranger_alerted2 = false
		question_count += 1
		question_answers += 3
		multiple_choice_question_setup()
		multiple_choice_challenge()
		multiple_choice_started = true
		end_first_multiple_choice = false
		question_3_started = true
		
	if multiple_choice_started:
		playerPos = playerNode.get_pos()
		alertBox.set_pos(Vector2(playerPos.x-76, playerPos.y-45))
		if singleton.wrong_choice:
			chapter_score -= 5
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
		wrong_answer = false
	
	time_delta += delta
	if interact: # space bar pressed
		if possesiveNounsScreenNode.is_visible():
			possesiveNounsScreenNode.set_hidden(true) #dismiss lesson plan shown at start of the scene
			
	if !alert_done and !possesiveNounsScreenNode.is_visible():
		initial_popup()
		alert_done = true
	
	if stranger_alerted and dialogueNode.is_visible() and !singleton.message_done:
		if dialogueNode.currentText > 0:
			get_node("exclamation").set_hidden(true)
		if dialogueNode.currentText == 1:
			get_node("area_stranger/Sprite").set_frame(10)
			get_node("gatos").set_frame(5)
		if dialogueNode.currentText > 3:
			stranger_alerted = false
			stranger_part1_done = true
			
	# When second multiple choice questions done -> show end of chapter score
	if !alertBox.is_visible() and question_4_started and first_multiple_choice_done:
		question_4_started = false
		score_popup()
	
	if scorePopupNode.is_visible():
		# score < 80 and resart chapter pressed
		if scorePopupNode.get_node("restart_chapter_level").is_pressed() and !chapter_done:
			chapter_done = true # do block once
			singleton.scene_1_restart = true #ignore info alerts in the inside scene this time
			get_tree().change_scene("res://chapters/chapter_03/ch3_outside_possesive_noun.tscn")
			#not sure if i need to free this scene
			self.queue_free()
		# score >= 80 and next chapter button pressed
		if scorePopupNode.get_node("next_chapter_button").is_pressed() and !chapter_done:
			scorePopupNode.get_node("next_chapter_pw").set_text(singleton.chapter_passwords[2])
			chapter_done = true
			#set to a random scene for now. This will be to chapter 2
			
			get_tree().change_scene("res://chapters/chapter_04/inside_world_pronouns.tscn")
			

	# Block movements when an popup/dialogue box is open
	if singleton.message_done:
		if alertBox.is_visible() or multipleChoiceBox.is_visible() or possesiveNounsScreenNode.is_visible() or endPopupNode.is_visible() and scorePopupNode.is_visible() or sentenceInfoBox.is_visible():
			disable_movements()
		else:
			enable_movements()
	else:
		disable_movements()



func set_up_lesson_plan():
	lesson_plan_bottomtext = singleton.possesiveNounLessonPlanText
	possesiveNounsScreenNode.get_node("title1").set_text("Les noms possessifs")
	possesiveNounsScreenNode.get_node("intro_text").set_hidden(true)
	possesiveNounsScreenNode.get_node("describing_text").set_bbcode(lesson_plan_bottomtext[0])

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
		
func initial_popup():
	delete_alert_box_text()
	playerPos = get_node("Player").get_pos()
	alertBox.set_pos(Vector2(playerPos.x-76, playerPos.y-20))
	alertBox._print_alert_string("\n")
	alertBox.get_node("Label1").set_text("")
	alertBox.get_node("Label2").set_text("Dans le chapitre, nous suivrons\nle voisin de Marie-Thérèse, Sidney")
	alertBox.get_node("Label3").set_text("")
	alertBox.show()

func multiple_choice_question_setup():
	multipleChoiceBox.get_node("RichTextLabel").set_bbcode(multipleChoiceQuestion[question_count])
	multipleChoiceBox.get_node("Label1").set_text(multipleChoiceAnswers[question_answers])
	multipleChoiceBox.get_node("Label2").set_text(multipleChoiceAnswers[question_answers+1])
	multipleChoiceBox.get_node("Label3").set_text(multipleChoiceAnswers[question_answers+2])
	get_node("multiple_choice").correctIndex = multipleChoiceCorrectIndex[question_count]
	
func stranger_dialogue():
	playerPos = playerNode.get_pos() #get position of the player to place the dialogue box
	get_node("exclamation").set_pos(Vector2(playerPos.x, playerPos.y-26))
	get_node("exclamation").set_hidden(false)
	get_node("dialogue_box").set_pos(Vector2(playerPos.x-76, playerPos.y+31)) #hardcoded distance to position middle bottom
	get_node("dialogue_box").set_hidden(false)
	get_node("dialogue_box")._print_dialogue(get_node("dialogeObj1/StaticBody2D/dialogue").text) 
	stranger_alerted = true
	
func stranger_dialogue2():
	playerPos = playerNode.get_pos() #get position of the player to place the dialogue box
	get_node("dialogue_box").set_pos(Vector2(playerPos.x-76, playerPos.y+31)) #hardcoded distance to position middle bottom
	get_node("dialogue_box").set_hidden(false)
	get_node("dialogue_box")._print_dialogue(get_node("dialogeObj2/StaticBody2D/dialogue").text) 
	stranger_alerted2 = true

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

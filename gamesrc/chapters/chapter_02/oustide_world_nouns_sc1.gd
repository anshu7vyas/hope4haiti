# Chapter 2: Scene 1 Outside Script (Entire World)
extends Node2D

onready var alert_box = get_node("control_alerts")
onready var directionNode = get_node("direction_arrow")
onready var destinationNode = get_node("destinationObj")
onready var compassNode = get_node("compassBG")
onready var tie = get_node("PopupDialog/TextInterfaceEngine")
onready var sentence_info_text = get_node("sentance_info/TextInterfaceEngine")
onready var nameChallengeBox = get_node("PopupDialog")
onready var sentenceInfoBox = get_node("sentance_info")
onready var playerNode = get_node("Player")
onready var nounsScreenNode = get_node("lesson_plan")

var alert_done = false
var neighbor1_alerted = false
var neighbor2_alerted = false
var neighbor2_done = false
var name_challenge_start = false
var name_challenge_done = false
var wrong_answer_popup_shown = false
var emotion_dialogue_started = false
var emotion_dialogue_done = false
var emotion_challenge_printed = false
var final_convo_started = false
var final_alert_done = false
var sentence_info_text_done = false
var final_challenge_start = false
var scene_complete = false
var interact = false
var left_trigger = false
var right_trigger = false
var time_delta = 0
var lesson_plan_page = 0
var wrong_answer_count = 0
var player_pos
var name_challenge_text

var lesson_plan_toptext = singleton.nounsLessonPlanTop
var lesson_plan_bottomtext = singleton.nounsLessonPlanBottom

func _ready():
	set_process_input(true)
	set_fixed_process(true)
	directionNode.show()
	compassNode.show()
	nounsScreenNode.set_hidden(false)

	singleton.message_done = true
	singleton.wrong_choice = false
	singleton.multiple_choice_complete = false
	lesson_plan_bottomtext = singleton.nounsLessonPlanBottom
	
	tie.connect("input_enter", self, "_on_input_enter")
	tie.connect("buff_end", self, "_on_buff_end")
	tie.connect("enter_break", self, "_on_enter_break")
	

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
	#if event.is_action("ui_accept") && event.is_pressed() && !event.is_echo():

func _fixed_process(delta):
	time_delta += delta
	if interact: # space bar pressed
		if nounsScreenNode.is_visible():
			nounsScreenNode.set_hidden(true)
		if singleton.wrong_choice:
			alert_box.hide()
			multiple_choice_challenge()
		if singleton.multiple_choice_complete:
			scene_complete = true
		if final_challenge_start:
			multiple_choice_challenge()
			final_challenge_start = false
		if sentence_info_text_done and time_delta > 2: #allow hiding popup after 2 seconds
			enable_movements()
			sentenceInfoBox.hide()
			sentence_info_text_done = false
			final_challenge_start = true
		if name_challenge_done and !alert_box.is_visible():
			nameChallengeBox.hide()
			enable_movements()
		if wrong_answer_popup_shown and !alert_box.is_visible():
			print("here")
			wrong_answer_popup_shown = false # do once
			nameChallengeBox.set_hidden(false)
			correct_answer("")
			interact = false

				
	# Handle neighbor dialogue
	if neighbor2_alerted:
		if !alert_done:
			player_pos = playerNode.get_pos()
			neighbor2_popup_alert()
			#alert_box._print_alert(2) #alert text stored at index 2 in control_alert.gd-> alerts[]
			alert_box.set_pos(Vector2(player_pos.x-76, player_pos.y-20))
			#alert_box.show()
			alert_done = true
		if !alert_box.is_visible() and !neighbor2_done:
			neighbor2_dialogue()
			neighbor2_alerted = true
			neighbor2_done = true
	
	# Block movements when an popup/dialogue box is open
	if singleton.message_done:
		if alert_box.is_visible() or nameChallengeBox.is_visible() or sentenceInfoBox.is_visible() or nounsScreenNode.is_visible():
			disable_movements()
		else:
			enable_movements()
	else:
		disable_movements()
	
	# Handle input challenge popup
	if neighbor2_done and !name_challenge_start:
		if singleton.message_done:
			player_pos = playerNode.get_pos() #get position of the player to place the box
			get_node("PopupDialog").set_pos(Vector2(player_pos.x-76, player_pos.y-50)) #hardcoded distance to middle
			nameChallengeBox.show()
			name_challenge()
			playerNode.canMove = false
			name_challenge_start = true
			
	
func delete_alert_box_text():
	alert_box._print_alert_string("\n")
	alert_box.get_node("Label1").set_text("")
	alert_box.get_node("Label2").set_text("")
	alert_box.get_node("Label3").set_text("")

func neighbor2_popup_alert():
	delete_alert_box_text() #reset alert
	alert_box.set_title("Alerte")
	alert_box._print_alert_string("\n\n\n")
	alert_box.get_node("Label1").set_text("Maintenant, on va intégrer")
	alert_box.get_node("Label2").set_text("un nom important.\nRegardez attentivement.")
	alert_box.get_node("Label3").set_text("")
	alert_box.show()


func disable_movements():
	directionNode.hide()
	compassNode.hide()
	playerNode.canMove = false

func enable_movements():
	directionNode.show()
	compassNode.show()
	playerNode.canMove = true

func show_sentence_structure_info():
	disable_movements()
	player_pos = playerNode.get_pos()
	get_node("sentance_info").set_pos(Vector2(player_pos.x-76, player_pos.y))
	sentenceInfoBox.show()
	sentence_info_text.set_color(Color(1,1,1))
	sentence_info_text.buff_text("Regardons cette dernière phrase encore une fois: “I do not like mathematics.” Examinez la construction de la phrase ….\nPour former une phrase en anglais, on utilise toujours l'ordre: sujet + verbe + objet")
	sentence_info_text.set_state(tie.STATE_OUTPUT)
	sentence_info_text_done = true
	
	
func name_challenge():
	tie.set_color(Color(1,1,1))
	# Schedule an Input in the buffer, after all
	# the text before it is displayed
	tie.buff_text("Vous avez vu le nom ? Qu'est-ce que c'était ?\n", 0.01)
	tie.buff_input()
	tie.set_state(tie.STATE_OUTPUT)

func _on_input_enter(s):
	if playerNode.get_pos().x > 400: #position is close to school
		pass # old scene had stuff here but content shifted around
	else:
		tie.add_newline()
		if s == "school" or s == "School":
			correct_answer("Très bien ! ")
		else:
			wrong_answer_count += 1
			if wrong_answer_count > 2:  #Popup alert with correct answer after 3 tries
				tie.reset()
				nameChallengeBox.set_hidden(true)
				player_pos = playerNode.get_pos()
				delete_alert_box_text()
				alert_box.set_pos(Vector2(player_pos.x-76, player_pos.y-30))
				alert_box.set_title("Alerte")
				alert_box._print_alert_string("\n\n\n")
				alert_box.get_node("Label1").set_text("Non, ce n'est pas le cas.")
				alert_box.get_node("Label2").set_text("La bonne réponse que\nnous recherchions était:\n'school'")
				alert_box.get_node("Label3").set_text("")
				alert_box.show()
				wrong_answer_popup_shown = true
				wrong_answer_count = 0
			else:
				tie.buff_text("Non, ce n'est pas le cas. Réessayer!\n")
				tie.buff_input()
				tie.set_state(tie.STATE_OUTPUT)
	pass

func correct_answer(very_good):
	tie.reset()
	tie.set_color(Color(1,1,1))
	tie.buff_text(str(very_good)+"On continuera à apprendre de nouveaux noms partout dans notre histoire. Maintenant, vous allez voir un adjectif. En anglais, les noms ne sont ni masculins ni féminins, donc les adjectifs sont pareils pour les femmes et les hommes, et tous les objets ! Regardez attentivement.", 0.001)
	name_challenge_done = true
	wrong_answer_count = 0
	tie.set_state(tie.STATE_OUTPUT)
	destinationNode.set_pos(Vector2(472,184))
	scene_complete = true

func neighbor2_dialogue():
	player_pos = playerNode.get_pos() #get position of the player to place the dialogue box
	get_node("dialogue_box").set_pos(Vector2(player_pos.x-76, player_pos.y+31)) #hardcoded distance to position middle bottom
	get_node("dialogue_box").set_hidden(false)
	get_node("dialogue_box")._print_dialogue(get_node("dialogeObj2/StaticBody2D/dialogue").text) 
	destinationNode.set_pos(Vector2(488,200))


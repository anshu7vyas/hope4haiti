# Chapter 2: Scene 1 Outside Script (Entire World)
extends Node2D

onready var alert_box = get_node("control_alerts")
onready var directionNode = get_node("direction_arrow")
onready var destinationNode = get_node("destinationObj")
onready var dialogueBox = get_node("dialogue_box")
onready var compassNode = get_node("compassBG")
onready var playerNode = get_node("Player")
onready var nounsScreenNode = get_node("lesson_plan")
onready var animation = get_node("AnimationPlayer")
onready var multipleChoiceBox = get_node("multiple_choice")
onready var scorePopupNode = get_node("chapter_score")

var scene_complete = false
var interact = false
var left_trigger = false
var right_trigger = false
var neighbor1_freed = false
var neighbor1_done = false
var popup_done = false
var filling_water = false
var animation_complete = false
var neighbor2_enabled = false
var neighbor2_started = false
var set_happy_face = false
var multiple_choice_started = false
var first_multiple_choice_done = false
var end_first_multiple_choice = false
var end_chapter_popup_visible = false
var wrong_answer = false
var time_delta = 0
var lesson_plan_page = 0
var player_pos
var old_layer_mask = 0
var old_collision_mask = 0
var chapter_score = 60
var chapter_done = false




var lesson_plan_toptext = singleton.nounsLessonPlanTop
var lesson_plan_bottomtext = singleton.nounsLessonPlanBottom

func _ready():
	set_process_input(true)
	set_fixed_process(true)
	directionNode.show()
	compassNode.show()
	nounsScreenNode.set_hidden(true)
	get_node("pot_full").set_hidden(true)
	singleton.message_done = true
	singleton.wrong_choice = false
	singleton.multiple_choice_complete = false
	lesson_plan_bottomtext = singleton.nounsLessonPlanBottom
	animation.connect("finished", self, "playNextAnim")
	get_node("happy_emote").set_hidden(true)
	get_node("area_neighbor2").hide()
	disable_staticbody()
	playerNode.SPEED = 1
	

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
	
	if animation_complete and time_delta > 0.7:
		disable_movements()
		animation_complete = false
		playerNode.SPEED = 2
		popup_alert_sprint()
	
	if neighbor2_started and !singleton.message_done and !set_happy_face:
		if dialogueBox.currentText == 3:
			get_node("happy_emote").set_hidden(false)
		elif dialogueBox.currentText > 3:
			get_node("happy_emote").set_hidden(true)
			set_happy_face = true
	
	if set_happy_face and !multiple_choice_started and !dialogueBox.is_visible() and !first_multiple_choice_done:
		multiple_choice_challenge()
		multiple_choice_started = true
	
	#multiple choice script not working - doing manually in this scene
	if multiple_choice_started:
		player_pos = playerNode.get_pos()
		alert_box.set_pos(Vector2(player_pos.x-76, player_pos.y-45))
		if singleton.wrong_choice:
			singleton.wrong_choice = false
			alert_box.set_hidden(false)
			multipleChoiceBox.set_hidden(true)
			wrong_answer = true
		elif singleton.correct_answer_chosen:
			singleton.correct_answer_chosen = false
			alert_box.set_hidden(false)
			multiple_choice_started = false
			first_multiple_choice_done = true
			end_first_multiple_choice = true
			#multipleChoiceBox.queue_free()
	if wrong_answer and !alert_box.is_visible() and !end_first_multiple_choice:
		multipleChoiceBox.set_hidden(false)
		wrong_answer = false
		
	# When second multiple choice questions done -> show end of chapter score
	if end_first_multiple_choice and !alert_box.is_visible() and !end_chapter_popup_visible:
		end_chapter_popup_visible = true
		playerNode.SPEED = 1
		score_popup()
	
	if scorePopupNode.is_visible():
		# score < 80 and resart chapter pressed
		if scorePopupNode.get_node("restart_chapter_level").is_pressed() and !chapter_done:
			chapter_done = true # do block once
			get_tree().change_scene("res://chapters/chapter_02/outside_world_nouns.tscn")
			#not sure if i need to free this scene
			#self.queue_free()
		# score >= 80 and next chapter button pressed
		if scorePopupNode.get_node("next_chapter_button").is_pressed() and !chapter_done:
			chapter_done = true
			#set to a random scene for now. This will be to chapter 2
			get_tree().change_scene("res://chapters/chapter_02/inside_world_verbs.tscn")
			
	
	if !filling_water:
		set_pot_pos()
	
	if neighbor1_done and !neighbor1_freed:
		if playerNode.get_pos().y > 168:
			neighbor1_freed = true
			get_node("area_neighbor").queue_free()
	# Block movements when an popup/dialogue box is open
	if singleton.message_done:
		if alert_box.is_visible() or nounsScreenNode.is_visible() or animation.is_playing() or multipleChoiceBox.is_visible() or dialogueBox.is_visible() or scorePopupNode.is_visible():
			disable_movements()
		elif animation_complete and time_delta < 0.8:
			disable_movements()
		else:
			enable_movements()
	else:
		disable_movements()
		
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

func multiple_choice_challenge():
	disable_movements()
	player_pos = playerNode.get_pos()
	multipleChoiceBox.set_pos(Vector2(player_pos.x-76, player_pos.y-45))
	multipleChoiceBox.show()
	multipleChoiceBox.correctIndex = 1
	singleton.wrong_choice = false

func fill_water():
	player_pos = playerNode.get_pos()
	get_node("pot_empty").set_pos(Vector2(player_pos.x, player_pos.y-12))
	get_node("pot_full").set_pos(Vector2(player_pos.x, player_pos.y-12))
	filling_water = true
	animation.play("push_pot");

func playNextAnim():
	if(animation.get_current_animation() == "push_pot"):
		disable_movements()
		get_node("pot_empty").set_hidden(true)
		get_node("pot_full").set_hidden(false)
		animation.play("pull_pot")
		filling_water = false
		destinationNode.set_pos(Vector2(120,24))
		get_node("area_neighbor2").set_hidden(false)
		enable_staticbody()
		neighbor2_enabled = true
	if(animation.get_current_animation() == "pull_pot"):
		disable_movements()
		time_delta = 0
		animation_complete = true
		

func set_pot_pos():
	player_pos = playerNode.get_pos()
	get_node("pot_empty").set_pos(Vector2(player_pos.x, player_pos.y-12))
	get_node("pot_full").set_pos(Vector2(player_pos.x, player_pos.y-12))
	
func neighbor_dialogue1():
	player_pos = playerNode.get_pos() #get position of the player to place the dialogue box
	if player_pos.x > 184:
		get_node("area_neighbor/Sprite").set_frame(4)
	else:
		get_node("area_neighbor/Sprite").set_frame(10)
	get_node("dialogue_box").set_pos(Vector2(player_pos.x-76, player_pos.y+31)) #hardcoded distance to position middle bottom
	get_node("dialogue_box").set_hidden(false)
	get_node("dialogue_box")._print_dialogue(get_node("dialogeObj2/StaticBody2D/dialogue").text) 
	destinationNode.set_pos(Vector2(-8,248))
	neighbor1_done = true
	
func neighbor2_dialogue():
	player_pos = playerNode.get_pos() #get position of the player to place the dialogue box
	if player_pos.x < 120:
		get_node("area_neighbor2/Sprite").set_frame(10)
		get_node("happy_emote").set_pos(Vector2(132,-6))
		get_node("happy_emote").set_flip_h(true)
	else:
		get_node("happy_emote").set_pos(Vector2(106,-6))
		get_node("happy_emote").set_flip_h(false)
		get_node("area_neighbor2/Sprite").set_frame(4)
	get_node("dialogue_box").set_pos(Vector2(player_pos.x-76, player_pos.y+31)) #hardcoded distance to position middle bottom
	get_node("dialogue_box").set_hidden(false)
	get_node("dialogue_box")._print_dialogue(get_node("dialogeObj3/StaticBody2D/dialogue").text) 
	destinationNode.set_pos(Vector2(-8,248))
	neighbor2_started = true

func enable_staticbody():
	get_node("area_neighbor2/StaticBody2D").set_layer_mask(old_layer_mask)
	get_node("area_neighbor2/StaticBody2D").set_collision_mask(old_collision_mask)
func disable_staticbody():
	old_layer_mask = get_node("area_neighbor2/StaticBody2D").get_layer_mask()
	old_collision_mask = get_node("area_neighbor2/StaticBody2D").get_collision_mask()
	get_node("area_neighbor2/StaticBody2D").set_layer_mask(0)
	get_node("area_neighbor2/StaticBody2D").set_collision_mask(0)
#func popup_alert_sprint():
#	delete_alert_box_text()
#	alert_box.set_title("Contrôles")
#	alert_box.get_node("Label2").set_text("Pour sprint, maintenez la touche\nTAB enfoncée tout en déplaçant")
#	player_pos = playerNode.get_pos()
#	alert_box.set_pos(Vector2(player_pos.x-76, player_pos.y-20))
#	alert_box.set_hidden(false)
#	alert_box.get_node("Label2").set_text("Pour sprint, maintenez la touche\nTAB enfoncée tout en déplaçant")

func popup_alert_sprint():
	delete_alert_box_text()
	alert_box.set_title("Alerte")
	alert_box._print_alert_string("\n\n\n\n")
	alert_box.get_node("Label2").set_text("Il devient trop tard, maintenant\nMarie-Thérèse va se << RUN >>\nà la maison au lieu de marcher")
	player_pos = playerNode.get_pos()
	alert_box.set_pos(Vector2(player_pos.x-76, player_pos.y-20))
	alert_box.set_hidden(false)
	
func delete_alert_box_text():
	alert_box._print_alert_string("\n")
	alert_box.get_node("Label1").set_text("")
	alert_box.get_node("Label2").set_text("")
	alert_box.get_node("Label3").set_text("")

func disable_movements():
	directionNode.hide()
	compassNode.hide()
	playerNode.canMove = false

func enable_movements():
	directionNode.show()
	compassNode.show()
	playerNode.canMove = true
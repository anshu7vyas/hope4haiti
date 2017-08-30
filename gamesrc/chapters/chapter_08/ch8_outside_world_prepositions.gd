extends Node2D

onready var alertNode = get_node("control_alerts")
onready var directionNode = get_node("direction_arrow")
onready var compassNode = get_node("compassBG")
onready var playerNode = get_node("Player")
onready var multipleChoiceBox = get_node("multiple_choice")
onready var dialogueBox = get_node("dialogue_box")
onready var scorePopupNode = get_node("chapter_score")
onready var prepositrionScreenNode = get_node("lesson_plan")


var time_delta = 0
var initial_popup_complete = false
var neighbor_dialogue_done = false
var instruction_started = false
var instruction_done = false
var multiple_choice_box = false
var multiple_choice_started = false
var wrong_answer = false
var first_multiple_choice_done = false
var end_first_multiple_choice = false
var chapter_done = false

var player_pos
var interact = false

var chapter_score = 100
var lesson_plan_page = 0
var lesson_plan_bottomtext = singleton.prepositionsLessonPlanText

func _ready():
	set_process_input(true)
	set_fixed_process(true)
	#get_node("Player").canMove = false
	enable_movements()
	directionNode.hide()
	compassNode.hide()
	singleton.wrong_choice = false
	singleton.multiple_choice_complete = false
	get_node("multiple_choice").correctIndex = 2
	set_up_lesson_plan()
	prepositrionScreenNode.set_hidden(false)

func _input(event):
	if event.is_action_pressed("ui_interact"): #tab press to dismiss alert boxes and progress dialogue
		interact = true
	elif event.is_action_released("ui_interact"):
		interact = false

func _fixed_process(delta):
	time_delta += delta
	
	if neighbor_dialogue_done and singleton.message_done and !instruction_started:
		instruction_alert()
		instruction_started = true
	
	if instruction_done and singleton.message_done and !multiple_choice_box and !alertNode.is_visible():
		multiple_choice_box = true
		multiple_choice_started = true
		multiple_choice_challenge()

	if multiple_choice_started:
		player_pos = playerNode.get_pos()
		alertNode.set_pos(Vector2(player_pos.x-76, player_pos.y-45))
		if singleton.wrong_choice:
			chapter_score -= 21
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
		first_multiple_choice_done = false
		score_popup()

	if scorePopupNode.is_visible():
		# score < 80 and resart chapter pressed
		if scorePopupNode.get_node("restart_chapter_level").is_pressed() and !chapter_done:
			chapter_done = true # do block once
			
			get_tree().change_scene("res://chapters/chapter_08/ch_8outside_world_prepasitions.tscn")
			#not sure if i need to free this scene
			self.queue_free()
		# score >= 80 and next chapter button pressed
		if scorePopupNode.get_node("next_chapter_button").is_pressed() and !chapter_done:
			scorePopupNode.get_node("next_chapter_pw").set_text("f5hi2x")
			chapter_done = true
			#set to a random scene for now. This will be to chapter 2
			get_tree().change_scene("res://chapters/chapter_09/ch9_inside_world_adverbs.tscn")

	
	if prepositrionScreenNode.is_visible() or scorePopupNode.is_visible() or alertNode.is_visible() or multipleChoiceBox.is_visible() or dialogueBox.is_visible():
		disable_movements()
	else:
		enable_movements()

func multiple_choice_challenge():
	player_pos = playerNode.get_pos()
	multipleChoiceBox.set_pos(Vector2(player_pos.x-76, player_pos.y-45))
	multipleChoiceBox.show()
	singleton.wrong_choice = false

func instruction_alert():
	player_pos = get_node("Player").get_pos() #get position of the player to place the dialogue box
	alertNode.set_pos(Vector2(player_pos.x-76, player_pos.y-20))
	alertNode._print_alert_string("\n\n")
	alertNode.get_node("Label1").set_text("qqch qui utilise ")
	alertNode.get_node("Label2").set_text('"before" and "after" and "between"')
	alertNode.get_node("Label3").set_text('qqch qui utilise "from" and "at"')
	alertNode.show()
	instruction_done = true
	
func neighbor_dialogue_predicate():
	# Set Mother's sprite direction facing
	if get_node("Player").get_pos().x < 328:
		get_node("area_neighbor/Sprite").set_frame(10)
	else:
		get_node("area_neighbor/Sprite").set_frame(4)

	player_pos = get_node("Player").get_pos() #get position of the player to place the dialogue box
	get_node("dialogue_box").set_pos(Vector2(player_pos.x-76, player_pos.y+31)) #hardcoded distance to position middle bottom
	get_node("dialogue_box").set_hidden(false)
	get_node("dialogue_box")._print_dialogue(get_node("dialogeObj1/StaticBody2D/dialogue").text) 
	neighbor_dialogue_done = true

func set_up_lesson_plan():
	lesson_plan_bottomtext = singleton.prepositionsLessonPlanText
	prepositrionScreenNode.get_node("title1").set_text("Les prépositions")
	prepositrionScreenNode.get_node("intro_text").set_hidden(true)
	prepositrionScreenNode.get_node("describing_text").set_bbcode(lesson_plan_bottomtext[0])

func delete_alert_box_text():
	alertNode._print_alert_string("\n")
	alertNode.get_node("Label1").set_text("")
	alertNode.get_node("Label2").set_text("")
	alertNode.get_node("Label3").set_text("")

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
		scorePopupNode.get_node("next_chapter_pw").set_hidden(true)
		scorePopupNode.get_node("next_chapter_button").set_hidden(true)
	else:
		scorePopupNode.get_node("failed_notes").set_hidden(true)
		scorePopupNode.get_node("restart_chapter_level").set_hidden(true)
		scorePopupNode.get_node("pass_chapter_notes").set_hidden(false)
		scorePopupNode.get_node("next_chapter_pw").set_hidden(false)
		scorePopupNode.get_node("next_chapter_button").set_hidden(false)
		
extends Node2D

onready var alertNode = get_node("control_alerts")
onready var directionNode = get_node("direction_arrow")
onready var compassNode = get_node("compassBG")
onready var playerNode = get_node("Player")
onready var multipleChoiceBox = get_node("multiple_choice")
onready var dialogueBox = get_node("startup_dialoge")
onready var adverbsScreenNode = get_node("lesson_plan")
onready var scorePopupNode = get_node("chapter_score")
onready var menuNode = get_node("Player/Camera2D/menu")
onready var fillinNode = get_node("fill_in")

var time_delta = 0
var initial_popup_complete = false
var dialogue_done = false
var multiple_choice_box = false
var final_challenge_start = false
var scene_complete = false
var claudine_dialogue_started = false
var claudine_dialogue2_started = false
var interacted = false
var conversation_complete = false
var multiple_choice_started = false
var multiple_choice1_started = false
var wrong_answer = false
var wrong_answer1 = false
var first_multiple_choice_done = false
var end_first_multiple_choice = false
var end_second_multiple_choice = false
var second_multiple_choice_done = false
var lesson_plan_page = 0
var chapter_score = 100
var end_chapter_popup_visible = false
var chapter_done = false
var fill_in_visible = false

var player_pos
var interact = false

var lesson_plan_text = singleton.adverbsLessonPlanBottom

func _ready():
	set_process_input(true)
	set_fixed_process(true)
	set_up_lesson_plan()
	directionNode.show()
	compassNode.show()
	adverbsScreenNode.set_hidden(false)
	menuNode.set_hidden(true)
	menuNode.lesson_plan_shown = false
	menuNode.chapterIsChanging = false
	singleton.wrong_choice = false
	singleton.correct_answer_chosen = false
	#singleton.correct_answer_chosen1 = false
	singleton.multiple_choice_complete = false
	
	get_node("multiple_choice").correctIndex = 0
	get_node("happy_mt").hide()
	#get_node("multiple_choice1").correctIndex = 2

func _input(event):
	if event.is_action_pressed("ui_interact"): #tab press to dismiss alert boxes and progress dialogue
		interact = true
	elif event.is_action_released("ui_interact"):
		interact = false

func _fixed_process(delta):
	time_delta += delta
	if interact and adverbsScreenNode.is_visible():
		interact = false
		adverbsScreenNode.set_hidden(true)
		
	if claudine_dialogue_started and !alertNode.is_visible() and !dialogueBox.is_visible():
		claudine_dialogue_started = false
		multiple_choice_challenge()
		get_node("happy_mt").hide()
		multiple_choice_started = true

	if dialogueBox.currentText == 1 and dialogueBox.is_visible() and !claudine_dialogue2_started:
		disable_movements()
		player_pos = get_node("Player").get_pos()
		get_node("happy_mt").set_pos(Vector2(player_pos.x-10, player_pos.y-25))
		get_node("happy_mt").show()

	#multiple choice script not working - doing manually in this scene
	if multiple_choice_started:
		player_pos = playerNode.get_pos()
		alertNode.set_pos(Vector2(player_pos.x-76, player_pos.y-45))
		if singleton.wrong_choice:
			singleton.wrong_choice = false
			chapter_score -= 5
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
		wrong_answer = false
	
	if first_multiple_choice_done and !alertNode.is_visible() and !second_multiple_choice_done:
		second_multiple_choice_done = true
		first_multiple_choice_done = false
		claudine_dialogue2()
		multipleChoiceBox.get_node("RichTextLabel").set_bbcode("Question: Maintenant, qu’est-ce que Claudine va faire?")
		multipleChoiceBox.get_node("Label1").set_text("a. dormir")
		multipleChoiceBox.get_node("Label2").set_text("b. manger")
		multipleChoiceBox.get_node("Label3").set_text("c. pratiquer avec Marie-Thérèse et Sidney")
		multipleChoiceBox.correctIndex = 2
		singleton.multiple_choice_complete = false
		end_first_multiple_choice = false
	
	if fillinNode.get_node("OK").is_pressed() and !end_chapter_popup_visible:
		end_chapter_popup_visible = true
		score_popup()
		
	
	if claudine_dialogue2_started and !dialogueBox.is_visible() and !dialogue_done:
		multiple_choice_started = true
		multiple_choice_challenge()
		dialogue_done = true
	
	if claudine_dialogue2_started and first_multiple_choice_done and !fill_in_visible:
		fill_in_visible = true
		end_chapter_challege()
		
	if menuNode.is_visible() or scorePopupNode.is_visible() or alertNode.is_visible() or multipleChoiceBox.is_visible() or dialogueBox.is_visible() or adverbsScreenNode.is_visible():
		disable_movements()
	else:
		enable_movements()
			
	if scorePopupNode.is_visible():
		# score < 80 and resart chapter pressed
		if scorePopupNode.get_node("restart_chapter_level").is_pressed() and !chapter_done:
			chapter_done = true # do block once
			
			get_tree().change_scene("res://chapters/chapter_09/ch9_inside_world_adverbs.tscn")
			#not sure if i need to free this scene
			#self.queue_free()
		# score >= 80 and next chapter button pressed
		if scorePopupNode.get_node("next_chapter_button").is_pressed() and !chapter_done:
			scorePopupNode.get_node("next_chapter_pw").set_text("Rvu9m7")
			chapter_done = true
			#set to a random scene for now. This will be to chapter 2
			get_tree().change_scene("res://chapters/chapter_10/ch10_soccer_world.tscn")
			
func end_chapter_challege():
	player_pos = playerNode.get_pos()
	fillinNode.set_pos(Vector2(player_pos.x-100, player_pos.y-75))
	fillinNode.set_hidden(false)

func multiple_choice_challenge():
	disable_movements()
	player_pos = playerNode.get_pos()
	multipleChoiceBox.set_pos(Vector2(player_pos.x-94, player_pos.y-45))
	multipleChoiceBox.show()
	singleton.wrong_choice = false

func delete_alert_box_text():
	alertNode._print_alert_string("\n\n\n")
	alertNode.get_node("Label1").set_text("")
	alertNode.get_node("Label2").set_text("")
	alertNode.get_node("Label3").set_text("")

func scene_intro_popup():
	delete_alert_box_text()
	alertNode.set_title("Alerte")
	alertNode._print_alert_string("\n\n\n")
	alertNode.get_node("Label1").set_text("")
	alertNode.get_node("Label2").set_text("Maintenant, Marie-Thérèse va aider\nmon père à cuisiner les plantains\nque j'ai déjà vus au marché")
	alertNode.get_node("Label3").set_text("")
	alertNode.show()

func claudine_dialogue():
	get_node("area_claudine/Sprite").set_frame(2)
	player_pos = get_node("Player").get_pos() #get position of the player to place the dialogue box
	get_node("startup_dialoge").set_pos(Vector2(player_pos.x-76, player_pos.y+31)) #hardcoded distance to position middle bottom
	get_node("startup_dialoge").set_hidden(false)
	get_node("startup_dialoge")._print_dialogue(get_node("dialogueObj/StaticBody2D/Interact").text) 
	claudine_dialogue_started = true


func claudine_dialogue2():
	player_pos = get_node("Player").get_pos() #get position of the player to place the dialogue box
	get_node("startup_dialoge").set_pos(Vector2(player_pos.x-76, player_pos.y+31)) #hardcoded distance to position middle bottom
	get_node("startup_dialoge").set_hidden(false)
	get_node("startup_dialoge")._print_dialogue(get_node("dialogueObj1/StaticBody2D/Interact").text) 
	claudine_dialogue2_started = true


func set_up_lesson_plan():
	lesson_plan_text = singleton.adverbsLessonPlanBottom
	adverbsScreenNode.get_node("title1").set_text("Les Adverbes")
	adverbsScreenNode.get_node("intro_text").set_hidden(true)
	adverbsScreenNode.get_node("describing_text").set_bbcode(lesson_plan_text[0])
	adverbsScreenNode.show()


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
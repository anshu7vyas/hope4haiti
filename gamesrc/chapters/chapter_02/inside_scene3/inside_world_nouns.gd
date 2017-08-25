extends Node2D

var currentScene = null

onready var alertNode = get_node("control_alerts")
onready var directionNode = get_node("direction_arrow")
onready var compassNode = get_node("compassBG")
onready var playerNode = get_node("Player")
onready var multipleChoiceBox = get_node("multiple_choice")
onready var dialogueBox = get_node("startup_dialoge")
onready var nounsScreenNode = get_node("lesson_plan")

var time_delta = 0
var initial_popup_complete = false
var mother_dialogue_done = false
var multiple_choice_box = false
var final_challenge_start = false
var scene_complete = false
var father_dialogue_started = false
var interacted = false
var conversation_complete = false
var multiple_choice_started = false
var multiple_choice2_started = false
var wrong_answer = false
var first_multiple_choice_done = false
var end_first_multiple_choice = false
var end_second_multiple_choice = false
var second_multiple_choice_done = false
var picked_up_pot = false

var player_pos
var interact = false

var lesson_plan_bottomtext = singleton.nounsLessonPlanBottom

func _ready():
	currentScene = get_tree().get_root().get_child(get_tree().get_root().get_child_count() -1)
	set_process_input(true)
	set_fixed_process(true)
	get_node("Player").canMove = false
	directionNode.hide()
	compassNode.hide()
	get_node("banana").set_hidden(true)
	get_node("exclamation").set_hidden(true)
	singleton.wrong_choice = false
	singleton.correct_answer_chosen = false
	singleton.multiple_choice_complete = false
	get_node("multiple_choice").correctIndex = 2
	get_node("multiple_choice2").correctIndex = 1

func _input(event):
	if event.is_action_pressed("ui_interact"): #tab press to dismiss alert boxes and progress dialogue
		interact = true
	elif event.is_action_released("ui_interact"):
		interact = false

func _fixed_process(delta):
	print(playerNode.get_pos())
	time_delta += delta
	if time_delta > 0.1 and !initial_popup_complete:
		get_node("Player").canMove = false
		scene_intro_popup()
		initial_popup_complete = true
	
	if father_dialogue_started and dialogueBox.is_visible():
		player_pos = playerNode.get_pos()
		if dialogueBox.currentText == 2:
			get_node("banana").set_pos(player_pos)
			get_node("banana").set_hidden(false)
		elif dialogueBox.currentText == 4:
			get_node("banana").set_pos(Vector2(-184,-48))
			get_node("area_father/Sprite").set_frame(1)
		elif dialogueBox.currentText == 6:
			get_node("exclamation").set_hidden(false)
		elif dialogueBox.currentText > 6:
			get_node("exclamation").set_hidden(true)
			father_dialogue_started = false #do once
			conversation_complete = true
			
	if conversation_complete and singleton.message_done and !dialogueBox.is_visible() and !first_multiple_choice_done:
		print("here1")
		conversation_complete = false
		multiple_choice_challenge()
		multiple_choice_started = true
	
	#multiple choice script not working - doing manually in this scene
	if multiple_choice_started:
		player_pos = playerNode.get_pos()
		alertNode.set_pos(Vector2(player_pos.x-76, player_pos.y-45))
		if singleton.wrong_choice:
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
		wrong_answer = false
		
	# second multiple choice
	if first_multiple_choice_done and !alertNode.is_visible():
		first_multiple_choice_done = false
		get_node("destinationObj").set_pos(Vector2(-120,-24)) # move desination to the pot
		multiple_choice_challenge2()
		multiple_choice2_started = true
	if multiple_choice2_started:
		player_pos = playerNode.get_pos()
		alertNode.set_pos(Vector2(player_pos.x-76, player_pos.y-45))
		if singleton.wrong_choice:
			singleton.wrong_choice = false
			alertNode.set_hidden(false)
			get_node("multiple_choice2").set_hidden(true)
			wrong_answer = true
		elif singleton.correct_answer_chosen:
			singleton.correct_answer_chosen = false
			alertNode.set_hidden(false)
			multiple_choice2_started = false
			second_multiple_choice_done = true
			end_second_multiple_choice = true
	if wrong_answer and !alertNode.is_visible() and !end_second_multiple_choice:
		get_node("multiple_choice2").set_hidden(false)
		wrong_answer = false
	
	#carry the pot
	if picked_up_pot:
		set_pot_pos()
	
	if time_delta > 0.05 and !alertNode.is_visible() and !father_dialogue_started:
		directionNode.show()
		compassNode.show()
	
	if alertNode.is_visible() or multipleChoiceBox.is_visible() or dialogueBox.is_visible() or get_node("multiple_choice2").is_visible():
		disable_movements()

func pick_up_pot():
	set_pot_pos()
	get_node("destinationObj").set_pos(Vector2(-56,296)) 
	picked_up_pot = true

func setScene(scene):
	#clean up the current scene
	currentScene.queue_free()
	#load the file passed in as the param "scene"
	var s = ResourceLoader.load(scene)
	#create an instance of our scene
	currentScene = s.instance()
	# add scene to root
	get_tree().get_root().add_child(currentScene)

func set_pot_pos():
	player_pos = playerNode.get_pos()
	get_node("pot_empty").set_pos(Vector2(player_pos.x, player_pos.y-12))
	
func multiple_choice_challenge():
	disable_movements()
	player_pos = playerNode.get_pos()
	multipleChoiceBox.set_pos(Vector2(player_pos.x-76, player_pos.y-45))
	multipleChoiceBox.show()
	singleton.wrong_choice = false

func multiple_choice_challenge2():
	disable_movements()
	#get_node("multiple_choice").correctIndex = 1
	player_pos = playerNode.get_pos()
	get_node("multiple_choice2").set_pos(Vector2(player_pos.x-76, player_pos.y-45))
	get_node("multiple_choice2").show()
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

func father_dialogue():
	disable_movements()
	if playerNode.get_pos().x < -184: #father x position
		get_node("area_father/Sprite").set_frame(10)
	else:
		get_node("area_father/Sprite").set_frame(4)
	directionNode.hide()
	compassNode.hide()
	player_pos = get_node("Player").get_pos() #get position of the player to place the dialogue box
	get_node("startup_dialoge").set_pos(Vector2(player_pos.x-76, player_pos.y+31)) #hardcoded distance to position middle bottom
	get_node("startup_dialoge").set_hidden(false)
	get_node("startup_dialoge")._print_dialogue(get_node("dialogueObj/StaticBody2D/Interact").text) 
	interacted = true
	father_dialogue_started = true

func set_up_lesson_plan():
	lesson_plan_bottomtext = singleton.nounsLessonPlanBottom
	nounsScreenNode.get_node("title1").set_text("Les Noms")
	nounsScreenNode.get_node("intro_text").set_hidden(true)
	nounsScreenNode.get_node("describing_text").set_bbcode(lesson_plan_bottomtext[0])


func disable_movements():
	directionNode.hide()
	compassNode.hide()
	playerNode.canMove = false

func enable_movements():
	directionNode.show()
	compassNode.show()
	playerNode.canMove = true

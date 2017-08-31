extends Node2D

onready var alertNode = get_node("control_alerts")
onready var directionNode = get_node("direction_arrow")
onready var compassNode = get_node("compassBG")
onready var playerNode = get_node("Player")
onready var multipleChoiceBox = get_node("multiple_choice")
onready var dialogueBox = get_node("startup_dialoge")
onready var verbsScreenNode = get_node("lesson_plan")
onready var spell_text = get_node("spelling_challenge/TextInterfaceEngine")
onready var spellingChallengeBox = get_node("spelling_challenge")
onready var scorePopupNode = get_node("chapter_score")

var time_delta = 0
var wrong_answer_count = 0
var initial_popup_complete = false
var mother_dialogue_done = false
var multiple_choice_started = false
var final_challenge_start = false
var scene_complete = false
var wrong_answer = false
var first_multiple_choice_done = false
var end_first_multiple_choice = false
var wrong_answer_popup_shown = false
var spell_challenge_done = false
var spell_challenge_started = false
var chapter_done_popup = false
var chapter_done = false
var dismiss_spell_box = false

var player_pos
var interact = false

var chapter_score = 100
var lesson_plan_page = 0
var lesson_plan_bottomtext = singleton.verbsLessonPlanText

func _ready():
	set_process_input(true)
	set_fixed_process(true)
	get_node("Player").canMove = false
	get_node("sad_emote").hide()
	directionNode.hide()
	compassNode.hide()
	singleton.wrong_choice = false
	singleton.multiple_choice_complete = false
	get_node("multiple_choice").correctIndex = 1
	set_up_lesson_plan()
	verbsScreenNode.set_hidden(false)
	
	spell_text.connect("input_enter", self, "_on_input_enter")
	spell_text.connect("buff_end", self, "_on_buff_end")
	spell_text.connect("enter_break", self, "_on_enter_break")	

func _input(event):
	if event.is_action_pressed("ui_interact"): #tab press to dismiss alert boxes and progress dialogue
		interact = true
	elif event.is_action_released("ui_interact"):
		interact = false

func _fixed_process(delta):
	time_delta += delta
	if interact and verbsScreenNode.is_visible():
		interact = false
		verbsScreenNode.set_hidden(true)
	
	if get_node("startup_dialoge").currentText == 2:
		disable_movements()
		player_pos = get_node("Player").get_pos()
		get_node("sad_emote").set_pos(Vector2(player_pos.x+10, player_pos.y-25))
		get_node("sad_emote").show()
	else:
		get_node("sad_emote").hide()
	
	if mother_dialogue_done and singleton.message_done and !multiple_choice_started and !final_challenge_start:
		disable_movements()
		multiple_choice_started = true
		final_challenge_start = true
		multiple_choice_challenge()
	
	
	if multiple_choice_started:
		player_pos = playerNode.get_pos()
		alertNode.set_pos(Vector2(player_pos.x-76, player_pos.y-45))
		if singleton.wrong_choice:
			chapter_score -= 11
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
		
	if first_multiple_choice_done and !spell_challenge_started and !alertNode.is_visible():
		spell_challenge_started = true
		player_pos = playerNode.get_pos() 
		spellingChallengeBox.set_pos(Vector2(player_pos.x-76, player_pos.y+15)) 
		spellingChallengeBox.show()
		spell_challenge()
	
	if interact and spellingChallengeBox.is_visible():
		if spell_challenge_done and !dismiss_spell_box:
			dismiss_spell_box = true
			spellingChallengeBox.set_hidden(true)
	
	if spell_challenge_done or wrong_answer_popup_shown:
		if !alertNode.is_visible() and !chapter_done_popup and !spellingChallengeBox.is_visible():
			score_popup()
			chapter_done_popup = true

	
	if scorePopupNode.is_visible():
		# score < 80 and resart chapter pressed
		if scorePopupNode.get_node("restart_chapter_level").is_pressed() and !chapter_done:
			chapter_done = true # do block once
			get_tree().change_scene("res://chapters/chapter_07/ch7_inside_world_verbs.tscn")
			#not sure if i need to free this scene
			self.queue_free()
		# score >= 80 and next chapter button pressed
		if scorePopupNode.get_node("next_chapter_button").is_pressed() and !chapter_done:
			scorePopupNode.get_node("next_chapter_pw").set_text(singleton.chapter_passwords[6])
			chapter_done = true
			#set to a random scene for now. This will be to chapter 2
			get_tree().change_scene("res://chapters/chapter_08/ch_8outside_world_prepasitions.tscn")
	
	if spellingChallengeBox.is_visible() or alertNode.is_visible() or multipleChoiceBox.is_visible() or dialogueBox.is_visible() or verbsScreenNode.is_visible():
		disable_movements()
	else:
		enable_movements()
		
func spell_challenge():
	spell_text.set_color(Color(1,1,1))
	# Schedule an Input in the buffer, after all
	# the text before it is displayed
	spell_text.buff_text("Alors, comment dit-on pratiquer en anglais ?\n", 0.01)
	spell_text.buff_input()
	spell_text.set_state(spell_text.STATE_OUTPUT)

func _on_input_enter(s):
	spell_text.add_newline()
	if s == "practice" or s == "Practice" or s == "practice " or s == " practice":
		spell_text.reset()
		spell_text.buff_text("Très bien ! C'est exact ! ", 0.001)
		spell_challenge_done = true
	else:
		wrong_answer_count += 1
		chapter_score -= 6
		if wrong_answer_count > 2:  #Popup alert with correct answer after 3 tries
			spell_text.reset()
			spellingChallengeBox.set_hidden(true)
			player_pos = playerNode.get_pos()
			delete_alert_box_text()
			alertNode.set_pos(Vector2(player_pos.x-76, player_pos.y-30))
			alertNode.set_title("Alerte")
			alertNode._print_alert_string("\n\n\n")
			alertNode.get_node("Label1").set_text("Non, ce n'est pas le cas.")
			alertNode.get_node("Label2").set_text("La bonne réponse que\nnous recherchions était:\n'practice'")
			alertNode.get_node("Label3").set_text("")
			alertNode.show()
			wrong_answer_popup_shown = true
			wrong_answer_count = 0
		else:

			spell_text.reset()
			spell_text.buff_text("Non, ce n'est pas le cas. Réessayer!\n")
			spell_text.buff_input()
			spell_text.set_state(spell_text.STATE_OUTPUT)


func set_up_lesson_plan():
	lesson_plan_bottomtext = singleton.verbsLessonPlanText
	verbsScreenNode.get_node("title1").set_text("Les Verbes")
	verbsScreenNode.get_node("intro_text").set_hidden(true)
	verbsScreenNode.get_node("describing_text").set_bbcode(lesson_plan_bottomtext[0])

func disable_movements():
	directionNode.hide()
	compassNode.hide()
	playerNode.canMove = false

func enable_movements():
	directionNode.show()
	compassNode.show()
	playerNode.canMove = true

func multiple_choice_challenge():
	disable_movements()
	player_pos = playerNode.get_pos()
	multipleChoiceBox.set_pos(Vector2(player_pos.x-76, player_pos.y-45))
	multipleChoiceBox.show()
	singleton.wrong_choice = false

func delete_alert_box_text():
	alertNode._print_alert_string("\n")
	alertNode.get_node("Label1").set_text("")
	alertNode.get_node("Label2").set_text("")
	alertNode.get_node("Label3").set_text("")

func verbs_intro_popup():
	alertNode.set_title("Alerte")
	alertNode._print_alert_string("\n\n\n")
	alertNode.get_node("Label1").set_text("Dans sa section:")
	alertNode.get_node("Label2").set_text("Nous allons voir comment les")
	alertNode.get_node("Label3").set_text("VERBES sont utilisés en anglais")
	alertNode.show()

func mother_dialogue():
	disable_movements()
	# Set Mother's sprite direction facing
	if get_node("Player").get_pos().y < get_node("area_mother/Sprite").get_pos().y:
		get_node("area_mother/Sprite").set_frame(4)
	else:
		get_node("area_mother/Sprite").set_frame(7)
	
	directionNode.hide()
	compassNode.hide()
	player_pos = get_node("Player").get_pos() #get position of the player to place the dialogue box
	get_node("startup_dialoge").set_pos(Vector2(player_pos.x-76, player_pos.y+31)) #hardcoded distance to position middle bottom
	get_node("startup_dialoge").set_hidden(false)
	get_node("startup_dialoge")._print_dialogue(get_node("dialogueObj/StaticBody2D/Interact").text) 
	mother_dialogue_done = true

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

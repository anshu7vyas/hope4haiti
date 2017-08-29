extends Node2D
#classroom scene

#The currently active scene
var currentScene = null

onready var alertBox = get_node("control_alerts")
onready var playerNode = get_node("Player")
onready var dialogueBox = get_node("dialogue_box")
onready var directionNode = get_node("direction_arrow")
onready var compassNode = get_node("compassBG")
onready var destinationNode = get_node("destinationObj")
onready var multipleChoiceBox = get_node("multiple_choice")
onready var adjectivesScreenNode = get_node("lesson_plan")
onready var school_text = get_node("emotion_challenge/TextInterfaceEngine")
onready var emotionChallengeBox = get_node("emotion_challenge")
onready var adjectivesBox = get_node("adjective_lesson")
onready var scorePopupNode = get_node("chapter_score")


var do_once = false
var interact
var player_pos
var time_delta = 0
var wrong_answer_count = 0
var in_multiple_choice = false
var syd_dialogue_started = false
var dialogue_done = false
var start_excited_challenge = false
var emotion_dialogue_done = false
var printing_question = false
var wrong_answer_popup_shown = false
var challenge_done = false
var assignment_alert = false
var mt_dialogue_started = false
var mt_dialogue_done = false
var multiple_choice_started  = false
var initiate_mc_question = false
var first_multiple_choice_done = false
var end_first_multiple_choice = false
var question2_started = false
var start_q3 = false
var start_q4 = false
var wrong_answer = false
var adjective_box_shown = false
var chapter_done = false
var chapter_done_popup = false
var special_alerts = ["Athletic = sportif / sportive", "Wise = sage", "", "Happy = heureux/heureuse"]

var chapter_score = 100
var lesson_plan_page = 0
var lesson_plan_bottomtext = singleton.adjectivesLessonPlanText
var question_count = 0
var question_answers = 0
var multipleChoiceQuestion = singleton.adjectivesMultipleChoiceQuestions
var multipleChoiceAnswers = singleton.adjectivesMultipleChoiceAnswers
var multipleChoiceCorrectIndex = singleton.adjectivesMultipleChoiceCorrectIndices

func _ready():
	#On load set the current scene to the last scene available
	currentScene = get_tree().get_root().get_child(get_tree().get_root().get_child_count() -1)
	set_process_input(true)
	set_fixed_process(true)
	directionNode.show()
	compassNode.show()
	multipleChoiceQuestion = singleton.adjectivesMultipleChoiceQuestions
	multipleChoiceAnswers = singleton.adjectivesMultipleChoiceAnswers
	multipleChoiceCorrectIndex = singleton.adjectivesMultipleChoiceCorrectIndices 
	get_node("multiple_choice").correctIndex = multipleChoiceCorrectIndex[0]
	singleton.message_done = true
	singleton.wrong_choice = false
	singleton.multiple_choice_complete = false
	set_up_lesson_plan()
	adjectivesScreenNode.set_hidden(false)
	wrong_answer = false
	adjective_box_shown = false
	chapter_done = false
	chapter_done_popup = false
	
	school_text.connect("input_enter", self, "_on_input_enter")
	school_text.connect("buff_end", self, "_on_buff_end")
	school_text.connect("enter_break", self, "_on_enter_break")
			
func _input(event):
	if event.is_action_pressed("ui_interact"): #tab press to dismiss alert boxes and progress dialogue
		interact = true
	elif event.is_action_released("ui_interact"):
		interact = false

func _fixed_process(delta):
	time_delta += delta
	if interact and adjectivesScreenNode.is_visible():
		adjectivesScreenNode.set_hidden(true)
		
	if syd_dialogue_started and !dialogue_done:
		if dialogueBox.currentText == 1:
			get_node("dialogeObj3/happy_emote").set_hidden(false)
		elif dialogueBox.currentText == 2:
			player_pos = playerNode.get_pos()
			get_node("dialogeObj3/sad_emote").set_pos(Vector2(player_pos.x-16, player_pos.y-60))
			get_node("dialogeObj3/sad_emote").set_hidden(false)
			dialogue_done = true
			
	if dialogue_done and !dialogueBox.is_visible() and !start_excited_challenge:
		get_node("dialogeObj3/sad_emote").set_hidden(true)
		get_node("dialogeObj3/happy_emote").set_hidden(true)
		start_excited_challenge = true
	
	if start_excited_challenge and !emotion_dialogue_done and !printing_question:
		printing_question = true
		player_pos = playerNode.get_pos() 
		emotionChallengeBox.set_pos(Vector2(player_pos.x-76, player_pos.y+15)) 
		emotionChallengeBox.show()
		emotion_challenge()

	if wrong_answer_popup_shown and !alertBox.is_visible() and interact and !challenge_done:
		wrong_answer_popup_shown = false # do once
		challenge_done = true
		emotionChallengeBox.set_hidden(true)
		interact = false
	
	if emotion_dialogue_done and emotionChallengeBox.is_visible() and interact:
		interact = false
		emotionChallengeBox.set_hidden(true)
		
	if challenge_done or emotion_dialogue_done: 
		if !assignment_alert and !emotionChallengeBox.is_visible() and !alertBox.is_visible():
			print("here")
			assignment_alert = true
			assignment_popup()
			mt_dialogue_started = true
	
	if mt_dialogue_started and !mt_dialogue_done and !alertBox.is_visible():
		print("here2")
		alertBox.set_hidden(true)
		mt_dialogue()
		mt_dialogue_done = true
		
	if mt_dialogue_done and !dialogueBox.is_visible() and !multiple_choice_started and !initiate_mc_question:
		initiate_mc_question = true
		multiple_choice_question_setup()
		multiple_choice_challenge()
		multiple_choice_started = true
		multipleChoiceBox.special_alert = true
		multipleChoiceBox.special_alert_text = special_alerts[question_count]
		
	if first_multiple_choice_done and !question2_started and !alertBox.is_visible():
		question_count += 1
		question_answers += 3
		multiple_choice_question_setup()
		multiple_choice_challenge()
		multipleChoiceBox.special_alert_text = special_alerts[question_count]
		multiple_choice_started = true
		end_first_multiple_choice = false
		question2_started = true
		first_multiple_choice_done = false
	
	if question2_started and !multipleChoiceBox.is_visible() and !alertBox.is_visible() and !adjective_box_shown and first_multiple_choice_done:
		adjective_box_shown = true
		player_pos = get_tree().get_current_scene().get_node("Player").get_pos()
		adjectivesBox.set_pos(Vector2(player_pos.x-100, player_pos.y-75))
		adjectivesBox.set_hidden(false)
		interact = false
	
	if interact and adjectivesBox.is_visible() and !start_q3:
		interact = false
		adjectivesBox.set_hidden(true)
		start_q3 = true
		question_count += 1
		question_answers += 3
		alertBox.set_hidden(true)
		multiple_choice_question_setup()
		multiple_choice_challenge()
		multipleChoiceBox.special_alert_text = special_alerts[question_count]
		multiple_choice_started = true
		end_first_multiple_choice = false
		first_multiple_choice_done = false
	
	if start_q3 and first_multiple_choice_done and !alertBox.is_visible() and !start_q4:
		interact = false
		start_q4 = true
		question_count += 1
		question_answers += 3
		alertBox.set_hidden(true)
		multiple_choice_question_setup()
		multiple_choice_challenge()
		multipleChoiceBox.special_alert_text = special_alerts[question_count]
		multiple_choice_started = true
		end_first_multiple_choice = false
		first_multiple_choice_done = false
	
	if start_q4 and !chapter_done_popup and !alertBox.is_visible() and first_multiple_choice_done:
		score_popup()
		chapter_done_popup = true
	
	if multipleChoiceBox.is_visible():
		alertBox.set_hidden(true)
		
	if scorePopupNode.is_visible():
		# score < 80 and resart chapter pressed
		if scorePopupNode.get_node("restart_chapter_level").is_pressed() and !chapter_done:
			chapter_done = true # do block once
			print("her")
			get_tree().change_scene("res://chapters/chapter_05/ch5_classroom_world.tscn")
			#not sure if i need to free this scene
			self.queue_free()
		# score >= 80 and next chapter button pressed
		if scorePopupNode.get_node("next_chapter_button").is_pressed() and !chapter_done:
			scorePopupNode.get_node("next_chapter_pw").set_text("f5hi2x")
			chapter_done = true
			#set to a random scene for now. This will be to chapter 2
			print("her4")
			get_tree().change_scene("res://chapters/chapter_06/ch6_inside_world.tscn")
			
	if multiple_choice_started:
		player_pos = playerNode.get_pos()
		alertBox.set_pos(Vector2(player_pos.x-76, player_pos.y-45))
		if singleton.wrong_choice:
			print("her8")
			chapter_score -= 4
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
		interact = false
		wrong_answer = false

	if scorePopupNode.is_visible() or dialogueBox.is_visible() or multipleChoiceBox.is_visible() or adjectivesScreenNode.is_visible() or emotionChallengeBox.is_visible() or alertBox.is_visible() or adjectivesBox.is_visible():
		disable_movements()
	else:
		enable_movements()

func mt_dialogue():
	playerNode.get_node("Sprite").set_frame(1)
	get_node("dialogue_box").set_pos(Vector2(player_pos.x-76, player_pos.y+31)) #hardcoded distance to position middle bottom
	get_node("dialogue_box").set_hidden(false)
	get_node("dialogue_box")._print_dialogue(get_node("dialogeObj4/StaticBody2D/dialogue").text) 

func assignment_popup():
	print("here3")
	player_pos = playerNode.get_pos()
	delete_alert_box_text()
	alertBox.set_pos(Vector2(player_pos.x-76, player_pos.y-30))
	alertBox.set_title("Alerte")
	alertBox._print_alert_string("\n\n\n")
	alertBox.get_node("Label1").set_text(" l'institutrice assigne un projet à")
	alertBox.get_node("Label2").set_text("Marie-Thérèse. Elle doit écrire quelques\n phrases en anglais qui décrivent des\n gens importants dans sa vie.")
	alertBox.get_node("Label3").set_text("")
	alertBox.show()

func setScene(scene):
	#clean up the current scene
	currentScene.queue_free()
	#load the file passed in as the param "scene"
	var s = ResourceLoader.load(scene)
	#create an instance of our scene
	currentScene = s.instance()
	# add scene to root
	get_tree().get_root().add_child(currentScene)

func multiple_choice_challenge():
	disable_movements()
	player_pos = playerNode.get_pos()
	multipleChoiceBox.set_pos(Vector2(player_pos.x-76, player_pos.y-45))
	multipleChoiceBox.show()
	singleton.wrong_choice = false

func multiple_choice_question_setup():
	multipleChoiceBox.get_node("RichTextLabel").set_bbcode(multipleChoiceQuestion[question_count])
	multipleChoiceBox.get_node("Label1").set_text(multipleChoiceAnswers[question_answers])
	multipleChoiceBox.get_node("Label2").set_text(multipleChoiceAnswers[question_answers+1])
	multipleChoiceBox.get_node("Label3").set_text(multipleChoiceAnswers[question_answers+2])
	get_node("multiple_choice").correctIndex = multipleChoiceCorrectIndex[question_count]

func sydney_dialogue():
	# 4= right 7=down
	player_pos = playerNode.get_pos() #get position of the player to place the dialogue box
	if player_pos.y > -40:
		get_node("area_sydney/Sprite").set_frame(7)
	elif player_pos.x > -104:
		get_node("area_sydney/Sprite").set_frame(4)
	get_node("dialogue_box").set_pos(Vector2(player_pos.x-76, player_pos.y+31)) #hardcoded distance to position middle bottom
	get_node("dialogue_box").set_hidden(false)
	get_node("dialogue_box")._print_dialogue(get_node("dialogeObj3/StaticBody2D/dialogue").text) 
	syd_dialogue_started = true

func emotion_challenge():
	school_text.set_color(Color(1,1,1))
	# Schedule an Input in the buffer, after all
	# the text before it is displayed
	school_text.buff_text("Selon le contexte, que signifie « excited » ?\n", 0.01)
	school_text.buff_input()
	school_text.set_state(school_text.STATE_OUTPUT)

func _on_input_enter(s):
	school_text.add_newline()
	if s == "ravie" or s == "heureux" or s == "content":
		school_text.reset()
		school_text.buff_text("Très bien ! C'est exact ! ", 0.001)
		emotion_dialogue_done = true
	else:
		wrong_answer_count += 1
		chapter_score -= 4
		if wrong_answer_count > 2:  #Popup alert with correct answer after 3 tries
			school_text.reset()
			emotionChallengeBox.set_hidden(true)
			player_pos = playerNode.get_pos()
			delete_alert_box_text()
			alertBox.set_pos(Vector2(player_pos.x-76, player_pos.y-30))
			alertBox.set_title("Alerte")
			alertBox._print_alert_string("\n\n\n")
			alertBox.get_node("Label1").set_text("Non, ce n'est pas le cas.")
			alertBox.get_node("Label2").set_text("La bonne réponse que\nnous recherchions était:\n'ravie' ou 'heureux' ou 'content'")
			alertBox.get_node("Label3").set_text("")
			alertBox.show()
			wrong_answer_popup_shown = true
			wrong_answer_count = 0
		else:

			school_text.reset()
			school_text.buff_text("Non, ce n'est pas le cas. Réessayer!\n")
			school_text.buff_input()
			school_text.set_state(school_text.STATE_OUTPUT)

func disable_movements():
	directionNode.hide()
	compassNode.hide()
	playerNode.canMove = false

func enable_movements():
	directionNode.show()
	compassNode.show()
	playerNode.canMove = true

func set_up_lesson_plan():
	lesson_plan_bottomtext = singleton.adjectivesLessonPlanText
	adjectivesScreenNode.get_node("title1").set_text("Les adjectifs")
	adjectivesScreenNode.get_node("intro_text").set_hidden(true)
	adjectivesScreenNode.get_node("describing_text").set_bbcode(lesson_plan_bottomtext[0])

func delete_alert_box_text():
	alertBox._print_alert_string("\n")
	alertBox.get_node("Label1").set_text("")
	alertBox.get_node("Label2").set_text("")
	alertBox.get_node("Label3").set_text("")

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
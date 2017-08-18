# Scene 1 Outside Script (Entire World)
extends Node2D

onready var alert_box = get_node("control_alerts")
onready var directionNode = get_node("direction_arrow")
onready var destinationNode = get_node("destinationObj")
onready var compassNode = get_node("compassBG")
onready var tie = get_node("PopupDialog/TextInterfaceEngine")
onready var school_text = get_node("emotion_challenge/TextInterfaceEngine")
onready var sentence_info_text = get_node("sentance_info/TextInterfaceEngine")
onready var nameChallengeBox = get_node("PopupDialog")
onready var emotionChallengeBox = get_node("emotion_challenge")
onready var sentenceInfoBox = get_node("sentance_info")
onready var multipleChoiceBox = get_node("multiple_choice")
onready var playerNode = get_node("Player")
onready var nounsScreenNode = get_node("about_nouns")

var alert_done = false
var neighbor1_alerted = false
var neighbor2_alerted = false
var neighbor2_done = false
var name_challenge_start = false
var name_challenge_done = false
var emotion_dialogue_started = false
var emotion_dialogue_done = false
var emotion_challenge_printed = false
var final_convo_started = false
var final_alert_done = false
var sentence_info_text_done = false
var final_challenge_start = false
var scene_complete = false
var interact = false
var time_delta = 0
var player_pos
var name_challenge_text

func _ready():
	set_process_input(true)
	set_fixed_process(true)
	destinationNode.set_pos(Vector2(136,8))
	directionNode.show()
	compassNode.show()
	nounsScreenNode.set_hidden(false)
	get_node("multiple_choice").correctIndex = 0
	singleton.message_done = true
	singleton.wrong_choice = false
	singleton.multiple_choice_complete = false
	
	tie.connect("input_enter", self, "_on_input_enter")
	tie.connect("buff_end", self, "_on_buff_end")
	tie.connect("enter_break", self, "_on_enter_break")
	
	school_text.connect("input_enter", self, "_on_input_enter")
	school_text.connect("buff_end", self, "_on_buff_end")
	school_text.connect("enter_break", self, "_on_enter_break")
	
	sentence_info_text.connect("buff_end", self, "_on_buff_end")
	sentence_info_text.connect("enter_break", self, "_on_enter_break")

func _input(event):
	if event.is_action_pressed("ui_interact"): #tab press to dismiss alert boxes and progress dialogue
		interact = true
	elif event.is_action_released("ui_interact"):
		interact = false
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
		if name_challenge_done:
			nameChallengeBox.hide()
			enable_movements()
		if emotion_dialogue_done:
			emotionChallengeBox.hide()
			get_node("dialogeObj3/happy_emote").hide()
			get_node("dialogeObj3/sad_emote").hide()
			if !final_convo_started:
				delete_alert_box_text()
				school_dialogue_part2()
		
	if final_convo_started and singleton.message_done and !final_alert_done:
		show_sentence_structure_info()
		final_alert_done = true
		time_delta = 0
		
	# Handle School Dialogue
	if emotion_dialogue_started and !emotion_challenge_printed:
		if get_node("dialogue_box").donePrinting:
			get_node("dialogeObj3/happy_emote").show()
			if interact:
				get_node("dialogeObj3/sad_emote").show()
		if singleton.message_done and !emotion_dialogue_done:
			disable_movements()
			player_pos = playerNode.get_pos() #get position of the player to place the box
			emotionChallengeBox.set_pos(Vector2(player_pos.x-76, player_pos.y+15)) #hardcoded distance to middle
			emotionChallengeBox.show()
			if !emotion_challenge_printed:
				emotion_challenge()
				emotion_challenge_printed = true
				
	# Handle Second neighbor dialogue
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
		if alert_box.is_visible() or nameChallengeBox.is_visible() or emotionChallengeBox.is_visible() or sentenceInfoBox.is_visible() or multipleChoiceBox.is_visible() or nounsScreenNode.is_visible():
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

func multiple_choice_challenge():
	disable_movements()
	player_pos = playerNode.get_pos()
	multipleChoiceBox.set_pos(Vector2(player_pos.x-76, player_pos.y-45))
	multipleChoiceBox.show()
	singleton.wrong_choice = false

func show_sentence_structure_info():
	disable_movements()
	player_pos = playerNode.get_pos()
	get_node("sentance_info").set_pos(Vector2(player_pos.x-76, player_pos.y))
	sentenceInfoBox.show()
	sentence_info_text.set_color(Color(1,1,1))
	sentence_info_text.buff_text("Regardons cette dernière phrase encore une fois: “I do not like mathematics.” Examinez la construction de la phrase ….\nPour former une phrase en anglais, on utilise toujours l'ordre: sujet + verbe + objet")
	sentence_info_text.set_state(tie.STATE_OUTPUT)
	sentence_info_text_done = true
	
func emotion_challenge():
	school_text.set_color(Color(1,1,1))
	# Schedule an Input in the buffer, after all
	# the text before it is displayed
	school_text.buff_text("Selon le contexte, que signifie « excited » ?\n", 0.01)
	school_text.buff_input()
	school_text.set_state(school_text.STATE_OUTPUT)
	
func name_challenge():
	tie.set_color(Color(1,1,1))
	# Schedule an Input in the buffer, after all
	# the text before it is displayed
	tie.buff_text("Vous avez vu le nom ? Qu'est-ce que c'était ?\n", 0.01)
	tie.buff_input()
	tie.set_state(tie.STATE_OUTPUT)

func _on_input_enter(s):
	if playerNode.get_pos().x > 400: #position is close to school
		school_text.add_newline()
		if s == "ravie" or s == "heureux" or s == "content":
			school_text.reset()
			school_text.buff_text("Très bien ! C'est exact ! ", 0.001)
			emotion_dialogue_done = true
		else:
			school_text.reset()
			school_text.buff_text("Non, ce n'est pas le cas. Réessayer!\n")
			school_text.buff_input()
			school_text.set_state(school_text.STATE_OUTPUT)
	else:
		tie.add_newline()
		if s == "school" or s == "School":
			tie.reset()
			tie.buff_text("Très bien ! On continuera à apprendre de nouveaux noms partout dans notre histoire. Maintenant, vous allez voir un adjectif. En anglais, les noms ne sont ni masculins ni féminins, donc les adjectifs sont pareils pour les femmes et les hommes, et tous les objets ! Regardez attentivement.", 0.001)
			name_challenge_done = true
		else:
			#tie.reset()
			tie.buff_text("Non, ce n'est pas le cas. Réessayer!\n")
			tie.buff_input()
			tie.set_state(tie.STATE_OUTPUT)
	pass

func neighbor1_dialogue():
	player_pos = playerNode.get_pos() #get position of the player to place the dialogue box
	get_node("dialogue_box").set_pos(Vector2(player_pos.x-76, player_pos.y+31)) #hardcoded distance to position middle bottom
	get_node("dialogue_box").set_hidden(false)
	get_node("dialogue_box")._print_dialogue(get_node("dialogeObj1/StaticBody2D/dialogue").text) 
	neighbor1_alerted = true
	if !neighbor2_alerted:
		destinationNode.set_pos(Vector2(264,8))

func neighbor2_dialogue():
	player_pos = playerNode.get_pos() #get position of the player to place the dialogue box
	get_node("dialogue_box").set_pos(Vector2(player_pos.x-76, player_pos.y+31)) #hardcoded distance to position middle bottom
	get_node("dialogue_box").set_hidden(false)
	get_node("dialogue_box")._print_dialogue(get_node("dialogeObj2/StaticBody2D/dialogue").text) 
	destinationNode.set_pos(Vector2(488,200))
	
func school_dialogue():
	player_pos = playerNode.get_pos() #get position of the player to place the dialogue box
	get_node("dialogue_box").set_pos(Vector2(player_pos.x-76, player_pos.y+31)) #hardcoded distance to position middle bottom
	get_node("dialogue_box").set_hidden(false)
	get_node("dialogue_box")._print_dialogue(get_node("dialogeObj3/StaticBody2D/dialogue").text) 
	emotion_dialogue_started = true

func school_dialogue_part2():
	player_pos = playerNode.get_pos() #get position of the player to place the dialogue box
	get_node("dialogue_box").set_pos(Vector2(player_pos.x-76, player_pos.y+31)) #hardcoded distance to position middle bottom
	get_node("dialogue_box").set_hidden(false)
	get_node("dialogue_box")._print_dialogue(get_node("dialogeObj4/StaticBody2D/dialogue").text) 
	final_convo_started = true
	destinationNode.set_pos(Vector2(472,184))

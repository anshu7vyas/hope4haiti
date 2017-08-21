extends Node2D
#world 1 start up scene

onready var alert_box = get_node("control_alerts")
onready var directionNode = get_node("direction_arrow")
onready var compassNode = get_node("compassBG")
onready var playerNode = get_node("Player")
onready var dialogueBox = get_node("startup_dialoge")
onready var playerDialogueBox = get_node("Player/Camera2D/dialogue_box")
onready var dialogueBoxNode = get_node("dialogue_textbox")
onready var dialogueText = get_node("dialogue_textbox/TextInterfaceEngine")

var time_seconds = 0 #skip for now
var dialogue_wait_secs = 1
var alert_wait_secs = 2

var interact  = false
var dialgoue_next = false
var intro_dialogue_complete = false
var timer_done = false
var alert_done = false
var alert2_done = false

var lesson_plan_toptext = [
"Ce chapitre vous présentera comment les noms sont utilisés en anglais. Vous pouvez vous référer à cet écran à tout moment en appuyant sur la touche TAB. Utilisez les touches fléchées pour faire défiler cet écran pour afficher des exemples.",
"Next pages of lessons top section..",
"Another page of lesson stuff.."
]
var lesson_plan_bottomtext = [
"Le nom est la première des huit parties du discours. Les noms peuvent être utilisés de différentes manières. Ils peuvent être communs ou appropriés. Ils peuvent être des sujets de phrases ou d'objets directs, nominatifs prédicats, objets de prépositions et objets indirects. Il y a aussi des noms d'adresse, des objets d'infinitives et des noms de gerundus.",
"maybe have examples here",
"Maybe add some more examples here..."
]

func _ready():
	set_process_input(true)
	set_fixed_process(true)
	directionNode.hide()
	compassNode.hide()
	dialogueBoxNode.hide()

	dialogueText.connect("input_enter", self, "_on_input_enter")
	dialogueText.connect("buff_end", self, "_on_buff_end")
	dialogueText.connect("enter_break", self, "_on_enter_break")
	#skip intro for debugging
	#skip_intro()

func _input(event):
	if event.is_action_pressed("ui_interact"): #tab press to dismiss alert boxes and progress dialogue
		interact = true
	elif event.is_action_released("ui_interact"):
		interact = false

func _fixed_process(delta): #running process
	time_seconds += delta #count how long the scene has been running
	if interact and alert_box.is_visible(): #dismiss alertbox
		alert_box.hide()
		if alert2_done:
			directionNode.show()
			compassNode.show()
	if time_seconds > 0.1 and !timer_done: #pause for 1s then start intro dialogue
		intro_dialogue()
		timer_done = true #dont run this block again
	if time_seconds > 1 and !alert_done: #show 1st alert box after 2s
		intro_popup_spacebar()
		alert_done = true #dont run this block again
	if singleton.message_done and !alert2_done: #show 2nd alert box after dialoge is complete
		intro_popup_arrowkeys()
		interact = false #bug fix so alert box is not immediatly dismssed
		OS.delay_msec(50) #allow "interact = false" to register
		alert2_done = true 
	if !singleton.message_done: #dont allopw walking during dialogue or alerts
		get_node("Player").canMove = false
	
	if dialogueBox.is_visible() or alert_box.is_visible() or playerDialogueBox.is_visible():
		disable_movements()
	else:
		enable_movements()
	

func intro_dialogue():
	#dialogueBoxNode.show()	
	#dialogueText.reset()
	#dialogueText.set_color(Color(1,1,1))
	#dialogueText.buff_text("Marie-Thérèse:\n", 0)
	#dialogueText.buff_text("Bonjour ! Je m’appelle Marie-Thérèse, et je vais ", 0)
	#OS.delay_msec(500)
	#dialogueText.set_color(Color(1,1,0))
	#dialogueText.buff_text("vous ", 0)
	#OS.delay_msec(500)
	#dialogueText.set_color(Color(1,1,1))
	#dialogueText.buff_text("aider à apprendre l’anglais ! On y va, suivez-moi !", 0)
	#tie.buff_silence(0.4)
	#dialogueText.set_state(dialogueText.STATE_OUTPUT)
	var player_pos = get_node("Player").get_pos() #get position of the player to place the dialogue box
	get_node("startup_dialoge").set_pos(Vector2(player_pos.x-76, player_pos.y+31)) #hardcoded distance to position middle bottom
	#get_node("startup_dialoge").has_color_change = true
	#get_node("startup_dialoge").colorChangeStart = 12
	#get_node("startup_dialoge").colorChangeEnd = 22
	#get_node("startup_dialoge").colorChangeLine = 0
	get_node("startup_dialoge").set_hidden(false)
	get_node("startup_dialoge")._print_dialogue(get_node("intoObj/StaticBody2D/introduction_dialogue").text) 

func delete_alert_box_text():
	alert_box._print_alert_string("\n")
	alert_box.get_node("Label1").set_text("")
	alert_box.get_node("Label2").set_text("")
	alert_box.get_node("Label3").set_text("")

func intro_popup_arrowkeys():
	delete_alert_box_text() #reset alert
	alert_box.set_title("Alerte")
	alert_box._print_alert_string("\n\n\n")
	alert_box.get_node("Label1").set_text("")
	alert_box.get_node("Label2").set_text("Utilisez les TOUCHES DE FLECHE\npour diriger le personnage")
	alert_box.get_node("Label3").set_text("")
	alert_box.show()

func intro_popup_spacebar():
	alert_box.set_title("Alerte")
	alert_box._print_alert_string("\n\n\n")
	alert_box.get_node("Label1").set_text("")
	alert_box.get_node("Label2").set_text("Appuyez sur ESPACE\npour continuer à lire le dialogue")
	alert_box.get_node("Label3").set_text("")
	alert_box.show()

func skip_intro():
	singleton.message_done = true
	time_seconds = 6
	intro_dialogue_complete = true
	timer_done = true
	alert_done = true
	alert2_done = true

func disable_movements():
	directionNode.hide()
	compassNode.hide()
	playerNode.canMove = false

func enable_movements():
	directionNode.show()
	compassNode.show()
	playerNode.canMove = true


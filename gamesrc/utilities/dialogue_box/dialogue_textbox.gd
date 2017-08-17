extends PopupDialog

var printing = false
var donePrinting = false
onready var dialogueText = get_node("TextInterfaceEngine")
var pressed = false

var timer = 0
var textToPrint = []

var currentChar = 0
var currentText = 0
var line_count = 0
func _ready():
	set_fixed_process(true)
	set_process_unhandled_key_input(true)

func _unhandled_key_input(key_event):
	if key_event.is_action_pressed("ui_interact"):
		pressed = true
	elif key_event.is_action_released("ui_interact"):
		pressed = false

func _fixed_process(delta):
	pass
extends Patch9Frame

var printing = false
var donePrinting = false

var pressed = false

var timer = 0
var textToPrint = []

var colorChangeStart = -1
var colorChangeEnd = -1
var colorChangeLine = -1
var has_color_change = false

var currentChar = 0
var currentText = 0
var line_count = 0

const SPEED = 0.007 #Lower prints words faster

func _ready():
	set_fixed_process(true)
	set_process_unhandled_key_input(true)

func _unhandled_key_input(key_event):
	if key_event.is_action_pressed("ui_interact"):
		pressed = true
	elif key_event.is_action_released("ui_interact"):
		pressed = false

func _fixed_process(delta):
	if printing:
		if !donePrinting:
			timer += delta
			if timer > SPEED:
				timer = 0
				if has_color_change and colorChangeLine == currentText and (currentChar > colorChangeStart) and (currentChar < colorChangeEnd):
					get_node("RichTextLabel").add_color_override("default_color", Color(1,0,0))
				else:
					get_node("RichTextLabel").add_color_override("default_color", Color(0,0,0))
				get_node("RichTextLabel").set_bbcode(get_node("RichTextLabel").get_bbcode() + textToPrint[currentText][currentChar])
				currentChar += 1
			if currentChar >= textToPrint[currentText].length():
				currentChar = 0
				timer = 0
				donePrinting = true
				currentText += 1
		elif pressed:
			donePrinting = false
			get_node("RichTextLabel").set_bbcode("")
			if currentText >= textToPrint.size():
				currentText = 0
				textToPrint = []
				printing = false
				set_hidden(true)
				singleton.message_done = true
				get_node("/root/world/Player").canMove = true
	pressed = false


func _print_dialogue(text):
	singleton.message_done = false
	textToPrint = text
	printing = true
	get_node("/root/world/Player").canMove = false
extends PopupPanel

var first_multiple_choice_done = false
var time_delta = 0
var second_multiple_choice_done = false
var third_multiple_choice_done = false
var matching_done = false

var interact = false
var right_trigger = false
var left_trigger = false

onready var root_node_panel = get_node("telling_a_story")
onready var matching = get_node("matching")
onready var multiple_choice_1 = get_node("multiple_choice_1")
onready var multiple_choice_2 = get_node("multiple_choice_2")
onready var multiple_choice_3 = get_node("multiple_choice_3")

func _ready():
	set_process_input(true)
	set_fixed_process(true)
	
func _input(event):
	if event.is_action_pressed("ui_interact"):
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

func _fixed_process(delta):
	time_delta += delta





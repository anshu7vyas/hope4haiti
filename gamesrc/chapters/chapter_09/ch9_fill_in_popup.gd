extends PopupDialog

# class member variables go here, for example:
var ok_pressed = false
var enter_pressed = false
onready var worldNode = get_parent()

func _ready():
	set_fixed_process(true)
	set_process_input(true)

func _fixed_process(delta):
	if get_node("enter").is_pressed() and !enter_pressed:
		if _all_filled_in():
			enter_pressed = true
			get_node("enter").set_hidden(true)
			get_node("OK").set_hidden(false)
			_handle_fillin_answers()

func _all_filled_in():
	if get_node("adjective_button").is_pressed() or get_node("adverb_button").is_pressed():
		if get_node("adjective_button1").is_pressed() or get_node("adverb_button1").is_pressed():
			if get_node("adjective_button2").is_pressed() or get_node("adverb_button2").is_pressed():
				if get_node("adjective_button3").is_pressed() or get_node("adverb_button3").is_pressed():
					if get_node("adjective_button4").is_pressed() or get_node("adverb_button4").is_pressed():
						if get_node("adjective_button5").is_pressed() or get_node("adverb_button5").is_pressed():
							if get_node("adjective_button7").is_pressed() or get_node("adverb_button7").is_pressed():
								if get_node("adjective_button8").is_pressed() or get_node("adverb_button8").is_pressed():
									if get_node("adjective_button9").is_pressed() or get_node("adverb_button9").is_pressed():
										if get_node("adjective_button10").is_pressed() or get_node("adverb_button10").is_pressed():
											if get_node("adjective_button11").is_pressed() or get_node("adverb_button11").is_pressed():
												return true
	return false

func _handle_fillin_answers():
	if get_node("adjective_button").is_pressed():
		get_node("adjective_button").set_button_icon(load("res://chapters/chapter_04/red_cross.png"))
		worldNode.chapter_score -= 2
	elif get_node("adverb_button").is_pressed():
		get_node("adverb_button").set_button_icon(load("res://chapters/chapter_04/green_checkmark.png"))
		
	if get_node("adjective_button1").is_pressed():
		get_node("adjective_button1").set_button_icon(load("res://chapters/chapter_04/red_cross.png"))
		worldNode.chapter_score -= 2
	elif get_node("adverb_button1").is_pressed():
		get_node("adverb_button1").set_button_icon(load("res://chapters/chapter_04/green_checkmark.png"))
		
	if get_node("adjective_button2").is_pressed():
		get_node("adjective_button2").set_button_icon(load("res://chapters/chapter_04/green_checkmark.png"))
	elif get_node("adverb_button2").is_pressed():
		get_node("adverb_button2").set_button_icon(load("res://chapters/chapter_04/red_cross.png"))
		worldNode.chapter_score -= 2
		
	if get_node("adjective_button3").is_pressed():
		get_node("adjective_button3").set_button_icon(load("res://chapters/chapter_04/red_cross.png"))
		worldNode.chapter_score -= 2
	elif get_node("adverb_button3").is_pressed():
		get_node("adverb_button3").set_button_icon(load("res://chapters/chapter_04/green_checkmark.png"))
		
	if get_node("adjective_button4").is_pressed():
		get_node("adjective_button4").set_button_icon(load("res://chapters/chapter_04/green_checkmark.png"))
	elif get_node("adverb_button4").is_pressed():
		get_node("adverb_button4").set_button_icon(load("res://chapters/chapter_04/red_cross.png"))
		worldNode.chapter_score -= 2
		
	if get_node("adjective_button5").is_pressed():
		get_node("adjective_button5").set_button_icon(load("res://chapters/chapter_04/green_checkmark.png"))
	elif get_node("adverb_button5").is_pressed():
		get_node("adverb_button5").set_button_icon(load("res://chapters/chapter_04/red_cross.png"))
		worldNode.chapter_score -= 2
	
	if get_node("adjective_button7").is_pressed():
		get_node("adjective_button7").set_button_icon(load("res://chapters/chapter_04/green_checkmark.png"))
	elif get_node("adverb_button7").is_pressed():
		get_node("adverb_button7").set_button_icon(load("res://chapters/chapter_04/red_cross.png"))
		worldNode.chapter_score -= 2
	
	if get_node("adjective_button8").is_pressed():
		get_node("adjective_button8").set_button_icon(load("res://chapters/chapter_04/red_cross.png"))
		worldNode.chapter_score -= 2
	elif get_node("adverb_button8").is_pressed():
		get_node("adverb_button8").set_button_icon(load("res://chapters/chapter_04/green_checkmark.png"))
	
	if get_node("adjective_button9").is_pressed():
		get_node("adjective_button9").set_button_icon(load("res://chapters/chapter_04/green_checkmark.png"))
	elif get_node("adverb_button9").is_pressed():
		get_node("adverb_button9").set_button_icon(load("res://chapters/chapter_04/red_cross.png"))
		worldNode.chapter_score -= 2
	
	if get_node("adjective_button10").is_pressed():
		get_node("adjective_button10").set_button_icon(load("res://chapters/chapter_04/green_checkmark.png"))
	elif get_node("adverb_button10").is_pressed():
		get_node("adverb_button10").set_button_icon(load("res://chapters/chapter_04/red_cross.png"))
		worldNode.chapter_score -= 2

	if get_node("adjective_button11").is_pressed():
		get_node("adjective_button11").set_button_icon(load("res://chapters/chapter_04/green_checkmark.png"))
	elif get_node("adverb_button11").is_pressed():
		get_node("adverb_button11").set_button_icon(load("res://chapters/chapter_04/red_cross.png"))
		worldNode.chapter_score -= 2
		
func _on_adverb_button_toggled( pressed ):
	get_node("adjective_button").set_pressed(false)
func _on_adjective_button_toggled( pressed ):
	get_node("adverb_button").set_pressed(false)
func _on_adverb_button1_pressed():
	get_node("adjective_button1").set_pressed(false)
func _on_adverb_button2_pressed():
	get_node("adjective_button2").set_pressed(false)
func _on_adverb_button3_pressed():
	get_node("adjective_button3").set_pressed(false)
func _on_adverb_button4_toggled( pressed ):
	get_node("adjective_button4").set_pressed(false)
func _on_adverb_button5_toggled( pressed ):
	get_node("adjective_button5").set_pressed(false)
func _on_adverb_button7_toggled( pressed ):
	get_node("adjective_button7").set_pressed(false)
func _on_adverb_button8_toggled( pressed ):
	get_node("adjective_button8").set_pressed(false)
func _on_adverb_button9_toggled( pressed ):
	get_node("adjective_button9").set_pressed(false)
func _on_adverb_button10_toggled( pressed ):
	get_node("adjective_button10").set_pressed(false)
func _on_adverb_button11_toggled( pressed ):
	get_node("adjective_button11").set_pressed(false)

func _on_adjective_button1_toggled( pressed ):
	get_node("adverb_button1").set_pressed(false)
func _on_adjective_button2_toggled( pressed ):
	get_node("adverb_button2").set_pressed(false)
func _on_adjective_button3_toggled( pressed ):
	get_node("adverb_button3").set_pressed(false)
func _on_adjective_button4_toggled( pressed ):
	get_node("adverb_button4").set_pressed(false)
func _on_adjective_button5_toggled( pressed ):
	get_node("adverb_button5").set_pressed(false)
func _on_adjective_button7_toggled( pressed ):
	get_node("adverb_button7").set_pressed(false)
func _on_adjective_button8_toggled( pressed ):
	get_node("adverb_button8").set_pressed(false)
func _on_adjective_button9_toggled( pressed ):
	get_node("adverb_button9").set_pressed(false)
func _on_adjective_button10_toggled( pressed ):
	get_node("adverb_button10").set_pressed(false)
func _on_adjective_button11_toggled( pressed ):
	get_node("adverb_button11").set_pressed(false)
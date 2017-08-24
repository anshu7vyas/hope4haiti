extends PopupDialog
# Lesson Plan Script
var interact = false
var right_trigger = false
var left_trigger = false
var singlePage = false
var lesson_plan_page = 0
var lesson_plan_top_size 
var lesson_plan_bottom_size 
var lesson_plan_toptext 
var lesson_plan_bottomtext 
var lesson_plan_size = 3



func _ready():
	set_fixed_process(true)
	set_process_input(true)
	#lesson_plan_toptext = get_parent().lesson_plan_toptext
	lesson_plan_bottomtext = get_parent().lesson_plan_bottomtext
	#lesson_plan_top_size = lesson_plan_toptext.size()
	lesson_plan_bottom_size =  lesson_plan_bottomtext.size()
	if lesson_plan_bottomtext[1] == "":
		self.get_node("left_button").set_hidden(true)
		self.get_node("right_button").set_hidden(true)
		singlePage = true
	else:
		self.get_node("left_button").set_hidden(false)
		self.get_node("right_button").set_hidden(false)
		singlePage = false


func _input(event):
	if event.is_action_pressed("ui_interact"): #tab press to dismiss alert boxes and progress dialogue
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
	if self.is_visible() and !singlePage: # navigate the lesson plan
		if right_trigger or self.get_node("right_button").is_pressed():
			if lesson_plan_page < lesson_plan_size-1: 
				lesson_plan_page += 1
				#self.get_node("intro_text").set_bbcode(lesson_plan_toptext[lesson_plan_page])
				self.get_node("describing_text").set_bbcode(lesson_plan_bottomtext[lesson_plan_page])
				OS.delay_msec(150) #pause so it doesnt skip to the next screen
			right_trigger = false
		elif left_trigger or self.get_node("left_button").is_pressed():
			if lesson_plan_page > 0:
				lesson_plan_page -= 1
				#self.get_node("intro_text").set_bbcode(lesson_plan_toptext[lesson_plan_page])
				self.get_node("describing_text").set_bbcode(lesson_plan_bottomtext[lesson_plan_page])
				OS.delay_msec(150)
			left_trigger = false 
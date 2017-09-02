extends PopupDialog

onready var checkMarks = get_node("marks")
onready var buttons = get_node("buttons")
onready var b1array = get_node("buttons/button_group1")
onready var b2array = get_node("buttons/button_group2")
onready var b3array = get_node("buttons/button_group3")
onready var b4array = get_node("buttons/button_group4")
onready var b5array = get_node("buttons/button_group5")
onready var answers = get_node("answers")

func _ready():
	set_fixed_process(true)
	set_process_input(true)

func check_answers():
	get_node("correct_answers").set_hidden(false)
	if get_node("answers/fill_in").get_text() != "woke up":
		get_parent().chapter_score -= 4
		get_node("correct_answers/corrent_answer1").set_hidden(false)
		get_node("marks/marker1").set_texture(load("res://chapters/chapter_04/red_cross.png"))
	else:
		get_node("correct_answers/corrent_answer1").set_hidden(true)
		
	if get_node("answers/fill_in1").get_text() != "walked":
		get_parent().chapter_score -= 4
		get_node("correct_answers/corrent_answer2").set_hidden(false)
		get_node("marks/marker2").set_texture(load("res://chapters/chapter_04/red_cross.png"))
	else:
		get_node("correct_answers/corrent_answer2").set_hidden(true)
		
	if get_node("answers/fill_in2").get_text() != "witnessed":
		get_parent().chapter_score -= 4
		get_node("correct_answers/corrent_answer3").set_hidden(false)
		get_node("marks/marker3").set_texture(load("res://chapters/chapter_04/red_cross.png"))
	else:
		get_node("correct_answers/corrent_answer3").set_hidden(true)
		
	if get_node("answers/fill_in3").get_text() != "gathered":
		get_parent().chapter_score -= 4
		get_node("correct_answers/corrent_answer4").set_hidden(false)
		get_node("marks/marker4").set_texture(load("res://chapters/chapter_04/red_cross.png"))
	else:
		get_node("correct_answers/corrent_answer4").set_hidden(true)
		
	if get_node("answers/fill_in4").get_text() != "spoke":
		get_parent().chapter_score -= 4
		get_node("correct_answers/corrent_answer5").set_hidden(false)
		get_node("marks/marker5").set_texture(load("res://chapters/chapter_04/red_cross.png"))
	else:
		get_node("correct_answers/corrent_answer5").set_hidden(true)


func _fixed_process(delta):
	if get_node("done_button").is_pressed():
		if answers.get_node("fill_in").get_text() != "" and answers.get_node("fill_in1").get_text() != "" and answers.get_node("fill_in2").get_text() != "" and answers.get_node("fill_in3").get_text() != "" and answers.get_node("fill_in4").get_text() != "":
			buttons.set_hidden(true)
			get_node("done_button").set_hidden(true)
			get_node("OK").set_hidden(false)
			checkMarks.set_hidden(false)
			check_answers()
	
	#First row matching
	if b1array.get_node("Button_je").is_pressed():
		answers.get_node("fill_in").set_text(b1array.get_node("Button_je").get_text())
	elif b1array.get_node("Button_tu").is_pressed():
		answers.get_node("fill_in").set_text(b1array.get_node("Button_tu").get_text())
	elif b1array.get_node("Button_nous").is_pressed():
		answers.get_node("fill_in").set_text(b1array.get_node("Button_nous").get_text())
	#elif b1array.get_node("Button_heshe").is_pressed():
	#	answers.get_node("fill_in").set_text(b1array.get_node("Button_heshe").get_text())
	#elif b1array.get_node("Button_they").is_pressed():
	#	answers.get_node("fill_in").set_text(b1array.get_node("Button_they").get_text())

	#second row matching
	if b2array.get_node("Button_je").is_pressed():
		answers.get_node("fill_in1").set_text(b2array.get_node("Button_je").get_text())
	elif b2array.get_node("Button_tu").is_pressed():
		answers.get_node("fill_in1").set_text(b2array.get_node("Button_tu").get_text())
	elif b2array.get_node("Button_nous").is_pressed():
		answers.get_node("fill_in1").set_text(b2array.get_node("Button_nous").get_text())
	#elif b2array.get_node("Button_heshe").is_pressed():
	#	answers.get_node("fill_in1").set_text(b2array.get_node("Button_heshe").get_text())
	#elif b2array.get_node("Button_they").is_pressed():
	#	answers.get_node("fill_in1").set_text(b2array.get_node("Button_they").get_text())

	#third row matching
	if b3array.get_node("Button_je").is_pressed():
		answers.get_node("fill_in2").set_text(b3array.get_node("Button_je").get_text())
	elif b3array.get_node("Button_tu").is_pressed():
		answers.get_node("fill_in2").set_text(b3array.get_node("Button_tu").get_text())
	elif b3array.get_node("Button_nous").is_pressed():
		answers.get_node("fill_in2").set_text(b3array.get_node("Button_nous").get_text())
	#elif b3array.get_node("Button_heshe").is_pressed():
	#	answers.get_node("fill_in2").set_text(b3array.get_node("Button_heshe").get_text())
	#elif b3array.get_node("Button_they").is_pressed():
	#	answers.get_node("fill_in2").set_text(b3array.get_node("Button_they").get_text())

	#fourth row matching
	if b4array.get_node("Button_je").is_pressed():
		answers.get_node("fill_in3").set_text(b4array.get_node("Button_je").get_text())
	elif b4array.get_node("Button_tu").is_pressed():
		answers.get_node("fill_in3").set_text(b4array.get_node("Button_tu").get_text())
	elif b4array.get_node("Button_nous").is_pressed():
		answers.get_node("fill_in3").set_text(b4array.get_node("Button_nous").get_text())
	#elif b4array.get_node("Button_heshe").is_pressed():
	#	answers.get_node("fill_in3").set_text(b4array.get_node("Button_heshe").get_text())
	#elif b4array.get_node("Button_they").is_pressed():
	#	answers.get_node("fill_in3").set_text(b4array.get_node("Button_they").get_text())

	#fifth row matching
	if b5array.get_node("Button_je").is_pressed():
		answers.get_node("fill_in4").set_text(b5array.get_node("Button_je").get_text())
	elif b5array.get_node("Button_tu").is_pressed():
		answers.get_node("fill_in4").set_text(b5array.get_node("Button_tu").get_text())
	elif b5array.get_node("Button_nous").is_pressed():
		answers.get_node("fill_in4").set_text(b5array.get_node("Button_nous").get_text())
	#elif b5array.get_node("Button_heshe").is_pressed():
	#	answers.get_node("fill_in4").set_text(b5array.get_node("Button_heshe").get_text())
	#elif b5array.get_node("Button_they").is_pressed():
	#	answers.get_node("fill_in4").set_text(b5array.get_node("Button_they").get_text())
	

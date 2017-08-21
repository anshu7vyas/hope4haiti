extends PopupDialog


onready var pointerNode = get_node("pointer")
onready var worldNode = get_parent()
onready var questionNode = get_node("question")
onready var labelsNode = get_node("Control")
#onready var alert_box = get_parent().get_node("control_alerts")

var questions = ["Question 2: Il s'agit d'une autre question sur les noms qui se trouvaient dans le plan de cours",
"Question 3: Quelle sentance utilise les noms en anglais sous la forme appropriée ci-dessous",
"Question 4: Je ne peux plus penser à d'autres questions à utiliser comme texte de remplissage, donc je pose ça?",
"Question 5: C'est la dernière question à choix multiple. Quel est l'exemple d'un nom?" ]

var answers = ["A. Le choix du nom correct est celui-ci",
"B. Ou est la bonne réponse à celle-ci",
"C. La réponse pourrait même être C",
"A. Plus de réponses à remplir ici",
"B. Texte de remplissage pour la bonne réponse",
"C. Un arbre est un nom",
"A. Réponse fausse insérée ici",
"B. Réponse totalement réelle ici",
"C. Peut-être une vraie réponse ici",
"A. Plus de réponses à remplir ici",
"B. Texte de remplissage pour la bonne réponse",
"C. Un arbre est un nom" ]

var correct_selected = false
var index = 0
var interact
var player_pos
var correctIndex = -1
var count = 0
var answerCount = 0
var fill_in_the_blank_started = false
var chapter_score = 92    #INITIALLY SET FOR DEBUGGING - REMOVE LINE WHEN SCORING ADDED
var chapter_complete = false

func _ready():
	set_process_input(true)
	set_fixed_process(true)
	get_node("intro_text").set_hidden(false)
	questionNode.set_hidden(false)
	get_node("ans1").set_hidden(false)
	get_node("ans2").set_hidden(false)
	get_node("ans3").set_hidden(false)
	get_node("pointer").set_hidden(false)
	get_node("fill_in_the_blank").set_hidden(true)
	
	get_node("end_score_text").set_hidden(true)
	get_node("score_label").set_hidden(true)
	
	fill_in_the_blank(true)

func _input(event):
	if self.is_visible():
		if event.is_action("ui_up") && event.is_pressed() && !event.is_echo():
			if(index != 0):
				index -= 1
				get_node("pointer")
				var x = pointerNode.get_pos().x
				var y = pointerNode.get_pos().y - 32 #69 is hard coded distance between labels
				pointerNode.set_pos(Vector2(x,y))
		if event.is_action("ui_down") && event.is_pressed() && !event.is_echo():
			if(index != 2):
				index += 1
				var x = pointerNode.get_pos().x
				var y = pointerNode.get_pos().y + 32
				pointerNode.set_pos(Vector2(x,y))
		if event.is_action("ui_accept") && event.is_pressed() && !event.is_echo():
			if !fill_in_the_blank_started:
				next_question()
			if chapter_complete:
				get_tree().change_scene("res://screens/main_menu/startUp.tscn")
		if fill_in_the_blank_started:
			if get_node("button_1").is_pressed():
				get_node("Control/Label1").set_text(get_node("button_1").get_text())
				get_node("Control/Label1").set_hidden(false)
				print("b1 pressed")
			if get_node("button_2").is_pressed():
				get_node("Control/Label1").set_text(get_node("button_2").get_text())
			if get_node("button_3").is_pressed():
				get_node("Control/Label2").set_text(get_node("button_3").get_text())
			if get_node("button_4").is_pressed():
				get_node("Control/Label2").set_text(get_node("button_4").get_text())
			if get_node("button_5").is_pressed():
				get_node("Control/Label3").set_text(get_node("button_5").get_text())
			if get_node("button_6").is_pressed():
				get_node("Control/Label3").set_text(get_node("button_6").get_text())
			if get_node("button_7").is_pressed():
				get_node("Control/Label4").set_text(get_node("button_7").get_text())
			if get_node("button_8").is_pressed():
				get_node("Control/Label4").set_text(get_node("button_8").get_text())
			if is_all_labels_filled() and get_node("done_button").is_pressed():
				end_of_chapter_score()

func end_of_chapter_score():
	fill_in_the_blank(true)
	if chapter_score > 80:
		get_node("title1").set_text("Bon travail!")
	else:
		get_node("title1").set_text("Presque là!")
	get_node("end_score_text").set_hidden(false)
	get_node("score_label").set_hidden(false)
	get_node("score_label").set_text(str(chapter_score) + " points!")
	chapter_complete = true

func next_question():
	if count < 4:
		questionNode.set_bbcode(questions[count])
		get_node("ans1").set_text(answers[answerCount])
		answerCount += 1
		get_node("ans2").set_text(answers[answerCount])
		answerCount += 1
		get_node("ans3").set_text(answers[answerCount])
		answerCount += 1
		count += 1
	else:
		get_node("intro_text").set_hidden(true)
		questionNode.set_hidden(true)
		get_node("ans1").set_hidden(true)
		get_node("ans2").set_hidden(true)
		get_node("ans3").set_hidden(true)
		get_node("pointer").set_hidden(true)
		
		get_node("fill_in_the_blank").set_hidden(false)
		fill_in_the_blank_started = true
		fill_in_the_blank(false)

func fill_in_the_blank(toggle_state):
	get_node("Control").set_hidden(toggle_state)
	get_node("button_1").set_hidden(toggle_state)
	get_node("button_2").set_hidden(toggle_state)
	get_node("button_3").set_hidden(toggle_state)
	get_node("button_4").set_hidden(toggle_state)
	get_node("button_5").set_hidden(toggle_state)
	get_node("button_6").set_hidden(toggle_state)
	get_node("button_7").set_hidden(toggle_state)
	get_node("button_8").set_hidden(toggle_state)
	get_node("done_button").set_hidden(toggle_state)
	get_node("fill_in_words").set_hidden(toggle_state)
	get_node("fill_in_the_blank").set_hidden(toggle_state)
	
func is_all_labels_filled():
	if get_node("Control/Label1").get_text() != "":
		if get_node("Control/Label2").get_text() != "":
			if get_node("Control/Label3").get_text() != "":
				if get_node("Control/Label4").get_text() != "":
					return true
	return false
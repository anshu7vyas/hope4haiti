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
	
	get_node("Button").set_hidden(true)
	get_node("Button1").set_hidden(true)
	get_node("Button2").set_hidden(true)
	get_node("Button3").set_hidden(true)
	get_node("Button4").set_hidden(true)
	get_node("Button5").set_hidden(true)
	get_node("Button6").set_hidden(true)
	get_node("Button7").set_hidden(true)
	get_node("Button8").set_hidden(true)
	get_node("fill_in_words").set_hidden(true)
	get_node("fill_in_the_blank").set_hidden(true)

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
			#player_pos = worldNode.get_node("Player").get_pos()
			next_question()
			print(count)

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
		fill_in_the_blank()

func fill_in_the_blank():
	get_node("Button").set_hidden(false)
	get_node("Button1").set_hidden(false)
	get_node("Button2").set_hidden(false)
	get_node("Button3").set_hidden(false)
	get_node("Button4").set_hidden(false)
	get_node("Button5").set_hidden(false)
	get_node("Button6").set_hidden(false)
	get_node("Button7").set_hidden(false)
	get_node("Button8").set_hidden(false)
	get_node("fill_in_words").set_hidden(false)
	get_node("fill_in_the_blank").set_hidden(false)
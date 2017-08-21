extends Node

# useful for transfering data between scenes
#var foo = 3

var item = [createItemData("Push", "Verb"), createItemData("Brick", "Noun"), createItemData("Beautiful", "Adjective"), createItemData("Wall", "Noun")]

# Nouns Suppor Text
var nounsLessonPlanTop = [
"Ce chapitre vous présentera comment les noms sont utilisés en anglais. Vous pouvez vous référer à cet écran à tout moment en appuyant sur la touche TAB. Utilisez les touches fléchées pour faire défiler cet écran pour afficher des exemples.",
"Next pages of lessons top section..",
"Another page of lesson stuff.."
]
var nounsLessonPlanBottom = [
"Le nom est la première des huit parties du discours. Les noms peuvent être utilisés de différentes manières. Ils peuvent être communs ou appropriés. Ils peuvent être des sujets de phrases ou d'objets directs, nominatifs prédicats, objets de prépositions et objets indirects. Il y a aussi des noms d'adresse, des objets d'infinitives et des noms de gerundus.",
"maybe have examples here",
"Maybe add some more examples here..."
]
var nounsQuestions = [
"Question 2: Il s'agit d'une autre question sur les noms qui se trouvaient dans le plan de cours",
"Question 3: Quelle sentance utilise les noms en anglais sous la forme appropriée ci-dessous",
"Question 4: Je ne peux plus penser à d'autres questions à utiliser comme texte de remplissage, donc je pose ça?",
"Question 5: C'est la dernière question à choix multiple. Quel est l'exemple d'un nom?" 
]

# Pronouns Support Text
var pronounsLessonPlanTop = [
"Ce chapitre vous présentera comment les noms sont utilisés en anglais. Vous pouvez vous référer à cet écran à tout moment en appuyant sur la touche TAB. Utilisez les touches fléchées pour faire défiler cet écran pour afficher des exemples.",
"Next pages of lessons top section..",
"Another page of lesson stuff.."
]
var pronounsLessonPlanBottom = [
"Le nom est la première des huit parties du discours. Les noms peuvent être utilisés de différentes manières. Ils peuvent être communs ou appropriés. Ils peuvent être des sujets de phrases ou d'objets directs, nominatifs prédicats, objets de prépositions et objets indirects. Il y a aussi des noms d'adresse, des objets d'infinitives et des noms de gerundus.",
"maybe have examples here",
"Maybe add some more examples here..."
]
var pronounsQuestions = [
"Question 2: Il s'agit d'une autre question sur les noms qui se trouvaient dans le plan de cours",
"Question 3: Quelle sentance utilise les noms en anglais sous la forme appropriée ci-dessous",
"Question 4: Je ne peux plus penser à d'autres questions à utiliser comme texte de remplissage, donc je pose ça?",
"Question 5: C'est la dernière question à choix multiple. Quel est l'exemple d'un nom?" 
]

var isNewGame = true
var message_done = false
var collision_finished = false
var index_selected = -1
var wrong_choice = false
var multiple_choice_complete = false
var multiple_choice_retry = false
var logged_in = false

func createItemData(_Name, _Type):
	return {Name = _Name, Type = _Type}

func createCurrentPokemon(_Name, _Health, _XP, _Level):
	return {Name = _Name, Health = _Health, XP = _XP, Level = _Level}

func _ready():
	#print(createCurrentPokemon("Ryan", 100, 0, 1))
	#var testObj = createCurrentPokemon("Ryan", 100, 0, 1)
	#print(testObj)
	pass

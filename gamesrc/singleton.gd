extends Node

# useful for transfering data between scenes
#var foo = 3

var item = [createItemData("Push", "Verb"), createItemData("Brick", "Noun"), createItemData("Beautiful", "Adjective"), createItemData("Wall", "Noun")]


# greetings support text
var grettingsLessonPlanText = [
"Les salutations sont des phrases très important dan chaque langue parce qu'il représente la politesse. Si vous vouliez apprendre l'anglais, vous devriez apprendre les salutations. Bonne chance!\n \nSALUTATIONS FORMELLES: ARRIVÉE\nGood morning / Good eveing-> Bonjour / Bonsoir\nHello Esther, how are you?->Bonjour Esther, comment vas-tu?\nGood day Sir / Madam (très formelle)\n->Bonne journée Monsieur / Madame\nRépondez à un accueil formel avec un autre accueil formel.\nGood morning Mr. Pierre->Bonjour monsieur Pierre.\nHello Ms. Louis. How are you today?\n->Bonjour, Madame Louis. Comment vas-tu aujourd'hui?",
"\nSALUTATION INFORMELLE: ARRIVÉE\nHi / Hello -> Salut / Bonjour\nHow are you? -> Comment allez-vous?\nWhat's up? (Très informel) -> Quoi de neuf?\n \nIl est important de noter que la question How are you? Ou What's up?  N'a pas besoin d'une réponse. Si vous répondez, ces phrases sont généralement attendues:\n \nHow are you? / How are you doing? -> Comment allez-vous?\nVery well, thank you. And you? (formel) -> Très bien merci. Et toi\nFine / Great (informel)  -> Je vais bien/ Je suis génial",
"SALUTATIONS FORMELLES: DÉPARTE\nUtilisez ces salutations quand vous dites au revoir en fin de journée. Ces salutations sont appropriées pour le travail et d'autres situations formelles.\nIt was a pleasure seeing you->C'était un plaisir de vous voir\nGoodbye. -> Au Revoir.\nRemarque: après 8 heures - Bonne nuit.\n \nSALUTATION INFORMELLE: DÉPARTE\nUtilisez ces salutations en vous disant au revoir dans une situation informelle.\nNice seeing you! -> C'est bien de te voir!\nGoodbye / Bye - > Au Revoir\nSee you later -> À plus tard\nLater (très informel) -> Plus tard"
]
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
var changingScene = false
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

extends Node

# useful for transfering data between scenes
#var foo = 3

var chapter_2_score = 100

var item = [createItemData("Push", "Verb"), createItemData("Brick", "Noun"), createItemData("Beautiful", "Adjective"), createItemData("Wall", "Noun")]

# MULTIPLE CHOICE QUESTIONS
# Chapter 1 Questions
var greetingsMultipleChoiceQuestions = [
"Question: Selon le contexte, que veut dire 'How are you?'",
"Question: Quand vous retrouvez quelqu'un(e), qu'est-ce que vous dites",
"Question: Laquelle est la traduction de Je vais bien ?",
"Traduisez: Bonjour, comment allez-vous ?",
"Question 1: Comment dit-on «oui» en anglais ?",
"Question 2: Comment dit-on «je m'appelle» ?",
"Question 3: Que veut dire «Thank you» ?",
"Choisissez la bonne traduction pour la réponse que le marchand a dit à Marie-Thérèse à la fin de la scène."
]
var possNounsMultipleChoiceQuestions = [
"Regardez encore une fois: << Marie-Thérèse's cat >>. Quel mot ici est le nom?",
"Révisons ! Quel est l'ordre pour former un nom possessif en anglais ?",
"Une question de plus ! Comment dirait-on l'amie de Sidney ?"
]
var possNounsMultipleChoiceAnswers = [
"a. cat",
"b. Marie-Thérèse's",
"c. Étranger",
"a. sujet + objet + 's",
"b. objet + sujet + 's",
"c. sujet + 's + objet",
"a. The friend of Sidney",
"b. Sidney's friend",
"c. Sidney friend's"
]
var greetingsMultipleChoiceAnswers = [
"a. Comment allez-vous?",
"b. Bonjour",
"c. Comment vous appelez-vous?",
"a. Goodbye!",
"b. Hello!",
"c. How are you?",
"a. I like math",
"b. I am sad",
"c. I am well",
"a. Goodbye!",
"b. Hello, how are you?",
"c. Hi, Marie-Thérèse", #sttart end
"a.  yes",
"b. soccer",
"c. no",
"a. hello",
"b. thank you",
"c. my name is",
"a. j'ai faim",
"b. merci",
"c. au revoir",
"a. merci, au revoir !",
"b. de rien, merci !",
"c. de rien, au revoir !"
]

var greetingsMultipleChoiceCorrectIndices = [0, 1, 2, 1, 0, 2, 1, 2]
var possNounsMultipleChoiceCorrectIndices = [0, 2, 1]
# greetings support text
var grettingsLessonPlanText = [
"Les salutations sont des phrases très important dan chaque langue parce qu'il représente la politesse. Si vous vouliez apprendre l'anglais, vous devriez apprendre les salutations. Bonne chance!\n \nSALUTATIONS FORMELLES: ARRIVÉE\nGood morning / Good evening-> Bonjour / Bonsoir\nHello Esther, how are you?->Bonjour Esther, comment vas-tu?\nGood day Sir / Madam (très formelle)\n->Bonne journée Monsieur / Madame\nRépondez à un accueil formel avec un autre accueil formel.\nGood morning Mr. Pierre->Bonjour monsieur Pierre.\nHello Ms. Louis. How are you today?\n->Bonjour, Madame Louis. Comment vas-tu aujourd'hui?",
"\nSALUTATION INFORMELLE: ARRIVÉE\nHi / Hello -> Salut / Bonjour\nHow are you? -> Comment allez-vous?\nWhat's up? (Très informel) -> Quoi de neuf?\n \nIl est important de noter que la question How are you? Ou What's up?  N'a pas besoin d'une réponse. Si vous répondez, ces phrases sont généralement attendues:\n \nHow are you? / How are you doing? -> Comment allez-vous?\nVery well, thank you. And you? (formel) -> Très bien merci. Et toi\nFine / Great (informel)  -> Je vais bien/ Je suis génial",
"SALUTATIONS FORMELLES: DÉPARTE\nUtilisez ces salutations quand vous dites au revoir en fin de journée. Ces salutations sont appropriées pour le travail et d'autres situations formelles.\nIt was a pleasure seeing you->C'était un plaisir de vous voir\nGoodbye. -> Au Revoir.\nRemarque: après 8 heures - Bonne nuit.\n \nSALUTATION INFORMELLE: DÉPARTE\nUtilisez ces salutations en vous disant au revoir dans une situation informelle.\nNice seeing you! -> C'est bien de te voir!\nGoodbye / Bye - > Au Revoir\nSee you later -> À plus tard\nLater (très informel) -> Plus tard"
]
var possesiveNounLessonPlanText = [
"\nLes noms possessifs, ou possessive nouns en anglais, expriment une relation entre une chose et l'autre. Regardez attentivement.\n\n\nPosséder quelque chose signifie avoir ou posséder quelque chose. Les noms possesseurs montrent qu'une personne, un animal, un lieu, une chose ou une idée a ou possède quelque chose. Dans ce film, vous découvrirez différentes façons de rendre les noms singuliers et pluriels possessifs. Vous pouvez ajouter une apostrophe et un 's' à la fin d'un mot, ou simplement une apostrophe.",
"\nLes règles suivantes s'appliquent:\n\n1. Si le nom possessif est singulier, ajoutez toujours une apostrophe + s.\n2. Si le nom possessif ne se termine pas par -s (sous sa forme écrite), ajoutez toujours une apostrophe + s.\n3. Si le nom possessif est au pluriel et se termine en -s (et c'est une caractéristique de la grande majorité des noms de plural), ajoutez simplement une apostrophe.",
"\nC'est pourquoi vous dites 'James's books', 'the children's books', et même 'the boss's books'. C'est aussi pourquoi vous ne savez pas si quelque chose appartient à un ou plusieurs garçons jusqu'à ce que vous voyiez la phrase par écrit.\n \nPour simplifier les choses, tout ce que vous devez vraiment retenir est la règle 3. Si la règle 3 ne s'applique pas, ajoutez toujours une apostrophe + s.\n \nAussi, notez que l'anglais américain ne suit pas toujours ces règles."
]
var pronounsLessonPlanText = [
"Les pronoms, ou pronouns en anglais, sont des mots qui remplacent des noms. On va les explorer maintenant, mais pas avant qu'on ne fasse connaissance de la famille de Marie-Thérèse !\n \nLes pronoms changent en fonction de la personne, du nombre et de la fonction dans une phrase. Nous utilisons différents pronoms pour les personnes que nous connaissons et les personnes que nous ne faisons pas. Nous utilisons les pronoms pour poser des questions, attirer l'attention sur certains objets et montrer la propriété.",
"Pour mieux comprendre moi et les membres de ma famille, il faudra qu’on les décrive ! Les pronoms en anglais sont:\n \n      I : je\n      You: tu/vous\n      We: nous\n      He/She: il/elle\n      They: ils/elles",
"C'est pourquoi vous dites 'James's books', 'the children's books', et même 'the boss's books'. C'est aussi pourquoi vous ne savez pas si quelque chose appartient à un ou plusieurs garçons jusqu'à ce que vous voyiez la phrase par écrit.\n \nPour simplifier les choses, tout ce que vous devez vraiment retenir est la règle 3. Si la règle 3 ne s'applique pas, ajoutez toujours une apostrophe + s.\n \nAussi, notez que l'anglais américain ne suit pas toujours ces règles."
]
# Nouns Suppor Text
var nounsLessonPlanTop = [
"",
"",
""
]
var nounsLessonPlanBottom = [
"Les noms, aussi connu comme le substantif, ou nouns en anglais, sont des mots qui fonctionnent comme la désignation par une personne, un animal, une chose, une idée, une catégorie.\n \nIl est très important de savoir que bien que les noms en français varient du genre, en anglais il n'y a jamais une change du genre des noms.\n \nRegardez Marie-Thérèse attentivement pour apprendre plus. Bonne chance !",
"",
""
]
# Nouns multiple choice questions
var nounsMultipleChoiceQuestions = [
"Question: Selon le contexte, quel mot est quelque chose que MT n'aime pas ?",
"Question finale: Choisissez le nom et sa traduction correcte dans la liste suivante:"
]
var nounsMultipleChoiceAnswers = [
"a. math",
"b. morning",
"c. school",
"a. school / l'église",
"b. like / aimer",
"c. school / l'école"
]
var nounsMultipleChoiceCorrectIndices = [0, 2] # a, c

# not currently used
var nounsQuestions = [
"Question 2: Il s'agit d'une autre question sur les noms qui se trouvaient dans le plan de cours",
"Question 3: Quelle sentance utilise les noms en anglais sous la forme appropriée ci-dessous",
"Question 4: Je ne peux plus penser à d'autres questions à utiliser comme texte de remplissage, donc je pose ça?",
"Question 5: C'est la dernière question à choix multiple. Quel est l'exemple d'un nom?" 
]

# Pronouns Support Text
#var pronounsLessonPlanTop = [
#"Ce chapitre vous présentera comment les noms sont utilisés en anglais. Vous pouvez vous référer à cet écran à tout moment en appuyant sur la touche TAB. Utilisez les touches fléchées pour faire défiler cet écran pour afficher des exemples.",
#"Next pages of lessons top section..",
#"Another page of lesson stuff.."
#]
#var pronounsLessonPlanBottom = [
#"Le nom est la première des huit parties du discours. Les noms peuvent être utilisés de différentes manières. Ils peuvent être communs ou appropriés. Ils peuvent être des sujets de phrases ou d'objets directs, nominatifs prédicats, objets de prépositions et objets indirects. Il y a aussi des noms d'adresse, des objets d'infinitives et des noms de gerundus.",
#"maybe have examples here",
#"Maybe add some more examples here..."
#]
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
var correct_answer_chosen = false
var scene_1_restart = false

func reset_score():
	chapter_2_score = 100
	return chapter_2_score

func createItemData(_Name, _Type):
	return {Name = _Name, Type = _Type}

func createCurrentPokemon(_Name, _Health, _XP, _Level):
	return {Name = _Name, Health = _Health, XP = _XP, Level = _Level}

func _ready():
	#print(createCurrentPokemon("Ryan", 100, 0, 1))
	#var testObj = createCurrentPokemon("Ryan", 100, 0, 1)
	#print(testObj)
	pass

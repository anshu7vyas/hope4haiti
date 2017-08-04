extends Node

# useful for transfering data between scenes
#var foo = 3

var item = [createItemData("Push", "Verb"), createItemData("Brick", "Noun"), createItemData("Beautiful", "Adjective"), createItemData("Wall", "Noun")]

var isNewGame = true
var message_done = false
var collision_finished = false

func createItemData(_Name, _Type):
	return {Name = _Name, Type = _Type}

func createCurrentPokemon(_Name, _Health, _XP, _Level):
	return {Name = _Name, Health = _Health, XP = _XP, Level = _Level}

func _ready():
	#print(createCurrentPokemon("Ryan", 100, 0, 1))
	#var testObj = createCurrentPokemon("Ryan", 100, 0, 1)
	#print(testObj)
	pass

# Scene 1 Outside Script (Entire World)
extends Node2D

onready var directionNode = get_node("direction_arrow")
onready var compassNode = get_node("compassBG")

func _ready():
	set_fixed_process(true)
	directionNode.show()
	compassNode.show()
	singleton.message_done = true

func _fixed_process(delta):
	if !singleton.message_done: #disable direction arrow
		directionNode.hide()
		compassNode.hide()
		get_node("Player").canMove = false
	else: # Re-enable direction arrow when convo finished
		directionNode.show()
		compassNode.show()


func neighbor1_dialogue():
	var player_pos = get_node("Player").get_pos() #get position of the player to place the dialogue box
	get_node("neighbor1_dialoge").set_pos(Vector2(player_pos.x-76, player_pos.y+31)) #hardcoded distance to position middle bottom
	get_node("neighbor1_dialoge").set_hidden(false)
	get_node("neighbor1_dialoge")._print_dialogue(get_node("dialogeObj/StaticBody2D/dialogue1").text) 

func neighbor2_dialogue():
	var player_pos = get_node("Player").get_pos() #get position of the player to place the dialogue box
	get_node("neighbor1_dialoge").set_pos(Vector2(player_pos.x-76, player_pos.y+31)) #hardcoded distance to position middle bottom
	get_node("neighbor1_dialoge").set_hidden(false)
	get_node("neighbor1_dialoge")._print_dialogue(get_node("dialogeObj/StaticBody2D/dialogue2").text) 
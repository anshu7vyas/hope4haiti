extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	set_fixed_process(true)
	

func _fixed_process(delta):
	pass
	#if singleton.collision_finished:
		#print("object gone")
		#singleton.collision_finished = false
		#OS.delay_msec(50)
		#get_node("Player").canMove = false
		#intro_dialogue()
		#get_node("KinematicBody2D/StaticBody2D/CollisionShape2D").set_trigger(true)
		#OS.delay_msec(5000)
		#get_node("Node2D").queue_free()

		

func intro_dialogue():
	var player_pos = get_node("Player").get_pos() #get position of the player to place the dialogue box
	get_node("neighbor1_dialoge").set_pos(Vector2(player_pos.x-76, player_pos.y+31)) #hardcoded distance to position middle bottom
	get_node("neighbor1_dialoge").set_hidden(false)
	get_node("neighbor1_dialoge")._print_dialogue(get_node("dialogeObj/StaticBody2D/dialogue1").text) 
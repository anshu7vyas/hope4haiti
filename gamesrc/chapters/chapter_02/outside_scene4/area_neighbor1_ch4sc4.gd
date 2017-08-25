extends Area2D

var area_count = 0
var done = false

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass


func _on_area_neighbor_body_enter( body ):
	area_count += 1
	if area_count > 2 and !done:
		done = true
		get_parent().neighbor_dialogue1()


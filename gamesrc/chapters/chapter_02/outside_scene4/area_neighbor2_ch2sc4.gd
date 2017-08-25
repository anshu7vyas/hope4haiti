extends Area2D

var area_count = 0
var done = false
func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass


func _on_area_neighbor2_body_enter( body ):
	area_count += 1
	print("here")
	if get_parent().neighbor2_enabled and !done:
		done = true
		get_parent().neighbor2_dialogue()

extends Area2D

var area_count = 0
var do_once = false

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass


func _on_area_fill_water_body_enter( body ):
	area_count += 1
	if area_count > 1 and !do_once:
		do_once = true
		get_parent().fill_water()

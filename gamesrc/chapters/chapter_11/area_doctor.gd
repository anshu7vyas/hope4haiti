extends Area2D

var area_count = 0

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _on_area_doctor_body_enter( body ):
	area_count += 1
	if area_count > 1:
		get_parent().doctor_dialogue()


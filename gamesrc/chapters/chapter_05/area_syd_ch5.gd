extends Area2D

var area_count = 0

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass


func _on_area_sydney_body_enter( body ):
	area_count += 1
	if area_count > 1 and !get_parent().syd_dialogue_started:
		get_parent().sydney_dialogue()

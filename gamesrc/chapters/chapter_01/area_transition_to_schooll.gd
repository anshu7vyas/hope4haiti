extends Area2D

var area_count = 0
onready var worldNode = get_parent()

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass


func _on_area_transition_to_class_body_enter( body ):
	area_count += 1
	if area_count > 1:
		if worldNode.scene_complete:
			get_tree().change_scene("res://chapters/chapter_02/classroom_scene2/classroom.tscn")
			OS.delay_msec(50)
			

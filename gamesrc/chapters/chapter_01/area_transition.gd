extends Area2D

var area_count = 0
onready var worldNode = get_parent()

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass


func _on_Area2D1_body_enter( body ):
	area_count += 1
	if area_count > 1:
		singleton.currentChapter = 1
		get_tree().change_scene("res://chapters/chapter_01/ch1_outside_world.tscn")

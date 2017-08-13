extends Area2D

var area_count = 0
onready var worldNode = get_parent()

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _on_area_neighbor2_body_enter( body ):
	area_count += 1
	if area_count > 1:
		worldNode.get_node("Player").canMove = false
		worldNode.neighbor2_alerted = true

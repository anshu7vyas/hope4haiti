extends Area2D

var area_count = 0
onready var worldNode = get_parent()

func _ready():
	pass

func _on_area_neighbor3_body_enter( body ):
	area_count += 1
	if area_count > 1 and worldNode.neighbor2_done:
		worldNode.get_node("Player").canMove = false
		worldNode.school_dialogue()
		self.queue_free()

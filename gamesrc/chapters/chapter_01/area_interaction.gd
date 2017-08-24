extends Area2D

var area_count = 0
onready var worldNode = get_parent()

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _on_Area2D_body_enter( body ):
	area_count += 1
	if area_count > 1 and !worldNode.first_multiple_choice_section_done:
		worldNode.get_node("Player").canMove = false
		worldNode.neighbor1_dialogue()
		#self.queue_free() #deletes the Sprite


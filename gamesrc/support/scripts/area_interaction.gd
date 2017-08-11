extends Area2D

var area_count = 0
onready var worldNode = get_parent()
var dialogue1_done = false
var dialogue2_done = false

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass


func _on_Area2D_body_enter( body ):
	area_count += 1
	if area_count > 1:
		print("actually in area")
		worldNode.get_node("Player").canMove = false
		worldNode.neighbor1_dialogue()
		

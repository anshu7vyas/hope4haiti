extends Area2D

var area_count = 0


func _ready():
	pass




func _on_area_mother_body_enter( body ):
	area_count += 1
	if area_count > 1:
		get_parent().mother_dialogue()


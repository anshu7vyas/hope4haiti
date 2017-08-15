# Contains the logic for all levels
extends Node

signal failed()
signal victory()

var player

func _ready():
	player = find_node("Hero")
	if(player == null):
		printerr("Warning: you must have a player in your level")
		return
	player.connect("killed", self, "_on_player_killed")
	
func _on_player_killed():
	emit_signal("failed")

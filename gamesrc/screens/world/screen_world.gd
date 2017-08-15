# Contains logic for the game screen
extends '../abstract_screen.gd'

var content
var retry_dialog
var correct_response_dialog
var failed_response_dialog
var current_chapter

var chapters = {
#			"chapter1" : preload(),
#			"chapter2" : preload(),
#			"chapter3" : preload(),
#			"chapter4" : preload(),
#			"chapter5" :preload(),
		}

func _ready():
	content = find_node("Content")
	retry_dialog = find_node("RetryDialog")
	correct_response_dialog = find_node("CorrectResponseDialog")
	failed_response_dialog = find_node("FailedResponseDialog")
	
func _load_chapters(name):
	if name in chapters:
		var old_chapter = null
		if content.get_child_count() > 0:
			old_chapter = content.get_child(0)
		if old_chapter != null:
			content.remove_child(old_chapter)
		
		var chapter = chapters[name].instance()
		content.add_child(chapter)
		
		current_chapter = name
	else:
		print("[ERROR] Cannot load chapter: ", name)

func _retry():
	print("RETRY")
	_load_chapters(current_chapter)
	get_tree().set_pause(false)

func _on_exit_pressed():
	get_tree().set_pause(false)
	emit_signal("next_screen", "main_menu")



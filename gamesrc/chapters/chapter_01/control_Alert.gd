extends AcceptDialog

var interact = false
var alerts = ["\nPress Space to continue reading dialogue",
"\nUse the Arrow keys to direct the character",
"\nMaintenant, on va intégrer un nom important.\nRegardez attentivement.",
"\nNon, ce n'est pas le cas. Réessayer!",
"\nTrès bien! A est correct",
"To access the menu press the Tab key",
"To interact with objects press the space bar"]

func _ready():
	#self.popup_centered(Vector2(-63,-9))
	set_process_input(true)
	set_fixed_process(true)

func _input(event):
	if event.is_action_pressed("ui_interact"):
		self.hide()

func _fixed_process(delta):
	if self.is_visible():
		get_tree().get_root().get_node("./world/Player").canMove = false
	else:
		get_tree().get_root().get_node("./world/Player").canMove = true

func _print_alert(alert_index):
	self.set_text(alerts[alert_index])
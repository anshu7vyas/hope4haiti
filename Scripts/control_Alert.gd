extends AcceptDialog

var interact = false
var alerts = ["\nPress Space to continue reading dialogue",
"\nUse the Arrow keys to direct the character",
"To access the menu press the Tab key",
"To interact with objects press the space bar"]

func _ready():
	#self.popup_centered(Vector2(-63,-9))
	set_process_input(true)
	set_fixed_process(true)

func _input(event):
	if event.is_action_pressed("ui_interact"):
		interact = true
	elif event.is_action_released("ui_interact"):
		interact = false

func _fixed_process(delta):
	if interact:
		self.get_ok()

func _print_alert(alert_index):
	self.set_text(alerts[alert_index])
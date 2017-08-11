extends CanvasLayer

var itemsHolder
var up = false
var down = false
var menu = false
var currentItem = 0

func _ready():
	var items = load("res://gamesrc/support/Item.tscn")
	itemsHolder = get_node("ItemsHolder")
	var x = 0 
	var y = 0
	get_node("Name").set_text(singleton.item[0].Name)
	get_node("Type").set_text(singleton.item[0].Type)
	for i in singleton.item:
		var node = items.instance()
		node.set_pos(Vector2(x,y))
		node.get_node("Label").set_text(i.Name)
		itemsHolder.add_child(node)
		y += 48+10 #48 hard coded from Item.tscn patch9frame rect y value
	set_process_unhandled_key_input(true)
	set_process(true)
func _unhandled_key_input(key_event):
	if key_event.is_action_pressed("ui_menu"):
		menu = true
	elif key_event.is_action_released("ui_menu"):
		menu = false
	if key_event.is_action_pressed("ui_down"):
		down = true
	elif key_event.is_action_released("ui_down"):
		down = false
	if key_event.is_action_pressed("ui_up"):
		up = true
	elif key_event.is_action_released("ui_up"):
		up = false

func _process(delta):
	if up and currentItem < singleton.item.size()-1:
		itemsHolder.set_pos(itemsHolder.get_pos() + Vector2(0, -(48+10)))
		currentItem += 1
		get_node("Name").set_text(singleton.item[currentItem].Name)
		get_node("Type").set_text(singleton.item[currentItem].Type)
	elif down and currentItem > 0:
		itemsHolder.set_pos(itemsHolder.get_pos() + Vector2(0, (10+48)))
		currentItem -= 1
		get_node("Name").set_text(singleton.item[currentItem].Name)
		get_node("Type").set_text(singleton.item[currentItem].Type)

	if menu:
		get_node("/root/world/Player/Camera2D/menu").open = true
		queue_free()
	up = false
	down = false
	menu = false

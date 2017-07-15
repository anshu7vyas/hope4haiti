extends KinematicBody2D

var direction = Vector2(0,0)
var startPos = Vector2(0,0)
var moving = false

var canMove = true
var interact = false
var menu = false

const SPEED = 1
const GRID = 16

var world

var sprite
var animationPlayer

func _ready():
	world = get_world_2d().get_direct_space_state()
	set_fixed_process(true)
	set_process_input(true)
	sprite = get_node("Sprite")
	animationPlayer = get_node("AnimationPlayer")

func _input(event):
	if event.is_action_pressed("ui_interact"):
		interact = true
	elif event.is_action_released("ui_interact"):
		interact = false
	if event.is_action_pressed("ui_menu"):
		menu = true
	elif event.is_action_released("ui_menu"):
		menu = false

func _fixed_process(delta):
	#print(str(singleton.foo)) #access singleton info
	if !moving and canMove:
		var resultUp = world.intersect_point(get_pos() + Vector2(0, -GRID))
		var resultDown = world.intersect_point(get_pos() + Vector2(0, GRID))
		var resultLeft = world.intersect_point(get_pos() + Vector2(-GRID, 0))
		var resultRight = world.intersect_point(get_pos() + Vector2(GRID, 0))
		if Input.is_action_pressed("ui_up"):
			sprite.set_frame(10) #sprite facing up
			if resultUp.empty():
				moving = true
				direction = Vector2(0, -1)
				startPos = get_pos()
				animationPlayer.play("walk_up")
		elif Input.is_action_pressed("ui_down"):
			sprite.set_frame(1) #sprite facing down
			if resultDown.empty():
				moving = true
				direction = Vector2(0, 1)
				startPos = get_pos()
				animationPlayer.play("walk_down")
		elif Input.is_action_pressed("ui_left"):
			sprite.set_frame(4) #sprite facing left
			if resultLeft.empty():
				moving = true
				direction = Vector2(-1, 0)
				startPos = get_pos()
				animationPlayer.play("walk_left")
		elif Input.is_action_pressed("ui_right"):
			sprite.set_frame(7) #sprite facing right
			if resultRight.empty():
				moving = true
				direction = Vector2(1, 0)
				startPos = get_pos()
				animationPlayer.play("walk_right")
		
		if interact:
			if sprite.get_frame() == 10: #character is facing up
				interact(resultUp)
			elif sprite.get_frame() == 1: #character is facing down
				interact(resultDown)
			elif sprite.get_frame() == 4: #character is facing left
				interact(resultLeft)
			elif sprite.get_frame() == 7: #character is facing right
				interact(resultRight)
		if menu and !interact:
			get_node("Camera2D/menu")._open_menu()
	elif canMove:
		move_to(get_pos() + direction * SPEED)
		if get_pos() == startPos + Vector2(GRID * direction.x, GRID * direction.y):
			moving = false
	interact = false
	menu = false


func interact(result):
	for dictionary in result:
		if typeof(dictionary.collider) == TYPE_OBJECT and dictionary.collider.has_node("Interact"):
			get_node("Camera2D/dialogue_box").set_hidden(false)
			get_node("Camera2D/dialogue_box")._print_dialogue(dictionary.collider.get_node("Interact").text)
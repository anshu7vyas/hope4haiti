extends KinematicBody2D

var direction = Vector2(0,0)
var startPosition = Vector2(0,0)
var moving = false

const SPEED = 1
const GRID = 16

var world

func _ready():
	world = get_world_2d().get_direct_space_state()
	set_fixed_process(true)

func _fixed_process(delta):
	if !moving:
		var resultUp = world.intersect_point(get_pos() + Vector2(0, -GRID))
		var resultDown = world.intersect_point(get_pos() + Vector2(0, GRID))
		var resultLeft = world.intersect_point(get_pos() + Vector2(-GRID, 0))
		var resultRight = world.intersect_point(get_pos() + Vector2(GRID, 0))
		
		if Input.is_action_pressed("ui_up") and resultUp.empty():
			moving = true
			direction = Vector2(0, -1)
			startPosition = get_pos()
		elif Input.is_action_pressed("ui_down") and resultDown.empty():
			moving = true
			direction = Vector2(0, 1)
			startPosition = get_pos()
		elif Input.is_action_pressed("ui_left") and resultLeft.empty():
			moving = true
			direction = Vector2(-1, 0)
			startPosition = get_pos()
		elif Input.is_action_pressed("ui_right") and resultRight.empty():
			moving = true
			direction = Vector2(1, 0)
			startPosition = get_pos()
	else:
		move_to(get_pos() + direction * SPEED)
		if get_pos() == startPosition + Vector2(GRID * direction.x, GRID * direction.y):
			moving = false

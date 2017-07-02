extends KinematicBody2D

var direction = Vector2(0,0)
var startPosition = Vector2(0,0)
var moving = false

const SPEED = 1
const GRID = 16

var world

var sprite
var animationPlayer

func _ready():
	world = get_world_2d().get_direct_space_state()
	set_fixed_process(true)
	sprite = get_node("Sprite")
	animationPlayer = get_node("AnimationPlayer")

func _fixed_process(delta):
	if !moving:
		var resultUp = world.intersect_point(get_pos() + Vector2(0, -GRID))
		var resultDown = world.intersect_point(get_pos() + Vector2(0, GRID))
		var resultLeft = world.intersect_point(get_pos() + Vector2(-GRID, 0))
		var resultRight = world.intersect_point(get_pos() + Vector2(GRID, 0))
		if Input.is_action_pressed("ui_up"):
			sprite.set_frame(10)
			if resultUp.empty():
				moving = true
				direction = Vector2(0, -1)
				startPosition = get_pos()
				animationPlayer.play("walk_up")
		elif Input.is_action_pressed("ui_down"):
			sprite.set_frame(1)
			if resultDown.empty():
				moving = true
				direction = Vector2(0, 1)
				startPosition = get_pos()
				animationPlayer.play("walk_down")
		elif Input.is_action_pressed("ui_left"):
			sprite.set_frame(4)
			if resultLeft.empty():
				moving = true
				direction = Vector2(-1, 0)
				startPosition = get_pos()
				animationPlayer.play("walk_left")
		elif Input.is_action_pressed("ui_right"):
			sprite.set_frame(7)
			if resultRight.empty():
				moving = true
				direction = Vector2(1, 0)
				startPosition = get_pos()
				animationPlayer.play("walk_right")
	else:
		move_to(get_pos() + direction * SPEED)
		if get_pos() == startPosition + Vector2(GRID * direction.x, GRID * direction.y):
			moving = false

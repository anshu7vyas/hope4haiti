extends KinematicBody2D

var direction = Vector2(0,0)
var startPos = Vector2(0,0)
var moving = false

var canMove = true
var interact = false
var start_walk_wait = false
var walk_done = false
var time_delta = 0
var count = 0

onready var worldNode = get_parent()


var world
var sprite
var animationPlayer

const SPEED = 1 #change speed for testing
const GRID = 16

func _ready():
	world = get_world_2d().get_direct_space_state()
	set_fixed_process(true)
	sprite = get_node("Sprite")
	animationPlayer = get_node("AnimationPlayer")
	sprite.set_frame(10)

func _fixed_process(delta):
	time_delta += delta

	if time_delta > 0.3 and worldNode.name_challenge_done and !worldNode.get_node("PopupDialog").is_visible() and !walk_done:
		count += 1
		if count < 8:
			walk_right()
		elif count < 20:
			walk_down()
		elif count < 27:
			walk_right()
		else:
			sprite.set_frame(10)
			OS.delay_msec(50)
			count = 0
			walk_done = true
		time_delta = 0



func walk_left():
	direction = Vector2(-16, 0)
	animationPlayer.play("walk_left2")
	move_to(get_pos() + direction * SPEED)

func walk_right():
	direction = Vector2(16, 0)
	animationPlayer.play("walk_left")
	move_to(get_pos() + direction * SPEED)

func walk_up():
	direction = Vector2(0, -16)
	animationPlayer.play("walk_down")
	move_to(get_pos() + direction * SPEED)

func walk_down():
	direction = Vector2(0, 16)
	animationPlayer.play("walk_right")
	move_to(get_pos() + direction * SPEED)
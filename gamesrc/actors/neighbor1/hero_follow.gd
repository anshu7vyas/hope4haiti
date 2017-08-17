extends KinematicBody2D

var direction = Vector2(0,0)
var startPos = Vector2(0,0)
var moving = false

var canMove = true
var interact = false
var start_walk_wait = false
var at_teacher = false
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
	sprite.set_frame(7)
	worldNode.teacher_dialogue_done = false

func _fixed_process(delta):
	time_delta += delta
	if time_delta > 0.5 and !start_walk_wait:
		start_walk_wait = true
		time_delta =0
	
	if time_delta > 0.3 and start_walk_wait and !worldNode.teacher_dialogue_done and !at_teacher:
		count += 1
		if count < 5:
			walk_left()
		elif count < 11:
			walk_up()
		elif count < 16:
			walk_left()
		else:
			sprite.set_frame(1)
			OS.delay_msec(50)
			at_teacher = true
			count = 0
		time_delta = 0
	elif time_delta > 0.3 and worldNode.teacher_dialogue_done and singleton.message_done:
		count += 1
		if count < 4:
			walk_down()
		elif count < 5:
			walk_right()
		else:
			sprite.set_frame(1)
		time_delta = 0
	
	#if get_pos() == Vector2(-126, -84): # classmate is at teacher
		#sprite.set_frame(1)
		#at_teacher = true


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
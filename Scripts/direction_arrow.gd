extends Node2D
# GDquest colors
var colors = {
	WHITE = Color(1.0, 1.0, 1.0),
	YELLOW = Color(1.0, .757, .027),
	GREEN = Color(.282, .757, .255),
	BLUE = Color(.098, .463, .824),
	PINK = Color(.914, .118, .388)
}
const WIDTH = 10
const MUL = 15
var parent = null

func _ready():
	parent = get_tree().get_root().get_node("./world/Player")
	set_fixed_process(true)
	update()

func _draw():
	draw_vector(parent.direction, Vector2(), colors['WHITE'])

func draw_vector(vector, offset, _color):
	if vector == Vector2():
		return
	draw_line(offset * MUL, vector * MUL, _color, WIDTH)

	var dir = vector.normalized()
	draw_triangle_equilateral(vector * MUL, dir, 5, _color)
	draw_circle(offset, 2, _color)


func draw_triangle_equilateral(center=Vector2(), direction=Vector2(), radius=30, _color=WHITE):
	var point_1 = center + direction * radius
	var point_2 = center + direction.rotated(2*PI/3) * radius
	var point_3 = center + direction.rotated(4*PI/3) * radius
	var points = Vector2Array([point_1, point_2, point_3])
	draw_polygon(points, ColorArray([_color]))

func _fixed_process(delta):
	var pos = parent.get_pos()
	self.set_pos(Vector2(pos.x, pos.y+15))
	update()

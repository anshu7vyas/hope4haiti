extends Node2D
# GDquest colors
var colors = {
	WHITE = Color(1.0, 1.0, 1.0),
	YELLOW = Color(1.0, .757, .027),
	GREEN = Color(.282, .757, .255),
	BLUE = Color(.098, .463, .824),
	PINK = Color(.914, .118, .388),
	BLACK = Color(0.0, 0.0, 0.0),
	AMBER = Color(0.486, 0.176, 0.063),
	RED = Color(0.900, 0.0, 0.0)
}
const WIDTH = 10
const MUL = 8
var parent = null
var outline_radius = 14
onready var bgNode = get_tree().get_root().get_node("./world/compassBG")

func _ready():
	parent = get_tree().get_root().get_node("./world/Player")
	set_fixed_process(true)
	update()

func _draw():
	draw_vector(parent.direction, Vector2(), colors['WHITE'], 2)
	draw_vector(parent.direction, Vector2(), colors['GREEN'], 0)
	#used for drawing circle outline before compass BG
	#draw_circle_arc(Vector2(), outline_radius, 0, 180, colors['YELLOW'])
	#draw_circle_arc(Vector2(), outline_radius, 180, 360, colors['YELLOW'])

func draw_circle_arc( center, radius, angle_from, angle_to, color ):  #use 2 arcs to create empty circle
    var nb_points = 32
    var points_arc = Vector2Array()
    for i in range(nb_points+1):
        var angle_point = angle_from + i*(angle_to-angle_from)/nb_points - 90
        var point = center + Vector2( cos(deg2rad(angle_point)), sin(deg2rad(angle_point)) ) * radius
        points_arc.push_back( point )
    for indexPoint in range(nb_points):
        draw_line(points_arc[indexPoint], points_arc[indexPoint+1], color)

func draw_vector(vector, offset, _color, size):
	if vector == Vector2():
		return
	draw_line(offset * MUL, vector * MUL, _color, (WIDTH+size)) #line to triangle (arrow head)
	draw_line(offset * MUL, vector * MUL*(-1.75), _color, (WIDTH+size)) #line back from circle center
	
	var dir = vector.normalized()
	var triagle_size = size
	if size != 0:
		triagle_size = .75
	#draw_triangle_equilateral(vector * MUL, dir, 5, _color)
	draw_triangle_equilateral(vector * MUL, dir, (triagle_size+5), _color)
	draw_circle(offset, 1.5, _color)

func draw_triangle_equilateral(center=Vector2(), direction=Vector2(), radius=30, _color=WHITE):
	var point_1 = center + direction * radius
	var point_2 = center + direction.rotated(2*PI/3) * radius
	var point_3 = center + direction.rotated(4*PI/3) * radius
	var points = Vector2Array([point_1, point_2, point_3])
	draw_polygon(points, ColorArray([_color]))

func _fixed_process(delta):
	var pos = parent.get_pos()
	self.set_pos(Vector2(pos.x, pos.y+60))
	bgNode.set_pos(Vector2(pos.x, pos.y+60))
	update()

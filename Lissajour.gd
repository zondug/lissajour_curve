extends Node2D

var A = 50  # x 진폭
var B = 50  # y 진폭
var a = 1    # x 각진동수
var b = 1    # y 각진동수
var delta_angle = PI/8  # 위상차 (90도)

var time = 0
var speed = 1.0  # 속도 조절 변수

var curves = []
var current_positions = []

func _ready():
	for i in range(8):
		for j in range(8):
			a = i + 1
			b = j + 1
			curves.append(generate_curve(i, j))
			current_positions.append(Vector2.ZERO)

func _process(delta):
	time += delta * speed
	update_current_positions()
	queue_redraw()

func _draw():
	var offset = Vector2(50, 50)
	var spacing = Vector2(120, 120)
	
	for i in range(8):
		for j in range(8):
			var pos = offset + Vector2(j, i) * spacing
			draw_lissajous_curve(curves[i * 8 + j], pos)
			draw_current_position(current_positions[i * 8 + j], pos)

func generate_curve(i, j):
	var curve = []
	for t in range(200):
		var angle = t * PI / 100
		var x = A * sin((i + 1) * angle + j * delta_angle)
		var y = B * sin((j + 1) * angle)
		curve.append(Vector2(x, y))
	return curve

func update_current_positions():
	for i in range(8):
		for j in range(8):
			var index = i * 8 + j
			var angle = time * (i + 1)
			var x = A * sin(angle + j * delta_angle)
			var y = B * sin(time * (j + 1))
			current_positions[index] = Vector2(x, y)

func draw_lissajous_curve(curve, position):
	var points = PackedVector2Array()
	for point in curve:
		points.append(point + position)
	draw_polyline(points, Color.WHITE, 1.0)

func draw_current_position(position, offset):
	draw_circle(position + offset, 5, Color.RED)

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var offset = Vector2(50, 50)
		var spacing = Vector2(120, 120)
		
		for i in range(8):
			for j in range(8):
				var pos = offset + Vector2(j, i) * spacing
				var rect = Rect2(pos - Vector2(60, 60), Vector2(120, 120))
				
				if rect.has_point(event.position):
					print_formula(i, j)

func print_formula(i, j):
	var formula = "x = %d * sin(%d * t + %d * %f)\ny = %d * sin(%d * t)" % [A, i + 1, j, delta_angle, B, j + 1]
	print("Offset (%d, %d) formula:" % [i, j])
	print(formula)

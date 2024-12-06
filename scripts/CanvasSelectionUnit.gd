extends Node2D
@onready var manager = $"../Manager"

var rect_size = Vector2(0, 0)
var rect_color = Color(1, 1, 1)

var is_dragging = false
var drag_threshold = 10
var start_position = Vector2.ZERO

func _draw():
	var rect = Rect2(start_position, rect_size)
	draw_rect(rect, rect_color, false)

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				is_dragging = false
				start_position = get_global_mouse_position()
			else:
				if is_dragging:
					check_elements_in_area(start_position, get_global_mouse_position())
					rect_size = Vector2.ZERO
					queue_redraw()
	elif event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if not is_dragging:
			var distance = event.position.distance_to(start_position)
			if distance > drag_threshold:
				is_dragging = true
		else:
			rect_size = get_global_mouse_position() - start_position
			queue_redraw()

func check_elements_in_area(start_position, end_position):
	var space_state = get_world_2d().direct_space_state

	var shape = RectangleShape2D.new()
	shape.extents = abs(end_position - start_position) / 2

	var query = PhysicsShapeQueryParameters2D.new()
	query.set_shape(shape)
	query.transform = Transform2D(0, (end_position + start_position) / 2)

	var results = space_state.intersect_shape(query)
	for result in results:		
		if (result.collider.ownerPlayer == manager.playerName):
			result.collider.setSelected(true)
			manager.selectedUnits.append(result.collider)


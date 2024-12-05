extends Node2D

var selectedUnits = []

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if not Input.is_key_pressed(KEY_SHIFT):
			selectedUnits = []

		var space_state = get_world_2d().direct_space_state
		var mouse_pos = get_global_mouse_position()
		
		var query = PhysicsPointQueryParameters2D.new()
		query.position = mouse_pos

		var results = space_state.intersect_point(query)

		if results.size() > 0:
			var unit = results[0].collider
			selectedUnits.append(unit)
	
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		var mouse_pos = get_global_mouse_position()		
		var space_between_units = 100
		var columns = 5
		var j = 0
		for i in range(selectedUnits.size()):
			var x = mouse_pos.x + space_between_units * j
			var y = mouse_pos.y + space_between_units * int(i / columns)

			selectedUnits[i].change_target_pos(Vector2(x, y))

			j += 1
			if j >= columns:
				j = 0


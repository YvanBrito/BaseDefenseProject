extends Node2D

var selectedUnits = []
var playerName: String = "player1"

func _input(event):		
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if not Input.is_key_pressed(KEY_SHIFT):
			for i in range(selectedUnits.size()):
				selectedUnits[i].setSelected(false)
			selectedUnits = []
		selectUnit()
	
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		var mouse_pos = get_global_mouse_position()
		gridFormation(mouse_pos)
		#for selectedUnit in selectedUnits:
			#selectedUnit.change_target_pos(mouse_pos)

func selectUnit():
	var space_state = get_world_2d().direct_space_state
	var mouse_pos = get_global_mouse_position()
	
	var query = PhysicsPointQueryParameters2D.new()
	query.position = mouse_pos

	var results = space_state.intersect_point(query)

	if results.size() > 0:
		var unit = results[0].collider
		if (unit.ownerPlayer == playerName):
			unit.setSelected(true)
			selectedUnits.append(unit)

func gridFormation(mouse_pos):
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

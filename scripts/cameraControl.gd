extends Camera2D

var velocity = 2000
var zoom_factor = 0.5

func _ready():
	zoom = Vector2(zoom_factor, zoom_factor)

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom_factor *= 1.1  # Aproxima a câmera (zoom in)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom_factor /= 1.1  # Afasta a câmera (zoom out)
			
		# Limita o zoom
		zoom_factor = clamp(zoom_factor, 0.4, 1.0)
		# Aplica o zoom
		zoom = Vector2(zoom_factor, zoom_factor)

func _process(delta):
	var mouse_pos = get_viewport().get_mouse_position()

	var window_size = get_viewport().size

	if mouse_pos.x <= 0 or Input.is_action_pressed("camera_left"): # Left
		position.x += -1 * velocity * delta
	elif mouse_pos.x >= (window_size.x - 1) or Input.is_action_pressed("camera_right"): # Right
		position.x += 1 * velocity * delta
	
	if mouse_pos.y <= 0 or Input.is_action_pressed("camera_up"): # Up
		position.y += -1 * velocity * delta
	elif mouse_pos.y >= window_size.y or Input.is_action_pressed("camera_down"): # Down
		position.y += 1 * velocity * delta

extends CharacterBody2D

const SPEED = 300.0
const ACCEL = 7.0

@onready var nav: NavigationAgent2D = $NavigationAgent2D
var targetPos: Vector2

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		print("Área clicada!")

func _ready():
	targetPos = position

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		targetPos = get_global_mouse_position()

func _physics_process(delta):
	var direction = Vector2();
	
	if position.distance_to(targetPos) > 1:
		nav.target_position = targetPos
	
		direction = nav.get_next_path_position() - global_position
		direction = direction.normalized()
		
		velocity = velocity.lerp(direction * SPEED, ACCEL * delta)

		move_and_slide()

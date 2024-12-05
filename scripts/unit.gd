extends CharacterBody2D

const SPEED = 300.0
const ACCEL = 7.0

@onready var nav: NavigationAgent2D = $NavigationAgent2D
var targetPos: Vector2

func change_target_pos(newTargetPos):
	targetPos = newTargetPos

func _ready():
	targetPos = position

func _physics_process(delta):
	var direction = Vector2();
	
	if position.distance_to(targetPos) > 1:
		nav.target_position = targetPos
	
		direction = nav.get_next_path_position() - global_position
		direction = direction.normalized()
		
		velocity = velocity.lerp(direction * SPEED, ACCEL * delta)

		move_and_slide()

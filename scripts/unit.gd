extends CharacterBody2D

const SPEED = 300.0
const ACCEL = 7.0

@onready var nav: NavigationAgent2D = $NavigationAgent2D
@onready var selection_mark: Sprite2D = $SelectionMark

var targetPos: Vector2
var selected: bool = false

func setSelected(_isSelected):
	selected = _isSelected

func isSelected():
	return selected

func change_target_pos(newTargetPos):
	targetPos = newTargetPos

func _ready():
	targetPos = position

func _physics_process(delta):
	var direction = Vector2();
	
	selection_mark.visible = selected
	
	if position.distance_to(targetPos) > 1:
		nav.target_position = targetPos
	
		direction = nav.get_next_path_position() - global_position
		direction = direction.normalized()
		
		velocity = velocity.lerp(direction * SPEED, ACCEL * delta)

		move_and_slide()

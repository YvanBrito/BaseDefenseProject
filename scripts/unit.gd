class_name Unit extends CharacterBody2D

const SPEED = 300.0
const ACCEL = 7.0

@onready var nav: NavigationAgent2D = $NavigationAgent2D
@onready var selection_mark: Sprite2D = $SelectionMark
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var health_bar = $HealthBar

var targetPos: Vector2
var selected: bool = false
@export var health: int
@export var ownerPlayer : String

func setSelected(_isSelected):
	selected = _isSelected

func _set_health(value):
	health = value
	health_bar.health = health

func isSelected():
	return selected

func change_target_pos(newTargetPos):
	targetPos = newTargetPos

func _ready():
	targetPos = position
	health_bar.init_health(health)

func _physics_process(delta):
	var direction = Vector2();
	
	selection_mark.visible = selected
	
	if position.distance_to(targetPos) > 1:
		animated_sprite_2d.play("Running")
		nav.target_position = targetPos
	
		direction = nav.get_next_path_position() - global_position
		direction = direction.normalized()
		
		if direction.x < 0:
			animated_sprite_2d.flip_h = true
		else:
			animated_sprite_2d.flip_h = false
		
		velocity = velocity.lerp(direction * SPEED, ACCEL * delta)

		move_and_slide()
	else:
		animated_sprite_2d.play("Idle")
		#animated_sprite_2d.flip_h = true

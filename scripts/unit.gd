class_name Unit extends CharacterBody2D

const SPEED = 300.0
const ACCEL = 7.0

@onready var nav: NavigationAgent2D = $NavigationAgent2D
@onready var selection_mark: Sprite2D = $SelectionMark
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var health_bar = $HealthBar

var targetPos: Vector2
var selected: bool = false
var movement_delta: float
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
	
		direction = global_position.direction_to(nav.get_next_path_position())
		#direction = direction.normalized()
		
		animated_sprite_2d.flip_h = direction.x < 0
		
		velocity = velocity.lerp(direction * SPEED, ACCEL * delta)
		#print(direction * SPEED)
		#nav.set_velocity(direction * SPEED)

		move_and_slide()
	else:
		animated_sprite_2d.play("Idle")
		#animated_sprite_2d.flip_h = true


func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	global_position = global_position.move_toward(global_position + safe_velocity, movement_delta)

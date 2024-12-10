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
	health_bar._set_health(health)

func isSelected():
	return selected

func change_target_pos(newTargetPos):
	nav.target_position = newTargetPos

func _ready():
	nav.target_position = position
	health_bar.init_health(health)
	nav.velocity_computed.connect(Callable(_on_navigation_agent_2d_velocity_computed))

func _physics_process(delta):
	var direction = Vector2()
	
	selection_mark.visible = selected
	
	print(nav.is_navigation_finished())
	if not nav.is_navigation_finished():
		animated_sprite_2d.play("Running")
		direction = global_position.direction_to(nav.get_next_path_position())
		
		animated_sprite_2d.flip_h = direction.x < 0
		
		var new_velocity: Vector2 = direction * SPEED
		if nav.avoidance_enabled:
			nav.set_velocity(new_velocity)
		else:
			_on_navigation_agent_2d_velocity_computed(velocity.lerp(new_velocity, ACCEL * delta))
	else:
		animated_sprite_2d.play("Idle")

func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	velocity = safe_velocity
	move_and_slide()

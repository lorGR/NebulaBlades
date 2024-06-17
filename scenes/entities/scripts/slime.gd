class_name Slime extends CharacterBody2D

#region variables
@export_category("Stats")
@export var HEALTH: float = 25.0
@export var SPEED: float = 35.0
@export var DAMAGE: float = 2.0
@export var ATTACK_SPEED: float = 1
@export var RANGE_PERCENT: float = 100.0

@onready var _sprite = $Sprite
@onready var _player = %Player

#endregion
#region built-ins
func _physics_process(delta):
	if _player != null:
		pass
		#handle_movement(delta) 

#endregion
#region signals
func _on_animation_finished():
	if _sprite.animation == "hurt":
		_sprite.play("move")
	if _sprite.animation == "die":
		queue_free()

#endregion
#region custom
func flip_sprite(direction: Vector2):
	if direction.x > 0:
		_sprite.flip_h = false
	elif direction.x < 0:
		_sprite.flip_h = true

func handle_movement(delta):
	var direction = (_player.global_position - global_position).normalized()
	position += direction * SPEED * delta
	flip_sprite(direction)
#endregion

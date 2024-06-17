class_name Player extends CharacterBody2D

#region variables
@export_category("Stats")
@export var HEALTH: float = 100.0
@export var SPEED: float = 300.0

@onready var _melee: AttackArea = $AttackArea
@onready var _sprite = $Sprite
#endregion
#region built-ins
func _physics_process(delta):
	handle_movement(delta)

#endregion
#region signals
func _on_animation_finished():
	if _sprite.animation == "hurt" || _sprite.animation == "run":
		_sprite.play("idle")
	if _sprite.animation == "die":
		get_tree().change_scene_to_file("res://scenes/levels/gameover.tscn")

#endregion
#region custom
func flip_sprite(direction: Vector2):
	if direction.x > 0:
		_sprite.flip_h = false
	elif direction.x < 0:
		_sprite.flip_h = true

func handle_movement(delta):
	var direction = Input.get_vector("left","right","up","down")
	velocity = direction * SPEED
	move_and_slide()
	if (!_melee._is_damaging):
		_sprite.play("run")
	if (!_melee._is_damaging):
		_sprite.play("idle")
	flip_sprite(direction)
#endregion

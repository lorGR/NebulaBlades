extends CharacterBody2D

#region variables
@export_category("STATS")
@export var SPEED: float = 35.0
@export var DAMAGE: float = 2.0
@export var ATTACK_SPEED: float = 2.3

@onready var hitbox_component = $HitboxComponent
@onready var animated_sprite = $AnimatedSprite2D
@onready var player = %Player
#endregion
#region built-ins
func _process(delta):
	if player != null:
		var direction = (player.global_position - global_position).normalized()
		position += direction * SPEED * delta # move towards player pos
		flip_sprite(direction)

#endregion
#region signals
func _on_animation_finished():
	if animated_sprite.animation == "hurt":
		animated_sprite.play("move")
	if animated_sprite.animation == "die":
		queue_free()

func _on_area_entered(area):
	if area is HitboxComponent:
		var hitbox: HitboxComponent = area
		var attack = Attack.new()
		attack.attack_damage = DAMAGE
		attack.attack_speed = ATTACK_SPEED
		hitbox.damage(attack)

func _on_timer_timeout():
	pass
#endregion
#region custom
func flip_sprite(direction: Vector2):
	if direction.x > 0:
		animated_sprite.flip_h = false
	elif direction.x < 0:
		animated_sprite.flip_h = true
#endregion

extends CharacterBody2D

#region variables
@export_category("STATS")
@export var SPEED: float = 300.0
@export var DAMAGE: float = 10.0
@export var ATTACK_SPEED: float = 1.2

@onready var animated_sprite = $AnimatedSprite2D
var taking_damage = false
#endregion
#region built-ins
func _process(delta):
	pass

func _physics_process(delta):
	var vertical = Input.get_axis("up", "down")
	var horizontal = Input.get_axis("left", "right")
	var direction = Vector2(horizontal, vertical)
	if direction.length() > 0:
		direction = direction.normalized()
		position += direction * SPEED * delta
		if (!self.taking_damage):
			animated_sprite.play("run")
	else:
		if (!self.taking_damage):
			animated_sprite.play("idle")

	flip_sprite(direction)

#endregion
#region signals
func _on_area_entered(area):
	if area is HitboxComponent:
		taking_damage = true
		var hitbox: HitboxComponent = area
		var attack = Attack.new()
		attack.attack_damage = DAMAGE
		attack.attack_speed = ATTACK_SPEED
		hitbox.damage(attack)

func _on_animation_finished():
	if animated_sprite.animation == "hurt" || animated_sprite.animation == "run":
		self.taking_damage = false
		animated_sprite.play("idle")
#endregion
#region custom
func flip_sprite(direction: Vector2):
	if direction.x > 0:
		animated_sprite.flip_h = false
	elif direction.x < 0:
		animated_sprite.flip_h = true
#endregion

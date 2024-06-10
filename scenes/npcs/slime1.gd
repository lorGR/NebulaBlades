extends CharacterBody2D

#region variables
@export_category("STATS")
@export var HEALTH: float = 20.0
@export var SPEED: float = 35.0
@export var DAMAGE: float = 2.0
@export var ATTACK_SPEED: float = 2.0

@onready var animated_sprite = $AnimatedSprite2D
@onready var timer = $Timer
@onready var player = %Player
#endregion
#region built-ins
func _process(delta):
	if player:
		var direction = (player.global_position - global_position).normalized()
		position += direction * SPEED * delta # move towards player pos
		
		flip_sprite(direction)

func _physics_process(delta):
	pass
#endregion
#region signals
func _on_animation_finished():
	if animated_sprite.animation == "hurt":
		animated_sprite.play("move")
	if animated_sprite.animation == "die":
		queue_free()

func _on_timer_timeout():
	print("timer stopped")
	pass
#endregion
#region custom
func flip_sprite(direction: Vector2):
	if direction.x > 0:
		animated_sprite.flip_h = false
	elif direction.x < 0:
		animated_sprite.flip_h = true

func take_damage(amount: float, attack_speed: float):
	timer.one_shot = true
	if timer.is_stopped():
		timer.start(attack_speed)
		if self.HEALTH > 0:
			self.HEALTH -= amount
			animated_sprite.play("hurt")
		else:
			self.SPEED = 0
			animated_sprite.play("die")
#endregion

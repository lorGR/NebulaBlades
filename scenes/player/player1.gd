extends CharacterBody2D

#region variables
@export_category("STATS")
@export var SPEED: float = 300.0
@export var HEALTH: float = 100.0
@export var DAMAGE: float = 10.0
@export var ATTACK_SPEED: float = 1.3

@onready var timer = $Timer
@onready var animated_sprite = $AnimatedSprite2D
@onready var player_collision_area = $Area2D

var taking_damage = false
var level = get_parent()
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
func _on_body_entered(body: Node):
	if body.is_in_group("enemy"):
		var enemy = body # just for clarification
		enemy.take_damage(self.DAMAGE, self.ATTACK_SPEED)
		self.take_damage(enemy.DAMAGE, enemy.ATTACK_SPEED)
		print(self.name + " entered body:" + enemy.name)

func _on_timer_timeout():
	print("timer stopped")

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

func take_damage(amount: float, attack_speed: float):
	self.taking_damage = true
	timer.one_shot = true # makes the timer not restart
	if timer.is_stopped():
		timer.start(attack_speed)
		if self.HEALTH > 0:
			self.HEALTH -= amount
			animated_sprite.play("hurt")
		else:
			self.SPEED = 0
			animated_sprite.play("die")
#endregion

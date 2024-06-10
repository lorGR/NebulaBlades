extends Node2D

@export var SPEED: float = 35.0
@export var HEALTH: float = 10.0
@export var DAMAGE: float = 10.0
@export var ATTACK_SPEED: float = 5.0
@onready var timer = $Timer

@onready var slime_animated_sprite = $AnimatedSprite2D
var player: Node2D

func melee(body: Node2D):
	if (timer.is_stopped()):
		body.HEALTH -= DAMAGE
		timer.start(ATTACK_SPEED)
		print("dealt " + str(DAMAGE) + " to " + body.name)


func _ready():
	print("slime spawned")
	player = %Player

func _process(delta: float):
	if HEALTH <= 0:
		if slime_animated_sprite.animation != "die":
			SPEED = 0
			slime_animated_sprite.play("die")
			

	if player:
		# Calculate the direction to the player
		var direction = (player.global_position - global_position).normalized()
		# Move the enemy towards the player
		position += direction * SPEED * delta

		if direction.x > 0:
			slime_animated_sprite.flip_h = false
		else:
			slime_animated_sprite.flip_h = true

func _on_area_entered(area):
	if area.is_in_group("player"):
		melee(player)
		player.get_child(1).play("hurt")

func _on_animation_finished():
	if slime_animated_sprite.animation == "die":
		queue_free()
		
	if slime_animated_sprite.animation == "hurt":
		slime_animated_sprite.play("move")

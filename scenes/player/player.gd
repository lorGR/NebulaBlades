extends Node2D

@export var SPEED: float = 250.0
@export var HEALTH: float = 35.0
@export var DAMAGE: float = 2
@onready var player_animate_sprite = $AnimatedSprite2D
@onready var area_2d = $Area2D
var enemy

func melee(body: Node2D):
	body.HEALTH -= DAMAGE
	print("dealt " + str(DAMAGE) + " to " + body.name)

func _physics_process(delta):
	var vertical = Input.get_axis("up", "down")
	var horizontal = Input.get_axis("left", "right")
	var direction = Vector2(horizontal, vertical)
	
	if (Input.is_action_just_released("up") || Input.is_action_just_released("down") || Input.is_action_just_released("left") || Input.is_action_just_released("right")):
		player_animate_sprite.play("idle")
	elif (area_2d.overlaps_area(enemy)):
			SPEED == 0
			player_animate_sprite.play("hurt")
			print("running + hitting slime")
			

	if direction != Vector2(0, 0):
		player_animate_sprite.play("run")
	
	
	
		
	if direction.x > 0:
		player_animate_sprite.flip_h = false
	elif direction.x < 0:
		player_animate_sprite.flip_h = true
		
	if direction.length() > 0:
		direction = direction.normalized()
		position += direction * SPEED * delta
	
func _process(delta):
	if HEALTH <= 0 && player_animate_sprite.animation != "die":
		self.SPEED = 0
		player_animate_sprite.play("die")

func _on_area_entered(area):
	if area.is_in_group("enemy"):
		var slime = area.get_parent()
		enemy = area
		melee(slime)
		slime.get_child(1).play("hurt")
		
	if area.is_in_group("collectible"):
		print("Collected something")

func _on_animation_finished():
	if player_animate_sprite.animation == "hurt":
		player_animate_sprite.play("idle")

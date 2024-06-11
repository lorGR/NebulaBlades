extends Node2D
class_name HealthComponent

@export var MAX_HEALTH: float = 10.0

var health: float

func _ready():
	health = MAX_HEALTH

func damage(attack: Attack):
	health -= attack.attack_damage
	if get_parent().has_node("AnimatedSprite2D"):
		get_parent().animated_sprite.play("hurt")
	if health <= 0:
		if get_parent().has_node("AnimatedSprite2D"):
			get_parent().SPEED = 0
			get_parent().animated_sprite.play("die")

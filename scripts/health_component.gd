extends Node2D
class_name HealthComponent

#region variables
@export var MAX_HEALTH: float = 10.0

var health: float
var parent: Node2D
var animated_sprite: AnimatedSprite2D
#endregion
#region built-ins
func _ready():
	health = MAX_HEALTH
	parent = get_parent()
	animated_sprite = get_animated_sprite(parent)
#endregion
#region custom
func damage(attack: Attack):
	health -= attack.attack_damage
	animated_sprite.play("hurt")
	if health <= 0:
		parent.SPEED = 0
		animated_sprite.play("die")

func get_animated_sprite(parent: Node2D):
	for node in parent.get_children():
		if node is AnimatedSprite2D:
			return node
#endregion

extends Node2D
class_name Health

#region variables
var _health: float
var _max_health: float
var _parent: CharacterBody2D
var _sprite: AnimatedSprite2D
#endregion
#region built-ins
func _ready():
	_parent = get_parent()
	_health = _parent.HEALTH
	_max_health = _health
	_sprite = get_animated_sprite(_parent)
#endregion
#region custom
func damage(attack: Attack) -> void:
	if _health <= 0:
		_parent.set_physics_process(false)
		print("%s died" % [_parent.name])
		_sprite.play("die")

	else:
		_health -= attack.attack_damage
		print("%s damaged for %s, %s/%s. node:%s" % [_parent.name, attack.attack_damage, _health, _parent.HEALTH, name])
		_sprite.play("hurt")

func get_animated_sprite(parent: Node2D) -> AnimatedSprite2D:
	for node in parent.get_children():
		if node is AnimatedSprite2D:
			return node
	return null
#endregion

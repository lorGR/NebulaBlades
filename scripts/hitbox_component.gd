extends Area2D
class_name HitboxComponent

#region variables
@export var health_component: HealthComponent
var taking_damage: bool
#endregion
#region custom
func damage(attack: Attack):
	if (!taking_damage):
		taking_damage = true
		if health_component:
			health_component.damage(attack)
		if get_tree() != null:
			await get_tree().create_timer(attack.attack_speed).timeout
		taking_damage = false
#endregion

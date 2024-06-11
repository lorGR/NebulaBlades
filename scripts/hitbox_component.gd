extends Area2D
class_name HitboxComponent

@export var health_component: HealthComponent
var taking_damage: bool

func damage(attack: Attack):
	if (!taking_damage):
		taking_damage = true
		if health_component:
			taking_damage
			health_component.damage(attack)
		await get_tree().create_timer(attack.attack_speed).timeout
		taking_damage = false
		
	

extends CharacterBody2D

#region variables
@export_category("STATS")
@export var SPEED: float = 35.0
@export var DAMAGE: float = 2.0
@export var ATTACK_SPEED: float = 1

@onready var slime_hitbox = $HitboxComponent
@onready var animated_sprite = $AnimatedSprite2D
@onready var player = %Player
var player_hitbox: HitboxComponent

var attack = Attack.new()

#endregion
#region built-ins
func _ready():
	attack.attack_damage = DAMAGE
	attack.attack_speed = ATTACK_SPEED
	
	if player.get_node("HitboxComponent"):
		player_hitbox = player.get_node("HitboxComponent")
	
func _physics_process(delta):
	if player != null:
		var direction = (player.global_position - global_position).normalized()
		position += direction * SPEED * delta # move towards player pos
		flip_sprite(direction)

	if slime_hitbox.overlaps_area(player_hitbox):
		player_hitbox.damage(attack)

#endregion
#region signals
func _on_animation_finished():
	if animated_sprite.animation == "hurt":
		animated_sprite.play("move")
	if animated_sprite.animation == "die":
		queue_free()

func _on_area_entered(area):
	if area is HitboxComponent and area.get_parent().name == "Player":
		var hitbox: HitboxComponent = area
		hitbox.damage(attack)

#endregion
#region custom
func flip_sprite(direction: Vector2):
	if direction.x > 0:
		animated_sprite.flip_h = false
	elif direction.x < 0:
		animated_sprite.flip_h = true
#endregion

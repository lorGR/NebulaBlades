extends CharacterBody2D

#region variables
@export_category("STATS")
@export var SPEED: float = 300.0
@export var DAMAGE: float = 10.0
@export var ATTACK_SPEED: float = 1.2

@onready var player_hitbox = $HitboxComponent
@onready var animated_sprite = $AnimatedSprite2D

var overlaping_areas = []
var attack = Attack.new()

#endregion
#region built-ins
func _ready():
	attack.attack_damage = DAMAGE
	attack.attack_speed = ATTACK_SPEED

func _process(delta):
	pass

func _physics_process(delta):
	handle_movement(delta)
	
	for hitbox in overlaping_areas:
		hitbox.damage(attack)

#endregion
#region signals
func _on_area_entered(area):
	if area is HitboxComponent:
		var hitbox: HitboxComponent = area
		hitbox.damage(attack)
		overlaping_areas.append(area)

func _on_area_exited(area):
	if area is HitboxComponent:
		overlaping_areas = overlaping_areas.filter(func(exited_area): return area != exited_area)
	
func _on_animation_finished():
	if animated_sprite.animation == "hurt" || animated_sprite.animation == "run":
		player_hitbox.taking_damage = false
		animated_sprite.play("idle")
	if animated_sprite.animation == "die":
		get_tree().change_scene_to_file("res://scenes/levels/gameover.tscn")
		#var mainMenu = "res://scenes/main.tscn"
		#get_tree().change_scene_to_file(mainMenu)

#endregion
#region custom
func flip_sprite(direction: Vector2):
	if direction.x > 0:
		animated_sprite.flip_h = false
	elif direction.x < 0:
		animated_sprite.flip_h = true

func handle_movement(delta):
	var vertical = Input.get_axis("up", "down")
	var horizontal = Input.get_axis("left", "right")
	var direction = Vector2(horizontal, vertical)
	if direction.length() > 0:
		direction = direction.normalized()
		position += direction * SPEED * delta
		if (!player_hitbox.taking_damage):
			animated_sprite.play("run")
	else:
		if (!player_hitbox.taking_damage):
			animated_sprite.play("idle")
	flip_sprite(direction)
#endregion

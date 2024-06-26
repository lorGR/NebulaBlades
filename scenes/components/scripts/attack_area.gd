class_name AttackArea extends Area2D

#region variables
@export_category("Stats")
@export var PROJECTILES: int = 1 # amount of enemies that will be hit simultaneously 
@export var ATTACK_SPEED: float = 1.0
@export var ATTACK_DAMAGE: float = 5.0
@export var RANGE_PERCENT: float = 100.0
@export var IS_PROJECTILE: bool = false

# used to asign a scene 
# scene should have a AnimatedSprite2D with an animation named default
@export var SPRITE_SCENE: PackedScene

# used in Range (CollisionShape2D) to set its scale
@export var BASE_RADIUS = Vector2(0.2, 0.1185)

@onready var CHARACTER_BODY: CharacterBody2D = get_parent()

var _attack = Attack.new()
var _is_damaging: bool = false
var _sprite: AnimatedSprite2D
var _sprites: Array[AnimatedSprite2D] = []
var _overlap_bodies: Array[CharacterBody2D] = []
#endregion
#region built-ins
func _ready():
	if SPRITE_SCENE == null:
		print("Error: SPRITE PackedScene is not assigned.")
		return

	_sprite = SPRITE_SCENE.instantiate()
	for p in range(PROJECTILES):
		_sprites.append(_sprite.duplicate())

	# signals for body entering and exiting the area
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _physics_process(delta):
	handle_attack() # can either be random on closest, accepts a bool
#endregion
#region signals
func _on_body_entered(body): # Body enters Melee - Range
	if body == CHARACTER_BODY:
		return
	if body.has_node("Hitbox"):
		if body is CharacterBody2D:
			_overlap_bodies.append(body)
			_attack.attack_damage = ATTACK_DAMAGE
			_attack.attack_speed = ATTACK_SPEED

func _on_body_exited(body):
	if body is CharacterBody2D:
		_overlap_bodies = _overlap_bodies.filter(func(exited_body): return body != exited_body)
#endregion
#region custom
func get_closest_bodies(bodies: Array[CharacterBody2D], attacked_bodies: Array[CharacterBody2D], projectiles: int) -> Array[CharacterBody2D]:
	var closest_bodies: Array[CharacterBody2D] = []
	var closest_distances: Array[float] = []
	
	for body in bodies:
		if body == CHARACTER_BODY:
			continue
		if body in attacked_bodies:
			continue
		
		var distance = CHARACTER_BODY.global_position.distance_to(body.global_position)
		
		if closest_bodies.size() < projectiles:
			closest_bodies.append(body)
			closest_distances.append(distance)
		else:
			# find the farthest body in the current closest_bodies
			var max_distance = -INF
			var max_index = -1
			for i in range(projectiles):
				if closest_distances[i] > max_distance:
					max_distance = closest_distances[i]
					max_index = i

			# replace the farthest body if the current one is closer
			if distance < max_distance:
				closest_bodies[max_index] = body
				closest_distances[max_index] = distance

	return closest_bodies

func get_random_bodies(bodies: Array[CharacterBody2D], attacked_bodies: Array[CharacterBody2D], projectiles: int) -> Array[CharacterBody2D]:
	var random_bodies: Array[CharacterBody2D] = _overlap_bodies
	random_bodies.shuffle()
	return random_bodies.slice(0,projectiles)

func handle_attack(randomly: bool = true) -> void:
	if _is_damaging:
		return
		
	var attacked_bodies: Array[CharacterBody2D] = []
	_is_damaging = true

	if randomly:
		var random_bodies = get_random_bodies(_overlap_bodies, attacked_bodies, PROJECTILES)
		for body in random_bodies:
			var other_health: Health = body.get_node("Health")
			if other_health is Health and not body.is_in_group(CHARACTER_BODY.get_groups()[0]):
				var index = random_bodies.find(body)
				handle_projectile_sprite(body, index)
				other_health.damage(_attack)
				attacked_bodies.append(body)
	else: # attack closest bodies
		var closest_bodies = get_closest_bodies(_overlap_bodies, attacked_bodies, PROJECTILES)
		for body in closest_bodies:
			var other_health: Health = body.get_node("Health")
			if other_health is Health and not body.is_in_group(CHARACTER_BODY.get_groups()[0]):
				var index = closest_bodies.find(body)
				handle_projectile_sprite(body, index)
				other_health.damage(_attack)
				attacked_bodies.append(body)  # Keep track of attacked bodies in this cycle

	await get_tree().create_timer(_attack.attack_speed).timeout
	_is_damaging = false

# _sprites has an array of _sprite * PROJECTILES set in _ready()
func handle_projectile_sprite(body, index): 
	var sprite: AnimatedSprite2D = _sprites[index]
	get_parent().get_parent().add_child(sprite)
	sprite.position = body.global_position
	sprite.speed_scale = _attack.attack_speed

	sprite.z_index = 5 # needs to be changed later on
	sprite.play("default")
#endregion

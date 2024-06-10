extends Node2D

@export var SPEED: float = 35.0
@export var HEALTH: float = 10.0
@export var DAMAGE: float = 1.0
@onready var animated_sprite_2d = $AnimatedSprite2D
var player: Node2D

func _ready():
	print("slime spawned")

	# Find the player in the scene tree (assuming the player node is a sibling to the enemy node)
	player = get_parent().get_node("Player")

func _process(delta: float):
	if HEALTH <= 0:
		animated_sprite_2d.play("die")
		queue_free()
	
	if player:
		# Calculate the direction to the player
		var direction = (player.global_position - global_position).normalized()
		# Move the enemy towards the player
		position += direction * SPEED * delta
		

func _on_area_2d_area_entered(area):
	if area.is_in_group("player"):
		print("*takes damage* or something >_>")
		melee(player)

func melee(body: Node2D):
	body.HEALTH -= DAMAGE
	print("dealt " + str(DAMAGE) + " to " + body.name)

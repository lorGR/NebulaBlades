extends Node2D

@export var speed: float = 100.0
var player: Node2D

func _ready():
	$Area2D.area_entered.connect(_on_area_2d_area_entered)
	print("slime spawned")

	# Find the player in the scene tree (assuming the player node is a sibling to the enemy node)
	player = get_parent().get_node("Player")

func _process(delta: float):
	if player:
		# Calculate the direction to the player
		var direction = (player.global_position - global_position).normalized()
		# Move the enemy towards the player
		position += direction * speed * delta

func _on_area_2d_area_entered(area):
	if area.is_in_group("player_projectile"):
		print("*takes damage* or something >_>")
		# Add logic for taking damage or other actions

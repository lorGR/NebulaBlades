extends Node2D

@export var SPEED: float = 75.0
@export var HEALTH: float = 35.0
@export var DAMAGE: float = 2
@onready var animated_sprite_2d = $AnimatedSprite2D

func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	var up = Input.get_axis("up", "down")

	if up != 0:
		position.y += up * SPEED * delta

	if direction != 0:
		position.x += direction * SPEED * delta		

func _ready():
	pass
	
func _process(delta):
	if HEALTH <= 0:
		animated_sprite_2d.play("die")
		queue_free()

func _on_area_2d_area_entered(area):
	if area.is_in_group("enemy"):
		var slime = area.get_parent()
		print("An enemy touched me Q_Q")
		melee(slime)
		# Take damage or die or whatever
		
	elif area.is_in_group("collectible"):
		print("Collected something")

func melee(body: Node2D):
	body.HEALTH -= DAMAGE
	print("dealt " + str(DAMAGE) + " to " + body.name)
	

func _on_animated_sprite_2d_animation_finished():
	if animated_sprite_2d.animation == "hurt":
			animated_sprite_2d.play("idle")


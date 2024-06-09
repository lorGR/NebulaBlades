extends Node2D

const SPEED = 100.0

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
	$Area2D.area_entered.connect(_on_area_2d_area_entered)

func _on_area_2d_area_entered(area):
	if area.is_in_group("enemy"):
		print("An enemy touched me Q_Q")
		# Take damage or die or whatever
		
	elif area.is_in_group("collectible"):
		print("Collected something")

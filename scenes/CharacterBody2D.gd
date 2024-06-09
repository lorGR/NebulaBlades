extends CharacterBody2D


const SPEED = 100.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	var up = Input.get_axis("up","down")
	
	if up:
		position.y += up * SPEED * delta
	else:
		position.y -= up * SPEED * delta
	
	if direction:
		#velocity.x += direction * SPEED * delta
		position.x += direction * SPEED * delta
	else:
		#position.x += move_toward(velocity.x, 0, SPEED)
		position.x -= direction * SPEED * delta
		 

	move_and_slide()

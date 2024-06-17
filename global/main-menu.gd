extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_btnstart_pressed():
	var level1 = "res://scenes/levels/level1.tscn"
	get_tree().change_scene_to_file(level1)
	print("Start BTN Pressed")

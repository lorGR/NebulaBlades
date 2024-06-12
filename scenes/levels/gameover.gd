extends Control

func _ready():
	$CenterContainer/VBoxContainer/Score.text = "Your Score: " + str(Global.score)

func _input(event):
	if event.is_action_pressed("restart"):
		get_tree().change_scene_to_file("res://scenes/levels/level1.tscn")

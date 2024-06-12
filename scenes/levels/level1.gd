extends Node2D

var score := 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$UI/MarginContainer/Score.text = str(score)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	var mainMenu = "res://scenes/main.tscn"
	get_tree().change_scene_to_file(mainMenu)



func _on_score_timer_timeout():
	score += 1
	Global.score = score
	$UI/MarginContainer/Score.text = str(score)

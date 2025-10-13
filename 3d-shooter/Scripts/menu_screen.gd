extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# This will open the game when play is hit
func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Level.tscn")

# This will close the game when the exit is hit.
func _on_exit_button_2_pressed() -> void:
	get_tree().quit()

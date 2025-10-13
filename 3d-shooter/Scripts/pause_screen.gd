extends Control


# Called when the node enters the scene tree for the first time.
# Turns the pause screen invisible
func _ready() -> void:
	self.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
# Runs the _ menu function
func _process(delta: float) -> void:
	_menu()

# This will pause the game and the player is able to unpause as well.
# When paused the pause can still move with the input mouse mode
func _menu() -> void:
	if Input.is_action_just_pressed("ui_cancel") and !get_tree().paused:
		_pause()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	elif Input.is_action_just_pressed("ui_cancel") and get_tree().paused:
		_resume()


# Allows the player you resume the game where they left off.
func _resume() -> void:
	self.hide()
	get_tree().paused = false


# Pauses the game 
func _pause() -> void:
	self.show()
	get_tree().paused = true

# Will return the player to the main menu screen
func _exit() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/menu_screen.tscn")

# This will take the player to the credits of my game.
func _options() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/Credits.tscn")

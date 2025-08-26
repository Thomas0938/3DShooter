extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_menu()


func _menu():
	if Input.is_action_just_pressed("ui_cancel") and !get_tree().paused:
		_pause()
	elif Input.is_action_just_pressed("ui_cancel") and get_tree().paused:
		_resume()


# Allows the player you resume the game where they left off.
func _resume():
	self.hide()
	get_tree().paused = false


# Pauses the game 
func _pause():
	self.show()
	get_tree().paused = true


func _exit() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/menu_screen.tscn")

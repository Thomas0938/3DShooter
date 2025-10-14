extends Node
# Variables
var enemy_damaged: bool = false
var score : int = 0
var high_score: int = 0
var save_path: String = "user://highscore.save"

# call it at the start
func _ready():
	load_high_score()

# This will load the high score to allow the player to see high score
func load_high_score() -> void:
	if FileAccess.file_exists(save_path):
		var saving = FileAccess.open(save_path, FileAccess.READ)
		high_score = saving.get_var()
	else:
		high_score = 0

# This will save the high score from the round
func save_high_score() -> void:
	var saving = FileAccess.open(save_path, FileAccess.WRITE)
	saving.store_var(high_score)

# This checks for if score is more than highscore then runs the rest.
func add_score() -> void:
	if score > high_score:
		high_score = score
		save_high_score()

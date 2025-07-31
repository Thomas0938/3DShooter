extends ProgressBar
@export var Player: CharacterBody3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_playerHealth()

func _playerHealth() -> void:
	value = Player.max_health

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

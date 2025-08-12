extends Node3D

var wave: int = 0
@onready var wave_time: Timer = $Timer
var spawner: PackedScene = preload("res://Scenes/Spawner.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	wave_time


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _spawn_spawner() -> void:
	var spawn = spawner.instantiate()
#	this will be the random generator to spawn spawners in random locationsS
	var spawner_position = 0

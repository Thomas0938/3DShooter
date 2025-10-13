extends Node3D

@export var spawner: PackedScene = preload("res://Scenes/Spawner.tscn")
@export var navigation_region: NavigationRegion3D
@export var distance_from_structures: int = 5
@export var structure: Array[Node3D]
#@export var timer: Timer = $Timer
@export var player: Node
var global_enemy: int = 120

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# This will spawn a spawner in a random location each time using the nav region
func _spawn_spawner() -> void:
	var nav_map = navigation_region.navigation_mesh
	var attempts = 0 
	var spawned = 0
	var random_pos
	if player:
		random_pos = NavigationServer3D.map_get_random_point(navigation_region.get_navigation_map(), 1, false)
	if is_position_valid(random_pos):
		var spawner_spawn = spawner.instantiate()
		spawner_spawn.global_position = random_pos
		add_child(spawner_spawn)
		$Timer.start()


# This will allow the spawner to check if where it is spawning is allowed
func is_position_valid(position) -> bool:
	if position:
		return true
	return false

class_name spawner
extends Node3D

var zombie: PackedScene = preload("res://Scenes/Zombie.tscn")
var wave: int = 1

var enemies: int = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_spawn_enemy()


func _spawn_enemy() -> void:
	if enemies > 0:
		var enemy = zombie.instantiate()
		enemy.global_position = global_position
		add_sibling(enemy)
		enemies -= 1
#		anything with a $ should be a variable
		$Timer.start()
	if enemies <= 0:
		queue_free()

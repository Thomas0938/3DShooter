extends Node3D

var bullet_speed: int = 25
var bullet_damage: int = 25
@onready var mesh: MeshInstance3D = $MeshInstance3D
@onready var ray: RayCast3D = $RayCast3D
@export var Zombie: CharacterBody3D = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position -= transform.basis * Vector3(0, 0, -bullet_speed) * delta

func _killEnemy(body) -> void:
	if body.has_method("_enemy_health"):
		body._enemy_health()
		queue_free()

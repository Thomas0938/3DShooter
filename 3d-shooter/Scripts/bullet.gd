extends Node3D
# These are the variables that allow the code to operate
@onready var mesh: MeshInstance3D = $MeshInstance3D
@onready var ray: RayCast3D = $RayCast3D
@export var zombie: CharacterBody3D = null
@onready var marker1: ProgressBar = $Marker1
@onready var marker2: ProgressBar = $marker2
@onready var marker3: ProgressBar = $marker3
@onready var marker4: ProgressBar = $marker4

var bullet_speed: int = 25
var bullet_damage: int = 25


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# This allows the bullet to move using vector3 and bullet speed.
func _process(delta: float) -> void:
	position -= transform.basis * Vector3(0, 0, -bullet_speed) * delta

# When the bullet hits a enemy the bullet will despawn
func _kill_enemy(body) -> void:
	if body.has_method("_enemy_health"):
		#marker1.visible = true
		#marker2.visible = true
		#marker3.visible = true
		#marker4.visible = true
		body._enemy_health()
	queue_free()

# This will despawn bullets that exit the map.
func _despawn(area) -> void:
	if area.has_method("despawn"):
		queue_free()

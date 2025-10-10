extends Node3D

var bullet_speed: int = 25
var bullet_damage: int = 25
@onready var mesh: MeshInstance3D = $MeshInstance3D
@onready var ray: RayCast3D = $RayCast3D
@export var Zombie: CharacterBody3D = null
@onready var marker1: ProgressBar = $Marker1
@onready var marker2: ProgressBar = $marker2
@onready var marker3: ProgressBar = $marker3
@onready var marker4: ProgressBar = $marker4

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position -= transform.basis * Vector3(0, 0, -bullet_speed) * delta

#moved the queue free down to make the bullets despawn when ever they hit a wall or boundry
func _killEnemy(body) -> void:
	if body.has_method("_enemy_health"):
		#marker1.visible = true
		#marker2.visible = true
		#marker3.visible = true
		#marker4.visible = true
		body._enemy_health()
	queue_free()


func _despawn(area) -> void:
	if area.has_method("despawn"):
		queue_free()

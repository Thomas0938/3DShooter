extends Control
@export var player: CharacterBody3D
@export var zombie: CharacterBody3D
@onready var marker1: MeshInstance2D = $Marker1
@onready var marker2: MeshInstance2D = $marker2
@onready var marker3: MeshInstance2D = $marker3
@onready var marker4: MeshInstance2D = $marker4
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var global = get_node("/root/Global")
@onready var score: Label = $CanvasLayer/score

# Called when the node enters the scene tree for the first time.
# allows _health and _enemy to run
func _ready() -> void:
	_player_health()
	_enemy_health()

# This shows the player health bar in game for feedback
func _player_health() -> void:
	progress_bar.value = player.max_health

# The hit markers will flash when the bullet hits the enemy
func _enemy_health() -> void:
	if global.enemy_damaged:
		marker1.visible = true
		marker2.visible = true
		marker3.visible = true
		marker4.visible = true
		await get_tree().create_timer(0.5).timeout
		marker1.visible = false
		marker2.visible = false
		marker3.visible = false
		marker4.visible = false
	

# does nothing
func enemy_hit() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
# This also does the marker hits.
func _process(delta: float) -> void:
	progress_bar.value = player.max_health
	score.text = ("Score: " + str(global.score))
	#print(global.score)
	
	if global.enemy_damaged:
		marker1.visible = true
		marker2.visible = true
		marker3.visible = true
		marker4.visible = true
		await get_tree().create_timer(0.5).timeout
		marker1.visible = false
		marker2.visible = false
		marker3.visible = false
		marker4.visible = false

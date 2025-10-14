extends Control
@export var player: CharacterBody3D
@export var zombie: CharacterBody3D
@onready var marker_1: MeshInstance2D = $Marker1
@onready var marker_2: MeshInstance2D = $marker2
@onready var marker_3: MeshInstance2D = $marker3
@onready var marker_4: MeshInstance2D = $marker4
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var global = get_node("/root/Global")
@onready var score: Label = $CanvasLayer/score
@onready var high_score_1: Label = $CanvasLayer/high_score


# Called when the node enters the scene tree for the first time.
# allows _health and _enemy to run
func _ready() -> void:
	_player_health()
	_enemy_health()
	_add_score()
	high_score_1.text = str(global.high_score)

# This shows the player health bar in game for feedback
func _player_health() -> void:
	progress_bar.value = player.max_health

# The hit markers will flash when the bullet hits the enemy
func _enemy_health() -> void:
	if global.enemy_damaged:
		marker_1.visible = true
		marker_2.visible = true
		marker_3.visible = true
		marker_4.visible = true
		await get_tree().create_timer(0.5).timeout
		marker_1.visible = false
		marker_2.visible = false
		marker_3.visible = false
		marker_4.visible = false
	

# does nothing
func enemy_hit() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
# This also does the marker hits.
func _process(delta: float) -> void:
	progress_bar.value = player.max_health
	score.text = ("Score: " + str(global.score))
	high_score_1.text = ("High score: " + str(global.high_score))
	#print(global.score)
	
	if global.enemy_damaged:
		marker_1.visible = true
		marker_2.visible = true
		marker_3.visible = true
		marker_4.visible = true
		await get_tree().create_timer(0.5).timeout
		marker_1.visible = false
		marker_2.visible = false
		marker_3.visible = false
		marker_4.visible = false


func _add_score() -> void:
	if global.score > global.high_score:
		global.high_score = global.score
		global.save_high_score()

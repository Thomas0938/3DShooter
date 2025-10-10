extends Control
@export var Player: CharacterBody3D
@export var Zombie: CharacterBody3D
@onready var marker1: MeshInstance2D = $Marker1
@onready var marker2: MeshInstance2D = $marker2
@onready var marker3: MeshInstance2D = $marker3
@onready var marker4: MeshInstance2D = $marker4
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var global = get_node("/root/Global")
@onready var score: Label = $CanvasLayer/score

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_playerHealth()
	_enemy_health()

func _playerHealth() -> void:
	progress_bar.value = Player.max_health

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
	

func enemy_hit() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	progress_bar.value = Player.max_health
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

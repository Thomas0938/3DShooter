extends CharacterBody3D

@export var EnemyMoveSpeed: int = 8
@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D

var Player: CharacterBody3D = null

func _ready() -> void:
	Player = get_tree().get_nodes_in_group("Player")[0]

func _physics_process(delta: float) -> void:
	navigation_agent.set_target_position(Player.global_position)
	if navigation_agent.is_navigation_finished():
		return
	var next_position: Vector3 = navigation_agent.get_next_path_postition()
	velocity = global_position.direction_to(next_position) * EnemyMoveSpeed
	
	move_and_slide()

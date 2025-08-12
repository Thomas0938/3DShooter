extends CharacterBody3D

@export var enemy_move_speed: int = 8
@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D
var enemy_health: int = 100
#bullet damage
var bullet_damage: int = 25
var dead: bool = false
var move: bool = true

@export var bullet: CharacterBody3D = null
@onready var Player: CharacterBody3D = null

func _ready() -> void:
	#queue_free()
	Player = get_tree().get_nodes_in_group("Player")[0]
	
func _Enemy_move() -> void:
	if not dead:
		var next_position: = Player.global_position
		navigation_agent.set_target_position(next_position)
		look_at(Player.position)
		rotation.x = clamp(rotation.x, 0, 0)
		rotation.z = clamp(rotation.z, 0, 0)

func _physics_process(delta: float) -> void:
	if not dead:
		var destination = navigation_agent.get_next_path_position()
		var local_destination = destination - global_position
		var direction = local_destination.normalized()
		velocity = direction * enemy_move_speed
		_Enemy_move()
		if not is_on_floor():
			velocity += get_gravity() * delta
	#navigation_agent.set_target_position(Player.global_position)
	#if navigation_agent.is_navigation_finished():
		#return
##	This can be fixed by finding the new name for get_next_path as this is from a old godot
	#var next_position: Vector3 = navigation_agent.set_target_position(1)
	#velocity = global_position.direction_to(next_position) * EnemyMoveSpeed
	
		move_and_slide()

func _enemy_health() -> void:
	if enemy_health > 0:
		enemy_health = enemy_health - bullet_damage
	elif enemy_health <= 0:
		dead = true
		move = false
		$AnimationPlayer.play("Dead_enemy")

func _playerDeath(body: Node3D) -> void:
	if body.has_method("_death"):
		body._death()
		

func _hit(body: Node3D) -> void:
	if body.has_method("_playerHealth"):
		body._playerHealth()
		$Timer.start()


func _on_timer_timeout() -> void:
	_hit(Player)


func _noHit(body: Node3D) -> void:
	if body.has_method("_playerHealth"):
		$Timer.stop()


func _dead_enemy(anim_name: StringName) -> void:
	dead = true
	queue_free()

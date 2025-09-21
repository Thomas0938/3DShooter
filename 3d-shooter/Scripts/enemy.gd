extends CharacterBody3D

@export var enemy_move_speed: int = 8
@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D
@onready var raycast: RayCast3D = $RayCast3D
var enemy_health: int = 100
#bullet damage
var bullet_damage: int = 25
var dead: bool = false
var move: bool = true
var distence_from_player: int
var enemy_dash_velocity: int = 10
var dash_direction_enemy
var random_number : int = randi_range(0, 10)
var can_dash: bool = true
var is_dashed: bool = true
var wall_climb_speed: int = 5

@export var bullet: CharacterBody3D = null
@onready var Player: CharacterBody3D = null

func _ready() -> void:
	#queue_free()
	Player = get_tree().get_nodes_in_group("Player")[0]
	raycast = get_node("RayCast3D")
	
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
		if distence_from_player <= 10:
			_enemy_dash()
# This will point the raycast in the dirction of enemy movement
		var raycast_velocity: Vector3 = get_velocity()
		if velocity.length() > 0.01:
			var raycast_direction = velocity.normalized()
		if not raycast.get_collider() == null and raycast.get_collider().has_meta("wall"):
			_enemy_climb()
			#raycast.look_at(global_position + raycast_direction, Vector3.FORWARD)
			#raycast.set_rotation_degrees(Vector3(0, rad_to_deg(atan2(-direction.x, -direction.z)),0))
#		old enemy climb
		#if is_on_wall():
			#_enemy_climb()
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

func _random_number_generator() -> void:
	random_number = randi_range(0, 10)
	print(random_number)


func _enemy_dash() -> void:
	random_number = randi_range(0, 10)
	print(random_number)
	if random_number > 7:
		can_dash = true
		$Timer2.start()
		dash_direction_enemy = transform.basis.z
		enemy_dash_velocity = enemy_dash_velocity

#
func _enemy_climb() -> void:
	velocity.y = wall_climb_speed


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


func _dashing_allowed() -> void:
	can_dash = false

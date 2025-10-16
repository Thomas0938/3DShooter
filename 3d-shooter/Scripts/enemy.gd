extends CharacterBody3D
# These are the variables
# exports and onreadys
@export var enemy_move_speed: int = 8
@export var bullet: CharacterBody3D = null
@export var score: PackedScene
@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D
@onready var raycast: RayCast3D = $RayCast3D
@onready var ray_cast_3d_2: RayCast3D = $RayCast3D2
@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var global = get_node("/root/Global")
@onready var player: CharacterBody3D = null
@onready var zombie: Node3D = null
# ints
var enemy_health: int = 100
var bullet_damage: int = 25
var distence_from_player: int
var enemy_dash_velocity: int = 10
var wall_climb_speed: int = 5
var enemy_jump: int = 6
var enemy_down: int = 5
var jump: int = 5
var dash_direction_enemy
var random_number : int = randi_range(0, 10)
var too_far: int = 10
var increase_in_score: int = 100
var greater_than_7: int = 7
# boolians
var can_dash: bool = true
var is_dashed: bool = true
var climbing : bool = false
var jumping: bool = false
var dead: bool = false
var move: bool = true

# The onready funtion will call the player and raycast to the scenetree at the start of game
func _ready() -> void:
	#queue_free()
	player = get_tree().get_nodes_in_group("Player")[0]
	raycast = get_node("RayCast3D")

# This function allow the enemy to move by using the navugation region
func _enemy_move() -> void:
	if not dead:
		var next_position: = player.global_position
		navigation_agent.set_target_position(next_position)
		look_at(player.position)
		rotation.x = clamp(rotation.x, 0, 0)
		rotation.z = clamp(rotation.z, 0, 0)

# The physics process using gravity and runs the movement for the enemy
# such as enemy climbing, dashing, moving and attacking
func _physics_process(delta: float) -> void:
	if not dead:
		if not jumping:
			var destination = navigation_agent.get_next_path_position()
			var local_destination = destination - global_position
			var direction = local_destination.normalized()
			velocity = direction * enemy_move_speed
			_enemy_move()
		if not is_on_floor():
			velocity += get_gravity() * delta
		if distence_from_player <= too_far:
			_enemy_dash()
# This will point the raycast in the dirction of enemy movement
		var raycast_velocity: Vector3 = get_velocity()
		if velocity.length() > 0.01:
			var raycast_direction = velocity.normalized()
		if raycast.is_colliding() and raycast.get_collider().has_meta("wall"):
			climbing = true
			#_climb()
		#else:
			#climbing = false
		elif not raycast.is_colliding():
			climbing = false
		if not ray_cast_3d_2.is_colliding() and not climbing and is_on_floor():
			velocity = transform.basis.z * -enemy_down
			print(transform.basis.z * -enemy_down)
			velocity.y = jump
			jumping = true
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
	
	if climbing:
		velocity.y = wall_climb_speed
		#print("ye")
	else:
		velocity += get_gravity() * delta
# The move n slide allows the enemy to collide with objects and the player
	move_and_slide()
	if is_on_floor():
		jumping = false

# This allows the enemy to climb
func _climb() -> void:
	velocity.y = wall_climb_speed

# This manages the enemy health when ever it takes damage
# This also increases the score when the enemy dies.
func _enemy_health() -> void:
	if enemy_health > 0:
		global.enemy_damaged = true
		enemy_health = enemy_health - bullet_damage
	elif enemy_health <= 0:
		dead = true
		move = false
#		had tp move queue free up as before it ended on the animation
		global.score = global.score + increase_in_score
		global.add_score() 
		print(global.score)
		queue_free()
		#$AnimationPlayer.play("Death1")

# This allows the enemy to dash when the number generator reaches a certain number.
func _enemy_dash() -> void:
	random_number = randi_range(0, 10)
	if random_number > greater_than_7:
		can_dash = true
		$Timer2.start()
		dash_direction_enemy = transform.basis.z
		enemy_dash_velocity = enemy_dash_velocity

# This will kill the player when the enemy is in the area of them
func _player_death(body: Node3D) -> void:
	if body.has_method("_death"):
		body._death()
		

# This will allow the enemy to hit the player
func _hit(body: Node3D) -> void:
	if body.has_method("_player_health"):
		body._player_health()
		$Timer.start()

# When the timer times out it will run _hit
func _on_timer_timeout() -> void:
	_hit(player)

# This will stop the enemy from hitting the player when dead
func _no_hit(body: Node3D) -> void:
	if body.has_method("_player_health"):
		$Timer.stop()

# After the timer ends the dashing will stop
func _dashing_allowed() -> void:
	can_dash = false

# This will despawn the enemy when it dies
func _dead_enemy(body: Node3D) -> void:
	if body.name == "bullet":
		#dead = true
		global.score = global.score + increase_in_score
		print(global.score)
		queue_free()

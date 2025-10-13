extends CharacterBody3D
class_name Player
# a float has a decemal place where int does not
# Onreadys and exports
@onready var global = get_node("/root/Global")
@onready var pivot: Node3D = $Node3D
@onready var gun_barrel: Node3D = $Node3D/SpringArm3D/Camera3D/gun1/RayCast3D
@onready var gun_barrel_2: Node3D = $Node3D/SpringArm3D/Camera3D/Gun2/RayCast3D
@onready var gunn_1: Node3D = $Node3D/SpringArm3D/Camera3D/gun1
@onready var gunn_2: Node3D = $Node3D/SpringArm3D/Camera3D/Gun2
@export var sens: float = 0.1
# Array
var numbers: Array = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
# Calls scenes
var gravity: int = ProjectSettings.get_setting("physics/3d/default_gravity")
var bullet: PackedScene = load("res://Scenes/bullet.tscn")
var bullet_2: PackedScene = load("res://Scenes/bullet2.tscn")
# ints and floats
var speed: int = 10
var jump_velocity: int = 7
var wall_jump_velocity: int = 7
var double_jump_velocity: int = 7
var dash_velocity: int = 25
var dash_duration: float = 0.1
var dash_cooldown: int = 30
var time: int = 0
var slide_velocity: int = 8
var max_health: int = 100
var loop: int = 1
var slide_duration: float = 0.1
var one_two: float = 1.2
var damage: int = 10
# bools
var double_jump: bool = true
var jumping: bool = false
var is_dashing: bool = false
var dash_cooldown_new: bool = true
var has_dashed: bool = false
var is_sliding: bool = true
var has_slide: bool = false
var shooting: bool = true
var looping: bool = false
var gun_2: bool = false
var gun: bool = false
var can_shoot: bool = true
var wall_jumped: bool = false
var lock: bool = false
var allowed: bool = false
# Things that are defined elsewhere
var dash_direction
var slide_direction
var velocity_slide
var current_health
var instance
var instances


# This allows the player to have gravity and has all the movement code in it.
func _physics_process(delta: float) -> void:
	# The gravity
	if not is_on_floor():
		velocity += get_gravity() * delta * one_two
# allows the player to jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity
		jumping = true
		double_jump = true
	elif Input.is_action_just_pressed("ui_accept") and double_jump:
		velocity.y = double_jump_velocity
		double_jump = false

# This allows the player to move on the x and z planes
	var input_direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_direction.x, 0, input_direction.y)).normalized()
	if not lock:
		if direction:
			velocity.x = lerp(velocity.x, direction.x * speed, 0.2)
			velocity.z = lerp(velocity.z, direction.z * speed, 0.2)
		else:
			velocity.x = lerp(velocity.x, 0.0, 0.2)
			velocity.z = lerp(velocity.z, 0.0, 0.2)
		
	#if is_on_wall():
		#wall_jumped = true
	
	#if wall_jumped:
		
# This is the double jump
	if is_on_wall() and Input.is_action_just_pressed("ui_accept"):
		
		var normal: Vector3 = get_last_slide_collision().get_normal()
		#velocity.x -= -direction.x * speed
		velocity = normal * wall_jump_velocity
		velocity.y = jump_velocity
		wall_jumped = true
		lock = true
		$Timer4.start()
	
#This is the dashing and sliding
	if is_dashing:
		time += delta
		velocity += -direction * -dash_velocity
		velocity.y = 0
	
	if is_sliding:
		time += delta
		#velocity += slide_direction * -slide_velocity
		#velocity.y = 0  
	
	if is_on_floor() and has_slide:
		has_slide = false
	
	if is_on_floor() and has_dashed:
		has_dashed = false
#This gives the dash a cooldown and allows the player to dash
	if Input.is_action_just_pressed("dash") and dash_cooldown_new:
		is_dashing = true
		dash_cooldown_new = false
		$Timer.start(dash_duration)
		$Timer2.start()
		dash_direction = transform.basis.z
		has_dashed = true
#This allows the player to slide in the game
	if Input.is_action_just_pressed("slide"):
		is_sliding = true
		$Timer3.start(slide_duration)
		slide_direction = transform.basis.x
		has_slide = true
# This allows the player to draw gun 1
	if Input.is_action_just_pressed("gun1"):
		gun = true
		gun_2 = false
		gunn_2.visible = false
		gunn_1.visible = true
# This allows the player to draw gun 2
	if Input.is_action_just_pressed("gun2"):
		gun_2 = true
		gun = false
		can_shoot = true
		gunn_2.visible = true
		gunn_1.visible = false
# allows the player to shoot
	if Input.is_action_just_pressed("shoot") and gun:
		shooting = true
		instance = bullet.instantiate()
		instance.position = gun_barrel.global_position
		instance.transform.basis = gun_barrel.global_transform.basis
		get_parent().add_child(instance)
		
	else:
		shooting = false
#	this will be for my second gun when switching to it
# Removing the just_ will allow automatic shooting.
	if Input.is_action_pressed("shoot") and gun_2 and can_shoot:
		shooting = true
		instances = bullet_2.instantiate()
		instances.position = gun_barrel_2.global_position
		instances.transform.basis = gun_barrel_2.global_transform.basis
		get_parent().add_child(instances)
		can_shoot = false
		$Timer5.start()
	else:
		shooting = false
# This is a countdown before breaking
	if allowed:
		for loop in numbers:
			print(loop)
			allowed = false
			break
# allows the player to collide with objects
	move_and_slide()

# This allows the mouse to stay in a place while playing
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

# This will allow teh player to rotate the camera up and down
func _input(event) -> void:
#	for the camera movement. This wasn't working because I was using int when i should have used a float.
	if event is InputEventMouseMotion:
		#print("MOUSE")
		rotate_y(deg_to_rad(-event.relative.x * sens))
		pivot.rotate_x(deg_to_rad(-event.relative.y * sens))
#		This will be the look up and down for y co-ords
		pivot.rotation.x = clamp(pivot.rotation.x, deg_to_rad(-90), deg_to_rad(90))

# This is the player health and stores the damage taken during a round
# when the player dies the score gets reset
func _player_health() -> void:
	if max_health > 0:
		max_health = max_health - damage
	else:
		if max_health == 0:
			global.score = 0
			_death()

# This will reload the scene when the player dies
func _death() -> void:
	if max_health == 0:
		global.score = 0
		get_tree().change_scene_to_file("res://Scenes/Level.tscn")

# This will stop the player from dashing when the timer stops
func _on_timer_timeout() -> void:
	is_dashing = false
	velocity.y = 0

# To allow you to dash again after cooldown
func _dash_cooldown() -> void:
	dash_cooldown_new = true
	is_dashing = false
	#$Timer2.start(dash_cooldown)
	#Dash_cooldown = false
	#has_dashed = true
	#is_dashing = false

# stops the player from sliding
func _on_timer_3_timeout() -> void:
	is_sliding = false
	velocity.y = 0

# walls for wall jump
func _wall_jump() -> void:
	wall_jumped = false
	lock = false

# To control the AK rate of fire
func _rate_of_fire() -> void:
	can_shoot = true

extends CharacterBody3D
class_name Player
# a float has a decemal place where int does not



var speed: int = 10
var jump_velocity: int = 7
var wall_jump_velocity: int = 7
var double_jump: bool = true
var double_jump_velocity: int = 7
@onready var pivot: Node3D = $Node3D
@export var sens: float = 0.1
var jumping: bool = false
var dash_direction
var is_dashing: bool = false
var dash_velocity: int = 25
var dash_duration: float = 0.1
var dash_cooldown: int = 30
var dash_cooldown_new: bool = true
var time: int = 0
var has_dashed: bool = false
var gravity: int = ProjectSettings.get_setting("physics/3d/default_gravity")
var is_sliding: bool = true
var slide_velocity: int = 8
var slide_duration: float = 0.1
var slide_direction
var has_slide: bool = false
var velocity_slide
var wall_jumped: bool = false
var lock: bool = false
@export var health_bar: ProgressBar
var current_health
var max_health: int = 100
@onready var gun_barrel: Node3D = $Node3D/SpringArm3D/Camera3D/gun1/RayCast3D
@onready var gun_barrel2: Node3D = $Node3D/SpringArm3D/Camera3D/Gun2/RayCast3D
var bullet: PackedScene = load("res://Scenes/bullet.tscn")
var instance
var shooting: bool = true
var loop: int = 1
var looping: bool = false
var gun2: bool = false
var gun: bool = false
@onready var gunn1: Node3D = $Node3D/SpringArm3D/Camera3D/gun1
@onready var gunn2: Node3D = $Node3D/SpringArm3D/Camera3D/Gun2


func _physics_process(delta: float) -> void:
	# The gravity
	if not is_on_floor():
		velocity += get_gravity() * delta * 1.2
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity
		jumping = true
		double_jump = true
	elif Input.is_action_just_pressed("ui_accept") and double_jump:
		velocity.y = double_jump_velocity
		double_jump = false


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
		
		
	if is_on_wall() and Input.is_action_just_pressed("ui_accept"):
		
		var normal: Vector3 = get_last_slide_collision().get_normal()
		#velocity.x -= -direction.x * speed
		velocity = normal * wall_jump_velocity
		velocity.y = jump_velocity
		wall_jumped = true
		lock = true
		$Timer4.start()
	
	
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
	
	if Input.is_action_just_pressed("gun1"):
		gun = true
		gun2 = false
		gunn2.visible = false
		gunn1.visible = true
	
	if Input.is_action_just_pressed("gun2"):
		gun2 = true
		gun = false
		gunn2.visible = true
		gunn1.visible = false

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
	if Input.is_action_pressed("shoot") and gun2:
		shooting = true
		instance = bullet.instantiate()
		instance.position = gun_barrel2.global_position
		instance.transform.basis = gun_barrel.global_transform.basis
		get_parent().add_child(instance)
	else:
		shooting = false
	
	for loop in range(loop):
		print(loop)
		loop + 1
		looping = false
		if looping:
			break


	move_and_slide()


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event) -> void:
#	for the camera movement. This wasn't working because I was using int when i should have used a float.
	if event is InputEventMouseMotion:
		#print("MOUSE")
		rotate_y(deg_to_rad(-event.relative.x * sens))
		pivot.rotate_x(deg_to_rad(-event.relative.y * sens))
#		This will be the look up and down for y co-ords
		pivot.rotation.x = clamp(pivot.rotation.x, deg_to_rad(-90), deg_to_rad(90))

func _playerHealth() -> void:
	if max_health > 0:
		max_health = max_health - 10
		health_bar.value = max_health
	else:
		if max_health == 0:
			_death()

func _death() -> void:
	if max_health == 0:
		get_tree().change_scene_to_files("res://Scenes/Level.tscn")

func _on_timer_timeout() -> void:
	is_dashing = false
	velocity.y = 0

#To allow you to dash again after cooldown
func _dash_cooldown() -> void:
	dash_cooldown_new = true
	is_dashing = false
	#$Timer2.start(dash_cooldown)
	#Dash_cooldown = false
	#has_dashed = true
	#is_dashing = false

func _on_timer_3_timeout() -> void:
	is_sliding = false
	velocity.y = 0


func _wall_jump() -> void:
	wall_jumped = false
	lock = false

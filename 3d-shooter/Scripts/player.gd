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
var dash_velocity: int = 30
var dash_duration: float = 0.1
var dash_cooldown: int = 30
var Dash_cooldown: bool = true
var time: int = 0
var has_dashed: bool = false
var gravity: int = ProjectSettings.get_setting("physics/3d/default_gravity")
var is_sliding: bool = true
var slide_velocity: int = 8
var slide_duration: float = 0.1
var slide_direction
var has_slide: bool = false
var velocity_slide
var wall_jumped: bool = true


func _physics_process(delta: float) -> void:
	# The gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity
		jumping = true
		double_jump = true
	elif Input.is_action_just_pressed("ui_accept") and double_jump:
		velocity.y = double_jump_velocity
		double_jump = false

	

	var input_direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_direction.x, 0, input_direction.y)).normalized()
	if direction:
		velocity.x = lerp(velocity.x, direction.x * speed, 0.2)
		velocity.z = lerp(velocity.z, direction.z * speed, 0.2)
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
		
	if is_on_wall() and wall_jumped:
		wall_jumped = false
		
	if is_on_wall() and Input.is_action_just_pressed("ui_accept"):
		var normal: Vector3 = get_last_slide_collision().get_normal()
		velocity.y = jump_velocity
		$Timer4.start()
		#velocity.x -= -direction.x * speed
		velocity = normal * wall_jump_velocity
		print(normal)
		
	if is_dashing:
		time += delta
		velocity += dash_direction * -dash_velocity
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
	if Input.is_action_just_pressed("dash") and Dash_cooldown:
		is_dashing = true
		Dash_cooldown = false
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

	move_and_slide()

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event) -> void:
#	for the camera movement. This wasn't working because I was using int when i should have used a float.
	if event is InputEventMouseMotion:
		#print("MOUSE")
		rotate_y(deg_to_rad(-event.relative.x * sens))
		pivot.rotate_x(deg_to_rad(-event.relative.y * sens))
		pivot.rotation.x = clamp(pivot.rotation.x, deg_to_rad(-50), deg_to_rad(40))

func _on_timer_timeout() -> void:
	is_dashing = false
	velocity.y = 0

#To allow you to dash again after cooldown
func _dash_cooldown() -> void:
	Dash_cooldown = true
	is_dashing = false
	#$Timer2.start(dash_cooldown)
	#Dash_cooldown = false
	#has_dashed = true
	#is_dashing = false

func _on_timer_3_timeout() -> void:
	is_sliding = false
	velocity.y = 0


func _wall_jump() -> void:
	wall_jumped = true

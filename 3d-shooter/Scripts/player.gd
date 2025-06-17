extends CharacterBody3D
class_name Player

var speed: int = 8.0
var jump_velocity: int = 6.0
var double_jump: float = true
var double_jump_velocity: int = 6.0
@onready var pivot: Node3D = $Node3D
@export var sens: int = 0.1

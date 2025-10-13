extends Camera3D

var look: int = 110

# This will set the camera FOV
func _ready() -> void:
	self.fov = look

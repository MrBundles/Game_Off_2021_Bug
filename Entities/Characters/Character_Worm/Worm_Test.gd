tool
extends RigidBody2D

# references -----------------------------------------------------------------------------------------------------------


# signals --------------------------------------------------------------------------------------------------------------


# variables ------------------------------------------------------------------------------------------------------------
export var length = 20.0 setget set_length
var force = 10.0


# main functions -------------------------------------------------------------------------------------------------------
func _ready():
	# connect signals
	
	# initialize setgets
	self.length = length
	
	# initialize variables
	pass


func _process(delta):
	if Input.is_action_pressed("left_click"):
		apply_central_impulse(global_position.direction_to(get_global_mouse_position()).normalized() * force)


func _get_configuration_warning():
	if 0:
		return "Configuration Warning String"
	else:
		return ""


# helper functions ------------------------------------------------------------------------------------------------------



# set/get functions ------------------------------------------------------------------------------------------------------
func set_length(new_val):
	length = new_val
	
	if has_node("CollisionShape2D"):
		$CollisionShape2D.position.x = length
		$CollisionShape2D.shape.height = length
	
	if has_node("PinJoint2D"):
		$PinJoint2D.position.x = length * 2
		$PinJoint2D.disable_collision = !$PinJoint2D.disable_collision


# signal functions -------------------------------------------------------------------------------------------------------



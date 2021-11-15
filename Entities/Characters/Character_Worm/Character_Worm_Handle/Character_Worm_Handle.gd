extends RigidBody2D

# references -----------------------------------------------------------------------------------------------------------


# signals --------------------------------------------------------------------------------------------------------------


# variables ------------------------------------------------------------------------------------------------------------
var handle_type = GVM.HANDLE_TYPES.null
export var move_force = 20.0
export var radius = 16.0 setget set_radius


# main functions -------------------------------------------------------------------------------------------------------
func _ready():
	# connect signals
	
	# initialize setgets
	self.radius = radius
	
	# initialize variables
	pass
	
	update_joint()


func _process(delta):
	get_input()


func _get_configuration_warning():
	if 0:
		return "Configuration Warning String"
	else:
		return ""


# helper functions ------------------------------------------------------------------------------------------------------
func get_input():
	match handle_type:
		GVM.HANDLE_TYPES.front:
			if Input.is_action_pressed("left_click"):
					apply_central_impulse(global_position.direction_to(get_global_mouse_position()).normalized() * move_force)
			
		GVM.HANDLE_TYPES.back:
			if Input.is_action_pressed("right_click"):
					apply_central_impulse(global_position.direction_to(get_global_mouse_position()).normalized() * move_force)


func update_joint():
	$PinJoint2D.node_b = $PinJoint2D.get_path_to(get_parent())


# set/get functions ------------------------------------------------------------------------------------------------------
func set_radius(new_val):
	radius = new_val
	
	if has_node("CollisionShape2D"):
		$CollisionShape2D.shape.radius = radius


# signal functions -------------------------------------------------------------------------------------------------------



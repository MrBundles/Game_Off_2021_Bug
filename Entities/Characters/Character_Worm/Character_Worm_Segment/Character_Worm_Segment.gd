tool
extends RigidBody2D

# references -----------------------------------------------------------------------------------------------------------


# signals --------------------------------------------------------------------------------------------------------------


# variables ------------------------------------------------------------------------------------------------------------
export var move = false
export var radius = 16.0 setget set_radius
export var length = 50.0 setget set_length
export var length_max = 150.0 setget set_length_max
export var length_min = 25.0


# main functions -------------------------------------------------------------------------------------------------------
func _ready():
	# connect signals
	
	# initialize setgets
	self.radius = radius
	self.length = length
	self.length_max = length_max
	
	# initialize variables
	pass


func _process(delta):
	if Input.is_action_pressed("left_click") and move:
		apply_central_impulse(global_position.direction_to(get_global_mouse_position()).normalized() * 10.0)


func _integrate_forces(state):
#	for i in range(state.get_contact_count()):
#		contact_positions.append(state.get_contact_local_position(i))
	
	update()


func _draw():
	draw_set_transform_matrix(transform.inverse())
	
#	for pos in contact_positions:
#		draw_circle(pos, radius / 2, Color(1,1,1,1))


func _get_configuration_warning():
	if 0:
		return "Configuration Warning String"
	else:
		return ""


# helper functions ------------------------------------------------------------------------------------------------------



# set/get functions ------------------------------------------------------------------------------------------------------
func set_radius(new_val):
	radius = new_val
	
	if has_node("CollisionShape2D"):
		$CollisionShape2D.shape.radius = radius


func set_length(new_val):
	if new_val > length_max:
		return
	
	length = new_val
	
	if has_node("CollisionShape2D"):
		$CollisionShape2D.shape.height = length
		$CollisionShape2D.position.x = length / 2
	
#	if has_node("GrooveJoint2D"):
#		$GrooveJoint2D.initial_offset = length
	
	if has_node("DampedSpringJoint2D"):
		$DampedSpringJoint2D.length = length
		$DampedSpringJoint2D.rest_length = length


func set_length_max(new_val):
	length_max = new_val
	
	if has_node("GrooveJoint2D"):
		$GrooveJoint2D.length = length_max
#
#	if has_node("DampedSpringJoint2D"):
#		$DampedSpringJoint2D.length = length_max


# signal functions -------------------------------------------------------------------------------------------------------

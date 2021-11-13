extends RigidBody2D

# references -----------------------------------------------------------------------------------------------------------


# signals --------------------------------------------------------------------------------------------------------------


# variables ------------------------------------------------------------------------------------------------------------
var thickness = 16.0 setget set_thickness
var contact_positions = []


# main functions -------------------------------------------------------------------------------------------------------
func _ready():
	# connect signals
	
	# initialize setgets
	self.thickness = thickness
	
	# initialize variables
	pass


func _integrate_forces(state):
	contact_positions.clear()
	
	for i in range(state.get_contact_count()):
		contact_positions.append(state.get_contact_local_position(i))
	
	update()


func _draw():
	draw_set_transform_matrix(transform.inverse())
	
	for pos in contact_positions:
		draw_circle(pos, thickness / 2, Color(1,1,1,1))


func _get_configuration_warning():
	if 0:
		return "Configuration Warning String"
	else:
		return ""


# helper functions ------------------------------------------------------------------------------------------------------



# set/get functions ------------------------------------------------------------------------------------------------------
func set_thickness(new_val):
	thickness = new_val
	
	$CollisionShape2D.shape.radius = thickness / 2.0


# signal functions -------------------------------------------------------------------------------------------------------
#func _on_Character_Worm_Segment_body_entered(body):
#	if not body in colliding_bodies:
#		colliding_bodies.append(body)
#
#
#func _on_Character_Worm_Segment_body_exited(body):
#	if body in colliding_bodies:
#		colliding_bodies.remove(colliding_bodies.find(body))

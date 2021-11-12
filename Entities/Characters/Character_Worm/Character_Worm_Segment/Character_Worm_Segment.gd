extends RigidBody2D

# references -----------------------------------------------------------------------------------------------------------


# signals --------------------------------------------------------------------------------------------------------------


# variables ------------------------------------------------------------------------------------------------------------
var thickness = 16.0 setget set_thickness


# main functions -------------------------------------------------------------------------------------------------------
func _ready():
	# connect signals
	
	# initialize setgets
	self.thickness = thickness
	
	# initialize variables
	pass


func _process(delta):
	update()


func _draw():
	draw_circle(Vector2(0,0), thickness / 2, Color(1,1,1,1))


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



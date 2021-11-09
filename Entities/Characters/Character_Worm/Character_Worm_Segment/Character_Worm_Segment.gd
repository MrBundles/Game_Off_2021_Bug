extends Node

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
	pass


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



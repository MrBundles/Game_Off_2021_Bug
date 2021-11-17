tool
extends StaticBody2D

# references -----------------------------------------------------------------------------------------------------------


# signals --------------------------------------------------------------------------------------------------------------


# variables ------------------------------------------------------------------------------------------------------------
export var color_grabbable = Color(1,1,1,1) setget set_color_grabbable


# main functions -------------------------------------------------------------------------------------------------------
func _ready():
	# connect signals
	
	# initialize setgets
	self.color_grabbable = color_grabbable
	
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
func set_color_grabbable(new_val):
	color_grabbable = new_val
	
	modulate = color_grabbable


# signal functions -------------------------------------------------------------------------------------------------------



tool
extends Label

# references -----------------------------------------------------------------------------------------------------------


# signals --------------------------------------------------------------------------------------------------------------


# variables ------------------------------------------------------------------------------------------------------------
export var font_size = 45 setget set_font_size


# main functions -------------------------------------------------------------------------------------------------------
func _ready():
	# connect signals
	
	# initialize setgets
	self.font_size = font_size
	
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
func set_font_size(new_val):
	font_size = new_val
	
	if has_node("FeatureFontSizeOverrider"):
		$FeatureFontSizeOverrider.font_size = font_size


# signal functions -------------------------------------------------------------------------------------------------------



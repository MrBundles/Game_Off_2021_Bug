extends Node

# references -----------------------------------------------------------------------------------------------------------


# signals --------------------------------------------------------------------------------------------------------------

# scene management signals
signal change_game_scene										# new_game_scene_id
signal change_menu_scene										# new_menu_scene_id
signal reload_game_scene
signal reload_menu_scene


# theme management signals
signal change_theme												# new_theme_id


# worm signals
signal break_worm


# event signals
signal event_trigger											# event_id, event_value


# variables ------------------------------------------------------------------------------------------------------------



# main functions -------------------------------------------------------------------------------------------------------
func _ready():
	# connect signals
	
	# initialize setgets
	
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



# signal functions -------------------------------------------------------------------------------------------------------



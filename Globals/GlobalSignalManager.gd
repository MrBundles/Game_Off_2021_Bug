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


# audio signals
signal set_bus_volume											# bus_id, bus_volume
signal set_bus_mute												# bus_id, bus_mute


# worm signals
signal break_worm


# event signals
signal event_trigger											# event_id, event_value


# LevelSelect_Line2D signals
signal point_handle_hovered										# point_handle_id, point_handle_hovered
signal point_handle_pressed										# point_handle_id, point_handle_pressed


# pickup signals
signal pickup_collected


# win signals
signal level_completed
signal evaporate_worm


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



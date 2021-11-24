tool
extends Node

# enums
enum INPUT_TYPES {null, left, right}
enum EVENT_TRIGGER_TYPES {null, on, off, delay_on, delay_off, on_delay_off, off_delay_on}

enum MENU_SCENE_IDS {null, main, level_select, settings, credits, pause, quit}
enum UI_BUTTON_IDS {null, back, level_select, pause, play, reset}

enum AUDIO_BUS_IDS {master, music, effects}

# references -----------------------------------------------------------------------------------------------------------


# signals --------------------------------------------------------------------------------------------------------------


# variables ------------------------------------------------------------------------------------------------------------

# theme management variables
export(Array, Theme) var theme_array = []
var current_theme_id = 0

# worm variables
var worm_hook_hovered = false

# scene management variables
var current_game_scene_id = -1
var current_menu_scene_id = -1
var game_scene_qty = 0
var highest_unlocked_game_scene_id = -1


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



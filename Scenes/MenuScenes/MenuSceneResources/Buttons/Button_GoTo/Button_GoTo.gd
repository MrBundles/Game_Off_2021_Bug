tool
extends Button_Base

# references -----------------------------------------------------------------------------------------------------------


# signals --------------------------------------------------------------------------------------------------------------


# variables ------------------------------------------------------------------------------------------------------------
export(int, 0, 256) var new_game_scene_id = 0
export(GVM.MENU_SCENE_IDS) var new_menu_scene_id = GVM.MENU_SCENE_IDS.null


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
func _on_Button_GoTo_button_base_pressed():
	GSM.emit_signal("change_game_scene", new_game_scene_id)
	GSM.emit_signal("change_menu_scene", new_menu_scene_id)

tool
extends Button_Base

# references -----------------------------------------------------------------------------------------------------------


# signals --------------------------------------------------------------------------------------------------------------


# variables ------------------------------------------------------------------------------------------------------------
export(GVM.UI_BUTTON_IDS) var ui_button_id = GVM.UI_BUTTON_IDS.null


# main functions -------------------------------------------------------------------------------------------------------
func _ready():
	# connect signals
	GSM.connect("change_menu_scene", self, "_on_change_menu_scene")
	
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
func _on_change_menu_scene(new_menu_scene_id):
	# set the visibility of the ui button. 
	# the back button is only visible during normal menu navigation when not already on the main menu
	if ui_button_id == GVM.UI_BUTTON_IDS.back:
		visible = new_menu_scene_id != GVM.MENU_SCENE_IDS.null and new_menu_scene_id != GVM.MENU_SCENE_IDS.main
	
	# the other buttons should always be visible during normal gameplay
	else:
		visible = new_menu_scene_id == GVM.MENU_SCENE_IDS.null


func _on_Button_UI_button_base_pressed():
	match ui_button_id:
		GVM.UI_BUTTON_IDS.back:
			GSM.emit_signal("change_game_scene", 0)
			GSM.emit_signal("change_menu_scene", GVM.MENU_SCENE_IDS.main)
		
		GVM.UI_BUTTON_IDS.level_select:
			GSM.emit_signal("change_game_scene", 0)
			GSM.emit_signal("change_menu_scene", GVM.MENU_SCENE_IDS.level_select)
		
		GVM.UI_BUTTON_IDS.pause:
			GSM.emit_signal("change_menu_scene", GVM.MENU_SCENE_IDS.pause)
		
		GVM.UI_BUTTON_IDS.reset:
			GSM.emit_signal("reload_game_scene")

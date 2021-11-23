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
	var button_visible = true
	
	# set the visibility of the ui button. 
	match ui_button_id:
		GVM.UI_BUTTON_IDS.back:
			button_visible = new_menu_scene_id != GVM.MENU_SCENE_IDS.null and new_menu_scene_id != GVM.MENU_SCENE_IDS.main and new_menu_scene_id != GVM.MENU_SCENE_IDS.pause
		
		GVM.UI_BUTTON_IDS.level_select:
			button_visible = new_menu_scene_id == GVM.MENU_SCENE_IDS.null or new_menu_scene_id == GVM.MENU_SCENE_IDS.pause
		
		GVM.UI_BUTTON_IDS.pause:
			button_visible = new_menu_scene_id == GVM.MENU_SCENE_IDS.null
		
		GVM.UI_BUTTON_IDS.play:
			button_visible = new_menu_scene_id == GVM.MENU_SCENE_IDS.pause
		
		GVM.UI_BUTTON_IDS.reset:
			button_visible = new_menu_scene_id == GVM.MENU_SCENE_IDS.null or new_menu_scene_id == GVM.MENU_SCENE_IDS.pause
	
	if button_visible:
		modulate = Color(1,1,1,1)
		disabled = false
		mouse_filter = Control.MOUSE_FILTER_STOP
	else:
		modulate = Color(1,1,1,0)
		disabled = true
		mouse_filter = Control.MOUSE_FILTER_IGNORE
		self.hovered = false


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
		
		GVM.UI_BUTTON_IDS.play:
			GSM.emit_signal("change_menu_scene", GVM.MENU_SCENE_IDS.null)
		
		GVM.UI_BUTTON_IDS.reset:
			GSM.emit_signal("reload_game_scene")

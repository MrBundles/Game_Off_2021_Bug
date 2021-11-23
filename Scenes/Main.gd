extends Node2D

# references -----------------------------------------------------------------------------------------------------------


# signals --------------------------------------------------------------------------------------------------------------


# variables ------------------------------------------------------------------------------------------------------------
export(Array, PackedScene) var game_scene_array = []
export(Array, PackedScene) var menu_scene_array = []
var current_game_scene_id = -1
var current_menu_scene_id = -1
var highest_unlocked_game_scene_id = 0 setget set_highest_unlocked_game_scene_id


# main functions -------------------------------------------------------------------------------------------------------
func _ready():
	# connect signals
	GSM.connect("change_game_scene", self, "_on_change_game_scene")
	GSM.connect("change_menu_scene", self, "_on_change_menu_scene")
	GSM.connect("reload_game_scene", self, "_on_reload_game_scene")
	GSM.connect("reload_menu_scene", self, "_on_reload_menu_scene")
	
	# initialize setgets
	self.highest_unlocked_game_scene_id = highest_unlocked_game_scene_id
	
	# initialize variables
	GVM.game_scene_qty = game_scene_array.size()
	
	# load initial game and menu scenes
	GSM.emit_signal("change_game_scene", 0)
	GSM.emit_signal("change_menu_scene", GVM.MENU_SCENE_IDS.main)


func _process(delta):
	pass


func _get_configuration_warning():
	if 0:
		return "Configuration Warning String"
	else:
		return ""


# helper functions ------------------------------------------------------------------------------------------------------
func clear_game_scenes():
	# clear all game scene children from under GameScenes node
	for child in $GameScenes.get_children():
		child.queue_free()


func clear_menu_scenes():
	# clear all menu scene children from under MenuScenes node
	for child in $MenuScenes.get_children():
		child.queue_free()


func add_game_scene(new_game_scene_id):
	if not new_game_scene_id < game_scene_array.size():
		return
	
	var game_scene_instance = game_scene_array[new_game_scene_id].instance()
	$GameScenes.add_child(game_scene_instance)


func add_menu_scene(new_menu_scene_id):
	if not new_menu_scene_id < menu_scene_array.size():
		return
	
	var menu_scene_instance = menu_scene_array[new_menu_scene_id].instance()
	$MenuScenes.add_child(menu_scene_instance)


# set/get functions ------------------------------------------------------------------------------------------------------
func set_highest_unlocked_game_scene_id(new_val):
	highest_unlocked_game_scene_id = new_val
	
	GVM.highest_unlocked_game_scene_id = highest_unlocked_game_scene_id


# signal functions -------------------------------------------------------------------------------------------------------
func _on_change_game_scene(new_game_scene_id):
	if new_game_scene_id != current_game_scene_id:
		current_game_scene_id = new_game_scene_id
		clear_game_scenes()
		add_game_scene(current_game_scene_id)
		
		GVM.current_game_scene_id = current_game_scene_id
		
		if current_game_scene_id > highest_unlocked_game_scene_id:
			self.highest_unlocked_game_scene_id = current_game_scene_id


func _on_change_menu_scene(new_menu_scene_id):
	# check if new menu scene is quit, if so, quit the game
	if new_menu_scene_id == GVM.MENU_SCENE_IDS.quit:
		get_tree().quit()
		return
	
	if new_menu_scene_id != current_menu_scene_id:
		current_menu_scene_id = new_menu_scene_id
		clear_menu_scenes()
		add_menu_scene(current_menu_scene_id)
		
		GVM.current_menu_scene_id = current_menu_scene_id
	
	# pause the game if the new menu is the pause menu
	get_tree().paused = new_menu_scene_id == GVM.MENU_SCENE_IDS.pause


func _on_reload_game_scene():
	clear_game_scenes()
	add_game_scene(current_game_scene_id)


func _on_reload_menu_scene():
	clear_menu_scenes()
	add_menu_scene(current_menu_scene_id)

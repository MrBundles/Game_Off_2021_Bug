extends Node2D

# references -----------------------------------------------------------------------------------------------------------


# signals --------------------------------------------------------------------------------------------------------------


# variables ------------------------------------------------------------------------------------------------------------
export(int, 0, 256) var revision_major = 0 setget set_revision_major
export(int, 0, 256) var revision_minor = 0 setget set_revision_minor
export(Array, PackedScene) var game_scene_array = []
export(Array, PackedScene) var menu_scene_array = []
var current_game_scene_id = -1
var current_menu_scene_id = -1
var highest_unlocked_game_scene_id = 20 setget set_highest_unlocked_game_scene_id

# level sample generation variables
export var generate_game_scene_samples = false setget set_generate_game_scene_samples


# main functions -------------------------------------------------------------------------------------------------------
func _ready():
	# connect signals
	GSM.connect("change_game_scene", self, "_on_change_game_scene")
	GSM.connect("change_menu_scene", self, "_on_change_menu_scene")
	GSM.connect("reload_game_scene", self, "_on_reload_game_scene")
	GSM.connect("reload_menu_scene", self, "_on_reload_menu_scene")
	GSM.connect("level_completed", self, "_on_level_completed")
	
	# initialize setgets
	self.revision_major = revision_major
	self.revision_minor = revision_minor
	self.highest_unlocked_game_scene_id = highest_unlocked_game_scene_id
	self.generate_game_scene_samples = false
	
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
	if has_node("GameScenes"):
		for child in $GameScenes.get_children():
			child.queue_free()


func clear_menu_scenes():
	# clear all menu scene children from under MenuScenes node
	if has_node("MenuScenes"):
		for child in $MenuScenes.get_children():
			child.queue_free()


func add_game_scene(new_game_scene_id):
	if not new_game_scene_id < game_scene_array.size() or not game_scene_array[new_game_scene_id] or not has_node("GameScenes"):
		return
	
	var game_scene_instance = game_scene_array[new_game_scene_id].instance()
	$GameScenes.add_child(game_scene_instance)


func add_menu_scene(new_menu_scene_id):
	if not new_menu_scene_id < menu_scene_array.size() or not menu_scene_array[new_menu_scene_id] or not has_node("MenuScenes"):
		return
	
	var menu_scene_instance = menu_scene_array[new_menu_scene_id].instance()
	$MenuScenes.add_child(menu_scene_instance)


# set/get functions ------------------------------------------------------------------------------------------------------
func set_revision_major(new_val):
	revision_major = new_val
	
	GVM.revision_major = revision_major


func set_revision_minor(new_val):
	revision_minor = new_val
	
	GVM.revision_minor = revision_minor


func set_highest_unlocked_game_scene_id(new_val):
	highest_unlocked_game_scene_id = new_val
	
	GVM.highest_unlocked_game_scene_id = highest_unlocked_game_scene_id


func set_generate_game_scene_samples(new_val):
	generate_game_scene_samples = new_val
	
	if generate_game_scene_samples and get_tree():
		# save current game and menu scene ids
		var _current_game_scene_id = current_game_scene_id
		var _current_menu_scene_id = current_menu_scene_id
		
		_on_change_menu_scene(GVM.MENU_SCENE_IDS.null)
		for j in range(5):
			yield(get_tree(), "idle_frame")
		
		for i in range(game_scene_array.size()):
			if not game_scene_array[i]:
				return
			
			_on_change_game_scene(i)
			for j in range(5):
				yield(get_tree(), "idle_frame")
			
			# generate a sample texture from viewport
			var game_scene_sample_image = get_viewport().get_texture().get_data()
			game_scene_sample_image.flip_y()
			var game_scene_sample_image_path = "res://Scenes/GameScenes/GameSceneResources/GameScene_Samples/" + str(i) + ".png"
			game_scene_sample_image.save_png(game_scene_sample_image_path)
		
		_on_change_game_scene(_current_game_scene_id)
		print("current: " + str(current_game_scene_id) + "   _current: " + str(_current_game_scene_id))
		_on_change_menu_scene(_current_menu_scene_id)
		for j in range(5):
			yield(get_tree(), "idle_frame")
		
		generate_game_scene_samples = false


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
	if get_tree():
		get_tree().paused = new_menu_scene_id == GVM.MENU_SCENE_IDS.pause


func _on_reload_game_scene():
	clear_game_scenes()
	add_game_scene(current_game_scene_id)


func _on_reload_menu_scene():
	clear_menu_scenes()
	add_menu_scene(current_menu_scene_id)


func _on_level_completed():
	if current_game_scene_id + 1 < game_scene_array.size():
		if current_game_scene_id + 1 > highest_unlocked_game_scene_id:
			highest_unlocked_game_scene_id = current_game_scene_id + 1
		
		GSM.emit_signal("change_game_scene", current_game_scene_id + 1)


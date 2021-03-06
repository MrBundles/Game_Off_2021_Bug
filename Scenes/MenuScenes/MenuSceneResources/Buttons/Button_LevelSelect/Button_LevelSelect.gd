tool
extends Button_Base

# references -----------------------------------------------------------------------------------------------------------


# signals --------------------------------------------------------------------------------------------------------------


# variables ------------------------------------------------------------------------------------------------------------
export(int, 0, 256) var game_scene_id = 0 setget set_game_scene_id


# main functions -------------------------------------------------------------------------------------------------------
func _ready():
	# connect signals
	GSM.connect("point_handle_hovered", self, "_on_point_handle_hovered")
	
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
func game_scene_sample_exists(game_scene_id):
	var directory = Directory.new()
	var game_scene_sample_image_path = "res://Scenes/GameScenes/GameSceneResources/GameScene_Samples/" + str(game_scene_id) + ".png"
	return directory.file_exists(game_scene_sample_image_path)


# set/get functions ------------------------------------------------------------------------------------------------------
func set_game_scene_id(new_val):
	game_scene_id = new_val
	
	# set button pressed based on game_scene_id and the highest unlocked game scene
	pressed = game_scene_id > GVM.highest_unlocked_game_scene_id
	text = str(game_scene_id).pad_zeros(2)
	
	if not game_scene_sample_exists(game_scene_id):
		return
	
	# load and set button_icon if the given id has a valid associated sample image
	var game_scene_sample_image_path = "res://Scenes/GameScenes/GameSceneResources/GameScene_Samples/" + str(game_scene_id) + ".png"
	var game_scene_sample_image = ResourceLoader.load(game_scene_sample_image_path)
	set_button_icon(game_scene_sample_image)

# signal functions -------------------------------------------------------------------------------------------------------
func _on_point_handle_hovered(point_handle_id, point_handle_hovered):
	if point_handle_hovered:
		self.game_scene_id = point_handle_id


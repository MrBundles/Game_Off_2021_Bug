extends TextureRect

# references -----------------------------------------------------------------------------------------------------------


# signals --------------------------------------------------------------------------------------------------------------


# variables ------------------------------------------------------------------------------------------------------------


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


# signal functions -------------------------------------------------------------------------------------------------------
func _on_point_handle_hovered(point_handle_id, point_handle_hovered):
	if point_handle_hovered:
		if not game_scene_sample_exists(point_handle_id):
			return
		
		# load and set button_icon if the given id has a valid associated sample image
		var game_scene_sample_image_path = "res://Scenes/GameScenes/GameSceneResources/GameScene_Samples/" + str(point_handle_id) + ".png"
		var game_scene_sample_image = ResourceLoader.load(game_scene_sample_image_path)
		texture = game_scene_sample_image

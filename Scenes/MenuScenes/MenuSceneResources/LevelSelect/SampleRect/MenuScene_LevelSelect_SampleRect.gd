extends TextureRect

# references -----------------------------------------------------------------------------------------------------------


# signals --------------------------------------------------------------------------------------------------------------


# variables ------------------------------------------------------------------------------------------------------------
export var color_mod = Color(1,1,1,1)
export var tween_duration = 1.0
export(Array, Texture) var game_scene_sample_array = []

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
func update_sample_texture(point_handle_id):
	# load and set button_icon if the given id has a valid associated sample image
	if point_handle_id < game_scene_sample_array.size():
		texture = game_scene_sample_array[point_handle_id]


# set/get functions ------------------------------------------------------------------------------------------------------


# signal functions -------------------------------------------------------------------------------------------------------
func _on_point_handle_hovered(point_handle_id, point_handle_hovered):
	if point_handle_hovered:
		if has_node("Tween"):
			$Tween.stop_all()
			
			$Tween.interpolate_callback(self, tween_duration / 2.0, "update_sample_texture", point_handle_id)
			$Tween.interpolate_property(self, "modulate", modulate, Color(1,1,1,0), tween_duration / 2.0, Tween.TRANS_CUBIC, Tween.EASE_IN)
			$Tween.interpolate_property(self, "modulate", Color(1,1,1,0), color_mod, tween_duration / 2.0, Tween.TRANS_CUBIC, Tween.EASE_OUT, tween_duration / 2.0)
			
			$Tween.start()

extends TileMap

# references -----------------------------------------------------------------------------------------------------------


# signals --------------------------------------------------------------------------------------------------------------


# variables ------------------------------------------------------------------------------------------------------------
export(Array, String, FILE) var spawn_scene_paths = []


# main functions -------------------------------------------------------------------------------------------------------
func _ready():
	# connect signals
	
	# initialize setgets
	
	# initialize variables
	
	spawn()


func _process(delta):
	pass


func _get_configuration_warning():
	if 0:
		return "Configuration Warning String"
	else:
		return ""


# helper functions ------------------------------------------------------------------------------------------------------
func spawn():
	if Engine.editor_hint:
		return
	
	for i in range(get_used_cells().size()):
		var tile_pos = get_used_cells()[i]
		var tile_id = get_cellv(tile_pos)
		
		if tile_id < spawn_scene_paths.size():
			var spawn_instance = load(spawn_scene_paths[tile_id]).instance()
			spawn_instance.global_position = map_to_world(tile_pos)
			
			var tile_rotation_info = get_tile_rotation_info(tile_pos)
			if "tile_rotation_degrees" in spawn_instance:
				spawn_instance.tile_rotation_degrees = tile_rotation_info[0]
			if "tile_flip" in spawn_instance:
				spawn_instance.tile_flip = tile_rotation_info[1]
			
			add_child(spawn_instance)
	
	clear()


func get_tile_rotation_info(tile_position : Vector2) -> Array:
	var tile_rotation_degrees = 1.0
	var tile_flipped = false
	var tile_flipped_x = is_cell_x_flipped(tile_position.x, tile_position.y)
	var tile_flipped_y = is_cell_y_flipped(tile_position.x, tile_position.y)
	var tile_transposed = is_cell_transposed(tile_position.x, tile_position.y)
	var state_array = [tile_flipped_x, tile_flipped_y, tile_transposed]
	
	match state_array:
		[false, false, false]:
			tile_rotation_degrees = 0
			tile_flipped = false
		[false, false, true]:
			tile_rotation_degrees = 270
			tile_flipped = true
		[false, true, false]:
			tile_rotation_degrees = 180
			tile_flipped = true
		[false, true, true]:
			tile_rotation_degrees = 270
			tile_flipped = false
		[true, false, false]:
			tile_rotation_degrees = 0
			tile_flipped = true
		[true, false, true]:
			tile_rotation_degrees = 90
			tile_flipped = false
		[true, true, false]:
			tile_rotation_degrees = 180
			tile_flipped = false
		[true, true, true]:
			tile_rotation_degrees = 90
			tile_flipped = true
	
#	print("xflip: " + str(tile_flipped_x) + "    yflip: " + str(tile_flipped_y) + "    transposed: " + str(tile_transposed))
	
	return [tile_rotation_degrees, tile_flipped]


# set/get functions ------------------------------------------------------------------------------------------------------



# signal functions -------------------------------------------------------------------------------------------------------



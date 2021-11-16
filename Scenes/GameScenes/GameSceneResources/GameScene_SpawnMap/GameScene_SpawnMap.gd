extends TileMap

# references -----------------------------------------------------------------------------------------------------------


# signals --------------------------------------------------------------------------------------------------------------


# variables ------------------------------------------------------------------------------------------------------------
export(Array, PackedScene) var spawn_scenes = []


# main functions -------------------------------------------------------------------------------------------------------
func _ready():
	# connect signals
	
	# initialize setgets
	
	# initialize variables
	pass
	
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
	for i in range(get_used_cells().size()):
		var tile_pos = get_used_cells()[i]
		var tile_id = get_cellv(tile_pos)
		
		if tile_id < spawn_scenes.size():
			var spawn_instance = spawn_scenes[tile_id].instance()
			spawn_instance.global_position = map_to_world(tile_pos)
			print(map_to_world(tile_pos))
			add_child(spawn_instance)
	
	clear()


# set/get functions ------------------------------------------------------------------------------------------------------



# signal functions -------------------------------------------------------------------------------------------------------



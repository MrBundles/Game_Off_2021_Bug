tool
extends StaticBody2D

# references -----------------------------------------------------------------------------------------------------------


# signals --------------------------------------------------------------------------------------------------------------


# variables ------------------------------------------------------------------------------------------------------------
export var tile_size = Vector2(16,16) setget set_tile_size


# main functions -------------------------------------------------------------------------------------------------------
func _ready():
	# connect signals
	
	# initialize setgets
	self.tile_size = tile_size
	
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
func set_tile_size(new_val):
	tile_size = new_val
	
	if has_node("CollisionShape2D"):
		$CollisionShape2D.position = tile_size
		$CollisionShape2D.shape.extents = tile_size


# signal functions -------------------------------------------------------------------------------------------------------



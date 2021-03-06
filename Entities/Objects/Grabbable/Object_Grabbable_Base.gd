tool
extends RigidBody2D
class_name Grabbable

# references -----------------------------------------------------------------------------------------------------------


# signals --------------------------------------------------------------------------------------------------------------


# variables ------------------------------------------------------------------------------------------------------------
export var grabbable = true setget set_grabbable
export var rigidbody = false
export var color = Color(1,1,1,1) setget set_color
export var tile_rotation_degrees = 0.0 setget set_tile_rotation_degrees
export var tile_flip = false setget set_tile_flip
#var size = Vector2(0,0) setget , get_size
export var child_position_init = Vector2(0,0) setget set_child_position_init
var child_position_current = Vector2(0,0)

var grabbed = false setget set_grabbed


# main functions -------------------------------------------------------------------------------------------------------
func _ready():
	# connect signals
	
	# initialize setgets
	self.grabbable = grabbable
	self.color = color
	self.tile_rotation_degrees = tile_rotation_degrees
	self.tile_flip = tile_flip
	self.child_position_init
	
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
func set_grabbable(new_val):
	grabbable = new_val
	
	if grabbable:
		if not is_in_group("grabbable"):
			add_to_group("grabbable")
	else:
		if is_in_group("grabbable"):
			remove_from_group("grabbable")


func set_color(new_val):
	color = new_val
	
	modulate = color


func set_tile_rotation_degrees(new_val):
	tile_rotation_degrees = new_val
	
	# set child_position_current based on tile_rotation_degrees
	if tile_rotation_degrees == 0 or tile_rotation_degrees == 180:
		child_position_current = child_position_init
	else:
		child_position_current = Vector2(child_position_init.y, child_position_init.x)
	
	if has_node("Sprite"):
		$Sprite.rotation_degrees = tile_rotation_degrees
		$Sprite.position = child_position_current
	
	if has_node("CollisionPolygon2D"):
		$CollisionPolygon2D.rotation_degrees = tile_rotation_degrees
		$CollisionPolygon2D.position = child_position_current


func set_tile_flip(new_val):
	tile_flip = new_val
	
	if has_node("Sprite"):
		if tile_flip:
			$Sprite.scale.x = -1
		else:
			$Sprite.scale.x = 1
	
	if not rigidbody:
		if has_node("CollisionPolygon2D"):
			if tile_flip:
				$CollisionPolygon2D.scale.x = -1
			else:
				$CollisionPolygon2D.scale.x = 1


func set_child_position_init(new_val):
	child_position_init = new_val
	
	if has_node("Sprite"):
		$Sprite.position = child_position_init
	
	if has_node("CollisionPolygon2D"):
		$CollisionPolygon2D.position = child_position_init


# this functionc can be used and overridden by inherited scenes/scripts
func set_grabbed(new_val):
	grabbed = new_val


#func get_size():
#	if has_node("CollisionPolygon2D"):
#		var x_array = []
#		var y_array = []
#		for v in $CollisionPolygon2D.polygon:
#			x_array.append(v.x)
#			y_array.append(v.y)
#
#		size = Vector2(x_array.max - x_array.min(), y_array.max() - y_array.min())
#
#	return size

# signal functions -------------------------------------------------------------------------------------------------------



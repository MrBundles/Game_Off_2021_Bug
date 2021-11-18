tool
extends NinePatchRect

# references -----------------------------------------------------------------------------------------------------------


# signals --------------------------------------------------------------------------------------------------------------


# variables ------------------------------------------------------------------------------------------------------------
export var gravity_vector = Vector2(0,0) setget set_gravity_vector
export var speed = 1.0 setget set_speed
export(NoiseTexture) var noise_tex setget set_noise_tex


# main functions -------------------------------------------------------------------------------------------------------
func _ready():
	# connect signals
	
	# initialize setgets
	self.gravity_vector = gravity_vector
	self.speed = speed
	self.noise_tex = noise_tex
	
	# initialize variables
	pass
	
	
	# force rect to update
	_on_Object_Forcefield_item_rect_changed()


func _process(delta):
	pass


func _get_configuration_warning():
	if 0:
		return "Configuration Warning String"
	else:
		return ""


# helper functions ------------------------------------------------------------------------------------------------------



# set/get functions ------------------------------------------------------------------------------------------------------
func set_gravity_vector(new_val):
	gravity_vector = new_val
	
	if has_node("Area2D"):
		$Area2D.gravity_vec = gravity_vector


func set_speed(new_val):
	speed = new_val
	
	if has_node("ColorRect"):
		$ColorRect.material.set_shader_param("speed", speed)


func set_noise_tex(new_val):
	noise_tex = new_val
	
	if has_node("ColorRect"):
		$ColorRect.material.set_shader_param("noise_tex", noise_tex)


# signal functions -------------------------------------------------------------------------------------------------------
func _on_Object_Forcefield_item_rect_changed():
	if has_node("Area2D"):
		$Area2D.position = rect_size / Vector2(2,2)
		$Area2D/CollisionShape2D.shape.extents = rect_size / Vector2(2,2)
	
	if has_node("ColorRect"):
		$ColorRect.rect_position = Vector2(0,0)
		$ColorRect.rect_size = rect_size

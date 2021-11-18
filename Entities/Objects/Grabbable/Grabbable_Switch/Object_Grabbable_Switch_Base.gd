tool
extends Grabbable

# references -----------------------------------------------------------------------------------------------------------


# signals --------------------------------------------------------------------------------------------------------------


# variables ------------------------------------------------------------------------------------------------------------
export var switch_offset_rest = Vector2(0,0) setget set_switch_offset_rest
export var switch_offset_grabbed = Vector2(0,0) setget set_switch_offset_grabbed
var switch_offset_current = Vector2(0,0) setget set_switch_offset_current

var global_position_init = Vector2(0,0)


# main functions -------------------------------------------------------------------------------------------------------
func _ready():
	# connect signals
	
	# initialize setgets
	self.switch_offset_rest = switch_offset_rest
	
	# initialize variables
	global_position_init = global_position


func _process(delta):
	pass



func _get_configuration_warning():
	if 0:
		return "Configuration Warning String"
	else:
		return ""


# helper functions ------------------------------------------------------------------------------------------------------



# set/get functions ------------------------------------------------------------------------------------------------------
func set_switch_offset_rest(new_val):
	switch_offset_rest = new_val
	
	self.switch_offset_current = switch_offset_rest


func set_switch_offset_grabbed(new_val):
	switch_offset_grabbed = new_val
	
	self.switch_offset_current = switch_offset_grabbed


func set_switch_offset_current(new_val):
	switch_offset_current = new_val
	
	global_position = global_position_init + switch_offset_current.rotated(deg2rad(tile_rotation_degrees))


func set_grabbed(new_val):
	grabbed = new_val
	
	if has_node("Tween"):
		$Tween.stop_all()
		
		if grabbed:
			$Tween.interpolate_property(self, "switch_offset_current", switch_offset_current, switch_offset_grabbed, .25, Tween.TRANS_QUAD, Tween.EASE_IN)
		else:
			$Tween.interpolate_property(self, "switch_offset_current", switch_offset_current, switch_offset_rest, .5, Tween.TRANS_QUINT, Tween.EASE_OUT)
		
		$Tween.start()


# signal functions -------------------------------------------------------------------------------------------------------



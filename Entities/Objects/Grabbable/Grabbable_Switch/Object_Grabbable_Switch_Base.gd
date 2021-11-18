tool
extends Grabbable

# references -----------------------------------------------------------------------------------------------------------


# signals --------------------------------------------------------------------------------------------------------------


# variables ------------------------------------------------------------------------------------------------------------
export var switch_pos_rest = Vector2(0,0) setget set_switch_pos_rest
export var switch_pos_pulled = Vector2(0,0)
var switch_pos_current = Vector2(0,0) setget set_switch_pos_current


# main functions -------------------------------------------------------------------------------------------------------
func _ready():
	# connect signals
	
	# initialize setgets
	self.switch_pos_rest = switch_pos_rest
#	self.switch_pos_current = switch_pos_current	# no need to set this variable as it is set in switch_pos_rest setter function
	
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
func set_switch_pos_rest(new_val):
	switch_pos_rest = new_val
	
	self.switch_pos_current = switch_pos_rest


func set_switch_pos_current(new_val):
	switch_pos_current = new_val
	
	if has_node("Sprite/Switch"):
		$Sprite/Switch.position = switch_pos_current


# signal functions -------------------------------------------------------------------------------------------------------



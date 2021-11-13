extends PinJoint2D

# references -----------------------------------------------------------------------------------------------------------


# signals --------------------------------------------------------------------------------------------------------------


# variables ------------------------------------------------------------------------------------------------------------
var node_spread = 0.0 setget , get_node_spread
var stretch = 0.0 setget set_stretch

# main functions -------------------------------------------------------------------------------------------------------
func _ready():
	# connect signals
	
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



# set/get functions ------------------------------------------------------------------------------------------------------
func get_node_spread():
	node_spread = get_node(node_a).global_position.distance_to(get_node(node_b).global_position)
	return node_spread


func set_stretch(new_val):
	stretch = new_val
	
	$Tween.stop_all()
	$Tween.interpolate_property(self, "softness", softness, stretch, 1, Tween.TRANS_QUAD, Tween.EASE_OUT)
	$Tween.start()


# signal functions -------------------------------------------------------------------------------------------------------



extends PinJoint2D

# references -----------------------------------------------------------------------------------------------------------


# signals --------------------------------------------------------------------------------------------------------------


# variables ------------------------------------------------------------------------------------------------------------
var node_spread = 0.0 setget , get_node_spread
var stretch = 0.0 setget set_stretch
var thickness = 16.0 setget set_thickness

# main functions -------------------------------------------------------------------------------------------------------
func _ready():
	# connect signals
	
	# initialize setgets
	self.node_spread = node_spread
	self.stretch = stretch
	
	# initialize variables
	pass


func _process(delta):
	update_area()


#func _physics_process(delta):
#	var colliders = $KinematicBody2D.co


func _get_configuration_warning():
	if 0:
		return "Configuration Warning String"
	else:
		return ""


# helper functions ------------------------------------------------------------------------------------------------------
func update_area():
	if not node_a or not node_b:
		return
	
	var node_a_pos : Vector2 = get_node(node_a).global_position
	var node_b_pos : Vector2 = get_node(node_b).global_position
	
	$Area2D.global_position = (node_a_pos + node_b_pos) / Vector2(2,2)
	$Area2D.rotation = node_a_pos.angle_to_point(node_b_pos)
	$Area2D/CollisionShape2D.shape.height = self.node_spread / 2


# set/get functions ------------------------------------------------------------------------------------------------------
func get_node_spread():
	if not node_a or not node_b:
		return 16.0
	
	var node_a_position : Vector2 = get_node(node_a).global_position
	var node_b_position : Vector2= get_node(node_b).global_position
	
	return node_a_position.distance_to(node_b_position)


func set_stretch(new_val):
	stretch = new_val
	
	$Tween.stop_all()
	$Tween.interpolate_property(self, "softness", softness, stretch, .5, Tween.TRANS_QUAD, Tween.EASE_OUT)
#	$Tween.interpolate_method(self, "update_area", null, null, .5, Tween.TRANS_QUAD, Tween.EASE_OUT)
	$Tween.start()


func set_thickness(new_val):
	thickness = new_val
	
	$Area2D/CollisionShape2D.shape.radius = thickness / 2


# signal functions -------------------------------------------------------------------------------------------------------



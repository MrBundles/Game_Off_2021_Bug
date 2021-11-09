tool
extends Node2D

# references -----------------------------------------------------------------------------------------------------------


# signals --------------------------------------------------------------------------------------------------------------


# variables ------------------------------------------------------------------------------------------------------------
export var generate = false

# worm parameters
export(float, 1, 256) var length = 10.0
export(int, 2, 256) var segment_qty = 10

# scenes for instancing
export(PackedScene) var worm_segment
export(PackedScene) var worm_joint



# main functions -------------------------------------------------------------------------------------------------------
func _ready():
	# connect signals
	
	# initialize setgets
	
	# initialize variables
	
	if generate:
		generate_segments()
	pass


func _process(delta):
	pass


func _get_configuration_warning():
	if 0:
		return "Configuration Warning String"
	else:
		return ""


# helper functions ------------------------------------------------------------------------------------------------------
func clear_segments():
	for child in $Segments.get_children():
		child.queue_free()


func generate_segments():
	# clear all current segments
	clear_segments()
	
	# calculate individual segment length
	var segment_length = length / segment_qty
	
	# first add a segment
	var worm_segment_instance : RigidBody2D = worm_segment.instance()
	$Segments.add_child(worm_segment_instance)
	
	# then loop over all remaining segments and add them as well as a joint between each
	for i in range(1, segment_qty):
		# add joint
		var worm_joint_instance : PinJoint2D = worm_joint.instance()
		worm_joint_instance.position.x = i * segment_length - segment_length / 2	# This should place the joint in between the previous two segments
		$Segments.add_child(worm_joint_instance)
		
		# add segment
		worm_segment_instance = worm_segment.instance()
		worm_segment_instance.position.x = i * segment_length
		$Segments.add_child(worm_segment_instance)
		
		# connect joints between segments
		worm_joint_instance.node_a = worm_joint_instance.get_path_to($Segments.get_child(2 * i - 2))
		worm_joint_instance.node_b = worm_joint_instance.get_path_to($Segments.get_child(2 * i))
		print("node a: " + str(worm_joint_instance.node_a) + "    node b: " + str(worm_joint_instance.node_b))


# set/get functions ------------------------------------------------------------------------------------------------------



# signal functions -------------------------------------------------------------------------------------------------------



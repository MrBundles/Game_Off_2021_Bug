tool
extends Node2D

# references -----------------------------------------------------------------------------------------------------------


# signals --------------------------------------------------------------------------------------------------------------


# variables ------------------------------------------------------------------------------------------------------------
# worm parameters
export(float, 1, 256) var length = 10.0
export(float, 1, 128) var thickness = 16.0 setget set_thickness
export(int, 2, 256) var segment_qty = 10
export(Color) var worm_color = Color(1,1,1,1) setget set_worm_color

# scenes for instancing
export(PackedScene) var worm_segment
export(PackedScene) var worm_joint



# main functions -------------------------------------------------------------------------------------------------------
func _ready():
	# connect signals
	
	# initialize setgets
	self.thickness = thickness
	self.worm_color = worm_color
	
	# initialize variables
	
	generate_segments()
	pass


func _process(delta):
	update_worm_line()


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
		worm_segment_instance.thickness = thickness
		$Segments.add_child(worm_segment_instance)
		
		# connect joints between segments
		worm_joint_instance.node_a = worm_joint_instance.get_path_to($Segments.get_child(2 * i - 2))
		worm_joint_instance.node_b = worm_joint_instance.get_path_to($Segments.get_child(2 * i))
		print("node a: " + str(worm_joint_instance.node_a) + "    node b: " + str(worm_joint_instance.node_b))
	
	# redraw worm graphic to reflect newly generate segments
	generate_worm_line()


func generate_worm_line():
	$Line2D.clear_points()
	
	for i in range($Segments.get_child_count()):
		if i % 2 == 0:
			$Line2D.add_point($Segments.get_child(i).position)

func update_worm_line():
	for i in range($Line2D.points.size()):
		$Line2D.set_point_position(i, $Segments.get_child(i * 2).position)


# set/get functions ------------------------------------------------------------------------------------------------------
func set_worm_color(new_val):
	worm_color = new_val
	
	if has_node("Line2D"):
		$Line2D.default_color = worm_color


func set_thickness(new_val):
	thickness = new_val
	
	if has_node("Segments"):
		for child in $Segments.get_children():
			if child.has_method("set_thickness"):
				child.thickness = thickness
	
	if has_node("Line2D"):
		$Line2D.width = thickness


# signal functions -------------------------------------------------------------------------------------------------------



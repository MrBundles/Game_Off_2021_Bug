tool
extends Node2D

# references -----------------------------------------------------------------------------------------------------------


# signals --------------------------------------------------------------------------------------------------------------


# variables ------------------------------------------------------------------------------------------------------------
# worm parameters
export(float, 1, 256) var length = 10.0
export(float, 1, 128) var thickness = 16.0 setget set_thickness
export(int, 2, 256) var segment_qty = 10
export(float, 1, 256) var move_force = 5
export(Color) var worm_color = Color(1,1,1,1) setget set_worm_color

# worm movement variables
var move_step = 0 setget set_move_step		# this variable is used to create a kind of stretch and contract wave through the worm as it moves
export var max_stretch = 16
export var min_stretch = 0

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
	
	if not Engine.editor_hint:
#		var text = ""
#		if has_node("Segments"):
#			for child in $Segments.get_children():
#				if child.has_method("get_node_spread"):
#					text += "    " + str(child.get_node_spread()).pad_decimals(2).pad_zeros(2)
		
		$Label.text = str(move_step)


func _physics_process(delta):
	if not Engine.editor_hint:
		get_input()


func _get_configuration_warning():
	if 0:
		return "Configuration Warning String"
	else:
		return ""


# helper functions ------------------------------------------------------------------------------------------------------
func get_input():
	if Input.is_action_pressed("left_click"):
		var lead_segment = $Segments.get_child(0)
		lead_segment.apply_central_impulse(lead_segment.global_position.direction_to(get_global_mouse_position()).normalized() * move_force)
		
#		for i in range(1, $Segments.get_child_count()):
#			var segment = $Segments.get_child(i)
#			var previous_segment = $Segments.get_child(i-1)
#			if segment.has_method("set_thickness"):
#				lead_segment.apply_central_impulse(segment.global_position.direction_to(previous_segment.global_position).normalized() * move_force / i)
	
	if Input.is_action_just_pressed("left_click"):
		$Timer.start()
		self.move_step = 1
	
	if Input.is_action_just_released("left_click"):
		$Timer.stop()
		self.move_step = 0


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
#		print("node a: " + str(worm_joint_instance.node_a) + "    node b: " + str(worm_joint_instance.node_b))
	
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


func set_move_step(new_val):
	move_step = new_val
	
	if has_node("Segments"):
		for i in range($Segments.get_child_count()):
			var joint = $Segments.get_child(i)
			if joint.has_method("get_node_spread"):
				match move_step:
					0:
						joint.softness = min_stretch
					1:
						if i < $Segments.get_child_count() / 2:
							joint.softness = max_stretch
						else:
							joint.softness = min_stretch
					2:
						if i < $Segments.get_child_count() / 2:
							joint.softness = min_stretch
						else:
							joint.softness = max_stretch


# signal functions -------------------------------------------------------------------------------------------------------




func _on_Timer_timeout():
	match move_step:
		1: self.move_step = 2
		2: self.move_step = 1

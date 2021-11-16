tool
extends RigidBody2D

# references -----------------------------------------------------------------------------------------------------------

# signals --------------------------------------------------------------------------------------------------------------

# variables ------------------------------------------------------------------------------------------------------------
# scene paths
export(String, FILE) var worm_segment_path
export(String, FILE) var worm_handle_path

# color variables
export var color_left = Color(1,1,1,1)
export var color_right = Color(1,1,1,1)
export var color_left_outline = Color(1,1,1,1)
export var color_right_outline = Color(1,1,1,1)
export var color_outline_thickness = 4.0

# segment quantity variables
export var segment_qty = 5
var first_segment = true

# when toggled, this bit will cause the segments to be drawn under one another rather than on top
export var invert_depth = false setget set_invert_depth

# input type variables
export(GVM.INPUT_TYPES) var input_type = GVM.INPUT_TYPES.null

# move force on worm handles
export var move_force = 20.0

# radius variables
export var radius_stretch = 8.0
export var radius_rest = 16.0 setget set_radius_rest
var radius = 16.0 setget set_radius

# length variables
export var length_stretch = 150.0 setget set_length_stretch
export var length_rest = 50.0 setget set_length_rest
var length = 50.0 setget set_length
var stretch_dist = 1.0
var stretch_dist_max = 1.0


# main functions -------------------------------------------------------------------------------------------------------
func _ready():
	# connect signals
	GSM.connect("break_worm", self, "_on_break_worm")
	
	# initialize setgets
	self.invert_depth = invert_depth
	self.radius_rest = radius_rest
#	self.radius = radius						# don't have to call this setget as it is called in the radius_rest setter function
	self.length_stretch = length_stretch
	self.length_rest = length_rest
#	self.length = length						# don't have to call this setget as it is called in the length_rest setter function
	
	# initialize variables
	if not Engine.editor_hint:
		generate_segments()
		init_stretch_dist_max()


func _process(delta):
	update_stretch_distance()
	update_collision_shape()
	update()


func _physics_process(delta):
	get_input()


func _draw():
	if Engine.editor_hint or $ChildSegmentPosition.get_child_count() < 1:
		return
	
	match input_type:
		GVM.INPUT_TYPES.left:
			# draw outline of segment
			draw_circle(Vector2(length,0) + $ChildSegmentPosition.get_child(0).position, radius + color_outline_thickness, color_left_outline)
			draw_line(Vector2(0,0), Vector2(length,0) + $ChildSegmentPosition.get_child(0).position, color_left_outline, (radius + color_outline_thickness) * 2, true)
			draw_circle(Vector2(0,0), radius + color_outline_thickness, color_left_outline)
			# draw segment
			draw_circle(Vector2(length,0) + $ChildSegmentPosition.get_child(0).position, radius, color_left)
			draw_line(Vector2(0,0), Vector2(length,0) + $ChildSegmentPosition.get_child(0).position, color_left, radius * 2, true)
			draw_circle(Vector2(0,0), radius, color_left)
		
		GVM.INPUT_TYPES.right:
			# draw outline of segment
			draw_circle(Vector2(length,0) + $ChildSegmentPosition.get_child(0).position, radius + color_outline_thickness, color_right_outline)
			draw_line(Vector2(0,0), Vector2(length,0) + $ChildSegmentPosition.get_child(0).position, color_right_outline, (radius + color_outline_thickness) * 2, true)
			draw_circle(Vector2(0,0), radius + color_outline_thickness, color_right_outline)
			# draw segment
			draw_circle(Vector2(length,0) + $ChildSegmentPosition.get_child(0).position, radius, color_right)
			draw_line(Vector2(0,0), Vector2(length,0) + $ChildSegmentPosition.get_child(0).position, color_right, radius * 2, true)
			draw_circle(Vector2(0,0), radius, color_right)


func _get_configuration_warning():
	if 0:
		return "Configuration Warning String"
	else:
		return ""


# helper functions ------------------------------------------------------------------------------------------------------
func get_input():
	if Engine.editor_hint:
		return
	
	match input_type:
		GVM.INPUT_TYPES.left:
			if Input.is_action_pressed("left_click"):
				$DampedSpringJoint2D.stiffness = 42
			else:
				$DampedSpringJoint2D.stiffness = 64

		GVM.INPUT_TYPES.right:
			if Input.is_action_pressed("right_click"):
				$DampedSpringJoint2D.stiffness = 42
			else:
				$DampedSpringJoint2D.stiffness = 64


func generate_segments():
	if not worm_segment_path:
		return
	
	if segment_qty > 1:																					# if there is more than one segment left, instantiate another segment
		var worm_segment_instance = load(worm_segment_path).instance()									# create worm instance
		
		worm_segment_instance.color_left = color_left
		worm_segment_instance.color_right = color_right
		worm_segment_instance.color_left_outline = color_left_outline
		worm_segment_instance.color_right_outline = color_right_outline
		worm_segment_instance.color_outline_thickness = color_outline_thickness							# set color variables
		
		worm_segment_instance.segment_qty = segment_qty - 1												# set segment_qty variable
		
		worm_segment_instance.first_segment = false														# set first segment flag to false
		
		worm_segment_instance.invert_depth = invert_depth												# set invert_depth variable
		
		worm_segment_instance.input_type = input_type													# set input_type variable
		worm_segment_instance.move_force = move_force													# set move_force variable
		
		worm_segment_instance.radius_stretch = radius_stretch
		worm_segment_instance.radius_rest = radius_rest													# set radius variables
		
		worm_segment_instance.length_stretch = length_stretch
		worm_segment_instance.length_rest = length_rest													# set length variables
		
		$ChildSegmentPosition.add_child(worm_segment_instance)											# add worm instance as a child of ChildSegmentPosition
		$GrooveJoint2D.node_b = $GrooveJoint2D.get_path_to(worm_segment_instance)						# update node_b of GrooveJoint
		$DampedSpringJoint2D.node_b = $DampedSpringJoint2D.get_path_to(worm_segment_instance)			# update node_b of SpringJoint
	
	else:																								# if this is the last segment, instantiate a handle for the endpoint
		var worm_handle_instance = load(worm_handle_path).instance()
		worm_handle_instance.radius = radius															# set handle radius
		worm_handle_instance.move_force = move_force													# set handle move_force
		
		worm_handle_instance.color_left = color_left
		worm_handle_instance.color_right = color_right
		worm_handle_instance.color_left_outline = color_left_outline
		worm_handle_instance.color_right_outline = color_right_outline
		worm_handle_instance.color_outline_thickness = color_outline_thickness							# set color variables
		
		worm_handle_instance.invert_depth = invert_depth												# set invert_depth variable
		
		worm_handle_instance.input_type = input_type													# set input_type
		
		$ChildSegmentPosition.add_child(worm_handle_instance)											# add handle as child of ChildSegmentPosition node
		$GrooveJoint2D.node_b = $GrooveJoint2D.get_path_to(worm_handle_instance)						# update node_b of GrooveJoint
		$DampedSpringJoint2D.node_b = $DampedSpringJoint2D.get_path_to(worm_handle_instance)			# update node_b of SpringJoint


func init_stretch_dist_max():
	stretch_dist_max = length_rest * 2.5


func update_stretch_distance():
	if $ChildSegmentPosition.get_child_count() > 0:
		stretch_dist = global_position.distance_to($ChildSegmentPosition.get_child(0).global_position)


func update_collision_shape():
	# update length of collisionshape
	if has_node("CollisionShape2D") and has_node("ChildSegmentPosition"):
		$CollisionShape2D.shape.height = stretch_dist
		$CollisionShape2D.position.x = stretch_dist / 2
		
		#update radius of collisionshape
		self.radius = lerp(radius_rest, radius_stretch, clamp(stretch_dist / stretch_dist_max, 0.0, 1.0))


# set/get functions ------------------------------------------------------------------------------------------------------
func set_invert_depth(new_val):
	invert_depth = new_val
	
	if not first_segment and get_parent():
		if invert_depth:
			z_index = get_parent().z_index - 1
		else:
			z_index = get_parent().z_index + 1
	
	
	if has_node("ChildSegmentPosition") and $ChildSegmentPosition.get_child_count() > 0:
		if $ChildSegmentPosition.get_child(0).has_method("set_invert_depth"):
			$ChildSegmentPosition.get_child(0).invert_depth = invert_depth


func set_radius_rest(new_val):
	radius_rest = new_val
	
	self.radius = radius_rest


func set_radius(new_val):
	radius = new_val
	
	if has_node("CollisionShape2D"):
		$CollisionShape2D.shape.radius = radius


func set_length_stretch(new_val):
	length_stretch = new_val
	
	if has_node("GrooveJoint2D"):
		$GrooveJoint2D.length = length_stretch


func set_length_rest(new_val):
	length_rest = new_val
	
	self.length = length_rest


func set_length(new_val):
	if length == new_val:
		return
		
	length = clamp(new_val, 1.0, length_stretch)
	
	if has_node("GrooveJoint2D"):
		$GrooveJoint2D.initial_offset = length
	
	if has_node("DampedSpringJoint2D"):
		$DampedSpringJoint2D.length = length
		$DampedSpringJoint2D.rest_length = length
	
	if has_node("ChildSegmentPosition"):
		$ChildSegmentPosition.position.x = length


# signal functions -------------------------------------------------------------------------------------------------------
func _on_break_worm():
	self.invert_depth = false

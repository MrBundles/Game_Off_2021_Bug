tool
extends RigidBody2D

# references -----------------------------------------------------------------------------------------------------------

# signals --------------------------------------------------------------------------------------------------------------

# variables ------------------------------------------------------------------------------------------------------------
# scene paths
export(String, FILE) var worm_segment_path
export(String, FILE) var worm_handle_path

# color variables
export var color_front = Color(1,1,1,1)
export var color_back = Color(1,1,1,1)
export var color_front_outline = Color(1,1,1,1)
export var color_back_outline = Color(1,1,1,1)
export var color_outline_thickness = 4.0

# segment type variables
export(Array, GVM.SEGMENT_TYPES) var segment_types = []
var segment_type = GVM.SEGMENT_TYPES.null

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


# main functions -------------------------------------------------------------------------------------------------------
func _ready():
	# connect signals
	
	# initialize setgets
	self.radius_rest = radius_rest
#	self.radius = radius						# don't have to call this setget as it is called in the radius_rest setter function
	self.length_stretch = length_stretch
	self.length_rest = length_rest
#	self.length = length						# don't have to call this setget as it is called in the length_rest setter function
	
	# initialize variables
	if segment_types:
		segment_type = segment_types[0]
	
	if not Engine.editor_hint:
		generate_segments()
		add_handle()


func _process(delta):
	update_collision_shape()
	update()


func _physics_process(delta):
	get_input()


func _draw():
	if Engine.editor_hint:
		return
	
	if segment_type == GVM.SEGMENT_TYPES.front or segment_type == GVM.SEGMENT_TYPES.mid_front:
		# draw outline of segment
		draw_line(Vector2(0,0), Vector2(length,0) + $ChildSegmentPosition.get_child(0).position, color_front_outline, (radius + color_outline_thickness) * 2, true)
		draw_circle(Vector2(0,0), radius + color_outline_thickness, color_front_outline)
		# draw segment
		draw_line(Vector2(0,0), Vector2(length,0) + $ChildSegmentPosition.get_child(0).position, color_front, radius * 2, true)
		draw_circle(Vector2(0,0), radius, color_front)
	
	elif segment_type == GVM.SEGMENT_TYPES.back or segment_type == GVM.SEGMENT_TYPES.mid_back:
		# draw outline of segment
		draw_line(Vector2(0,0), Vector2(length,0) + $ChildSegmentPosition.get_child(0).position, color_back_outline, (radius + color_outline_thickness) * 2, true)
		draw_circle(Vector2(0,0), radius + color_outline_thickness, color_back_outline)
		# draw segment
		draw_line(Vector2(0,0), Vector2(length,0) + $ChildSegmentPosition.get_child(0).position, color_back, radius * 2, true)
		draw_circle(Vector2(0,0), radius, color_back)


func _get_configuration_warning():
	if 0:
		return "Configuration Warning String"
	else:
		return ""


# helper functions ------------------------------------------------------------------------------------------------------
func get_input():
	if Engine.editor_hint:
		return
	
	if segment_type == GVM.SEGMENT_TYPES.front or segment_type == GVM.SEGMENT_TYPES.mid_front:
		if Input.is_action_pressed("left_click"):
			$DampedSpringJoint2D.stiffness = 32
		else:
			$DampedSpringJoint2D.stiffness = 64
		
	elif segment_type == GVM.SEGMENT_TYPES.back or segment_type == GVM.SEGMENT_TYPES.mid_back:
		if Input.is_action_pressed("right_click"):
			$DampedSpringJoint2D.stiffness = 32
		else:
			$DampedSpringJoint2D.stiffness = 64


func generate_segments():
	if not worm_segment_path:
		return
	
	if segment_types and segment_types.size() > 1:
		var worm_segment_instance = load(worm_segment_path).instance()									# create worm instance
		
		worm_segment_instance.color_front = color_front
		worm_segment_instance.color_back = color_back
		worm_segment_instance.color_front_outline = color_front_outline
		worm_segment_instance.color_back_outline = color_back_outline
		worm_segment_instance.color_outline_thickness = color_outline_thickness							# set color variables
		
		segment_types.remove(0)
		worm_segment_instance.segment_types = segment_types												# set segment_type variable
		
		worm_segment_instance.move_force = move_force													# set move_force variable
		
		worm_segment_instance.radius_stretch = radius_stretch
		worm_segment_instance.radius_rest = radius_rest													# set radius variables
		
		worm_segment_instance.length_stretch = length_stretch
		worm_segment_instance.length_rest = length_rest													# set length variables
		
		$ChildSegmentPosition.add_child(worm_segment_instance)											# add worm instance as a child of ChildSegmentPosition
		$GrooveJoint2D.node_b = $GrooveJoint2D.get_path_to(worm_segment_instance)						# update node_b of GrooveJoint
		$DampedSpringJoint2D.node_b = $DampedSpringJoint2D.get_path_to(worm_segment_instance)			# update node_b of SpringJoint


func add_handle():
	if not worm_handle_path:
		return
	
	if segment_type == GVM.SEGMENT_TYPES.front or segment_type == GVM.SEGMENT_TYPES.back:
		var worm_handle_instance = load(worm_handle_path).instance()
		worm_handle_instance.radius = radius																	# set handle radius
		worm_handle_instance.move_force = move_force															# set handle move_force
		
		worm_handle_instance.color_front = color_front
		worm_handle_instance.color_back = color_back
		worm_handle_instance.color_front_outline = color_front_outline
		worm_handle_instance.color_back_outline = color_back_outline
		worm_handle_instance.color_outline_thickness = color_outline_thickness							# set color variables
		
		# set handle position
		match segment_type:
			GVM.SEGMENT_TYPES.front:
				worm_handle_instance.handle_type = GVM.HANDLE_TYPES.front										# set handle type
				add_child(worm_handle_instance)																	# add handle as child of RigidBody2D
				
				# pin handle in place
				var pin_joint_instance = PinJoint2D.new()
				pin_joint_instance.position = Vector2(0,0)
				add_child(pin_joint_instance)
				pin_joint_instance.node_a = pin_joint_instance.get_path_to(self)
				pin_joint_instance.node_b = pin_joint_instance.get_path_to(worm_handle_instance)
				
			GVM.SEGMENT_TYPES.back:
				worm_handle_instance.handle_type = GVM.HANDLE_TYPES.back										# set handle type
				$ChildSegmentPosition.add_child(worm_handle_instance)											# add handle as child of ChildSegmentPosition node
				$GrooveJoint2D.node_b = $GrooveJoint2D.get_path_to(worm_handle_instance)						# update node_b of GrooveJoint
				$DampedSpringJoint2D.node_b = $DampedSpringJoint2D.get_path_to(worm_handle_instance)			# update node_b of SpringJoint


func update_collision_shape():
	# update length of collisionshape
	if has_node("CollisionShape2D") and has_node("ChildSegmentPosition"):
		var stretch_dist = length
		
		if $ChildSegmentPosition.get_child_count() > 0:
			stretch_dist = global_position.distance_to($ChildSegmentPosition.get_child(0).global_position)
			
		$CollisionShape2D.shape.height = stretch_dist
		$CollisionShape2D.position.x = stretch_dist / 2
		
		#update radius of collisionshape
		var max_stretch_dist = length_rest * 2
		self.radius = lerp(radius_rest, radius_stretch, clamp(stretch_dist / max_stretch_dist, 0.0, 1.0))


# set/get functions ------------------------------------------------------------------------------------------------------
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

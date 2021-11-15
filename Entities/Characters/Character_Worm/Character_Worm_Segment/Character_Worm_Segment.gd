tool
extends RigidBody2D

# references -----------------------------------------------------------------------------------------------------------

# signals --------------------------------------------------------------------------------------------------------------

# variables ------------------------------------------------------------------------------------------------------------
export(Array, GVM.SEGMENT_TYPES) var segment_types = []
var segment_type = GVM.SEGMENT_TYPES.null
export var move_force = 20.0
export(String, FILE) var worm_segment_path
export(String, FILE) var worm_handle_path
export var radius = 16.0 setget set_radius
export var length_stretch = 150.0 setget set_length_stretch
export var length_rest = 50.0 setget set_length_rest
var length = 50.0 setget set_length


# main functions -------------------------------------------------------------------------------------------------------
func _ready():
	# connect signals
	
	# initialize setgets
	self.radius = radius
	self.length_stretch = length_stretch
	self.length_rest = length_rest
	
	# initialize variables
	if segment_types:
		segment_type = segment_types[0]
		print(segment_type)
	
	if not Engine.editor_hint:
		generate_segments()
		add_handle()


func _process(delta):
	update_collision_shape()
	if not Engine.editor_hint:
		match segment_type:
			GVM.SEGMENT_TYPES.front:
				pass
				
			GVM.SEGMENT_TYPES.mid_front:
				pass
			
			GVM.SEGMENT_TYPES.mid_back:
				pass
			
			GVM.SEGMENT_TYPES.back:
				pass


func _integrate_forces(state):
#	for i in range(state.get_contact_count()):
#		contact_positions.append(state.get_contact_local_position(i))
	
	update()


func _draw():
	draw_set_transform_matrix(transform.inverse())
	
#	for pos in contact_positions:
#		draw_circle(pos, radius / 2, Color(1,1,1,1))


func _get_configuration_warning():
	if 0:
		return "Configuration Warning String"
	else:
		return ""


# helper functions ------------------------------------------------------------------------------------------------------
func generate_segments():
	if not worm_segment_path:
		return
	
	if segment_types and segment_types.size() > 1:
		var worm_segment_instance = load(worm_segment_path).instance()									# create worm instance
		worm_segment_instance.length_stretch = length_stretch
		worm_segment_instance.length_rest = length_rest
		worm_segment_instance.radius = radius
		segment_types.remove(0)
		worm_segment_instance.segment_types = segment_types
		$ChildSegmentPosition.add_child(worm_segment_instance)											# add worm instance as a child of ChildSegmentPosition
		$GrooveJoint2D.node_b = $GrooveJoint2D.get_path_to(worm_segment_instance)						# update node_b of GrooveJoint
		$DampedSpringJoint2D.node_b = $DampedSpringJoint2D.get_path_to(worm_segment_instance)			# update node_b of SpringJoint
#	else:
#		move = true


func add_handle():
	if not worm_handle_path:
		return
	
	if segment_type == GVM.SEGMENT_TYPES.front or segment_type == GVM.SEGMENT_TYPES.back:
		var worm_handle_instance = load(worm_handle_path).instance()
		worm_handle_instance.radius = radius
		worm_handle_instance.move_force = move_force
		
		# set handle position
		match segment_type:
			GVM.SEGMENT_TYPES.front:
				worm_handle_instance.handle_type = GVM.HANDLE_TYPES.front
				worm_handle_instance.position = Vector2(0,0)
			GVM.SEGMENT_TYPES.back:
				worm_handle_instance.handle_type = GVM.HANDLE_TYPES.back
				worm_handle_instance.position = $ChildSegmentPosition.position
		
		# add handle as child node
		add_child(worm_handle_instance)


func update_collision_shape():
	if has_node("CollisionShape2D") and has_node("ChildSegmentPosition"):
		if $ChildSegmentPosition.get_child_count() < 1:
			return
		
		var stretch_dist = global_position.distance_to($ChildSegmentPosition.get_child(0).global_position)
		$CollisionShape2D.shape.height = stretch_dist
		$CollisionShape2D.position.x = stretch_dist / 2


# set/get functions ------------------------------------------------------------------------------------------------------
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
	length = clamp(new_val, 1.0, length_stretch)
	
	if has_node("GrooveJoint2D"):
		$GrooveJoint2D.initial_offset = length
	
	if has_node("DampedSpringJoint2D"):
		$DampedSpringJoint2D.length = length
		$DampedSpringJoint2D.rest_length = length
	
	if has_node("ChildSegmentPosition"):
		$ChildSegmentPosition.position.x = length


# signal functions -------------------------------------------------------------------------------------------------------

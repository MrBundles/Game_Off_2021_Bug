extends RigidBody2D

# references -----------------------------------------------------------------------------------------------------------


# signals --------------------------------------------------------------------------------------------------------------


# variables ------------------------------------------------------------------------------------------------------------
# color variables
export var color_front = Color(1,1,1,1)
export var color_back = Color(1,1,1,1)
export var color_front_outline = Color(1,1,1,1)
export var color_back_outline = Color(1,1,1,1)
export var color_outline_thickness = 4.0

# handle type variables
var handle_type = GVM.HANDLE_TYPES.null

# move force on handle
export var move_force = 20.0

# segment variables
export var radius = 16.0 setget set_radius

# body collision tracking variables
var bodies = []
var bodies_grabbed = []


# main functions -------------------------------------------------------------------------------------------------------
func _ready():
	# connect signals
	
	# initialize setgets
	self.radius = radius
	
	# initialize variables
	pass


func _process(delta):
	update_radius()
	update()


func _physics_process(delta):
	get_input()


func _draw():
	match handle_type:
		GVM.HANDLE_TYPES.front:
#			draw_circle(Vector2(0,0), radius + color_outline_thickness, color_front_outline)
#			draw_circle(Vector2(0,0), radius, color_front)
			pass
		
		GVM.HANDLE_TYPES.back:
			draw_circle(Vector2(0,0), radius + color_outline_thickness, color_back_outline)
			draw_circle(Vector2(0,0), radius, color_back)


func _get_configuration_warning():
	if 0:
		return "Configuration Warning String"
	else:
		return ""


# helper functions ------------------------------------------------------------------------------------------------------
func get_input():
	match handle_type:
		GVM.HANDLE_TYPES.front:
			if Input.is_action_just_pressed("left_click"):
				clear_pins()
			
			if Input.is_action_pressed("left_click"):
				apply_central_impulse(global_position.direction_to(get_global_mouse_position()).normalized() * move_force)
				
			elif bodies.size() > 0:
				for b in bodies:
					add_body_pin(b)
			
		GVM.HANDLE_TYPES.back:
			if Input.is_action_just_pressed("right_click"):
				clear_pins()
			
			if Input.is_action_pressed("right_click"):
				apply_central_impulse(global_position.direction_to(get_global_mouse_position()).normalized() * move_force)
			
			elif bodies.size() > 0:
				for b in bodies:
					add_body_pin(b)


func update_radius():
	match handle_type:
		GVM.HANDLE_TYPES.front:
			self.radius = get_parent().radius
			
		GVM.HANDLE_TYPES.back:
			self.radius = get_parent().get_parent().radius


func clear_pins():
	for child in $PinJoints.get_children():
		child.queue_free()
	
	bodies.clear()
	bodies_grabbed.clear()


func add_body_pin(body):
	if body in bodies_grabbed:
		return
	
	# add a pin
	var pin_instance = PinJoint2D.new()
	$PinJoints.add_child(pin_instance)
	pin_instance.node_a = pin_instance.get_path_to(self)
	pin_instance.node_b = pin_instance.get_path_to(body)
	
	bodies_grabbed.append(body)


func add_tilemap_pin():
	# add a static body to attach to
	var static_instance = StaticBody2D.new()
	var static_shape_instance = CollisionShape2D.new()
	static_shape_instance.shape = CircleShape2D.new()
	static_shape_instance.shape.radius = 16.0
	static_instance.add_child(static_shape_instance)
	$PinJoints.add_child(static_instance)
	
	# add a pin
	var pin_instance = PinJoint2D.new()
	$PinJoints.add_child(pin_instance)
	pin_instance.node_a = pin_instance.get_path_to(self)
	pin_instance.node_b = pin_instance.get_path_to(static_instance)


# set/get functions ------------------------------------------------------------------------------------------------------
func set_radius(new_val):
	radius = new_val
	
	if has_node("CollisionShape2D"):
		$CollisionShape2D.shape.radius = radius
	
	if has_node("Area2D"):
		$Area2D/CollisionShape2D.shape.radius = radius + 6


# signal functions ------------------------------------------------------------------------------------------------------
func _on_Area2D_body_entered(body):
	if not body in bodies and body.is_in_group("grabbable"):
		bodies.append(body)


func _on_Area2D_body_exited(body):
	if body in bodies:
		bodies.remove(bodies.find(body))

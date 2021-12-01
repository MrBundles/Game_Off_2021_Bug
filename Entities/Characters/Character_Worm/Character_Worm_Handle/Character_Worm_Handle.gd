extends RigidBody2D

# references -----------------------------------------------------------------------------------------------------------


# signals --------------------------------------------------------------------------------------------------------------


# variables ------------------------------------------------------------------------------------------------------------

export var worm_id = 0

# color variables
export var color_grab_available = Color(1,1,1,1)
export var color_grab_active = Color(1,1,1,1)
export var color_grab_outline_thickness = 8.0

export var color_left = Color(1,1,1,1)
export var color_right = Color(1,1,1,1)
export var color_left_outline = Color(1,1,1,1)
export var color_right_outline = Color(1,1,1,1)
export var color_outline_thickness = 4.0

export var color_force = Color(1,1,1,1)
var color_force_current = Color(1,1,1,0)
export var width_force = 1.0
var width_force_current = 1.0

# input type variables
export(GVM.INPUT_TYPES) var input_type = GVM.INPUT_TYPES.null

# move force on handle
export var move_force = 20.0
var move_force_current = 0.0

# when toggled, this bit will cause the hangle to be drawn under its parent segment rather than on top
export var invert_depth = false setget set_invert_depth

# segment variables
export var radius = 16.0 setget set_radius

# body collision tracking variables
var bodies = []
var bodies_grabbed = []

var broken = false

export(Curve) var move_force_curve


# main functions -------------------------------------------------------------------------------------------------------
func _ready():
	# connect signals
	GSM.connect("break_worm", self, "_on_break_worm")
	GSM.connect("evaporate_worm", self, "_on_evaporate_worm")
	
	# initialize setgets
	self.invert_depth = invert_depth
	self.radius = radius
	
	# initialize variables
	if GVM.float_mode:
		gravity_scale = 0


func _process(delta):
	update_radius()
	update()


func _physics_process(delta):
	get_input()


func _draw():
	# draw force vector
	var color_force_target
	match input_type:
		GVM.INPUT_TYPES.left:
			color_force_target = color_left_outline
		GVM.INPUT_TYPES.right:
			color_force_target = color_right_outline
	var width_force_target = 0.0
	
	if (input_type == GVM.INPUT_TYPES.left and Input.is_action_pressed("left_click")) or (input_type == GVM.INPUT_TYPES.right and Input.is_action_pressed("right_click")):
		color_force_target.a = color_force.a
		width_force_target = move_force_current / move_force * width_force
	else:
		color_force_target.a = 0
		width_force_target = 0
	
	color_force_current = lerp(color_force_current, color_force_target, .1)
	width_force_current = lerp(width_force_current, width_force_target, .1)
	
	var snip_length = 12
	for i in range(1, clamp(Vector2(0,0).distance_to(get_local_mouse_position()) / snip_length, 4, 8)):
		var line_length = get_local_mouse_position().normalized() * i * snip_length
#		if (input_type == GVM.INPUT_TYPES.left and Input.is_action_pressed("left_click")) or (input_type == GVM.INPUT_TYPES.right and Input.is_action_pressed("right_click")):
		draw_circle(line_length, clamp(width_force_current - i * .75, 2, width_force_current), color_force_current)
#		draw_line(Vector2(0,0), line_length, color_force_current, width_force_current - i, true)
	
	# draw grab handles
	var grab_available = bodies.size() > 0
	var grab_active = bodies_grabbed.size() > 0
	
	match input_type:
		GVM.INPUT_TYPES.left:
			if grab_available:
				if grab_active:
					draw_circle(Vector2(0,0), radius + color_grab_outline_thickness, color_grab_active)
				else:
					draw_circle(Vector2(0,0), radius + color_grab_outline_thickness, color_grab_available)
			
			draw_circle(Vector2(0,0), radius, color_left_outline)
			draw_circle(Vector2(0,0), radius - color_outline_thickness, color_left)
			
		GVM.INPUT_TYPES.right:
			if grab_available:
				if grab_active:
					draw_circle(Vector2(0,0), radius + color_grab_outline_thickness, color_grab_active)
				else:
					draw_circle(Vector2(0,0), radius + color_grab_outline_thickness, color_grab_available)
			
			draw_circle(Vector2(0,0), radius, color_right_outline)
			draw_circle(Vector2(0,0), radius - color_outline_thickness, color_right)

func _get_configuration_warning():
	if 0:
		return "Configuration Warning String"
	else:
		return ""


# helper functions ------------------------------------------------------------------------------------------------------
func get_input():
	# nerf the move_force if both inputs are pressed at once, this is to keep the player from cheesing the game by always pressing both inputs...
	var nerf_mult = 1.0
	if Input.is_action_pressed("left_click") and Input.is_action_pressed("right_click") and not broken:
		nerf_mult = 0.5
	
	# do not process input is the worm_hook is currently hovered, we don't want to let go if we're breaking the worm
	if GVM.worm_hook_hovered:
		return
	
	# set stretch_force, this is the minimum force needed to keep the segments stretched
	var stretch_force = .35
	
	# update move_force_current
	move_force_current = clamp(($Timer.time_left + stretch_force) * move_force * nerf_mult, 0, move_force)
	
	match input_type:
		GVM.INPUT_TYPES.left:
			if Input.is_action_just_pressed("left_click"):
				clear_pins()
				$Timer.start()
			
			if Input.is_action_pressed("left_click"):
				apply_central_impulse(global_position.direction_to(get_global_mouse_position()).normalized() * move_force_current)
				
			elif bodies.size() > 0 and Input.is_action_just_released("left_click"):
				for b in bodies:
					add_body_pin(b)
			
		GVM.INPUT_TYPES.right:
			if Input.is_action_just_pressed("right_click"):
				clear_pins()
				$Timer.start()
			
			if Input.is_action_pressed("right_click"):
				apply_central_impulse(global_position.direction_to(get_global_mouse_position()).normalized() * move_force_current)
			
			elif bodies.size() > 0 and Input.is_action_just_released("right_click"):
				for b in bodies:
					add_body_pin(b)


func update_radius():
	self.radius = get_parent().get_parent().radius


func clear_pins():
	for child in $PinJoints.get_children():
		child.queue_free()
	
	# this will tell a switch that it is no longer being grabbed
	for body in bodies_grabbed:
		if "grabbed" in body:
			body.grabbed = false
		
		if not body in bodies:
			bodies.append(body)
	
#	bodies.clear()
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
	
	# this will tell a switch if it is being grabbed
	if "grabbed" in body:
		body.grabbed = true


#func add_tilemap_pin():
#	# add a static body to attach to
#	var static_instance = StaticBody2D.new()
#	var static_shape_instance = CollisionShape2D.new()
#	static_shape_instance.shape = CircleShape2D.new()
#	static_shape_instance.shape.radius = 16.0
#	static_instance.add_child(static_shape_instance)
#	$PinJoints.add_child(static_instance)
#
#	# add a pin
#	var pin_instance = PinJoint2D.new()
#	$PinJoints.add_child(pin_instance)
#	pin_instance.node_a = pin_instance.get_path_to(self)
#	pin_instance.node_b = pin_instance.get_path_to(static_instance)


# set/get functions ------------------------------------------------------------------------------------------------------
func set_invert_depth(new_val):
	invert_depth = new_val
	
	if get_parent() and get_parent().get_parent():
		if invert_depth:
			z_index = get_parent().get_parent().z_index - 1
		else:
			z_index = get_parent().get_parent().z_index + 1


func set_radius(new_val):
	radius = new_val
	
	if has_node("CollisionShape2D"):
		$CollisionShape2D.shape.radius = radius
	
	if has_node("Area2D"):
		$Area2D/CollisionShape2D.shape.radius = radius + 6


# signal functions ------------------------------------------------------------------------------------------------------
func _on_break_worm():
	self.invert_depth = false
	move_force = move_force / 1.5
	broken = true


func _on_evaporate_worm():
	$EvaporateWormASP.play()


func _on_Area2D_body_entered(body):
#	print("body in bodies: " + str(body in bodies) + "    body in group: " + str(body.is_in_group("grabbable")) + "    body name: " + str(body.name))
	if not body in bodies and body.is_in_group("grabbable"):
		bodies.append(body)


func _on_Area2D_body_exited(body):
	if body in bodies:
		bodies.remove(bodies.find(body))


func _on_Timer_timeout():
	if has_node("Timer"):
		$Timer.stop()


func _on_EvaporateWormASP_finished():
	queue_free()

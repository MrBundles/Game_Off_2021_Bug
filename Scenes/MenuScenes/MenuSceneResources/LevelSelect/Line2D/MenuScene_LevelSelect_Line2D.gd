extends Line2D

# enums -----------------------------------------------------------------------------------------------------------
enum POINT_STATES {null, hovered, pressed}

# references -----------------------------------------------------------------------------------------------------------


# signals --------------------------------------------------------------------------------------------------------------


# variables ------------------------------------------------------------------------------------------------------------
export(PackedScene) var point_handle = null

# point data variables
var point_state_array = []					# each point will be assigned a value given its hovered or pressed state

# line appearance variables
export var point_spread = 64.0

export var line_width_normal = 8.0
export var line_width_hovered = 16.0
export var line_width_pressed = 24.0
export var line_width_locked = 16.0

export var line_color_normal = Color(1,1,1,1)
export var line_color_hovered = Color(1,1,1,1)
export var line_color_pressed = Color(1,1,1,1)

export var line_color_locked = Color(1,1,1,1)
export var line_color_unloacked = Color(1,1,1,1)


# main functions -------------------------------------------------------------------------------------------------------
func _ready():
	# connect signals
	GSM.connect("point_handle_hovered", self, "_on_point_handle_hovered")
	GSM.connect("point_handle_pressed", self, "_on_point_handle_pressed")
	
	# initialize setgets
	
	# initialize variables
	generate_points()
	generate_curve()
	generate_gradient()
	generate_point_handles()
#	print_curve_info()
#	print_gradient_info()


func _process(delta):
	update_curve()
	update_gradient()


func _get_configuration_warning():
	if 0:
		return "Configuration Warning String"
	else:
		return ""


# helper functions ------------------------------------------------------------------------------------------------------
func print_curve_info():
	var c : Curve = width_curve
	for i in range(c.get_point_count()):
		print("id: " + str(i) + "   left mode: " + str(c.get_point_left_mode(i)) + "   right_mode: " + str(c.get_point_right_mode(i)) + "   left_tan: " + str(c.get_point_left_tangent(i)) + "   right_tan: " + str(c.get_point_right_tangent(i)) + "   pos: " + str(c.get_point_position(i)))


func print_gradient_info():
	var g : Gradient = gradient
	for i in range(g.get_point_count()):
		print("id: " + str(i) + "   offset: " + str(g.get_offset(i)) + "   color: " + str(g.get_color(i)))


func generate_points():
	# clear all current points
	clear_points()
	
	# generate new points based on given params
	for i in range(GVM.game_scene_qty - 1):
		add_point(Vector2(i * point_spread, sin(i) * 48.0))
		point_state_array.append(POINT_STATES.null)


func generate_curve():
	var curve_instance = Curve.new()
	
	for i in range(get_point_count()):
		curve_instance.add_point(Vector2(i * 1.0 / (get_point_count() - 1), line_width_normal), 5.0, 5.0, Curve.TANGENT_FREE, Curve.TANGENT_FREE)
	
	width_curve = curve_instance


func update_curve():
	for i in range(get_point_count()):
		var line_width_target = 0.0
		var line_width_current = width_curve.get_point_position(i).y
		
		match point_state_array[i]:
			POINT_STATES.null:
				line_width_target = line_width_normal
			POINT_STATES.hovered:
				if i > GVM.highest_unlocked_game_scene_id:
					line_width_target = line_width_locked
				else:
					line_width_target = line_width_hovered
			POINT_STATES.pressed:
				if i > GVM.highest_unlocked_game_scene_id:
					line_width_target = line_width_locked
				else:
					line_width_target = line_width_pressed
		
		width_curve.set_point_value(i, lerp(line_width_current, line_width_target, 0.1))


func generate_gradient():
	var gradient_instance = Gradient.new()
	
	# add points to gradient for each point on the line
	for i in range(1, get_point_count() - 1):
		gradient_instance.add_point(i * 1.0 / (get_point_count() - 1), line_color_locked)
	
	# ensure that each point on the line is the proper color
	for i in range(gradient.get_point_count()):
		gradient_instance.set_color(i, line_color_locked)
	
	gradient = gradient_instance


func update_gradient():
	for i in range(get_point_count()):
		var line_color_target = Color(1,1,1,1)
		var line_color_current = gradient.get_color(i)
		
		if i > GVM.highest_unlocked_game_scene_id:
			line_color_target = line_color_locked
		else:
			line_color_target = line_color_unloacked
		
		
		var line_color = Color(1,1,1,1)
		line_color.r = lerp(line_color_current.r, line_color_target.r, 0.1)
		line_color.g = lerp(line_color_current.g, line_color_target.g, 0.1)
		line_color.b = lerp(line_color_current.b, line_color_target.b, 0.1)
		line_color.a = lerp(line_color_current.a, line_color_target.a, 0.1)
		gradient.set_color(i, line_color)


func generate_point_handles():
	if not point_handle:
		return
	
	if has_node("PointHandles"):
		for i in range(get_point_count()):
			var point_handle_instance = point_handle.instance()
			point_handle_instance.global_position = get_point_position(i)
			point_handle_instance.handle_size = point_spread
			point_handle_instance.point_handle_id = i
			$PointHandles.add_child(point_handle_instance)


# set/get functions ------------------------------------------------------------------------------------------------------



# signal functions -------------------------------------------------------------------------------------------------------
func _on_point_handle_hovered(point_handle_id, point_handle_hovered):
	if point_handle_hovered:
		if point_state_array[point_handle_id] == POINT_STATES.null:
			point_state_array[point_handle_id] = POINT_STATES.hovered
	else:
		point_state_array[point_handle_id] = POINT_STATES.null


func _on_point_handle_pressed(point_handle_id, point_handle_pressed):
	if point_handle_pressed:
		point_state_array[point_handle_id] = POINT_STATES.pressed
	else:
		if point_state_array[point_handle_id] == POINT_STATES.pressed:
			point_state_array[point_handle_id] = POINT_STATES.hovered

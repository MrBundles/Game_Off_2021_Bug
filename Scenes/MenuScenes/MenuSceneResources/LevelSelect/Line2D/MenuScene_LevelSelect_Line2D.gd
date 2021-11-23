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

export var line_color_normal = Color(1,1,1,1)
export var line_color_hovered = Color(1,1,1,1)
export var line_color_pressed = Color(1,1,1,1)


# main functions -------------------------------------------------------------------------------------------------------
func _ready():
	# connect signals
	GSM.connect("point_handle_hovered", self, "_on_point_handle_hovered")
	GSM.connect("point_handle_pressed", self, "_on_point_handle_pressed")
	
	# initialize setgets
	
	# initialize variables
#	print_curve_info()
	generate_points()
	generate_curve()
	generate_point_handles()


func _process(delta):
	pass


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


func generate_points():
	# clear all current points
	clear_points()
	
	# generate new points based on given params
	for i in range(GVM.game_scene_qty):
		add_point(Vector2(i * point_spread, 0))
		point_state_array.append(POINT_STATES.null)


func generate_curve():
	var curve_instance = Curve.new()
	
	for i in range(get_point_count()):
		curve_instance.add_point(Vector2(i * 1.0 / (get_point_count() - 1), line_width_normal), 0, 0, Curve.TANGENT_LINEAR, Curve.TANGENT_LINEAR)
	
#	print(width_curve.)


func update_curve():
	if not has_node("Tween"):
		return
	
	$Tween.stop_all()
	
	for i in range(get_point_count()):
		match point_state_array[i]:
			POINT_STATES.null:
#				$Tween.interpolate_method()
				width_curve.set_point_value(i, line_width_normal)
			POINT_STATES.hovered:
				width_curve.set_point_value(i, line_width_hovered)
			POINT_STATES.pressed:
				width_curve.set_point_value(i, line_width_pressed)


func update_curve_point():
	pass


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
	
	update_curve()


func _on_point_handle_pressed(point_handle_id, point_handle_pressed):
	if point_handle_pressed:
		point_state_array[point_handle_id] = POINT_STATES.pressed
	else:
		if point_state_array[point_handle_id] == POINT_STATES.pressed:
			point_state_array[point_handle_id] = POINT_STATES.hovered
	
	update_curve()


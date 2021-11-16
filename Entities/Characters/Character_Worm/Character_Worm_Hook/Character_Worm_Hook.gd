extends PinJoint2D

# references -----------------------------------------------------------------------------------------------------------


# signals --------------------------------------------------------------------------------------------------------------


# variables ------------------------------------------------------------------------------------------------------------
var hovered = false
export var breakable = false

# draw variables
export var radius = 16.0
export var color_normal = Color(1,1,1,1)
export var color_hovered = Color(1,1,1,1)


# main functions -------------------------------------------------------------------------------------------------------
func _ready():
	# connect signals
	
	# initialize setgets
	
	# initialize variables
	pass


func _process(delta):
	get_input()
	update()


func _draw():
	if hovered and breakable:
		draw_circle(Vector2(0,0), radius, color_hovered)
	else:
		draw_circle(Vector2(0,0), radius, color_normal)


func _get_configuration_warning():
	if 0:
		return "Configuration Warning String"
	else:
		return ""


# helper functions ------------------------------------------------------------------------------------------------------
func get_input():
	if hovered and breakable:
		if Input.is_action_just_pressed("left_click") or Input.is_action_just_pressed("right_click"):
			GSM.emit_signal("break_worm")
			queue_free()


# set/get functions ------------------------------------------------------------------------------------------------------



# signal functions -------------------------------------------------------------------------------------------------------




func _on_Area2D_mouse_entered():
	hovered = true


func _on_Area2D_mouse_exited():
	hovered = false

tool
extends Node2D

# enums
enum TRIGGER_GROUPS {null, worm, left, right, rigid}
enum ICON_IDS {win, panel_up, panel_down, panel_left, panel_right, gravity_up, gravity_down, gravity_left, gravity_right}


# references -----------------------------------------------------------------------------------------------------------


# signals --------------------------------------------------------------------------------------------------------------


# variables ------------------------------------------------------------------------------------------------------------
export var pressed = false setget set_pressed
export var oneshot = false
var oneshot_flag = false
export(TRIGGER_GROUPS) var trigger_group = TRIGGER_GROUPS.worm setget set_trigger_group
var trigger_group_name = ""
export(ICON_IDS) var icon_id = ICON_IDS.win setget set_icon_id
export(Array, Texture) var icons = []
var bodies_present = []
var button_position_released = Vector2(0, -8)
var button_position_pressed = Vector2(0, 8)

export(Color) var color_worm
export(Color) var color_left
export(Color) var color_right
export(Color) var color_rigid
export(Color) var color_disabled
var color_button = Color(1,1,1,1) setget set_color_button

export(int, 0, 256) var event_id_pressed = 0 setget set_event_id_pressed
export(int, 0, 256) var event_id_released = 0 setget set_event_id_released
export(GVM.EVENT_TRIGGER_TYPES) var event_trigger_type_pressed = GVM.EVENT_TRIGGER_TYPES.null
export(GVM.EVENT_TRIGGER_TYPES) var event_trigger_type_released = GVM.EVENT_TRIGGER_TYPES.null
export(float, 0.0, 256.0) var event_delay_time_pressed = 0.0
export(float, 0.0, 256.0) var event_delay_time_released = 0.0


# main functions -------------------------------------------------------------------------------------------------------
func _ready():
	# connect signals
	
	# initialize setgets
	self.trigger_group = trigger_group
	self.icon_id = icon_id
	self.event_id_pressed = event_id_pressed
	self.event_id_released = event_id_released
	
	# initialize variables
	pass


func _process(delta):
	pass


func _get_configuration_warning():
	if 0:
		return "Configuration Warning String"
	else:
		return ""


# helper functions ------------------------------------------------------------------------------------------------------



# set/get functions ------------------------------------------------------------------------------------------------------
func set_pressed(new_val):
	if pressed == new_val:
		return
	
	pressed = new_val
	
	if has_node("Tween") and has_node("KinematicBody2D"):
		$Tween.stop_all()
		
		# tween variables
		var tween_duration_time = 0.25
		var tween_delay_time = 0.0
		
		if pressed:
			$Tween.interpolate_property($KinematicBody2D, "position", $KinematicBody2D.position, button_position_pressed, tween_duration_time, Tween.TRANS_QUAD, Tween.EASE_IN, tween_delay_time)
		else:
			$Tween.interpolate_property($KinematicBody2D, "position", $KinematicBody2D.position, button_position_released, tween_duration_time, Tween.TRANS_QUAD, Tween.EASE_IN, tween_delay_time)
		
		$Tween.start()


func set_trigger_group(new_val):
	trigger_group = new_val
	
	match trigger_group:
		TRIGGER_GROUPS.worm:
			trigger_group_name = "worm"
			self.color_button = color_worm
		TRIGGER_GROUPS.left:
			trigger_group_name = "left"
			self.color_button = color_left
		TRIGGER_GROUPS.right:
			trigger_group_name = "right"
			self.color_button = color_right
		TRIGGER_GROUPS.rigid:
			trigger_group_name = "rigid"
			self.color_button = color_rigid
	
	bodies_present.clear()


func set_color_button(new_val):
	color_button = new_val
	
	if has_node("KinematicBody2D/Sprite"):
		$KinematicBody2D/Sprite.modulate = color_button


func set_icon_id(new_val):
	icon_id = new_val
	
	if has_node("Sprite"):
		$Sprite.texture = icons[icon_id]


func set_event_id_pressed(new_val):
	event_id_pressed = new_val
	
	if has_node("VBoxContainer/pressed_label"):
		if Engine.editor_hint:
			$VBoxContainer/pressed_label.text = "event_id_pressed: " + str(event_id_pressed)
		else:
			$VBoxContainer/pressed_label.text = ""


func set_event_id_released(new_val):
	event_id_released = new_val
	
	if has_node("VBoxContainer/released_label"):
		if Engine.editor_hint:
			$VBoxContainer/released_label.text = "event_id_released: " + str(event_id_released)
		else:
			$VBoxContainer/released_label.text = ""


# signal functions -------------------------------------------------------------------------------------------------------
func _on_Area2D_body_entered(body):
	if body.is_in_group(trigger_group_name):
		if not body in bodies_present:
			bodies_present.append(body)
		
		if bodies_present.size() > 0:
			self.pressed = true
			oneshot_flag = true


func _on_Area2D_body_exited(body):
	if body.is_in_group(trigger_group_name):
		if body in bodies_present:
			bodies_present.remove(bodies_present.find(body))
		
		if bodies_present.size() < 2 and not (oneshot and oneshot_flag):
			self.pressed = false
			$GameButtonReleaseASP.play()
	
	print(bodies_present)


func _on_Tween_tween_completed(object, key):
	if pressed:
		GEM.event_trigger(event_id_pressed, event_trigger_type_pressed, event_delay_time_pressed)
		$Sprite.modulate = color_button
		$GameButtonPressASP.play()
	else:
		GEM.event_trigger(event_id_released, event_trigger_type_released, event_delay_time_released)
		$Sprite.modulate = color_disabled

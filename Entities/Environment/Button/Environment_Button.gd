tool
extends Node2D

# references -----------------------------------------------------------------------------------------------------------


# signals --------------------------------------------------------------------------------------------------------------


# variables ------------------------------------------------------------------------------------------------------------
export var pressed = false setget set_pressed
var bodies_present = []
var button_position_released = Vector2(0, -8)
var button_position_pressed = Vector2(0, 8)

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
	pressed = new_val
	
	if has_node("Tween") and has_node("KinematicBody2D"):
		$Tween.stop_all()
		
		# tween variables
		var tween_duration_time = 0.5
		var tween_delay_time = 0.0
		
		if pressed:
			$Tween.interpolate_property($KinematicBody2D, "position", $KinematicBody2D.position, button_position_pressed, tween_duration_time, Tween.TRANS_QUAD, Tween.EASE_OUT, tween_delay_time)
		else:
			$Tween.interpolate_property($KinematicBody2D, "position", $KinematicBody2D.position, button_position_released, tween_duration_time, Tween.TRANS_QUAD, Tween.EASE_OUT, tween_delay_time)
		
		$Tween.start()


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
	if body.is_in_group("worm"):
		if not body in bodies_present:
			bodies_present.append(body)
		
		if bodies_present.size() > 0:
			self.pressed = true


func _on_Area2D_body_exited(body):
	if body.is_in_group("worm"):
		if body in bodies_present:
			bodies_present.remove(bodies_present.find(body))
		
		if bodies_present.size() == 0:
			self.pressed = false


func _on_Tween_tween_completed(object, key):
	if pressed:
		GEM.event_trigger(event_id_pressed, event_trigger_type_pressed, event_delay_time_pressed)
	else:
		GEM.event_trigger(event_id_released, event_trigger_type_released, event_delay_time_released)

tool
extends Control

# references -----------------------------------------------------------------------------------------------------------


# signals --------------------------------------------------------------------------------------------------------------


# variables ------------------------------------------------------------------------------------------------------------
export(int, 0, 255) var event_id_worm_enter = 0 setget set_event_id_worm_enter
export(int, 0, 255) var event_id_worm_exit = 0 setget set_event_id_worm_exit
export(GVM.EVENT_TRIGGER_TYPES) var event_trigger_type_worm_enter = GVM.EVENT_TRIGGER_TYPES.on
export(GVM.EVENT_TRIGGER_TYPES) var event_trigger_type_worm_exit = GVM.EVENT_TRIGGER_TYPES.off
export var event_delay_time_worm_enter = 0.0
export var event_delay_time_worm_exit = 0.0
export var one_shot_worm_enter = false
export var one_shot_worm_exit = false
var one_shot_flag = false


# main functions -------------------------------------------------------------------------------------------------------
func _ready():
	# connect signals
	
	# initialize setgets
	self.event_id_worm_enter = event_id_worm_enter
	self.event_id_worm_exit = event_id_worm_exit
	
	# initialize variables
	_on_EventTriggerArea_item_rect_changed()


func _process(delta):
	pass


func _get_configuration_warning():
	if 0:
		return "Configuration Warning String"
	else:
		return ""


# helper functions ------------------------------------------------------------------------------------------------------



# set/get functions ------------------------------------------------------------------------------------------------------
func set_event_id_worm_enter(new_val):
	event_id_worm_enter = new_val
	
	if has_node("VBoxContainer/enter_label") and Engine.editor_hint:
		$VBoxContainer/enter_label.text = "event_id_worm_enter: " + str(event_id_worm_enter)
	else:
		$VBoxContainer/enter_label.text = ""


func set_event_id_worm_exit(new_val):
	event_id_worm_exit = new_val
	
	if has_node("VBoxContainer/exit_label") and Engine.editor_hint:
		$VBoxContainer/exit_label.text = "event_id_worm_exit: " + str(event_id_worm_exit)
	else:
		$VBoxContainer/exit_label.text = ""


# signal functions -------------------------------------------------------------------------------------------------------
func _on_EventTriggerArea_item_rect_changed():
	if has_node("Area2D"):
		$Area2D.position = rect_size / Vector2(2,2)
		$Area2D/CollisionShape2D.shape.extents = rect_size / Vector2(2,2)


func _on_Area2D_body_entered(body):
	if body.is_in_group("worm"):
		if one_shot_worm_enter and one_shot_flag:
			return
		
		GEM.event_trigger(event_id_worm_enter, event_trigger_type_worm_enter, event_delay_time_worm_enter)
		one_shot_flag = true


func _on_Area2D_body_exited(body):
	if body.is_in_group("worm"):
		if one_shot_worm_exit and one_shot_flag:
			return
		
		GEM.event_trigger(event_id_worm_exit, event_trigger_type_worm_exit, event_delay_time_worm_exit)
		one_shot_flag = true


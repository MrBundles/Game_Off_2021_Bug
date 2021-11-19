tool
extends Node2D

# references -----------------------------------------------------------------------------------------------------------


# signals --------------------------------------------------------------------------------------------------------------


# variables ------------------------------------------------------------------------------------------------------------
# event variables
export(int, 0, 256) var event_id = 0
export(GVM.EVENT_TRIGGER_TYPES) var event_trigger_type_grabbed = GVM.EVENT_TRIGGER_TYPES.null
export(GVM.EVENT_TRIGGER_TYPES) var event_trigger_type_rest = GVM.EVENT_TRIGGER_TYPES.null
export(float, 0.0, 256.0) var event_delay_time_grabbed = 0.0
export(float, 0.0, 256.0) var event_delay_time_rest = 0.0

# panel appearance variables
export var color = Color(1,1,1,1) setget set_color

# switch behavior variables
export var grabbed_offset = Vector2(0,0) setget set_grabbed_offset
export var grabbed = false setget set_grabbed


# main functions -------------------------------------------------------------------------------------------------------
func _ready():
	# connect signals
	
	# initialize setgets
	self.color = color
	self.grabbed = grabbed


func _process(delta):
	pass


func _get_configuration_warning():
	if 0:
		return "Configuration Warning String"
	else:
		return ""


# helper functions ------------------------------------------------------------------------------------------------------



# set/get functions ------------------------------------------------------------------------------------------------------
func set_grabbed_offset(new_val):
	grabbed_offset = new_val
	
	if has_node("Switch_Body"):
		$Switch_Body.position = grabbed_offset


func set_grabbed(new_val):
	grabbed = new_val
	
	if has_node("Tween") and has_node("Switch_Body"):
		$Tween.stop_all()
		
		if grabbed:
			$Tween.interpolate_property($Switch_Body, "position", $Switch_Body.position, grabbed_offset, .25, Tween.TRANS_QUAD, Tween.EASE_IN)
		else:
			$Tween.interpolate_property($Switch_Body, "position", $Switch_Body.position, Vector2(0,0), .5, Tween.TRANS_QUINT, Tween.EASE_OUT)
			
		$Tween.start()


func set_color(new_val):
	color = new_val
	
	modulate = color


# signal functions -------------------------------------------------------------------------------------------------------
func _on_Tween_tween_all_completed():
	match $Switch_Body.position:
		Vector2(0,0):
			GEM.event_trigger(event_id, event_trigger_type_rest, event_delay_time_grabbed)
		
		grabbed_offset:
			GEM.event_trigger(event_id, event_trigger_type_grabbed, event_delay_time_rest)

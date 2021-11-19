tool
extends Grabbable

# references -----------------------------------------------------------------------------------------------------------


# signals --------------------------------------------------------------------------------------------------------------


# variables ------------------------------------------------------------------------------------------------------------
export var switch_offset_rest = Vector2(0,0) setget set_switch_offset_rest
export var switch_offset_grabbed = Vector2(0,0) setget set_switch_offset_grabbed
var switch_offset_current = Vector2(0,0) setget set_switch_offset_current

var global_position_init = Vector2(0,0)

# event variables
export(int, 0, 256) var event_id = 0
export(GVM.EVENT_TRIGGER_TYPES) var event_trigger_type_grabbed = GVM.EVENT_TRIGGER_TYPES.null
export(GVM.EVENT_TRIGGER_TYPES) var event_trigger_type_rest = GVM.EVENT_TRIGGER_TYPES.null
export(float, 0.0, 256.0) var event_delay_time_grabbed = 0.0
export(float, 0.0, 256.0) var event_delay_time_rest = 0.0


# main functions -------------------------------------------------------------------------------------------------------
func _ready():
	# connect signals
	
	# initialize variables
	if not Engine.editor_hint:
		global_position_init = global_position
	
	# initialize setgets
	if not Engine.editor_hint:
		self.switch_offset_current = switch_offset_rest


func _process(delta):
	pass



func _get_configuration_warning():
	if 0:
		return "Configuration Warning String"
	else:
		return ""


# helper functions ------------------------------------------------------------------------------------------------------



# set/get functions ------------------------------------------------------------------------------------------------------
func set_switch_offset_rest(new_val):
	switch_offset_rest = new_val
	
	self.switch_offset_current = switch_offset_rest


func set_switch_offset_grabbed(new_val):
	switch_offset_grabbed = new_val
	
	self.switch_offset_current = switch_offset_grabbed


func set_switch_offset_current(new_val):
	switch_offset_current = new_val
	
	global_position = global_position_init + switch_offset_current.rotated(deg2rad(tile_rotation_degrees))


func set_grabbed(new_val):
	grabbed = new_val
	
	if has_node("Tween"):
		$Tween.stop_all()
		
		if grabbed:
			$Tween.interpolate_property(self, "switch_offset_current", switch_offset_current, switch_offset_grabbed, .25, Tween.TRANS_QUAD, Tween.EASE_IN)
		else:
			$Tween.interpolate_property(self, "switch_offset_current", switch_offset_current, switch_offset_rest, .5, Tween.TRANS_QUINT, Tween.EASE_OUT)
		
		$Tween.start()


# signal functions -------------------------------------------------------------------------------------------------------
func _on_Tween_tween_all_completed():
	match switch_offset_current:
		switch_offset_rest:
			GEM.event_trigger(event_id, event_trigger_type_rest, event_delay_time_grabbed)
		
		switch_offset_grabbed:
			GEM.event_trigger(event_id, event_trigger_type_grabbed, event_delay_time_rest)

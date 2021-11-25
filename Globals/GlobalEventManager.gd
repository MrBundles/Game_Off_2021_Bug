extends Node

# references -----------------------------------------------------------------------------------------------------------


# signals --------------------------------------------------------------------------------------------------------------


# variables ------------------------------------------------------------------------------------------------------------
export(PackedScene) var event_timer_scene


# main functions -------------------------------------------------------------------------------------------------------
func _ready():
	# connect signals
	GSM.connect("event_trigger", self, "_on_event_trigger")
	GSM.connect("change_game_scene", self, "_on_change_game_scene")
	GSM.connect("reload_game_scene", self, "_on_reload_game_scene")
	
	# initialize setgets
	
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
func event_trigger(event_id, event_trigger_type, event_delay_time):
#	print("event id: " + str(event_id) + "    event_trigger_type: " + str(event_trigger_type) + "    event_delay_time: " + str(event_delay_time))
	
	# remove any event timers currently dedicated to the current event_id
	remove_duplicate_event_timers(event_id)
	
	match event_trigger_type:
		GVM.EVENT_TRIGGER_TYPES.on:
			GSM.emit_signal("event_trigger", event_id, true)
		
		GVM.EVENT_TRIGGER_TYPES.off:
			GSM.emit_signal("event_trigger", event_id, false)
		
		GVM.EVENT_TRIGGER_TYPES.delay_on:
			create_event_timer(event_id, true, event_delay_time)
		
		GVM.EVENT_TRIGGER_TYPES.delay_off:
			create_event_timer(event_id, false, event_delay_time)
		
		GVM.EVENT_TRIGGER_TYPES.on_delay_off:
			GSM.emit_signal("event_trigger", event_id, true)
			create_event_timer(event_id, false, event_delay_time)
		
		GVM.EVENT_TRIGGER_TYPES.off_delay_on:
			GSM.emit_signal("event_trigger", event_id, false)
			create_event_timer(event_id, true, event_delay_time)


func create_event_timer(event_id, event_value, event_delay_time):
	var event_timer_instance : Timer = event_timer_scene.instance()
	event_timer_instance.event_id = event_id
	event_timer_instance.event_value = event_value
	event_timer_instance.wait_time = event_delay_time
	
	$EventTimers.add_child(event_timer_instance)


func remove_duplicate_event_timers(event_id_to_remove):
	for timer in $EventTimers.get_children():
		if timer.event_id == event_id_to_remove:
			timer.queue_free()


func clear_all_event_timers():
	for timer in $EventTimers.get_children():
		timer.queue_free()


# set/get functions ------------------------------------------------------------------------------------------------------



# signal functions -------------------------------------------------------------------------------------------------------
func _on_event_trigger(event_id, event_value):
	print("event_id: " + str(event_id) + "    event_value: " + str(event_value))


func _on_change_game_scene(new_game_scene_id):
	clear_all_event_timers()


func _on_reload_game_scene():
	clear_all_event_timers()

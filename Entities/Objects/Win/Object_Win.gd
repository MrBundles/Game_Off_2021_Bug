tool
extends Node2D

# references -----------------------------------------------------------------------------------------------------------


# signals --------------------------------------------------------------------------------------------------------------


# variables ------------------------------------------------------------------------------------------------------------
export var event_id = 0 setget set_event_id


# main functions -------------------------------------------------------------------------------------------------------
func _ready():
	# connect signals
	GSM.connect("event_trigger", self, "_on_event_trigger")
	
	# initialize setgets
	self.event_id = event_id
	
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
func set_event_id(new_val):
	event_id = new_val
	
	if has_node("Label"):
		if Engine.editor_hint:
			$Label.text = "event_id: " + str(event_id)
		else:
			$Label.text = ""


# signal functions -------------------------------------------------------------------------------------------------------
func _on_event_trigger(_event_id, event_value):
	if _event_id == event_id and event_value:
		GSM.emit_signal("evaporate_worm")
		
		if has_node("Timer"):
			$Timer.start()


func _on_Timer_timeout():
	GSM.emit_signal("level_completed")

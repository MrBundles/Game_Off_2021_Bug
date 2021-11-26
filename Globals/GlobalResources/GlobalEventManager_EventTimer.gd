extends Timer

# references -----------------------------------------------------------------------------------------------------------


# signals --------------------------------------------------------------------------------------------------------------


# variables ------------------------------------------------------------------------------------------------------------
export var event_id = 0
export var event_value = true


# main functions -------------------------------------------------------------------------------------------------------
func _ready():
	# connect signals
	
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



# set/get functions ------------------------------------------------------------------------------------------------------



# signal functions -------------------------------------------------------------------------------------------------------
func _on_EventTimer_timeout():
	GSM.emit_signal("event_trigger", event_id, event_value)
	queue_free()

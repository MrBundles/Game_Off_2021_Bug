extends Node

# references -----------------------------------------------------------------------------------------------------------


# signals --------------------------------------------------------------------------------------------------------------


# variables ------------------------------------------------------------------------------------------------------------



# main functions -------------------------------------------------------------------------------------------------------
func _ready():
	# connect signals
	GSM.connect("set_bus_mute", self, "_on_set_bus_mute")
	GSM.connect("set_bus_volume", self, "_on_set_bus_volume")
	
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
func _on_set_bus_mute(bus_id, bus_mute):
	if bus_mute != AudioServer.is_bus_mute(bus_id):
		AudioServer.set_bus_mute(bus_id, bus_mute)


func _on_set_bus_volume(bus_id, bus_volume):
	if bus_volume != AudioServer.get_bus_volume_db(bus_id):
		AudioServer.set_bus_volume_db(bus_id, bus_volume)


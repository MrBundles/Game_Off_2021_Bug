tool
extends Button_Base

# references -----------------------------------------------------------------------------------------------------------


# signals --------------------------------------------------------------------------------------------------------------


# variables ------------------------------------------------------------------------------------------------------------
export(GVM.AUDIO_BUS_IDS) var bus_id = GVM.AUDIO_BUS_IDS.music
export(Texture) var texture_muted
export(Texture) var texture_unmuted
export var muted = false setget set_muted


# main functions -------------------------------------------------------------------------------------------------------
func _ready():
	# connect signals
	
	# initialize setgets
	self.muted = AudioServer.is_bus_mute(bus_id)
	
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
func set_muted(new_val):
	muted = new_val
	
	# set button texture based on mute status
	if muted:
		icon = texture_muted
	else:
		icon = texture_unmuted
	
	GSM.emit_signal("set_bus_mute", bus_id, muted)


# signal functions -------------------------------------------------------------------------------------------------------
func _on_Button_Mute_pressed():
	self.muted = !muted

tool
extends HBoxContainer

# references -----------------------------------------------------------------------------------------------------------


# signals --------------------------------------------------------------------------------------------------------------


# variables ------------------------------------------------------------------------------------------------------------
export(GVM.AUDIO_BUS_IDS) var bus_id = GVM.AUDIO_BUS_IDS.music setget set_bus_id
export var slider_text = "" setget set_slider_text
var volume = 0 setget set_volume

# main functions -------------------------------------------------------------------------------------------------------
func _ready():
	# connect signals
	
	# initialize setgets
	self.bus_id = bus_id
	self.slider_text = slider_text
	self.volume = AudioServer.get_bus_volume_db(bus_id)
	
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
func set_bus_id(new_val):
	bus_id = new_val
	
	if has_node("Button_Mute"):
		$Button_Mute.bus_id = bus_id


func set_slider_text(new_val):
	slider_text = new_val
	
	if has_node("Label"):
		$Label.text = slider_text


func set_volume(new_val):
	volume = new_val
	
	if has_node("HSlider"):
		$HSlider.value = volume


# signal functions -------------------------------------------------------------------------------------------------------
func _on_HSlider_value_changed(value):
	GSM.emit_signal("set_bus_volume", bus_id, value)

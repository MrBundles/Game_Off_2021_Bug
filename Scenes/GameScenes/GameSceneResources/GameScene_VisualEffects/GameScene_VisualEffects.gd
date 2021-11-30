extends Node2D

# references -----------------------------------------------------------------------------------------------------------


# signals --------------------------------------------------------------------------------------------------------------


# variables ------------------------------------------------------------------------------------------------------------
export var event_id_confetti = 0
export(Color) var color_confetti setget set_color_confetti


# main functions -------------------------------------------------------------------------------------------------------
func _ready():
	# connect signals
	GSM.connect("event_trigger", self, "_on_event_trigger")
	
	# initialize setgets
	self.color_confetti = color_confetti
	
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
func set_color_confetti(new_val):
	color_confetti = new_val
	
	if has_node("ConfettiParticles"):
		$ConfettiParticles.color = color_confetti


# signal functions -------------------------------------------------------------------------------------------------------
func _on_event_trigger(event_id, event_value):
	match event_id:
		event_id_confetti:
			if has_node("ConfettiParticles"):
				$ConfettiParticles.emitting = true


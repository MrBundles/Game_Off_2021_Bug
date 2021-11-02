tool
extends Node

# references ------------------------------------------------------------------


# signals ---------------------------------------------------------------------


# variables -------------------------------------------------------------------



# main functions --------------------------------------------------------------
func _ready():
	# connect signals
	GSM.connect("change_theme", self, "_on_change_theme")
	
	# initialize theme
	_on_change_theme(GVM.current_theme_id)


func _process(delta):
	pass


func _get_configuration_warning():
	if not get_parent() is Control:
		return "Feature can only be added to a Control Node"
	else:
		return ""


# helper functions ------------------------------------------------------------



# set/get functions -----------------------------------------------------------



# signal functions ------------------------------------------------------------
func _on_change_theme(new_theme_id):
	if get_parent() is Control:
		get_parent().set_theme(GVM.theme_array[new_theme_id])
	else:
		push_warning("warning: feature theme setter can only be added to control nodes.")


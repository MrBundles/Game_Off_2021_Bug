tool
extends Node

# references ------------------------------------------------------------------


# signals ---------------------------------------------------------------------


# variables -------------------------------------------------------------------
export var font_size = 32 setget set_font_size


# main functions --------------------------------------------------------------
func _ready():
	# connect signals
	GSM.connect("change_theme", self, "_on_change_theme")
	
	
	# initialize variables
	self.font_size = font_size


func _process(delta):
	pass


func _get_configuration_warning():
	if get_parent() and not get_parent() is Control:
		return "Feature can only be added to a Control Node"
	else:
		return ""


# helper functions ------------------------------------------------------------



# set/get functions -----------------------------------------------------------
func set_font_size(new_val):
	font_size = new_val
	
	if get_parent() is Control:
		var new_font = DynamicFont.new()
		new_font = GVM.theme_array[GVM.current_theme_id].get_default_font().duplicate()
		new_font.size = font_size
		get_parent().add_font_override("font", new_font)
	else:
		pass
		# push_warning("warning: can only add feature font size overrider to control node")
	


# signal functions ------------------------------------------------------------
func _on_change_theme(new_theme_id):
	self.font_size = font_size


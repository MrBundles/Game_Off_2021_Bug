tool
extends Node2D

# references -----------------------------------------------------------------------------------------------------------


# signals --------------------------------------------------------------------------------------------------------------


# variables ------------------------------------------------------------------------------------------------------------
export(int, 0, 255) var event_id = 0 setget set_event_id
export(GVM.EVENT_MODULATOR_TYPES) var event_modulator_type = GVM.EVENT_MODULATOR_TYPES.true_show__false_hide
var modulate_current = Color(1,1,1,1) setget set_modulate_current
export var value = false setget set_value

# tween variables
var tween_duration = 0.0
var tween_delay = 0.0


# main functions -------------------------------------------------------------------------------------------------------
func _ready():
	# connect signals
	GSM.connect("event_trigger", self, "_on_event_trigger")
	
	# initialize setgets
	self.event_id = event_id
	self.value = value
	tween_duration = 1.0		# we initialize the tween_duration to 0.0s so that the initial transition is immediate
	
	# initialize variables
	pass


func _process(delta):
	pass


func _get_configuration_warning():
	if 0:
		return "Feature can only be added to a Control Node"
	else:
		return ""


# helper functions ------------------------------------------------------------------------------------------------------



# set/get functions ------------------------------------------------------------------------------------------------------
func set_event_id(new_val):
	event_id = new_val
	
	if has_node("Label") and Engine.editor_hint and get_parent():
		$Label.text = "event_id: " + str(event_id)
	else:
		$Label.text = ""


func set_modulate_current(new_val):
	modulate_current = new_val
	
	if get_parent() and "modulate" in get_parent() and not Engine.editor_hint:
		get_parent().modulate = modulate_current


func set_value(new_val):
	value = new_val
	
	if has_node("Tween"):
		$Tween.stop_all()
		
		match event_modulator_type:
			GVM.EVENT_MODULATOR_TYPES.true_show__false_hide:
				$Tween.interpolate_property(self, "modulate_current", modulate_current, Color(1,1,1,int(value)), tween_duration, Tween.TRANS_QUAD, Tween.EASE_IN_OUT, tween_delay)
			GVM.EVENT_MODULATOR_TYPES.true_hide__false_show:
				$Tween.interpolate_property(self, "modulate_current", modulate_current, Color(1,1,1,int(!value)), tween_duration, Tween.TRANS_QUAD, Tween.EASE_IN_OUT, tween_delay)
		
		$Tween.start()


# signal functions -------------------------------------------------------------------------------------------------------
func _on_event_trigger(_event_id, event_value):
	if _event_id == event_id:
		self.value = event_value


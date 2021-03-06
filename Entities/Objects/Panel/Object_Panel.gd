tool
extends Node2D

# references -----------------------------------------------------------------------------------------------------------


# signals --------------------------------------------------------------------------------------------------------------


# variables ------------------------------------------------------------------------------------------------------------
# event variables
export(int, 0, 256) var event_id = 0 setget set_event_id
export(GVM.EVENT_PANEL_TYPES) var event_panel_type = GVM.EVENT_PANEL_TYPES.true_open__false_close
export var triggered = false setget set_triggered

# panel appearance variables
export(int, 1, 18) var length = 2 setget set_length
export var color = Color(1,1,1,1) setget set_color

# panel behavior variables
export var triggered_offset = Vector2(0,0) setget set_triggered_offset


# main functions -------------------------------------------------------------------------------------------------------
func _ready():
	# connect signals
	GSM.connect("event_trigger", self, "_on_event_trigger")
	
	# initialize setgets
	self.event_id = event_id
	self.triggered = triggered
	self.color = color


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


func set_triggered_offset(new_val):
	triggered_offset = new_val
	
	if has_node("Panel_Body"):
		$Panel_Body.position = triggered_offset


func set_triggered(new_val):
	var no_audio_flag = false
	
	if triggered == new_val:
		no_audio_flag = true
	
	triggered = new_val
	
	# tween variables
	var tween_duration_time = .65
	var tween_delay_time = 0.0
	
	if has_node("Tween") and has_node("Panel_Body"):
		$Tween.stop_all()
		
		match event_panel_type:
			GVM.EVENT_PANEL_TYPES.true_open__false_close:
				if triggered:
					$Tween.interpolate_property($Panel_Body, "position", $Panel_Body.position, triggered_offset, tween_duration_time, Tween.TRANS_QUINT, Tween.EASE_OUT, tween_delay_time)
				else:
					$Tween.interpolate_property($Panel_Body, "position", $Panel_Body.position, Vector2(0,0), tween_duration_time, Tween.TRANS_QUINT, Tween.EASE_OUT, tween_delay_time)
			
			GVM.EVENT_PANEL_TYPES.true_close__false_open:
				if triggered:
					$Tween.interpolate_property($Panel_Body, "position", $Panel_Body.position, Vector2(0,0), tween_duration_time, Tween.TRANS_QUINT, Tween.EASE_OUT, tween_delay_time)
				else:
					$Tween.interpolate_property($Panel_Body, "position", $Panel_Body.position, triggered_offset, tween_duration_time, Tween.TRANS_QUINT, Tween.EASE_OUT, tween_delay_time)
			
		$Tween.start()
	
	# handle audio
	if not Engine.editor_hint and not no_audio_flag:
		if triggered:
			$PanelOpenASP.play()
		else:
			$PanelCloseASP.play()


func set_length(new_val):
	length = new_val
	
	if has_node("Panel_Body/Sprite"):
		$Panel_Body/Sprite.texture.region.size = Vector2(length * 32, 32)
	
	if has_node("Panel_Body/CollisionShape2D"):
		$Panel_Body/CollisionShape2D.shape.extents = Vector2(length * 32 / 2, 15)


func set_color(new_val):
	color = new_val
	
	modulate = color


# signal functions -------------------------------------------------------------------------------------------------------
func _on_event_trigger(_event_id, event_value):
	if _event_id == event_id:
		self.triggered = event_value

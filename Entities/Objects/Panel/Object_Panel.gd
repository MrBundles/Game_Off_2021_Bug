tool
extends Node2D

# references -----------------------------------------------------------------------------------------------------------


# signals --------------------------------------------------------------------------------------------------------------


# variables ------------------------------------------------------------------------------------------------------------
# event variables
export(int, 0, 256) var event_id = 0
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
func set_triggered_offset(new_val):
	triggered_offset = new_val
	
	if has_node("Panel_Body"):
		$Panel_Body.position = triggered_offset


func set_triggered(new_val):
	triggered = new_val
	
	if has_node("Tween") and has_node("Panel_Body"):
		$Tween.stop_all()
		
		if triggered:
			$Tween.interpolate_property($Panel_Body, "position", $Panel_Body.position, triggered_offset, .5, Tween.TRANS_QUINT, Tween.EASE_OUT)
		else:
			$Tween.interpolate_property($Panel_Body, "position", $Panel_Body.position, Vector2(0,0), .5, Tween.TRANS_QUINT, Tween.EASE_OUT)
			
		$Tween.start()


func set_length(new_val):
	length = new_val
	
	if has_node("Panel_Body/Sprite"):
		$Panel_Body/Sprite.texture.region.size = Vector2(length * 32, 32)
	
	if has_node("Panel_Body/CollisionShape2D"):
		$Panel_Body/CollisionShape2D.shape.extents = Vector2(length * 32 / 2, 16)


func set_color(new_val):
	color = new_val
	
	modulate = color


# signal functions -------------------------------------------------------------------------------------------------------
func _on_event_trigger(_event_id, event_value):
	if _event_id != event_id:
		return
	
	self.triggered = event_value

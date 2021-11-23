tool
extends Area2D

# references -----------------------------------------------------------------------------------------------------------


# signals --------------------------------------------------------------------------------------------------------------


# variables ------------------------------------------------------------------------------------------------------------
export(int, 0, 255) var point_handle_id = 0
export var handle_size = 32.0 setget set_handle_size
var hovered = false setget set_hovered
var pressed = false setget set_pressed

# main functions -------------------------------------------------------------------------------------------------------
func _ready():
	# connect signals
	
	# initialize setgets
	self.handle_size = handle_size
	self.hovered = hovered
	self.pressed = pressed
	
	# initialize variables
	pass


func _process(delta):
	get_input()


func _get_configuration_warning():
	if 0:
		return "Configuration Warning String"
	else:
		return ""


# helper functions ------------------------------------------------------------------------------------------------------
func get_input():
	if not Engine.editor_hint:
		self.pressed = Input.is_action_pressed("left_click") and hovered


# set/get functions ------------------------------------------------------------------------------------------------------
func set_handle_size(new_val):
	handle_size = new_val
	
	if has_node("CollisionShape2D"):
		$CollisionShape2D.shape.radius = handle_size / 2


func set_hovered(new_val):
	if hovered == new_val:
		return
	
	hovered = new_val
	
	GSM.emit_signal("point_handle_hovered", point_handle_id, hovered)


func set_pressed(new_val):
	if pressed == new_val:
		return
	
	pressed = new_val
	
	GSM.emit_signal("point_handle_pressed", point_handle_id, pressed)


# signal functions -------------------------------------------------------------------------------------------------------
func _on_PointHandle_mouse_entered():
	self.hovered = true


func _on_PointHandle_mouse_exited():
	self.hovered = false

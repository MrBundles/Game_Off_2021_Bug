tool
extends Area2D

# references -----------------------------------------------------------------------------------------------------------


# signals --------------------------------------------------------------------------------------------------------------


# variables ------------------------------------------------------------------------------------------------------------
export(int, 0, 255) var point_handle_id = 0 setget set_point_handle_id
export var handle_size = 32.0 setget set_handle_size
var hovered = false setget set_hovered
var pressed = false setget set_pressed

# main functions -------------------------------------------------------------------------------------------------------
func _ready():
	# connect signals
	
	# initialize setgets
	self.point_handle_id = point_handle_id
	self.handle_size = handle_size
	self.hovered = hovered
	self.pressed = pressed
	
	# initialize variables
	pass


func _process(delta):
	get_input()
	update_label()


func _get_configuration_warning():
	if 0:
		return "Configuration Warning String"
	else:
		return ""


# helper functions ------------------------------------------------------------------------------------------------------
func get_input():
	if not Engine.editor_hint:
		self.pressed = Input.is_action_pressed("left_click") and hovered


func update_label():
	if has_node("Label"):
		var target_mod = Color(1,1,1,1)
		var current_mod = $Label.modulate
		var lerp_mod = Color(1,1,1,1)
		var lerp_val = 0.15
		
		if hovered:
			target_mod = Color(1,1,1,1)
		else:
			target_mod = Color(1,1,1,0)
		
		lerp_mod.r = lerp(current_mod.r, target_mod.r, lerp_val)
		lerp_mod.g = lerp(current_mod.g, target_mod.g, lerp_val)
		lerp_mod.b = lerp(current_mod.b, target_mod.b, lerp_val)
		lerp_mod.a = lerp(current_mod.a, target_mod.a, lerp_val)
		$Label.modulate = lerp_mod
		
		if point_handle_id > GVM.highest_unlocked_game_scene_id:
			$LockedLabel.modulate = lerp_mod
		else:
			$LockedLabel.modulate = Color(1,1,1,0)


# set/get functions ------------------------------------------------------------------------------------------------------
func set_point_handle_id(new_val):
	point_handle_id = new_val

	if has_node("Label"):
		$Label.text = "Level " + str(point_handle_id + 1).pad_zeros(2)
	

func set_handle_size(new_val):
	handle_size = new_val
	
	if has_node("CollisionShape2D"):
		$CollisionShape2D.shape.radius = handle_size / 2


func set_hovered(new_val):
	if hovered == new_val:
		return
	
	hovered = new_val
	
	GSM.emit_signal("point_handle_hovered", point_handle_id, hovered)
	
	if hovered:
		$LevelHoverOnASP.play()
	else:
		$LevelHoverOffASP.play()


func set_pressed(new_val):
	if pressed == new_val:
		return
	
	pressed = new_val
	
	GSM.emit_signal("point_handle_pressed", point_handle_id, pressed)
	
	$LevelPressASP.play()
	
	if not point_handle_id > GVM.highest_unlocked_game_scene_id:
		GSM.emit_signal("change_game_scene", point_handle_id + 1)
		GSM.emit_signal("change_menu_scene", GVM.MENU_SCENE_IDS.null)


# signal functions -------------------------------------------------------------------------------------------------------
func _on_PointHandle_mouse_entered():
	self.hovered = true


func _on_PointHandle_mouse_exited():
	self.hovered = false

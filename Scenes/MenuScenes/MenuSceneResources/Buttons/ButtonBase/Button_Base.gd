tool
extends Button
class_name Button_Base

# references -----------------------------------------------------------------------------------------------------------


# signals --------------------------------------------------------------------------------------------------------------
signal button_base_hovered
signal button_base_pressed

# variables ------------------------------------------------------------------------------------------------------------
var hovered = false setget set_hovered

# border animation variables
export var show_border = false setget set_show_border
export var animate_border = false
export var border_size_current = Vector2(0,0) setget set_border_size_current
export var border_size_normal = Vector2(0,0)
export var border_size_hovered = Vector2(0,0)
export var border_size_pressed = Vector2(0,0)

# rotation animation variables
export var animate_rotation = false
export var rotation_current = 0.0 setget set_rotation_current
export var rotation_normal = 0.0
export var rotation_hovered = 0.0
export var rotation_pressed = 0.0


# main functions -------------------------------------------------------------------------------------------------------
func _ready():
	# connect signals
	
	# initialize setgets
	self.hovered = hovered
	self.show_border = show_border
	self.border_size_current = border_size_current
	self.rotation_current = rotation_current
	
	# initialize variables
	_on_ButtonBase_item_rect_changed()


func _process(delta):
	pass


func _get_configuration_warning():
	if 0:
		return "Configuration Warning String"
	else:
		return ""


# helper functions ------------------------------------------------------------------------------------------------------
func animate_button(button_pressed, button_hovered):
	# tween variables
	var tween_duration = .5
	var tween_delay = 0.0
	
	if has_node("Tween") and has_node("Border"):
		$Tween.stop_all()
		
		# handle border animations
		if animate_border:
			if button_pressed:
				$Tween.interpolate_property(self, "border_size_current", border_size_current, border_size_pressed, tween_duration, Tween.TRANS_ELASTIC, Tween.EASE_OUT, tween_delay)
			elif button_hovered:
				$Tween.interpolate_property(self, "border_size_current", border_size_current, border_size_hovered, tween_duration, Tween.TRANS_ELASTIC, Tween.EASE_OUT, tween_delay)
			else:
				$Tween.interpolate_property(self, "border_size_current", border_size_current, border_size_normal, tween_duration, Tween.TRANS_QUART, Tween.EASE_OUT, tween_delay)
		else:
			border_size_current = border_size_normal
		
		# handle rotation_animations
		if animate_rotation:
			if button_pressed:
				$Tween.interpolate_property(self, "rotation_current", rotation_current, rotation_pressed, tween_duration, Tween.TRANS_ELASTIC, Tween.EASE_OUT, tween_delay)
			elif button_hovered:
				$Tween.interpolate_property(self, "rotation_current", rotation_current, rotation_hovered, tween_duration, Tween.TRANS_ELASTIC, Tween.EASE_OUT, tween_delay)
			else:
				$Tween.interpolate_property(self, "rotation_current", rotation_current, rotation_normal, tween_duration, Tween.TRANS_QUART, Tween.EASE_OUT, tween_delay)
		else:
			rotation_current = rotation_normal
		
		$Tween.start()


# set/get functions ------------------------------------------------------------------------------------------------------
func set_hovered(new_val):
	hovered = new_val
	
	animate_button(pressed, hovered)
	emit_signal("button_base_hovered")


func set_show_border(new_val):
	show_border = new_val
	
	if has_node("Border"):
		$Border.visible = show_border


func set_border_size_current(new_val):
	border_size_current = new_val
	
	if has_node("Border"):
		$Border.rect_size = rect_size + border_size_current * Vector2(2,2)
		$Border.rect_position = (rect_size - $Border.rect_size) / Vector2(2,2)
		$Border.rect_pivot_offset = rect_size / Vector2(2,2)


func set_rotation_current(new_val):
	rotation_current= new_val
	
	rect_rotation = rotation_current


# signal functions -------------------------------------------------------------------------------------------------------
func _on_ButtonBase_mouse_entered():
	self.hovered = true


func _on_ButtonBase_mouse_exited():
	self.hovered = false


func _on_ButtonBase_item_rect_changed():
	# set pivot offset position so rotation is centered
	rect_pivot_offset = rect_size / Vector2(2,2)
	
	# recenter and resize Background
	if has_node("Border"):
		self.border_size_current = border_size_current


func _on_Button_Base_button_down():
	animate_button(true, hovered)
	emit_signal("button_base_pressed")


func _on_Button_Base_button_up():
	animate_button(false, hovered)

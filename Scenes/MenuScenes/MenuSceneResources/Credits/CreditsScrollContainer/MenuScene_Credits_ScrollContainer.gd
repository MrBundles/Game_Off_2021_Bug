extends ScrollContainer

# references -----------------------------------------------------------------------------------------------------------


# signals --------------------------------------------------------------------------------------------------------------


# variables ------------------------------------------------------------------------------------------------------------
var scroll_vertical_max = 0
export var scroll_speed = 100


# main functions -------------------------------------------------------------------------------------------------------
func _ready():
	# connect signals
	
	# initialize setgets
	
	# initialize variables
	if has_node("VBoxContainer"):
		scroll_vertical_max = $VBoxContainer.rect_size.y - rect_size.y
	
	print(scroll_vertical_max)


func _process(delta):
	if scroll_vertical > scroll_vertical_max - 3:
		on_scroll_max()
	elif scroll_vertical < 1:
		on_scroll_min()
	else:
		scroll_vertical += delta * scroll_speed


func _get_configuration_warning():
	if 0:
		return "Configuration Warning String"
	else:
		return ""


# helper functions ------------------------------------------------------------------------------------------------------
func on_scroll_max():
	if has_node("VBoxContainer"):
		var child_height = $VBoxContainer.get_child(0).rect_size.y
		$VBoxContainer.move_child($VBoxContainer.get_child(0), $VBoxContainer.get_child_count() - 1)
		scroll_vertical = scroll_vertical_max - child_height


func on_scroll_min():
	if has_node("VBoxContainer"):
		var child_height = $VBoxContainer.get_child($VBoxContainer.get_child_count() - 1).rect_size.y
		$VBoxContainer.move_child($VBoxContainer.get_child($VBoxContainer.get_child_count() - 1), 0)
		scroll_vertical = child_height


# set/get functions ------------------------------------------------------------------------------------------------------



# signal functions -------------------------------------------------------------------------------------------------------
func _on_ScrollContainer_SpeedSlider_value_changed(value):
	scroll_speed = value
	$ScrollASP.play()

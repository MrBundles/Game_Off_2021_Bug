extends Area2D

# references -----------------------------------------------------------------------------------------------------------


# signals --------------------------------------------------------------------------------------------------------------


# variables ------------------------------------------------------------------------------------------------------------
export(PackedScene) var pickup_particle_scene
var pickup_flag = false


# main functions -------------------------------------------------------------------------------------------------------
func _ready():
	# connect signals
	
	# initialize setgets
	
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



# signal functions -------------------------------------------------------------------------------------------------------




func _on_Environment_Pickup_body_entered(body):
	if body.is_in_group("worm") and not pickup_flag:
		if pickup_particle_scene:
			var pickup_particle_scene_instance = pickup_particle_scene.instance()
			pickup_particle_scene_instance.global_position = global_position + Vector2(32,32)
			pickup_particle_scene_instance.z_index = z_index
			get_tree().root.add_child(pickup_particle_scene_instance)
		
		if has_node("CPUParticles2D"):
			$CPUParticles2D.emitting = false
		
		if has_node("Timer"):
			$Timer.start()
		
		GSM.emit_signal("pickup_collected")
		
		$PickupDingASP.play()
		
		pickup_flag = true


func _on_Timer_timeout():
	queue_free()

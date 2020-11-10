extends Node2D

const GRASS_EFFECT = preload("res://Effects/GrassEffect.tscn")
func create_grass_effect():
	var grass_effect = GRASS_EFFECT.instance()
	get_parent().add_child(grass_effect)
	grass_effect.global_position = global_position
	
func _on_Hurtbox_area_entered(area):
	
	create_grass_effect()
	queue_free()

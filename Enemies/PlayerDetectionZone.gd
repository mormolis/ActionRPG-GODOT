extends Area2D

var player = null



func _on_PlayerDetectionZone_body_entered(body):
	player = body



func _on_PlayerDetectionZone_body_shape_exited(body_id, body, body_shape, area_shape):
	player = null
	
func can_see_player():
	return player != null

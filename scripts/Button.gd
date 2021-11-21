extends Area2D

func _on_button_body_entered(body):
	if(body.is_in_group("players")):
		$Sprite.modulate = Color(0.2,0.2,0.2);

func _on_button_body_exited(body):
	if(body.is_in_group("players")):
		$Sprite.modulate = Color(1,1,1);

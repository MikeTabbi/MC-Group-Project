extends CharacterBody2D


func _physics_process(delta):
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * 600
	move_and_slide()
	
	if Input.is_action_pressed("bullet_boost"):
		velocity = velocity / 5
		
	if Input.is_action_pressed("agile_boost"):
		velocity = velocity * 5
	
	if velocity.length() > 0.0:
		%HappyBoo.play_walk_animation()
	else:
		%HappyBoo.play_idle_animation()
		
	

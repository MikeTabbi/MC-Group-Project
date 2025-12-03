extends Area2D


var travelled_distance = 0

func _physics_process(delta):
	var SPEED = 1000
	const RANGE = 1200
	
	# Check if Q is pressed (affects existing bullets in real-time)
	if Input.is_action_pressed("bullet_boost"):
		SPEED = 2500  # 50% faster
		
	if Input.is_action_pressed("agile_boost"):
		SPEED = 250  # 50% slower
	
	position += Vector2.RIGHT.rotated(rotation) * SPEED * delta
	travelled_distance += SPEED * delta
	
	if travelled_distance > RANGE:
		queue_free()


func _on_body_entered(body):
	queue_free()
	if body.has_method("take_damage"):
		body.take_damage()

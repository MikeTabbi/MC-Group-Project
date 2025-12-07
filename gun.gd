extends Area2D

const BULLET = preload("res://bullet_2d.tscn")
@onready var shooting_point: Marker2D = %ShootingPoint

func _process(_delta: float) -> void:
	# Point gun at mouse
	look_at(get_global_mouse_position())
	
	# ---- FIX: manually wrap rotation to -180..180 ----
	# wrapped_rotation_degrees() doesn't exist → we do it ourselves
	var deg = rad_to_deg(rotation)
	while deg > 180:
		deg -= 360
	while deg <= -180:
		deg += 360
	rotation_degrees = deg
	# ------------------------------------------------
	
	# Flip sprite when pointing left (so it doesn't look upside-down)
	if rotation_degrees > 90 or rotation_degrees < -90:
		scale.y = -1
	else:
		scale.y = 1

func _on_timer_timeout() -> void:
	shoot()

func shoot() -> void:
	var new_bullet = BULLET.instantiate()
	new_bullet.global_transform = shooting_point.global_transform
	get_tree().current_scene.add_child(new_bullet)

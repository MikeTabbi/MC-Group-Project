extends Node2D
class_name PowerUp

enum PowerUpType { INDUSTRIAL_BOOST, BERRY_BURST, THUNDER_DASH, ENERGY_SURGE }

@export var powerup_type: PowerUpType = PowerUpType.THUNDER_DASH
@export var duration: float = 15.0
@export var icon_texture: Texture2D

@onready var sprite: Sprite2D = $PickupArea/Sprite2D
@onready var pickup_area: Area2D = $PickupArea
@onready var despawn_timer: Timer = $PickupArea/Timer

func _ready() -> void:
	# Icon + fallback colors
	if icon_texture:
		sprite.texture = icon_texture
	else:
		match powerup_type:
			PowerUpType.THUNDER_DASH:     sprite.modulate = Color("00f0ff")
			PowerUpType.BERRY_BURST:      sprite.modulate = Color("ff3399")
			PowerUpType.ENERGY_SURGE:     sprite.modulate = Color("ff8800")
			PowerUpType.INDUSTRIAL_BOOST: sprite.modulate = Color("ffff00")
	
	# Normal size + above everything
	scale = Vector2(1, 1)
	z_index = 10
	
	# Beautiful floating + gentle rotation
	var tween = create_tween().set_loops()
	tween.set_parallel(false)
	tween.tween_property(self, "position:y", position.y - 18, 1.4).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "position:y", position.y + 8, 1.4).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	var rot_tween = create_tween().set_loops()
	rot_tween.tween_property(self, "rotation_degrees", 8, 2.0).set_trans(Tween.TRANS_SINE)
	rot_tween.tween_property(self, "rotation_degrees", -8, 2.0).set_trans(Tween.TRANS_SINE)
	
	# Pickup & auto-despawn
	pickup_area.body_entered.connect(_on_body_entered)
	despawn_timer.wait_time = 30.0
	despawn_timer.start()
	despawn_timer.timeout.connect(queue_free)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("POWER-UP GET!", PowerUpType.keys()[powerup_type])
		body.apply_powerup(powerup_type, duration)
		queue_free()

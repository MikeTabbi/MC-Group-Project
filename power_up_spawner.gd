extends Node2D

var powerup_scenes = [
	preload("res://PowerUps/industrial_boost.tscn"),
	preload("res://PowerUps/berry_burst.tscn"),
	preload("res://PowerUps/thunder_dash.tscn"),
	preload("res://PowerUps/energy_surge.tscn")
]

@onready var timer = $Timer

func _ready():
	timer.wait_time = 8.0
	timer.autostart = true
	timer.timeout.connect(_spawn)

func _spawn():
	var powerup = powerup_scenes[randi() % powerup_scenes.size()].instantiate()
	
	# **SIMPLE FIX: Add to scene FIRST, THEN set position**
	get_tree().current_scene.add_child(powerup)
	powerup.z_index = 3
	# Now position works safely
	powerup.global_position = Vector2(
		randf_range(100, 1100), 300       # Ground level
	)
	
	print(self.global_position, " global", powerup.global_position, " power Up")
	#
	print(powerup.get_tree().current_scene)
	print(powerup.name, " has spawned")
	print("💎 Spawned power-up!")

extends Node2D

@onready var timer: Timer = $Timer
@onready var path_follow = %PathFollow2D


func _ready():
	# Debug: Check if nodes exist
	print("Timer exists: ", timer != null)
	print("PathFollow2D exists: ", path_follow != null)
	
	# Only connect if timer exists
	if timer:
		# Connect the timeout signal
		timer.timeout.connect(_on_timer_timeout)
		
		# Make sure timer starts
		if not timer.is_stopped():
			timer.start()
	else:
		print("ERROR: Timer node not found!")
		# Create a timer programmatically as fallback
		create_fallback_timer()


func create_fallback_timer():
	var new_timer = Timer.new()
	new_timer.name = "AutoTimer"
	new_timer.wait_time = 2.0  # Spawn every 2 seconds
	new_timer.autostart = true
	add_child(new_timer)
	new_timer.timeout.connect(_on_timer_timeout)
	timer = new_timer
	print("Created fallback timer")


func spawn_mob():
	print("Attempting to spawn mob...")
	
	# Check if PathFollow2D exists
	if not is_instance_valid(path_follow):
		print("PathFollow2D is not valid, using random position")
		# Fallback to random position
		var viewport = get_viewport_rect().size
		var random_pos = Vector2(
			randf_range(100, viewport.x - 100),
			randf_range(100, viewport.y - 100)
		)
		
		var mob_scene = preload("res://mob.tscn")
		var new_mob = mob_scene.instantiate()
		new_mob.global_position = random_pos
		add_child(new_mob)
		print("✅ Mob spawned at random position: ", random_pos)
		return
	
	# Use PathFollow2D for spawning
	path_follow.progress_ratio = randf()
	var mob_scene = preload("res://mob.tscn")
	var new_mob = mob_scene.instantiate()
	
	if new_mob:
		new_mob.global_position = path_follow.global_position
		add_child(new_mob)
		print("✅ Mob spawned via PathFollow2D at: ", new_mob.global_position)
	else:
		print("❌ Failed to instantiate mob!")


func _on_timer_timeout():
	spawn_mob()


func _on_player_health_depleted():
	if %GameOver:
		%GameOver.show()
	get_tree().paused = true
	
	# Stop the timer
	if timer and not timer.is_stopped():
		timer.stop()
		

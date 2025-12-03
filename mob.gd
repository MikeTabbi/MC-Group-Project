extends CharacterBody2D

signal died

var speed = randf_range(200, 300)
var health = 5
var player: Node2D = null

@onready var slime = %Slime


func _ready():
	slime.play_walk()
	
	# Wait for the player to exist in the scene
	await get_tree().process_frame
	
	# Try to find player with multiple fallbacks
	player = get_node_or_null("/root/Game/Player")
	
	if not player:
		# Try alternative path
		player = get_node_or_null("/root/Main/Player")
	
	if not player:
		# Try finding by group
		var players = get_tree().get_nodes_in_group("player")
		if players.size() > 0:
			player = players[0]
	
	if player:
		print("Mob found player!")
	else:
		print("Mob: Player not found yet, will try again in physics process")


func _physics_process(_delta):
	# If we still don't have a player, try to find it
	if not player or not is_instance_valid(player):
		player = get_node_or_null("/root/Game/Player")
		
		if not player:
			# Try alternative paths
			player = get_node_or_null("../../Player")  # Go up two parents
			if not player:
				return  # Can't move without player
	
	# Only move if we have a valid player
	if player and is_instance_valid(player):
		var direction = global_position.direction_to(player.global_position)
		velocity = direction * speed
		move_and_slide()


func take_damage():
	%Slime.play_hurt()
	health -= 1

	if health == 0:
		var smoke_scene = preload("res://smoke_explosion/smoke_explosion.tscn")
		var smoke = smoke_scene.instantiate()
		get_parent().add_child(smoke)
		smoke.global_position = global_position
		died.emit()
		queue_free()

extends CharacterBody2D

# Movement constants
const SPEED = 600.0  # Your original speed

# Power-up variables
var powerup_effects: Dictionary = {}  # {type: remaining_time}
var base_speed: float = SPEED
var hp: int = 100  # Basic HP system for Berry Burst

# Reference to HappyBoo animation node
@onready var happy_boo = %HappyBoo

func _ready() -> void:
	$ThunderTimer.connect("timeout", endPowerUp)
	$BerryTimer.connect("timeout", endPowerUp)
	$EnergyTimer.connect("timeout", endPowerUp)
	$IndusrialtTimer.connect("timeout", endPowerUp)
	

func _physics_process(delta):
	# Decay power-up timers
	for type in powerup_effects.keys():
		powerup_effects[type] -= delta
		if powerup_effects[type] <= 0:
			powerup_effects.erase(type)
	
	# Apply power-up effects
	var speed_mult = 1.0
	var glow_color = Color.WHITE
	
	if powerup_effects.has(PowerUp.PowerUpType.THUNDER_DASH):
		
		speed_mult = 2.0  # 2x speed
		glow_color = Color.YELLOW  # Thunder glow
	if powerup_effects.has(PowerUp.PowerUpType.INDUSTRIAL_BOOST):
		# Placeholder: Boost resource gathering (add to tree script)
		print("Industrial Boost active! (infinite ammo")
	if powerup_effects.has(PowerUp.PowerUpType.BERRY_BURST):
		# Heal +50 HP (capped at 100)
		hp = min(hp + 50 * delta, 100)  # Heal over time
		print("Berry Burst healing! HP: ", hp)
	if powerup_effects.has(PowerUp.PowerUpType.ENERGY_SURGE):
		# Placeholder: Boost attack/stamina
		print("Energy Surge active! (Boost attack)")
	
	# Your original movement
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var current_speed = base_speed * speed_mult
	velocity = direction * current_speed
	move_and_slide()
	
	# Your original animations
	if velocity.length() > 0.0:
		happy_boo.play_walk_animation()
	else:
		happy_boo.play_idle_animation()
	
	# Visual feedback
	happy_boo.modulate = glow_color
	if powerup_effects.is_empty():
		happy_boo.modulate = Color.WHITE

func endPowerUp():
	pass

# Power-up application function
func apply_powerup(type: PowerUp.PowerUpType, duration: float):
	powerup_effects[type] = duration
	$PowerUpTimer.start(duration)
	print("🧡 Power-Up Active: ", PowerUp.PowerUpType.keys()[type], " (", duration, "s)")

# Getter for HP (optional for UI later)
func get_hp():
	return hp

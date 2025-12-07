extends CharacterBody2D



# Movement constants
const SPEED := 600.0
const DAMAGE_RATE := 6.0

# Health with proper setter
var health := 100.0 :
	set(value):
		health = clamp(value, 0.0, 100.0)
		if %HealthBar:
			%HealthBar.value = health
		if health <= 0:
			%GameOver.visible = true
			#health_depleted.emit()
		
# Power-up system
var powerup_effects: Dictionary = {}  # {PowerUp.PowerUpType: remaining_time}

# Node references
@onready var happy_boo = %HappyBoo
@onready var health_bar = %HealthBar
@onready var hurt_box = %HurtBox

# Power-up timers (make sure these Timer nodes exist in your Player scene)
@onready var thunder_timer = $ThunderTimer
@onready var berry_timer = $BerryTimer
@onready var energy_timer = $EnergyTimer
@onready var industrial_timer = $IndustrialTimer

func _ready() -> void:
	# Connect timers
	thunder_timer.timeout.connect(_on_powerup_timer_timeout.bind(PowerUp.PowerUpType.THUNDER_DASH))
	berry_timer.timeout.connect(_on_powerup_timer_timeout.bind(PowerUp.PowerUpType.BERRY_BURST))
	energy_timer.timeout.connect(_on_powerup_timer_timeout.bind(PowerUp.PowerUpType.ENERGY_SURGE))
	industrial_timer.timeout.connect(_on_powerup_timer_timeout.bind(PowerUp.PowerUpType.INDUSTRIAL_BOOST))
	
	health = 100.0


func _physics_process(delta: float) -> void:
	# Update power-up timers
	for type in powerup_effects.keys().duplicate():
		powerup_effects[type] -= delta
		if powerup_effects[type] <= 0:
			powerup_effects.erase(type)

	# Apply effects
	var speed_mult := 1.0
	var glow_color := Color.WHITE

	if powerup_effects.has(PowerUp.PowerUpType.THUNDER_DASH):
		speed_mult = 2.0
		glow_color = Color.YELLOW

	if powerup_effects.has(PowerUp.PowerUpType.BERRY_BURST):
		var heal_per_sec := 50.0 / 15.0
		health += heal_per_sec * delta
		glow_color = Color(1.0, 0.4, 0.8)

	if powerup_effects.has(PowerUp.PowerUpType.INDUSTRIAL_BOOST):
		pass  # Add your effects here later

	if powerup_effects.has(PowerUp.PowerUpType.ENERGY_SURGE):
		pass  # Add your effects here later

	# Movement
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * SPEED * speed_mult
	move_and_slide()

	# Animation
	if velocity.length() > 10:
		happy_boo.play_walk_animation()
	else:
		happy_boo.play_idle_animation()

	# Visual glow
	happy_boo.modulate = glow_color if powerup_effects.size() > 0 else Color.WHITE

	# Take damage from overlapping enemies
	if hurt_box and hurt_box.get_overlapping_bodies().size() > 0:
		var mobs = hurt_box.get_overlapping_bodies()
		health -= DAMAGE_RATE * mobs.size() * delta


func _on_powerup_timer_timeout(type: PowerUp.PowerUpType) -> void:
	if powerup_effects.has(type):
		powerup_effects.erase(type)
		print("Power-up ended: ", PowerUp.PowerUpType.keys()[type])


# Called by power-up pickup
func apply_powerup(type: PowerUp.PowerUpType, duration: float) -> void:
	powerup_effects[type] = duration
	
	match type:
		PowerUp.PowerUpType.THUNDER_DASH:
			thunder_timer.start(duration)
		PowerUp.PowerUpType.BERRY_BURST:
			berry_timer.start(duration)
		PowerUp.PowerUpType.ENERGY_SURGE:
			energy_timer.start(duration)
		PowerUp.PowerUpType.INDUSTRIAL_BOOST:
			industrial_timer.start(duration)
	
	print("Power-Up Activated: ", PowerUp.PowerUpType.keys()[type], " for ", duration, "s")

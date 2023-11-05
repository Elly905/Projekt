extends CharacterBody2D
var attackSpeed = 150 # Adjust this speed as needed
var is_attacking = false

# Variable to store gravity
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Variable to store a reference to the player
var player

# Variable to control whether the enemy is chasing the player
var chase = false

# Speed of the enemy
var SPEED = 50
var attackCooldown = 1.0 # Adjust the cooldown time between attacks
var timeSinceLastAttack = 0.0

func _ready():
	# Initialize the enemy with the "Idle" animation
	get_node("AnimatedSprite2D").play("Idle")

func _physics_process(delta):
	# Apply gravity
	velocity.y += gravity * delta

	if chase == true:
		if is_attacking:
			timeSinceLastAttack += delta
			if timeSinceLastAttack >= attackCooldown:
				# Inflict damage to the player when the cooldown is over
				timeSinceLastAttack = 0.0
				dealDamageToPlayer()
		# Check if the animation is not "Death"
		if get_node("AnimatedSprite2D").animation != "Death":
			if not is_attacking:
			# Play the "Walk" animation
				get_node("AnimatedSprite2D").play("Walk")

		# Get a reference to the player
		player = get_node("../../Player/Player")

		# Calculate the direction to the player and normalize it
		var direction = (player.position - self.position).normalized()

		# Flip the enemy sprite based on the direction
		if direction.x > 0:
			get_node("AnimatedSprite2D").flip_h = true
		else:
			get_node("AnimatedSprite2D").flip_h = false

		# Set the velocity based on the direction and speed
		velocity.x = direction.x * SPEED
		if is_attacking:
			velocity.x= direction.x * attackSpeed
	else:
		if get_node("AnimatedSprite2D").animation != "Death" and not is_attacking:
			get_node("AnimatedSprite2D").play("Idle")
		# Stop the enemy by setting its velocity to zero
		velocity.x = 0

	# Move the enemy and handle collisions
	move_and_slide()
func start_attack():
	if !is_attacking:
		is_attacking =true
		get_node("AnimatedSprite2D").play("Attack")
func stop_attack():
	if is_attacking:
		is_attacking=false
		get_node("AnimatedSprite2D").play("Idle")

# Called when the enemy's detection area enters the player's body
func _on_player_detection_body_entered(body):
	if body.name == "Player":
		# Start chasing the player
		chase = true


# Called when the enemy's detection area exits the player's body
func _on_player_detection_body_exited(body):
	if body.name == "Player":
		# Stop chasing the player
		chase = false

# Called when the enemy's body enters the player's body (collision)
#Snowy death
func _on_northern_death_body_entered(body):
	if body.name == "Player":
		# Stop chasing the player
		death()
		
		# Play the "Death" animation
		get_node("AnimatedSprite2D").play("Death")
		
		# Wait for the "Death" animation to finish
		await get_node("AnimatedSprite2D").animation_finished
		
		# Queue the enemy to be removed (you can also handle other actions here)
		self.queue_free()

	if Game.playerHP <= 0:
		queue_free()
		get_tree().change_scene_to_file("res://main.tscn")

#func _on_player_collision_body_entered(body):
	#if body.name == "Player":
		# Decrease the player's HP by 2
		#Game.playerHP -= 3

# Function to handle enemy's death

func death():
	# Increase the player's gold by 5
	Game.Gold += 5
	
	# Save the game data
	Utils.saveGame()
	
	# Stop chasing the player
	chase = false
	
	# Play the "Death" animation
	get_node("AnimatedSprite2D").play("Death")
	
	# Wait for the "Death" animation to finish
	await get_node("AnimatedSprite2D").animation_finished
	
	# Queue the enemy to be removed (you can also handle other actions here)
	self.queue_free()


func _on_northern_attack_body_entered(body):
	if body.name == "Player":
		# Start chasing the player
		chase = true
		start_attack()


func _on_northern_attack_body_exited(body):
	if body.name == "Player":
		chase = false
		stop_attack()
func dealDamageToPlayer():
	if player:
		# Decrease the player's HP when dealing damage
		Game.playerHP -= 1 # Adjust the amount of damage as needed

extends CharacterBody2D

# Variable to store gravity
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Variable to store a reference to the player
var player

# Variable to control whether the enemy is chasing the player
var chase = false

# Speed of the enemy
var SPEED = 100

func _ready():
	# Initialize the enemy with the "Idle" animation
	get_node("AnimatedSprite2D").play("Idle")

func _physics_process(delta):
	# Apply gravity
	velocity.y += gravity * delta

	if chase == true:
		# Check if the animation is not "Death"
		if get_node("AnimatedSprite2D").animation != "Death":
			# Play the "Walk" animation
			get_node("AnimatedSprite2D").play("Walk")

		# Get a reference to the player
		player = get_node("../../Player/Player")

		# Calculate the direction to the player and normalize it
		var direction = (player.position - self.position).normalized()

		# Flip the enemy sprite based on the direction
		if direction.x > 0:
			get_node("AnimatedSprite2D").flip_h = false
		else:
			get_node("AnimatedSprite2D").flip_h = true

		# Set the velocity based on the direction and speed
		velocity.x = direction.x * SPEED
	else:
		if get_node("AnimatedSprite2D").animation != "Death":
			get_node("AnimatedSprite2D").play("Idle")
		# Stop the enemy by setting its velocity to zero
		velocity.x = 0

	# Move the enemy and handle collisions
	move_and_slide()

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
func _on_player_death_body_entered(body):
	if body.name == "Player":
		# Stop chasing the player
		chase = false
		
		# Play the "Death" animation
		get_node("AnimatedSprite2D").play("Death")
		
		# Wait for the "Death" animation to finish
		await get_node("AnimatedSprite2D").animation_finished
		
		# Queue the enemy to be removed (you can also handle other actions here)
		self.queue_free()

func _on_player_collison_body_entered(body):
	if body.name == "Player":
		# Decrease the player's HP by 3
		Game.playerHP -= 3
		# Call the "death" function

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

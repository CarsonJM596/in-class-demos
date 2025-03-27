extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -610.0
var coins = 0
signal win
var was_on_floor_last_frame := false
@onready var coinLabel = %Label
@onready var ap = $AnimationPlayer
@onready var sprite = $Sprite2D
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle movement.
	var direction := Input.get_axis("ui_left", "ui_right")

	# Smooth deceleration when not moving
	velocity.x = move_toward(velocity.x, SPEED * direction, SPEED * 8 * delta)

	if direction != 0:
		sprite.flip_h = (direction == -1)
		
	move_and_slide()
	updateanim(direction)  # Pass direction to ensure idle detection works correctly
	# Update last-frame floor status

func updateanim(direction) -> void:
	if is_on_floor():  # Ensures stable ground detection
		if direction == 0:  # If no input detected
			ap.play("Idle")  # Play idle animation
		else:
			ap.play("run")
	else:
		if velocity.y < 0: 
			ap.play("jump")
		elif velocity.y > 0:
			ap.play("fall")
			
func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("coin"):
		coins += 1
		set_coin(coins)
	elif area.is_in_group("flag"):
		check_coins(coins)

func set_coin(coins: int) -> void:
	coinLabel.text = "Coin count: " + str(coins)
	
func check_coins(coins : int) -> void:
	if coins >= 8:
		emit_signal("win")
	else: 
		coinLabel.text = "Not enough coins!"
		await get_tree().create_timer(2.0).timeout  # Wait for 2 seconds
		coinLabel.text = "Coin count: " + str(coins)

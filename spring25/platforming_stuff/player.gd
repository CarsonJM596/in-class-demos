extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -610.0
var coins = 0

@onready var coinLabel = %Label
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if is_on_floor():
		if direction:
			#velocity.x = direction * SPEED
			velocity.x = move_toward(velocity.x, SPEED * direction, SPEED * 8 * delta)
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED*8*delta)
	else: # handle air physics differently?
		if direction:
			velocity.x = move_toward(velocity.x, SPEED * direction, SPEED * 8 * delta)
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED*8*delta)
			
	move_and_slide()
	

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("coin"):
		set_coin(coins + 1)
	if area.is_in_group("flag"):
		print("You win!")

func set_coin(new_coin_count: int) -> void:
	coins = new_coin_count
	coinLabel.text = "Coin count: " + str(coins)

extends CharacterBody2D


const SPEED = 400.0
@onready var aplayer = $AnimationPlayer
@onready var atree = $AnimationTree
@onready var playback = $AnimationTree.get('parameters/playback')
var state = 'idle'

func _physics_process(delta):
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_axis("ui_left", "ui_right")
	input_vector.y = Input.get_axis("ui_up", "ui_down")
	if Input.is_action_just_pressed('ui_select'):
		playback.travel('Attack')
	elif input_vector:
		state = 'move'
		velocity = input_vector * SPEED
		playback.travel('Run')
		$AnimationTree.set('parameters/Run/blend_position',
						   input_vector)
		$AnimationTree.set('parameters/Idle/blend_position',
						   input_vector)
		$AnimationTree.set('parameters/Attack/blend_position',
							input_vector)
		#if input_vector.x > 0:
		#	$AnimationPlayer.play('run_right')
		#elif input_vector.x < 0:
		#	$AnimationPlayer.play('run_left')
	else:
		playback.travel('Idle')
		state = 'idle'
		velocity = Vector2.ZERO

	move_and_slide()

func attack_finished():
	print('attack')
	state = 'move'

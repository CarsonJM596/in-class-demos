#Player.gd
extends KinematicBody2D
const ACCELERATION = 500
const MAX_SPEED = 100
var velocity = Vector2.ZERO
onready var animTree = $AnimationTree
onready var animState = animTree.get('parameters/playback')

func _ready():
	animTree.active = true
	
func _process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength('ui_right')-Input.get_action_strength('ui_left')
	#remember, down increases y
	input_vector.y = Input.get_action_strength('ui_down')-Input.get_action_strength('ui_up')
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector*MAX_SPEED,ACCELERATION * delta)
		animTree.set('parameters/Move/blend_position',input_vector)
		animState.travel('Move')
	else:
		velocity = velocity.move_toward(input_vector*MAX_SPEED,ACCELERATION * delta*2)
		animState.travel('Idle')
	
func _physics_process(delta):
	velocity = move_and_slide(velocity)

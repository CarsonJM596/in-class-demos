extends CharacterBody2D

signal hit_player
signal ouch

const SPEED = 150.0
var dir = -1


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	if is_on_wall():
		dir *= -1
	velocity.x = dir * SPEED
	
	
	move_and_slide()


func _on_hitbox_body_entered(body: Node2D) -> void:
	emit_signal("hit_player")
	
func _on_hurt_box_body_entered(body: Node2D) -> void:
	emit_signal("ouch")
	$Hitbox/CollisionShape2D.set_deferred("disabled", true)
	$HurtBox/CollisionShape2D.set_deferred("disabled", true)
	dir = 0
	scale.y = 0.5
	await get_tree().create_timer(1.0).timeout
	$CollisionShape2D.set_deferred("disabled", true)
	velocity.x = 100
	velocity.y = -100
	
	#queue_free()

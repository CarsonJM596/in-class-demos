extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	#print($Player/Camera2D.global_position)
	#$Player/Camera2D.limit_left += 1


func _on_kill_plane_body_entered(body: Node2D) -> void:
	$Player.position = $PlayerStartPosition.position


func _on_enemy_hit_player() -> void:
	$Player.position = $PlayerStartPosition.position

func _on_enemy_ouch() -> void:
	# maybe not
	#queue_free()
	pass

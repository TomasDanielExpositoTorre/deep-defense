extends CharacterBody3D

const SPEED = 5.0

func _physics_process(delta: float) -> void:
	velocity = Vector3(0, 0, -SPEED)
	move_and_slide()

func _on_area_3d_body_entered(body: Node3D) -> void:
	body.queue_free()

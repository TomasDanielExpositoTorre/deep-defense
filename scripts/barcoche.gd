extends CharacterBody3D

const SPEED = 5.0
@onready var crash: AudioStreamPlayer3D = $Crash
var crashing = false


func _physics_process(delta: float) -> void:
	if crashing:
		return
	velocity = Vector3(0, 0, SPEED)
	rotation.y = -30
	move_and_slide()

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(15)
	if body != self and body.name != "Floor":
		crash.play(0.25)
		crashing = true


func _on_crash_finished() -> void:
	queue_free()

extends CharacterBody3D
@onready var detection_area: Area3D = $DetectionArea
@onready var ray_cast_3d: RayCast3D = $RayCast3D
@onready var boom: AudioStreamPlayer3D = $boom

var exploding = false
@onready var hitbox: CollisionShape3D = $CollisionShape3D

func _process(delta: float) -> void:
	if exploding:
		return
		
	position.y -= delta
	if ray_cast_3d.is_colliding():
		boom.play()
		hitbox.disabled = true
		exploding=true
		visible = false 

func _on_detection_area_body_entered(body: Node3D) -> void:
	if exploding:
		return
		
	if body.has_method("take_damage"):
		body.take_damage(10)
		boom.play()
		hitbox.disabled = true
		exploding=true
		visible = false


func _on_boom_finished() -> void:
	queue_free()

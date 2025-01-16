extends NinePatchRect

@onready var text: Label = $Label

func _process(delta: float) -> void:
	Global.time += delta
	var minutes = int(Global.time / 60)
	var seconds = int(Global.time) % 60
	var milliseconds = int((Global.time - int(Global.time)) * 100)
	# Actualiza el Label con el formato "MM:SS:MS"
	text.text = "%02d:%02d.%02d" % [minutes, seconds, milliseconds]

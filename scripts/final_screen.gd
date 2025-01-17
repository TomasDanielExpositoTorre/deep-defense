extends Control

@onready var metrics = $metrics

func _ready():
	var minutes = int(Global.time / 60)
	var seconds = int(Global.time) % 60
	var milliseconds = int((Global.time - int(Global.time)) * 100)
	# Actualiza el Label con el formato "MM:SS:MS"
	
	visible=true
	var kills = (Global.shrimp_kills + Global.minion_kills + Global.fish_kills + Global.other_kills)
	var score = int(Global.time) * kills
	metrics.text = "%02d:%02d.%02d\n" % [minutes, seconds, milliseconds] + str(kills) + '\n' + str(score)

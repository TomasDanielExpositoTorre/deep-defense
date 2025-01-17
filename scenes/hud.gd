extends Control
@onready var HP: Label = $PatrickBar/Counter/Label
@onready var HS: Label = $Safebar/Counter/Label
@onready var playerhealth: TextureProgressBar = $PatrickBar/TextureProgressBar
@onready var safehealth: TextureProgressBar = $Safebar/TextureProgressBar


func _process(_delta: float) -> void:
	if %Player:
		HP.text = "%0.1f" % %Player.health
		playerhealth.value = float(HP.text)
	else:
		HP.text = "0"
		playerhealth.value = 0
		
	HS.text = str(%Safe.health)
	safehealth.value = %Safe.health

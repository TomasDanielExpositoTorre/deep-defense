extends Node3D

var xr_interface: XRInterface

""""""
@onready var env: WorldEnvironment = $WorldEnvironment

const background = preload("res://assets/img/background.jpg")
const background_a = preload("res://assets/img/background-groupA.jpg")
const background_b = preload("res://assets/img/background-groupB.jpg")
const background_nightmare = preload("res://assets/img/background-nightmare.jpg")

var changed = false 
@onready var shrimptotem: Node3D = %shrimptotem

func _ready():
	xr_interface = XRServer.find_interface("OpenXR")
	
	if xr_interface and xr_interface.is_initialized():
		print("Using XR")
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		get_viewport().use_xr = true
		%Player.use_xr = true
	else:
		print("Using 3D")


func _background_change_timeout() -> void:
	var bg = env.get_environment().sky.get_material()
	var group_a = Global.shrimp_kills + Global.minion_kills
	var group_b = Global.fish_kills + Global.other_kills
	
	if not changed:
		changed = true
		if group_a > group_b:
			Global.totems = 2
			bg.set_panorama(background_a)
			shrimptotem.setup()
		elif group_b > group_a:
			Global.totems = 2
			bg.set_panorama(background_b)
		else:
			Global.totems = 4
			shrimptotem.setup()
			bg.set_panorama(background_nightmare)
	else:
		changed = false
		shrimptotem.shut_down()
		Global.totems = 0
		bg.set_panorama(background)



func _next_wave_timeout() -> void:
	for child in get_node("Spawners").get_children():
		var e = child.spawn_enemy()
		get_node("Enemies").add_child(e)
		e.target = %Safe
		e.safe = %Safe
		e.player = %Player
		e.visible = true


func _on_shrimptotem_visibility_changed() -> void:
	if not shrimptotem:
		return
	if shrimptotem.visible == false and Global.totems == 0:
		var bg = env.get_environment().sky.get_material()
		bg.set_panorama(background)
		

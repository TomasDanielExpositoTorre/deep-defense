extends Node3D

var xr_interface: XRInterface

""""""
@onready var env: WorldEnvironment = $WorldEnvironment

const background = preload("res://assets/img/background.jpg")
const background_a = preload("res://assets/img/background-groupA.jpg")
const background_b = preload("res://assets/img/background-groupB.jpg")
const background_nightmare = preload("res://assets/img/background-nightmare.jpg")

var changed = false 
var wave_no=0
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
	
	_next_wave_timeout()

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
			for child in get_node("Enemies").get_children():
				if child.type == "shrimp":
					child.enrage()
		elif group_b > group_a:
			Global.totems = 2
			bg.set_panorama(background_b)
		else:
			Global.totems = 4
			shrimptotem.setup()
			bg.set_panorama(background_nightmare)
			for child in get_node("Enemies").get_children():
				child.enrage()
	else:
		changed = false
		shrimptotem.shut_down()
		Global.totems = 0
		bg.set_panorama(background)
		for child in get_node("Enemies").get_children():
			child.target = %Safe
			child.safe = %Safe
			child.restore()


func _next_wave_timeout() -> void:
	wave_no += 1
	
	for child in get_node("Spawners").get_children():
		var a = randi_range(max(1, int(wave_no/3)), int(wave_no/2)+1)
		for _i in range(a):
			var e = child.spawn_enemy()
			get_node("Enemies").add_child(e)
			e.target = %Safe
			e.safe = %Safe
			e.player = %Player
		
			if Global.totems > 0:
				if shrimptotem.visible and e.type == "shrimp":
					e.enrage()
			e.visible = true


func _on_shrimptotem_visibility_changed() -> void:
	if not shrimptotem or shrimptotem.visible:
		return
	if Global.totems == 0:
		var bg = env.get_environment().sky.get_material()
		bg.set_panorama(background)
		
	for child in get_node("Enemies").get_children():
		if child.type == "shrimp":
			child.target = %Safe
			child.restore()

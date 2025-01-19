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
@onready var miniomtotem: StaticBody3D = %MINIOMtotem

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

func totem_setup(totem, enetype):
	totem.setup()
	for child in get_node("Enemies").get_children():
		if child.type == enetype:
			child.enrage()

func totem_shutdown(totem, enetype):
	totem.shut_down()
	for child in get_node("Enemies").get_children():
		if child.type == enetype:
			child.target = child.safe if child.type == "shrimp" else child.player
			child.restore()
			
func _background_change_timeout() -> void:
	var bg = env.get_environment().sky.get_material()
	
	if not changed:
		changed = true
		if Global.shrimp_kills > Global.minion_kills:
			Global.totems = 1
			bg.set_panorama(background_a)
			totem_setup(shrimptotem, "shrimp")
		elif Global.minion_kills > Global.shrimp_kills:
			Global.totems = 1
			bg.set_panorama(background_b)
			totem_setup(miniomtotem, "miniom")
		else:
			Global.totems = 2
			bg.set_panorama(background_nightmare)
			totem_setup(shrimptotem, "shrimp")
			totem_setup(miniomtotem, "miniom")
	else:
		Global.totems = 0
		changed = false
		bg.set_panorama(background)
		totem_shutdown(shrimptotem, "shrimp")
		totem_shutdown(miniomtotem, "miniom")

func _next_wave_timeout() -> void:
	wave_no += 1
	
	for child in get_node("Spawners").get_children():
		for _i in range(randi_range(max(1, int(wave_no/3)), int(wave_no/2)+1)):
			var e = child.spawn_enemy()
			get_node("Enemies").add_child(e)
			e.safe = %Safe
			e.player = %Player
			e.target = e.safe if e.type == "shrimp" else e.player

			if Global.totems > 0:
				if shrimptotem.visible and e.type == "shrimp":
					e.enrage()
				elif miniomtotem.visible and e.type == "miniom":
					e.enrage()
			e.visible = true
	
	for child in get_node("MinaSpawners").get_children():
		var spawn = randi_range(0,1)
		spawn = true
		if spawn:
			var e = child.spawn_mina()
			get_node("Minas").add_child(e)

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


func _on_miniomtotem_visibility_changed() -> void:
	if not miniomtotem or miniomtotem.visible:
		return
	if Global.totems == 0:
		var bg = env.get_environment().sky.get_material()
		bg.set_panorama(background)
	
	for child in get_node("Enemies").get_children():
		if child.type == "miniom":
			child.target = %Player
			child.restore()

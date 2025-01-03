extends CharacterBody3D

# 3D variables
@onready var camera: Camera3D = $head/Camera3D
@onready var armature: Node3D = $Armature
@onready var animation: AnimationPlayer = $AnimationPlayer

const WALK_SPEED = 5
const SPRINT_SPEED = 8
const JUMP_VELOCITY = 5
const SENSITIVITY = 0.03
const BFREQ = 2 
const BAMP = 0.06
var btime = 0

# XR variables
@onready var xr_camera = $xr_origin/XRCamera3D
@onready var xr_origin = $xr_origin
@onready var left_controller = %Left
@onready var right_controller = %Right

var use_xr = false

func _ready():
	if not use_xr:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * SENSITIVITY)
		#camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-40), deg_to_rad(60))

func _physics_process(delta: float) -> void:
	if use_xr:
		physics_xr(delta)
	else:
		physics_3d(delta)

func physics_3d(delta):
	# Handle jumping and gravity
	var sprinting = Input.is_action_pressed("sprint")
	var dir := Input.get_vector("left", "right", "up", "down")
	var direction := (transform.basis * Vector3(dir.x, 0, dir.y)).normalized()
	if not is_on_floor():
		velocity += get_gravity() * delta	
	elif Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_VELOCITY
		
	if direction:
		animation.play("Walking")
		velocity.x = direction.x * (SPRINT_SPEED if sprinting else WALK_SPEED)
		velocity.z = direction.z * (SPRINT_SPEED if sprinting else WALK_SPEED)
	else:
		velocity.x = 0
		velocity.z = 0
	
	if Input.is_action_just_pressed("lclick"):
		animation.play("Attack")
		
	btime += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = Vector3(cos(btime * BFREQ / 2) * BAMP, sin(btime*BFREQ) * BAMP, 0)
	move_and_slide()

func physics_xr(delta):
	var dir = XRToolsUserSettings.get_adjusted_vector2(left_controller, "primary")
	dir.y = -dir.y
	var camdir = XRToolsUserSettings.get_adjusted_vector2(right_controller, "primary")
	var sprinting = left_controller.is_button_pressed("primary_click")
	var jumping = left_controller.is_button_pressed("ax_button") or right_controller.is_button_pressed("ax_button")
	var attacking = left_controller.is_button_pressed("trigger_click") or right_controller.is_button_pressed("trigger_click")


		
	var direction := (transform.basis * Vector3(dir.x, 0, dir.y)).normalized()
	
	# Handle jumping
	if not is_on_floor():
		velocity += get_gravity() * delta
	elif jumping:
		velocity.y = JUMP_VELOCITY
	
	# Handle movement
	if direction:
		animation.play("Walking")
		velocity.x = direction.x * (SPRINT_SPEED if sprinting else WALK_SPEED)
		velocity.z = direction.z * (SPRINT_SPEED if sprinting else WALK_SPEED)
	else:
		velocity.x = 0
		velocity.z = 0
	
	# Handle attack
	if attacking:
		animation.play("Attack")
	
	# Handle camera
	if camdir:
		rotate_y(-camdir.x * SENSITIVITY * 3)
		#xr_origin.rotate_y(-camdir.x * SENSITIVITY)
	move_and_slide()
	

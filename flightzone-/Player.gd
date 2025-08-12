# File: Player.gd
extends CharacterBody3D

# Movement Settings
const SPEED := 10.0
const JUMP_FORCE := 15.0
const BOOST_FORCE := 25.0
const GRAVITY := -24.8
const MAX_SLOPE_ANGLE := 45.0

# Jetpack Settings
const JETPACK_FORCE := 10.0
const MAX_JETPACK_FUEL := 100.0
const JETPACK_DRAIN := 30.0  # fuel drained per second
const JETPACK_RECHARGE := 20.0  # fuel recharge per second

# State Variablesawd
var jetpack_fuel := MAX_JETPACK_FUEL
var is_boosting := false

func _physics_process(delta: float) -> void:
	var input_dir = get_input_direction()
	var direction = (transform.basis * input_dir).normalized()

	# Horizontal movement
	var target_velocity = direction * SPEED
	velocity.x = target_velocity.x
	velocity.z = target_velocity.z

	# Apply gravity
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	# Jetpack upward movement
	if Input.is_action_pressed("jetpack") and jetpack_fuel > 0:
		velocity.y += JETPACK_FORCE * delta
		jetpack_fuel = max(jetpack_fuel - JETPACK_DRAIN * delta, 0)
	elif is_on_floor():
		jetpack_fuel = min(jetpack_fuel + JETPACK_RECHARGE * delta, MAX_JETPACK_FUEL)

	# Boost jump
	if Input.is_action_just_pressed("boost") and is_on_floor():
		velocity.y = BOOST_FORCE

	# Regular jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_FORCE

	# Apply movement
	move_and_slide()

func get_input_direction() -> Vector3:
	var dir = Vector3.ZERO
	if Input.is_action_pressed("move_forward"):
		dir -= Vector3.FORWARD
	if Input.is_action_pressed("move_back"):
		dir += Vector3.FORWARD
	if Input.is_action_pressed("move_left"):
		dir -= Vector3.RIGHT
	if Input.is_action_pressed("move_right"):
		dir += Vector3.RIGHT
	return dir

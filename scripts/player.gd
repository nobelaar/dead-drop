extends CharacterBody3D

const SPEED: float = 3.6
const MOUSE_SENS: float = 0.0022
const PITCH_LIMIT: float = 1.35
const INTERACT_DISTANCE: float = 2.4

@onready var camera: Camera3D = $Camera3D
@onready var ray: RayCast3D = $Camera3D/InteractRay
@onready var hud: CanvasLayer = $"../HUD"

var gravity: float = float(ProjectSettings.get_setting("physics/3d/default_gravity"))
var terminal_open: bool = false
var _look_target: Node = null


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	ray.target_position = Vector3(0.0, 0.0, -INTERACT_DISTANCE)
	ray.collision_mask = 4
	ray.enabled = true
	ray.collide_with_areas = false
	ray.collide_with_bodies = true


func _unhandled_input(event: InputEvent) -> void:
	if terminal_open:
		if event.is_action_pressed("ui_cancel") or _is_interact_pressed(event):
			_close_terminal()
			get_viewport().set_input_as_handled()
		return

	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		var motion := event as InputEventMouseMotion
		rotate_y(-motion.relative.x * MOUSE_SENS)
		camera.rotate_x(-motion.relative.y * MOUSE_SENS)
		camera.rotation.x = clampf(camera.rotation.x, -PITCH_LIMIT, PITCH_LIMIT)

	if event.is_action_pressed("ui_cancel"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		get_viewport().set_input_as_handled()
		return

	if event is InputEventMouseButton:
		var mb := event as InputEventMouseButton
		if mb.pressed and mb.button_index == MOUSE_BUTTON_LEFT:
			if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
				get_viewport().set_input_as_handled()
				return

	if _is_interact_pressed(event) and _look_target != null:
		_open_terminal(_look_target)
		get_viewport().set_input_as_handled()


func _physics_process(delta: float) -> void:
	_update_look_target()

	if terminal_open:
		velocity = Vector3.ZERO
		move_and_slide()
		return

	if not is_on_floor():
		velocity.y -= gravity * delta

	var input_dir := Vector2.ZERO
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		if Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT):
			input_dir.x -= 1.0
		if Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT):
			input_dir.x += 1.0
		if Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP):
			input_dir.y -= 1.0
		if Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_DOWN):
			input_dir.y += 1.0
		input_dir = input_dir.normalized()

	var direction := (transform.basis * Vector3(input_dir.x, 0.0, input_dir.y)).normalized()
	if direction != Vector3.ZERO:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0.0, SPEED)
		velocity.z = move_toward(velocity.z, 0.0, SPEED)

	move_and_slide()


func _is_interact_pressed(event: InputEvent) -> bool:
	if event is InputEventKey:
		var key := event as InputEventKey
		return key.pressed and not key.echo and key.keycode == KEY_E
	return false


func _update_look_target() -> void:
	_look_target = null
	if terminal_open:
		if hud:
			hud.set_prompt("")
		return

	if ray.is_colliding():
		var collider := ray.get_collider() as Node
		if collider != null and collider.is_in_group("terminal"):
			_look_target = collider
			if hud:
				hud.set_prompt("[E] open tty  root@node07")
			return

	if hud:
		hud.set_prompt("")


func _open_terminal(target: Node) -> void:
	if terminal_open:
		return
	terminal_open = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	velocity = Vector3.ZERO
	if hud:
		hud.show_terminal(_read_terminal_message(target))


func _close_terminal() -> void:
	if not terminal_open:
		return
	terminal_open = false
	if hud:
		hud.hide_terminal()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _read_terminal_message(target: Node) -> String:
	if target.has_method("get_message"):
		return str(target.call("get_message"))
	return "NO DATA"

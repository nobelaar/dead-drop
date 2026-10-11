extends Node3D


func _ready() -> void:
	_build_room()
	_build_desk_and_terminal()
	_build_props()
	_setup_environment()


func _mat(color: Color, rough: float = 0.9, metallic: float = 0.0) -> StandardMaterial3D:
	var m := StandardMaterial3D.new()
	m.albedo_color = color
	m.roughness = rough
	m.metallic = metallic
	m.shading_mode = BaseMaterial3D.SHADING_MODE_PER_PIXEL
	return m


func _box(size: Vector3, pos: Vector3, color: Color, rough: float = 0.92, metallic: float = 0.05) -> StaticBody3D:
	var body := StaticBody3D.new()
	body.position = pos
	body.collision_layer = 1
	body.collision_mask = 0

	var mesh_inst := MeshInstance3D.new()
	var box := BoxMesh.new()
	box.size = size
	mesh_inst.mesh = box
	mesh_inst.material_override = _mat(color, rough, metallic)
	body.add_child(mesh_inst)

	var col := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = size
	col.shape = shape
	body.add_child(col)

	$World.add_child(body)
	return body


func _build_room() -> void:
	var wall := Color(0.28, 0.32, 0.34)
	var floor_c := Color(0.18, 0.19, 0.20)
	var ceil_c := Color(0.16, 0.17, 0.18)
	var trim := Color(0.12, 0.13, 0.14)

	_box(Vector3(10.0, 0.2, 8.0), Vector3(0.0, -0.1, 0.0), floor_c, 0.95, 0.0)
	_box(Vector3(10.0, 0.2, 8.0), Vector3(0.0, 3.1, 0.0), ceil_c, 0.98, 0.0)

	_box(Vector3(10.0, 3.2, 0.2), Vector3(0.0, 1.5, -4.0), wall)
	_box(Vector3(10.0, 3.2, 0.2), Vector3(0.0, 1.5, 4.0), wall)
	_box(Vector3(0.2, 3.2, 8.0), Vector3(-5.0, 1.5, 0.0), wall)
	_box(Vector3(0.2, 3.2, 8.0), Vector3(5.0, 1.5, 0.0), wall)

	_box(Vector3(9.6, 0.12, 0.08), Vector3(0.0, 0.06, -3.86), trim)
	_box(Vector3(9.6, 0.12, 0.08), Vector3(0.0, 0.06, 3.86), trim)
	_box(Vector3(0.08, 0.12, 7.6), Vector3(-4.86, 0.06, 0.0), trim)
	_box(Vector3(0.08, 0.12, 7.6), Vector3(4.86, 0.06, 0.0), trim)

	# Fluorescent housing
	_box(Vector3(2.4, 0.06, 0.35), Vector3(0.0, 2.97, 0.4), Color(0.35, 0.38, 0.32), 0.35, 0.25)
	_box(Vector3(1.8, 0.06, 0.35), Vector3(-2.8, 2.97, -1.5), Color(0.35, 0.38, 0.32), 0.35, 0.25)
	_box(Vector3(1.8, 0.06, 0.35), Vector3(2.8, 2.97, -1.5), Color(0.35, 0.38, 0.32), 0.35, 0.25)


func _build_desk_and_terminal() -> void:
	var metal := Color(0.30, 0.32, 0.34)
	var dark := Color(0.12, 0.13, 0.14)
	var screen := Color(0.03, 0.10, 0.05)

	_box(Vector3(2.2, 0.08, 0.9), Vector3(0.0, 0.74, 3.2), metal, 0.7, 0.4)
	_box(Vector3(0.08, 0.74, 0.9), Vector3(-1.0, 0.37, 3.2), dark, 0.85, 0.2)
	_box(Vector3(0.08, 0.74, 0.9), Vector3(1.0, 0.37, 3.2), dark, 0.85, 0.2)
	_box(Vector3(2.0, 0.5, 0.08), Vector3(0.0, 0.25, 3.55), dark, 0.9, 0.1)

	_box(Vector3(0.55, 0.45, 0.08), Vector3(0.0, 1.15, 3.05), dark, 0.6, 0.5)
	_box(Vector3(0.12, 0.18, 0.12), Vector3(0.0, 0.88, 3.12), metal, 0.5, 0.6)
	_box(Vector3(0.28, 0.04, 0.2), Vector3(0.0, 0.78, 3.15), metal, 0.5, 0.6)

	var glow := MeshInstance3D.new()
	var screen_mesh := BoxMesh.new()
	screen_mesh.size = Vector3(0.48, 0.36, 0.02)
	glow.mesh = screen_mesh
	var glow_mat := _mat(screen, 0.3, 0.0)
	glow_mat.emission_enabled = true
	glow_mat.emission = Color(0.2, 0.7, 0.35)
	glow_mat.emission_energy_multiplier = 2.2
	glow.material_override = glow_mat
	glow.position = Vector3(0.0, 1.15, 3.0)
	$World.add_child(glow)

	# Screen spill light
	var screen_light := OmniLight3D.new()
	screen_light.position = Vector3(0.0, 1.15, 2.75)
	screen_light.light_color = Color(0.35, 0.9, 0.45)
	screen_light.light_energy = 0.85
	screen_light.omni_range = 2.8
	screen_light.omni_attenuation = 1.4
	screen_light.shadow_enabled = false
	$World.add_child(screen_light)

	_box(Vector3(0.42, 0.03, 0.16), Vector3(0.0, 0.8, 2.95), Color(0.16, 0.17, 0.18), 0.8, 0.1)

	var terminal := StaticBody3D.new()
	terminal.name = "Terminal"
	terminal.position = Vector3(0.0, 1.1, 3.0)
	terminal.set_script(load("res://scripts/terminal.gd"))
	var tcol := CollisionShape3D.new()
	var tshape := BoxShape3D.new()
	tshape.size = Vector3(0.7, 0.7, 0.5)
	tcol.shape = tshape
	terminal.add_child(tcol)
	$World.add_child(terminal)

	_box(Vector3(0.06, 0.35, 0.06), Vector3(0.85, 0.96, 3.0), metal, 0.4, 0.7)
	_box(Vector3(0.18, 0.04, 0.18), Vector3(0.85, 0.78, 3.0), dark, 0.5, 0.5)
	var lamp := OmniLight3D.new()
	lamp.position = Vector3(0.85, 1.25, 2.85)
	lamp.light_color = Color(0.95, 0.92, 0.8)
	lamp.light_energy = 2.4
	lamp.omni_range = 5.5
	lamp.omni_attenuation = 0.85
	lamp.shadow_enabled = false
	$World.add_child(lamp)


func _build_props() -> void:
	var crate := Color(0.38, 0.32, 0.24)
	var pipe := Color(0.4, 0.42, 0.4)
	var cab := Color(0.24, 0.26, 0.28)

	_box(Vector3(0.7, 0.55, 0.55), Vector3(-3.6, 0.28, -2.6), crate, 0.95, 0.0)
	_box(Vector3(0.5, 0.4, 0.5), Vector3(-3.5, 0.2, -1.9), crate, 0.95, 0.0)

	_box(Vector3(0.55, 1.2, 0.45), Vector3(3.8, 0.6, 3.2), cab, 0.75, 0.35)
	_box(Vector3(0.5, 0.02, 0.02), Vector3(3.8, 0.95, 2.97), Color(0.5, 0.5, 0.42), 0.4, 0.6)
	_box(Vector3(0.5, 0.02, 0.02), Vector3(3.8, 0.55, 2.97), Color(0.5, 0.5, 0.42), 0.4, 0.6)

	_box(Vector3(0.08, 0.08, 3.5), Vector3(-4.7, 2.4, -0.5), pipe, 0.5, 0.7)
	_box(Vector3(0.08, 0.08, 2.2), Vector3(-4.7, 2.15, 1.5), pipe, 0.5, 0.7)
	_box(Vector3(2.5, 0.08, 0.08), Vector3(-3.4, 2.4, -2.2), pipe, 0.5, 0.7)

	_box(Vector3(1.2, 0.35, 0.04), Vector3(4.85, 1.4, -1.5), Color(0.45, 0.38, 0.1), 0.85, 0.1)

	_box(Vector3(2.5, 0.03, 0.06), Vector3(-1.2, 0.02, 1.5), Color(0.08, 0.08, 0.08), 0.9, 0.0)
	_box(Vector3(0.06, 0.03, 1.8), Vector3(0.05, 0.02, 2.35), Color(0.08, 0.08, 0.08), 0.9, 0.0)


func _setup_environment() -> void:
	var env := Environment.new()
	env.background_mode = Environment.BG_COLOR
	env.background_color = Color(0.05, 0.06, 0.07)
	env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.ambient_light_color = Color(0.28, 0.34, 0.36)
	env.ambient_light_energy = 0.85
	env.fog_enabled = true
	env.fog_light_color = Color(0.14, 0.18, 0.2)
	env.fog_density = 0.012
	env.tonemap_mode = Environment.TONE_MAPPER_LINEAR
	$WorldEnvironment.environment = env

	# Main ceiling fluorescents
	var fill := OmniLight3D.new()
	fill.name = "FillLight"
	fill.position = Vector3(0.0, 2.75, 0.4)
	fill.light_color = Color(0.82, 0.92, 0.88)
	fill.light_energy = 3.2
	fill.omni_range = 10.0
	fill.omni_attenuation = 0.55
	fill.shadow_enabled = false
	$World.add_child(fill)

	var fill_l := OmniLight3D.new()
	fill_l.position = Vector3(-2.8, 2.75, -1.5)
	fill_l.light_color = Color(0.78, 0.88, 0.9)
	fill_l.light_energy = 2.4
	fill_l.omni_range = 7.0
	fill_l.omni_attenuation = 0.6
	fill_l.shadow_enabled = false
	$World.add_child(fill_l)

	var fill_r := OmniLight3D.new()
	fill_r.position = Vector3(2.8, 2.75, -1.5)
	fill_r.light_color = Color(0.78, 0.88, 0.9)
	fill_r.light_energy = 2.4
	fill_r.omni_range = 7.0
	fill_r.omni_attenuation = 0.6
	fill_r.shadow_enabled = false
	$World.add_child(fill_r)

	var corner := OmniLight3D.new()
	corner.position = Vector3(-3.5, 2.0, -2.5)
	corner.light_color = Color(0.45, 0.55, 0.7)
	corner.light_energy = 1.2
	corner.omni_range = 5.5
	corner.shadow_enabled = false
	$World.add_child(corner)

	var desk_area := OmniLight3D.new()
	desk_area.position = Vector3(0.0, 2.4, 2.6)
	desk_area.light_color = Color(0.85, 0.9, 0.8)
	desk_area.light_energy = 1.6
	desk_area.omni_range = 5.0
	desk_area.omni_attenuation = 0.7
	desk_area.shadow_enabled = false
	$World.add_child(desk_area)

extends Node2D

@onready var samples: Node = $Samples
@onready var camera_2d: Camera2D = $Camera2D

var warmness : float = 1.0
var coolness : float = 1.0

var skewed : bool = true

func _ready() -> void:
	for i in samples.get_children():
		create_theme(i)

func get_random_color() -> Color:
	var color : Color = Color(randf(), randf(), randf(), 1)
	
	if (warmness > coolness):
		color[0] = clampf(color[0], color[0] + 0.15 * (warmness - coolness), 1)
		color[2] = clampf(color[2], 0, color[2] - 0.15 * (warmness - coolness))
	elif (coolness > warmness):
		color[1] = clampf(color[1], color[1] + 0.05 * (coolness - warmness), 1)
		color[2] = clampf(color[2], color[2] + 0.15 * (coolness - warmness), 1)
	
	return color

func get_random_skew() -> float:
	if (!skewed):
		return 0
	var r_skew : float = float(randi_range(0, 5)) / 10
	return r_skew

func set_border_width(style : StyleBoxFlat) -> void:
	var random = randi_range(0, 2)
	if (random == 0):
		style.set_border_width_all(10)
		style.border_blend = true
		style.border_color = style.bg_color - Color(0.2, 0.2, 0.2, 0.0)
	if (random == 1):
		style.border_width_top = 5 # Border should be smaller in comparison
		style.border_width_left = 5 # Need to add case for top right, bottom left, etc.
		
		style.border_color = style.bg_color - Color(0.2, 0.2, 0.2, 0.0)
	if (random == 2):
		style.border_width_bottom = 10
		style.border_color = style.bg_color - Color(0.2, 0.2, 0.2, 0.0)
	return
	
func set_corner_radius(style : StyleBoxFlat) -> void:
	var random = randi_range(0, 2)
	if (random == 0):
		style.set_corner_radius_all(15)
	if (random == 1):
		style.corner_radius_top_left = 15 # Need to add case for bottom left / top right etc.
		style.corner_radius_bottom_right = 15
	return

func set_shadow(style : StyleBoxFlat) -> void:
	style.shadow_size = randi_range(0, 20)
	style.shadow_offset.y = randi_range(0, 5)
	return

func _on_button_2_pressed() -> void:
	'''button.add_theme_color_override("font_color", get_random_color()) # Changes font color
	button.add_theme_color_override("font_disabled_color", get_random_color()) # Changes when Disabled is toggled
	button.add_theme_color_override("font_focus_color", get_random_color()) # Focus is when the button has been clicked down on 
	button.add_theme_color_override("font_hover_color", get_random_color()) # When button is hovered over, self-explanatory
	button.add_theme_color_override("font_hover_pressed_color", get_random_color()) # Uh in the name
	button.add_theme_color_override("font_outline_color", get_random_color()) # Font outline idk what else to say lol, uhhhh I don't see it
	
	button.add_theme_color_override("icon_normal_color", get_random_color()) # Changes icon color, we are not dealing with icons'''

	for i in samples.get_children():
		create_theme(i)
	
func create_theme(button : Button) -> void:
	var theme : Theme = Theme.new()
	
	#theme.set_color("font_color", "Button", get_random_color())
	var normal_style : StyleBoxFlat = StyleBoxFlat.new()
	normal_style.bg_color = get_random_color()
	
	normal_style.skew.x = get_random_skew()
	set_border_width(normal_style)
	set_corner_radius(normal_style)
	set_shadow(normal_style)
	#normal_style.set_corner_radius_all(randi_range(border_min, border_max))
	normal_style.set_content_margin_all(10)
	
	theme.set_stylebox("normal", "Button", normal_style)
	theme.set_stylebox("hover", "Button", normal_style)
	theme.set_stylebox("pressed", "Button", normal_style)
	button.theme = theme

func _on_button_pressed() -> void:
	for i in samples.get_children():
		if (i.has_focus()):
			var _resource = ResourceSaver.save(i.theme, "res://themes/themes.theme")

var drag : bool = false
var offset : Vector2

func _physics_process(_delta: float) -> void:
	if (drag):
		camera_2d.position = get_viewport().get_mouse_position() - Vector2(1152.0 / 2, 648.0 / 2) - offset

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_MIDDLE:
			if event.is_pressed():
				offset = get_viewport().get_mouse_position() - Vector2(1152.0 / 2, 648.0 / 2)
				drag = true
			if event.is_released():
				drag = false
				offset = Vector2.ZERO
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			if event.is_pressed(): # Check event.is_pressed() to confirm the event
				camera_2d.zoom += Vector2(0.1, 0.1)
				camera_2d.zoom = camera_2d.zoom.clamp(camera_2d.zoom, Vector2(5, 5))
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			if event.is_pressed():
				camera_2d.zoom -= Vector2(0.1, 0.1)
				camera_2d.zoom = camera_2d.zoom.clamp(Vector2(1, 1), camera_2d.zoom)

@onready var warm: HSlider = $CanvasLayer/VBoxContainer/HBoxContainer/Warm
@onready var cool: HSlider = $CanvasLayer/VBoxContainer/HBoxContainer2/Cool

func _on_warm_value_changed(value: float) -> void:
	cool.value = 1.0 - value
	update_values()


func _on_cool_value_changed(value: float) -> void:
	warm.value = 1.0 - value
	update_values()

func update_values() -> void:
	warmness = warm.value
	coolness = cool.value


func _on_skew_toggled(toggled_on: bool) -> void:
	skewed = toggled_on

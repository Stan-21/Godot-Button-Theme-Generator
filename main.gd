extends Node2D

@onready var samples: Node = $Samples
@onready var camera_2d: Camera2D = $Camera2D

@onready var generate_button: Button = $CanvasLayer/VBoxContainer/GenerateButton
@onready var warm: HSlider = $CanvasLayer/VBoxContainer/HBoxContainer/Warm
@onready var cool: HSlider = $CanvasLayer/VBoxContainer/HBoxContainer2/Cool
@onready var sharp: HSlider = $CanvasLayer/VBoxContainer/HBoxContainer4/Sharp
@onready var smooth: HSlider = $CanvasLayer/VBoxContainer/HBoxContainer5/Smooth
@onready var save_button: Button = $CanvasLayer/VBoxContainer/SaveButton


var warmness : float = 0.5
var coolness : float = 0.5
var sharpness : float = 0.5
var smoothness : float = 0.5

var skewed : bool = true
var drag : bool = false
var offset : Vector2


func _ready() -> void:
	for i : Button in samples.get_children():
		i.pressed.connect(_on_button_clicked)
		create_theme(i)

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

func _physics_process(_delta: float) -> void:
	if (drag):
		camera_2d.position = get_viewport().get_mouse_position() - Vector2(1152.0 / 2, 648.0 / 2) - offset

# HELPER FUNCTIONS FOR GENERATING THEMES
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
	if (randf() > sharpness):
		var random = randi_range(0, 2)
		if (random == 0):
			style.set_corner_radius_all(15)
		if (random == 1):
			style.corner_radius_top_left = 15
			style.corner_radius_bottom_right = 15
		if (random == 2):
			style.corner_radius_bottom_left = 15
			style.corner_radius_top_right = 15
		
	return

func set_shadow(style : StyleBoxFlat) -> void:
	if (randf() < 0.3):
		style.shadow_size = 0
		return
	style.shadow_size = randi_range(0, 20)
	style.shadow_offset.y = randi_range(0, 5)
	return

func set_text_color(style : StyleBoxFlat, theme : Theme) -> void:
	# If the color is 'bright' set the text color to black
	if ((style.bg_color[0] + (style.bg_color[1] * 0.71) + style.bg_color[2]) / 3) > 0.5:
		theme.set_color("font_color", "Button", Color(0, 0, 0))
		theme.set_color("font_hover_color", "Button", Color(0, 0, 0))
		theme.set_color("font_hover_pressed_color", "Button", Color(0, 0, 0))

func create_hover_theme(style : StyleBoxFlat) -> StyleBoxFlat:
	var hover_style : StyleBoxFlat = style.duplicate()
	
	hover_style.bg_color = style.bg_color + Color(0.1, 0.1, 0.1, 0.0)
	return hover_style
	
func create_pressed_theme(style : StyleBoxFlat) -> StyleBoxFlat:
	var pressed_style : StyleBoxFlat = style.duplicate()
	
	if (pressed_style.get_border_width_min() > 0):
		return pressed_style
	
	pressed_style.shadow_size = 0
	pressed_style.border_blend = false
	pressed_style.border_color = Color(0)
	
	pressed_style.border_width_top = style.border_width_bottom
	pressed_style.border_width_bottom = style.border_width_top
	pressed_style.border_width_left = style.border_width_right
	pressed_style.border_width_right = style.border_width_left
	return pressed_style
		
func create_theme(button : Button) -> void:
	var theme : Theme = Theme.new()
	
	#theme.set_color("font_color", "Button", get_random_color())
	var normal_style : StyleBoxFlat = StyleBoxFlat.new()
	normal_style.bg_color = get_random_color()
	
	normal_style.skew.x = get_random_skew()
	set_border_width(normal_style)
	set_corner_radius(normal_style)
	set_shadow(normal_style)
	set_text_color(normal_style, theme)
	#normal_style.set_corner_radius_all(randi_range(border_min, border_max))
	normal_style.set_content_margin_all(-1)
	normal_style.set_expand_margin_all(5)
	
	theme.set_stylebox("normal", "Button", normal_style)
	theme.set_stylebox("hover", "Button", create_hover_theme(normal_style))
	theme.set_stylebox("pressed", "Button", create_pressed_theme(normal_style))
	button.theme = theme
	
# HELPER FUNCTION FOR UPDATING VALUES BASED ON SLIDERS
func update_values() -> void:
	warmness = warm.value
	coolness = cool.value
	sharpness = sharp.value
	smoothness = smooth.value


func _on_button_clicked() -> void:
	for i in samples.get_children():
		if (i.has_focus()):
			generate_button.theme = i.theme
			save_button.theme = i.theme
		
func _on_generate_pressed() -> void:
	for i in samples.get_children():
		create_theme(i)

# When export button is pressed
func _on_button_pressed() -> void:
	for i in samples.get_children():
		if (i.has_focus()):
			var _resource = ResourceSaver.save(i.theme, 
			"res://themes/" + generate_button_name(i.theme) + "Bttn.theme")

func generate_button_name(theme : Theme) -> String:
	var string = ""
	var normal_style : StyleBoxFlat = theme.get_stylebox("normal", "Button")
	
	if (normal_style.skew.x > 0):
		string += "skewed"
	else:
		string += "straight"
	if (normal_style.shadow_size == 0):
		string += "Shadowless"
	else:
		string += "Shadow"
		
	if ((normal_style.border_width_bottom + normal_style.border_width_left
		+ normal_style.border_width_top + normal_style.border_width_right) == 0):
		string += "Borderless"
	else:
		string += "Bordered"
		string += get_color_from_rgb(normal_style.border_color)
		
	if (normal_style.border_width_top > 0):
		string += "Top"
	if (normal_style.border_width_bottom > 0):
		string += "Bottom"
	if (normal_style.border_width_left > 0):
		string += "Left"
	if (normal_style.border_width_right > 0):
		string += "Right"
	
	string += get_color_from_rgb(normal_style.bg_color)
	return shorten_string(string)
	
func get_color_from_rgb(color : Color) -> String:
	if (color[0] > color[1] + color[2]):
		return "Red"
	if (color[1] > color[0] + color[2]):
		return "Green"
	if (color[2] > color[0] + color[1]):
		return "Blue"
	if (color[0] + color[1] > 1):
		return "Yellow"
	if (color[0] + color[2] > 1):
		return "Magenta"
	if (color[1] + color[2] > 1):
		return "Cyan"
	return ""
	
func shorten_string(str : String) -> String:
	str = str.replace("a", "")
	str = str.replace("e", "")
	str = str.replace("i", "")
	str = str.replace("o", "")
	str = str.replace("u", "")
	return str

func _on_warm_value_changed(value: float) -> void:
	cool.value = 1.0 - value
	update_values()

func _on_cool_value_changed(value: float) -> void:
	warm.value = 1.0 - value
	update_values()
	
func _on_sharp_value_changed(value: float) -> void:
	smooth.value = 1.0 - value
	update_values()

func _on_round_value_changed(value: float) -> void:
	sharp.value = 1.0 - value
	update_values()

func _on_skew_toggled(toggled_on: bool) -> void:
	skewed = toggled_on
	

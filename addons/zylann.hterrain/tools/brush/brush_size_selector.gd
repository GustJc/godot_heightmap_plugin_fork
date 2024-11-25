@tool
extends Control

@export var brush_size_factor: int = 3
@export var min_value: int = -1
@export var max_value: int = -1
@export var brush_preview_color: Color = Color.LIGHT_GREEN :
	set(value):
		brush_preview_color = value
		if is_inside_tree():
			%BrushSizePreview.modulate = brush_preview_color

signal on_value_selected(new_value: int)
signal on_cancel

var background_margin: int = 10


func _ready() -> void:
	%BrushSizePreview.modulate = brush_preview_color


func _process(delta: float) -> void:
	_update_size(_get_mouse_distance())


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			var distance := _get_mouse_distance()
			on_value_selected.emit(distance)
		else:
			on_cancel.emit()


func _update_size(value: int) -> void:
	var size := value * brush_size_factor
	var ui_size := clamp(size, 40, 1000)
	%BrushSizeBackground.size = Vector2(ui_size + background_margin, ui_size + background_margin)
	%BrushSizeBackground.position = Vector2(-( (ui_size/2) + (background_margin/2)) , -( (ui_size/2) + (background_margin/2)))
	%BrushSizePreview.size = Vector2(ui_size, ui_size)
	%BrushSizePreview.position = Vector2(-(ui_size/2) , -(ui_size/2))

	%ValueLabel.text = str(value)


func _get_mouse_distance() -> int:
	var global_mouse_pos = get_global_mouse_position()
	
	var distance: int = position.distance_to(global_mouse_pos)
	if position.x > global_mouse_pos.x:
		distance = 0

	if (min_value >= 0):
		distance = maxi(distance, min_value)

	if (max_value >= 0):
		distance = mini(distance, max_value)

	return distance;


func set_initial_value(value: float) -> void:
	position -= Vector2(value, 0)
	_update_size(value)

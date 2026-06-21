extends CanvasLayer

class_name  Dialog_system


@onready var npc_label: Label = %npc_name
@onready var text_label: RichTextLabel = %convo
@onready var next_button: Button = %next_button
@onready var sound_tool: AudioStreamPlayer = %sound

@export var typewriter_speed: float = 30.0


signal dialogo_opa

var current_tween: Tween
var queue: Array = []
var mostrar: bool = false

func _ready() -> void:
	hide()
	next_button.pressed.connect(_on_next_button_pressed)

func says(text: String, npc_name: String = "", speed: float = -1.0) -> void:
	queue.append({
		"text": text,
		"npc": npc_name,
		"speed": speed if speed > 0 else typewriter_speed
	})
	if not mostrar:
		_show_next()

func _show_next() -> void:

	if queue.is_empty():
		mostrar = false
		hide()
		dialogo_opa.emit()
		return

	mostrar = true
	show()

	var data = queue.pop_front()
	npc_label.text = data["npc"]
	text_label.text = data["text"]
	text_label.visible_characters = 0

	if current_tween and current_tween.is_running():
		current_tween.kill()

	var total_chars := max(1, text_label.get_total_character_count())
	var duration : float = total_chars / data["speed"]

	current_tween = create_tween()
	current_tween.tween_property(text_label, "visible_characters", total_chars, duration)

func estar_mostrando() -> bool:
	return mostrar

func neixt():
	_on_next_button_pressed()
	
func _on_next_button_pressed() -> void:
	if text_label.visible_characters < text_label.get_total_character_count():
		if current_tween and current_tween.is_running():
			current_tween.kill()
		text_label.visible_characters = text_label.get_total_character_count()
	else:
		_show_next()

extends CanvasLayer

const LANDING_MARKER: String = "cat /tmp/.drop/NOTE"

@onready var help_label: Label = $Root/HelpLabel
@onready var prompt_label: Label = $Root/PromptLabel
@onready var terminal_panel: Panel = $Root/TerminalPanel
@onready var title_label: Label = $Root/TerminalPanel/Margin/VBox/TitleBar/TitleLabel
@onready var scroll: ScrollContainer = $Root/TerminalPanel/Margin/VBox/Scroll
@onready var terminal_text: RichTextLabel = $Root/TerminalPanel/Margin/VBox/Scroll/TerminalText
@onready var terminal_hint: Label = $Root/TerminalPanel/Margin/VBox/TerminalHint

var _mono: Font


func _ready() -> void:
	_mono = _make_mono_font()
	help_label.text = "WASD — MOVE    MOUSE — LOOK    E — INTERACT    ESC — RELEASE MOUSE"
	prompt_label.text = ""
	terminal_panel.visible = false
	terminal_hint.text = "[E] or [ESC] disconnect    |    scroll up: session history"
	title_label.text = "root@node07:/tmp/.drop  —  secure console  —  COMPROMISED"
	_apply_mono(help_label, 10)
	_apply_mono(prompt_label, 12)
	_apply_mono(title_label, 10)
	_apply_mono(terminal_hint, 10)
	if _mono:
		terminal_text.add_theme_font_override("normal_font", _mono)
	terminal_text.add_theme_font_size_override("normal_font_size", 11)
	terminal_text.add_theme_color_override("default_color", Color(0.45, 0.92, 0.52, 1.0))
	terminal_text.bbcode_enabled = false
	terminal_text.fit_content = true
	terminal_text.scroll_active = false
	terminal_text.selection_enabled = true
	terminal_text.autowrap_mode = TextServer.AUTOWRAP_OFF


func set_prompt(text: String) -> void:
	prompt_label.text = text


func show_terminal(message: String) -> void:
	terminal_text.text = message
	terminal_panel.visible = true
	help_label.visible = false
	prompt_label.text = ""
	await get_tree().process_frame
	await get_tree().process_frame
	_scroll_to_landing(message)


func hide_terminal() -> void:
	terminal_panel.visible = false
	help_label.visible = true
	terminal_text.text = ""


func _scroll_to_landing(message: String) -> void:
	var marker_pos: int = message.find(LANDING_MARKER)
	if marker_pos < 0:
		scroll.scroll_vertical = 0
		return

	var before: String = message.substr(0, marker_pos)
	var line_index: int = before.count("\n")

	# Prefer pixel scroll from content height so NOTE sits near top of view.
	var content_h: float = terminal_text.get_content_height()
	var view_h: float = scroll.size.y
	if content_h <= view_h + 1.0:
		scroll.scroll_vertical = 0
		return

	var total_lines: int = maxi(message.count("\n") + 1, 1)
	var line_h: float = content_h / float(total_lines)
	var target: int = int(line_h * float(line_index))
	# Nudge up slightly so the cat line isn't flush against the title bar.
	target = maxi(target - int(line_h), 0)
	var max_scroll: int = maxi(int(content_h - view_h), 0)
	scroll.scroll_vertical = mini(target, max_scroll)


func _make_mono_font() -> Font:
	var sys := SystemFont.new()
	sys.font_names = PackedStringArray([
		"DejaVu Sans Mono",
		"Liberation Mono",
		"Noto Sans Mono",
		"FreeMono",
		"Courier New",
		"monospace",
	])
	sys.font_weight = 400
	return sys


func _apply_mono(label: Label, size: int) -> void:
	if _mono:
		label.add_theme_font_override("font", _mono)
	label.add_theme_font_size_override("font_size", size)

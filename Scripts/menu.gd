extends Control

# Video and first level paths
@export_file("*.ogv") var intro_video_path: String = "res://Sprites/Cutscenes/intro_cutscene.ogv"
@export_file("*.tscn") var first_level_scene: String = "res://Scenes/level1.tscn"

@onready var video: VideoStreamPlayer = $VideoStreamPlayer

func _ready() -> void:
	video.visible = false
	video.autoplay = false
	video.loop = false
	video.finished.connect(_on_video_finished)

func _on_play_button_pressed() -> void:
	# Hide menu UI (except the video)
	for child in get_children():
		if child != video:
			child.visible = false

	# Set up and play intro cutscene
	video.visible = true
	video.stream = load(intro_video_path)
	video.play()

func _on_video_finished() -> void:
	get_tree().change_scene_to_file(first_level_scene)

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_info_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/info.tscn")

# Optional: allow skipping with Enter or Esc
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") or event.is_action_pressed("ui_cancel"):
		if video.visible and video.playing:
			video.stop()
			_on_video_finished()

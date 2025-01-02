extends CanvasLayer

@onready var time_label: Label = $TimeLabel
@onready var user_time_label: Label = $UserTimeLabel
@onready var best_time_label: Label = $BestTimeLabel
@onready var restart_button: Button = $RestartButton
@onready var player: CharacterBody2D = $"../Player"


var start_time: float = 0.0
var end_time: float = 0.0
var elapsed_time: float = 0.0


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Events.on_finish.connect(_finished)
	start_time = Time.get_ticks_msec() / 1000.0
	user_time_label.text = ""
	restart_button.connect("pressed", _on_restart_button_pressed)
	restart_button.visible = false
	_update_best_time_label(best_time_label)


func _process(delta: float) -> void:
	if end_time > 0.0:
		time_label.text = ""
	else:
		elapsed_time = (Time.get_ticks_msec() / 1000.0) - start_time
		time_label.text = "Czas: %.2f s" % elapsed_time


func _finished():
	end_time = (Time.get_ticks_msec() / 1000.0) - start_time
	if _load_best_time() > end_time:
		user_time_label.text = "Gratulacje!\nNowy Rekord!!!\nCzas: %.2f s" % end_time
	else:
		user_time_label.text = "Gratulacje!\nCzas: %.2f s" % end_time
	player.set_physics_process(false)
	player.animated_sprite_2d.play("idle")
	restart_button.visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	_check_and_save_best_time(end_time)


func _on_restart_button_pressed():
	get_tree().reload_current_scene() 



func _save_best_time(best_time: float) -> void:
	var save_file = FileAccess.open("user://best_time.save", FileAccess.WRITE)
	if save_file:
		save_file.store_float(best_time)
		save_file.close()

func _load_best_time() -> float:
	var save_file = FileAccess.open("user://best_time.save", FileAccess.READ)
	if save_file:
		var best_time = save_file.get_float()
		save_file.close()
		return best_time
	return INF

func _check_and_save_best_time(current_time: float) -> void:
	var best_time = _load_best_time()
	if current_time < best_time:
		_save_best_time(current_time)
		print("New best time:", current_time)
	else:
		print("Best time remains:", best_time)

func _update_best_time_label(label: Label) -> void:
	var best_time = _load_best_time()
	if best_time < INF:
		label.text = "Rekord: %.2f s" % best_time
	else:
		label.text = ""

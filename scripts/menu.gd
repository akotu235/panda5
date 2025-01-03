extends CanvasLayer

@onready var menu: CanvasLayer = $"."
@onready var world: Node2D = $"../World"

var is_menu_visible = false
var is_menu_key_blocked = false

func _process(delta: float) -> void:
	Events.on_finish.connect(_finished)

func _finished():
	is_menu_key_blocked = true

func _input(event: InputEvent):
	if event.is_action_pressed("menu"):
		if not is_menu_key_blocked:
			toggle_menu()

func toggle_menu():
	is_menu_visible = !is_menu_visible
	menu.visible = is_menu_visible

	if is_menu_visible:
		pause_game()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		resume_game()
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _on_continue_button_pressed() -> void:
	toggle_menu()


func _on_restart_button_pressed() -> void:
	world.get_tree().reload_current_scene()


func _on_exit_button_pressed() -> void:
	get_tree().quit()


func pause_game():
	set_process_for_children(world, false)

func resume_game():
	set_process_for_children(world, true)


func set_process_for_children(node: Node, is_active: bool):
	for child in node.get_children():
		if child is Node:
			child.set_process(is_active)
			child.set_physics_process(is_active)
		if child is AnimationPlayer:
			if not is_active:
				child.pause()
			else:
				child.play()
		if child is AnimatedSprite2D:
			if not is_active:
				child.pause()
			else:
				child.play()
		set_process_for_children(child, is_active)

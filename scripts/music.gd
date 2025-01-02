extends AudioStreamPlayer

@onready var dead_sfx: AudioStreamPlayer = $DeadSfx

func _ready():
	Events.on_hit.connect(_dead)

func _dead():
	dead_sfx.play()

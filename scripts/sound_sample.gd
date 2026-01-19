extends Resource
class_name SoundSample

@export var stream: AudioStream
@export var start_time: float = 0.0 # seconds
@export var volume_db: float = 0.0
@export var pitch_scale: float = 1.0
@export var stop_time := -1.0 # -1 means "play full clip"

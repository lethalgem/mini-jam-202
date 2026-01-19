class_name BackgroundMusic extends Node

# References to the nodes in our scene
@onready var _anim_player := $AnimationPlayer
@onready var _track_1 := $TeknoKickLoop176Bpm292894
@onready var _track_2 := $GameBackground359782

# crossfades to a new audio stream
func crossfade_to() -> void:
	print("crossfade woring")
	# If both tracks are playing, we're calling the function in the middle of a fade.
	# We return early to avoid jumps in the sound.
	if _track_2.playing:
		return

	# The `playing` property of the stream players tells us which track is active. 
	# If it's track two, we fade to track one, and vice-versa.
	if _track_1.playing:
		_track_2.play()
		_anim_player.play("music_fade")

extends AudioStreamPlayer2D
class_name SoundPlayer2D

var _stop_timer: SceneTreeTimer = null

func play_from_samples(
	samples: Array[SoundSample],
	random_pitch: bool = true,
	pitch_variation: float = 0.05
) -> void:
	if samples.is_empty():
		return

	var sample: SoundSample = samples.pick_random()
	if sample == null or sample.stream == null:
		return

	stream = sample.stream
	volume_db = sample.volume_db

	if random_pitch:
		pitch_scale = sample.pitch_scale + randf_range(-pitch_variation, pitch_variation)
	else:
		pitch_scale = sample.pitch_scale

	play(sample.start_time)

	_cancel_stop_timer()

	if sample.stop_time > 0.0 and sample.stop_time > sample.start_time:
		var duration: float = sample.stop_time - sample.start_time
		_stop_timer = get_tree().create_timer(duration)
		_stop_timer.timeout.connect(_on_stop_timer_timeout)

func _on_stop_timer_timeout() -> void:
	stop()
	_stop_timer = null

func _cancel_stop_timer() -> void:
	if _stop_timer != null:
		_stop_timer.timeout.disconnect(_on_stop_timer_timeout)
		_stop_timer = null

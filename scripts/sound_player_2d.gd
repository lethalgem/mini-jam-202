extends AudioStreamPlayer2D
class_name SoundPlayer2D

func play_from_samples(
	samples: Array,
	random_pitch := true,
	pitch_variation := 0.05
) -> void:
	if samples.is_empty():
		return

	var sample = samples.pick_random()

	if not sample or not sample.stream:
		return

	stream = sample.stream
	volume_db = sample.volume_db

	if random_pitch:
		pitch_scale = sample.pitch_scale + randf_range(-pitch_variation, pitch_variation)
	else:
		pitch_scale = sample.pitch_scale

	play(sample.start_time)

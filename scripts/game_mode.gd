class_name GameMode extends Node2D

@export var platforms: TileMapLayer
@export var character: PlayerCharacterBody2D

func _ready():
	disable_and_hide()

func start():
	enable_and_show()

func enable_and_show():
	# enable collision and show the scene
	platforms.collision_enabled = true
	character.collision_layer = 1
	visible = true

func disable_and_hide():
	# disable collision and hide
	platforms.collision_enabled = false
	character.collision_layer = 0
	visible = false

func pause():
	disable_and_hide()
	set_pause_subtree(self, true)

func unpause():
	enable_and_show()
	set_pause_subtree(self, false)

# Pauses every node starting at the root and deeper
func set_pause_subtree(root: Node, pause: bool) -> void:
	var process_setters = ["set_process",
	"set_physics_process",
	"set_process_input",
	"set_process_unhandled_input",
	"set_process_unhandled_key_input",
	"set_process_shortcut_input",]
	
	for setter in process_setters:
		root.propagate_call(setter, [!pause])

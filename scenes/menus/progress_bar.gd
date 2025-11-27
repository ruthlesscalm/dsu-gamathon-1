extends ProgressBar

@export var player_path: NodePath = NodePath("")  # optional: assign in inspector
var player: Node = null

func _ready() -> void:
	# try inspector path first
	if player_path != NodePath(""):
		player = get_node_or_null(player_path)

	# fallback: find a node in group "player"
	if player == null:
		var found = get_tree().get_nodes_in_group("player")
		if found.size() > 0:
			player = found[0]

	# if still null, try current_scene root child named "Player"
	if player == null:
		player = get_tree().current_scene.get_node_or_null("Player")

	# if no player yet, try again after the frame (useful if player is instanced later)
	if player == null:
		call_deferred("_try_find_player_deferred")
		return

	_connect_and_init()

func _try_find_player_deferred() -> void:
	var found = get_tree().get_nodes_in_group("player")
	if found.size() > 0:
		player = found[0]
	else:
		player = get_tree().current_scene.get_node_or_null("Player")

	if player:
		_connect_and_init()
	else:
		push_warning("ProgressBar: could not find Player. Assign player_path or ensure Player is in group 'player'.")

func _connect_and_init() -> void:
	# connect to the signal (name must match Player.gd)
	if player.has_signal("health_changed"):
		player.connect("health_changed", Callable(self, "_on_player_health_changed"))
	else:
		push_warning("Player node does not have 'health_changed' signal. Check Player.gd.")
	# set max and initial value
	if "max_health" in player:
		max_value = float(player.max_health)
	else:
		max_value = 100.0
	_update_bar()

func _on_player_health_changed(new_health: int) -> void:
	_update_bar()

func _update_bar() -> void:
	if player == null:
		return
	if "max_health" in player:
		max_value = float(player.max_health)
	else:
		max_value = 100.0
	value = float(player.health)

extends JWorld

@export var camera_speed: int = 600

@onready var camera: Camera2D = $Camera2D


func _ready():
	map_to_sync = $Entities/Map
	enemies_to_sync = $Entities/Enemies
	npcs_to_sync = $Entities/NPCs
	player_respawn_locations = $PlayerRespawnLocations

	super()

	# To avoid duplicates, remove these placeholders, they are only used in the editor
	$Entities.queue_free()

	if not J.is_server():
		var client = load("res://scenes/world/clientfsm.gd").new()
		client.name = "ClientFSM"
		add_child(client)
		if J.global.env_debug:
			$UI/LoginPanel.show()
		else:
			# Show the check version panel
			$UI/VersionCheckPanel.show()
			# Only hide the check panel if the versions match.
			if await $UI/VersionCheckPanel.check_version():
				$UI/VersionCheckPanel.hide()
				$UI/DisclaimerPanel.show()
			else:
				J.logger.error(
					"Client's version does not match the Server's version. Not the running game."
				)


func _physics_process(delta):
	if J.is_server():
		var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		camera.position += input_direction * camera_speed * delta

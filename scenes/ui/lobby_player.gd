class_name UILobbyPlayer
extends MarginContainer

@onready var player_name: Label = %Name
@onready var player_role: Label = %Role
@onready var ready_texture: TextureRect = %Ready

var player_id: int


func _ready() -> void:
	player_role.hide()
	ready_texture.hide()


func setup(player: Game.PlayerData) -> void:
	player_id = player.id
	name = str(player_id)
	_update(player)
	Game.player_updated.connect(_on_player_updated)


func _on_player_updated(id: int) -> void:
	if id == player_id:
		_update(Game.get_player(player_id))


func _update(player: Game.PlayerData):
	_set_player_name(player.name)
	_set_player_role(player.role)


func _set_player_name(value: String) -> void:
	player_name.text = value


func _set_player_role(value: Game.Role) -> void:
	player_role.visible = value != Game.Role.NONE
	match value:
		Game.Role.DRIVER:
			player_role.text = "Driver"
		Game.Role.PEDAL:
			player_role.text = "Pedal"
		Game.Role.SHOOTER:
			player_role.text = "Shooter"
		Game.Role.SHIFT:
			player_role.text = "Shift"


func set_ready(value: bool) -> void:
	ready_texture.visible = value

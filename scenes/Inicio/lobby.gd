extends MarginContainer


const MAX_PLAYERS = 4
const PORT = 5409

@onready var user = %User
@onready var host = %Host
@onready var join = %Join


@onready var ip = %IP
@onready var back_join: Button = %BackJoin
@onready var confirm_join: Button = %ConfirmJoin

@onready var driver: Button = %Driver
@onready var pedal: Button = %Pedal
@onready var shooter: Button = %Shooter
@onready var shift: Button = %Shift

@onready var back_ready: Button = %BackReady
@onready var ready_toggle: Button = %Ready

@onready var menus: MarginContainer = %Menus

@onready var start_menu = %StartMenu
@onready var join_menu = %JoinMenu
@onready var ready_menu = %ReadyMenu

@onready var players = %Players

@onready var start_timer: Timer = $StartTimer

@onready var time_container: HBoxContainer = %TimeContainer
@onready var time: Label = %Time


@export var lobby_player_scene: PackedScene

var status = { 1 : false }

var _menu_stack: Array[Control] = []

func _ready():
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.connection_failed.connect(_on_connection_failed)
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	multiplayer.server_disconnected.connect(_on_server_disconnected)
	
	Game.player_updated.connect(func(_id) : _check_ready())
	Game.players_updated.connect(_check_ready)
	
	host.pressed.connect(_on_host_pressed)
	join.pressed.connect(_on_join_pressed)
	
	confirm_join.pressed.connect(_on_confirm_join_pressed)
	
	back_join.pressed.connect(_back_menu)
	back_ready.pressed.connect(_back_menu)
	
	driver.pressed.connect(func(): Game.set_current_player_role(Game.Role.DRIVER))
	pedal.pressed.connect(func(): Game.set_current_player_role(Game.Role.PEDAL))
	shooter.pressed.connect(func(): Game.set_current_player_role(Game.Role.SHOOTER))
	shift.pressed.connect(func(): Game.set_current_player_role(Game.Role.SHIFT))
	
	ready_toggle.pressed.connect(_on_ready_toggled)
	
	start_timer.timeout.connect(_on_start_timer_timeout)
	
	ready_toggle.disabled = true
	time_container.hide()

	_go_to_menu(start_menu)
	
	user.text = OS.get_environment("USERNAME") + (str(randi() % 1000) if Engine.is_editor_hint()
 else "")
	
	Game.upnp_completed.connect(_on_upnp_completed)


func _process(_delta: float) -> void:
	if !start_timer.is_stopped():
		time.text = str(ceil(start_timer.time_left))


func _on_upnp_completed(this_status) -> void:
	print(this_status)
	if this_status == OK:
		print("Port Opened", 5)
	else:
		print("Port Error", 5)


func _on_host_pressed() -> void:
	var peer = ENetMultiplayerPeer.new()
	
	var err = peer.create_server(PORT, MAX_PLAYERS)
	if err:
		print("Host Error: %d" %err)
		return
	
	multiplayer.multiplayer_peer = peer
	
	var player = Game.PlayerData.new(multiplayer.get_unique_id(), user.text)
	_add_player(player)
	
	_go_to_menu(ready_menu)


func _on_join_pressed() -> void:
	_go_to_menu(join_menu)


func _on_confirm_join_pressed() -> void:
	var peer = ENetMultiplayerPeer.new()
	var err = peer.create_client(ip.text, PORT)
	if err:
		print("Host Error: %d" %err)
		return
	
	multiplayer.multiplayer_peer = peer
	
	var player = Game.PlayerData.new(multiplayer.get_unique_id(), user.text)
	_add_player(player)
	
	_go_to_menu(ready_menu)


func _on_connected_to_server() -> void:
	print("connected_to_server")


func _on_connection_failed() -> void:
	print("connection_failed")


func _on_peer_connected(id: int) -> void:
	print("peer_connected %d" % id)
	
	send_info.rpc_id(id, Game.get_current_player().to_dict())
	var _local_id = multiplayer.get_unique_id()
	if multiplayer.is_server():
		for player_id in status:
			set_player_ready.rpc_id(id, player_id, status[player_id])
		status[id] = false


func _on_peer_disconnected(id: int) -> void:
	print("peer_disconnected %d" % id)
	_remove_player(id)
	if multiplayer.is_server():
		starting_game.rpc(false)
	
	# Server closed connection
	if id == 1:
		_back_menu()


func _on_server_disconnected() -> void:
	print("server_disconnected")


func _add_player(player: Game.PlayerData) -> void:
	Game.add_player(player)
	
	var lobby_player = lobby_player_scene.instantiate() as UILobbyPlayer
	players.add_child(lobby_player)
	lobby_player.setup(player)


func _remove_player(id: int):
	var lobby_player = players.find_child(str(id), true, false)
	players.remove_child(lobby_player)
	lobby_player.queue_free()
	status.erase(id)
	Game.remove_player(id)




@rpc("any_peer", "reliable")
func send_info(info_dict: Dictionary) -> void:
	var player = Game.PlayerData.new(info_dict.id, info_dict.name, info_dict.role)
	_add_player(player)


func _paint_ready(id: int) -> void:
	for child in players.get_children():
		if child.name == str(id):
			child.modulate = Color.GREEN_YELLOW


func _on_ready_toggled() -> void:
	player_ready.rpc_id(1, multiplayer.get_unique_id())


@rpc("reliable", "any_peer", "call_local")
func player_ready(id: int):
	if multiplayer.is_server():
		status[id] = !status[id]
		set_player_ready.rpc(id, status[id])
		var all_ok = true
		for ok in status.values():
			all_ok = all_ok and ok
		if all_ok:
			starting_game.rpc(true)
		else:
			starting_game.rpc(false)


@rpc("reliable", "any_peer", "call_local")
func set_player_ready(id: int, value: bool):
	for child in players.get_children():
		var player = child as UILobbyPlayer
		if player.player_id == id:
			player.set_ready(value)


@rpc("any_peer", "call_local", "reliable")
func starting_game(value: bool):
	driver.disabled = value
	pedal.disabled = value
	back_ready.disabled = value
	time_container.visible = value
	if value:
		start_timer.start()
	else:
		start_timer.stop()


@rpc("any_peer", "call_local", "reliable")
func start_game() -> void:
	get_tree().change_scene_to_file("res://scenes/Inicio/main.tscn")
	
	
func is_duplicated(list):
	var new_list = list.duplicate()
	new_list.sort()
	for i in range(new_list.size()-1):
		if new_list[i] == new_list[i+1]:
			return true
	return false
	
func _check_ready() -> void:
	var roles = []
	var cantidad_jugadores = 4
	for player in Game.players:
		if not player.role in roles and player.role != Game.Role.NONE:
			roles.push_back(player.role)
	var duplicates = is_duplicated(roles)
	ready_toggle.disabled = not(roles.size()==cantidad_jugadores and Game.Role.NONE not in roles and not duplicates)


func _disconnect():
	multiplayer.multiplayer_peer.close()

	for player in players.get_children():
		players.remove_child(player)
		player.queue_free()

	ready_toggle.disabled = true
	status = { 1 : false }
	Game.players = []


func _on_start_timer_timeout() -> void:
	if multiplayer.is_server():
		start_game.rpc()


func _hide_menus():
	for child in menus.get_children():
		child.hide()


func _go_to_menu(menu: Control) -> void:
	_hide_menus()
	_menu_stack.push_back(menu)
	menu.show()


func _back_menu() -> void:
	_hide_menus()
	_menu_stack.pop_back()
	var menu = _menu_stack.back()
	if menu:
		menu.show()
	_disconnect()


func _back_to_first_menu() -> void:
	var first = _menu_stack.front()
	_menu_stack.clear()
	if first:
		_menu_stack.push_back(first)
		first.show()
	if Game.is_online():
		_disconnect()


func _on_button_back_pressed():
	
	get_tree().change_scene_to_file("res://scenes/Inicio/main_menu.tscn")

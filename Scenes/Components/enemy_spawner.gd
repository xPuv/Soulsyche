extends Node

@export var enemy_spawn_pos_grouper : Node = null
@export var enemy_pool : WeightedTable = WeightedTable.new()
@export var enemies_to_spawn : int = 5
const SPAWN_COOLDOWN : float = 0.25

var enemies_alive : int = 0
var spawning : bool = false
signal enemies_in_room_clear


func spawn_enemies():
	spawning = true
	for num in enemies_to_spawn:
		if num == len(enemy_spawn_pos_grouper.get_children()):
			break
		var marker = enemy_spawn_pos_grouper.get_children()[num]
		var enemy_packed = enemy_pool.pick_random()
		var enemy : Enemy = enemy_packed.instantiate()
		var world : = Utils.get_entity_layer()
		world.call_deferred("add_child", enemy)
		enemies_alive += 1
		await enemy.ready
		enemy.global_position = world.to_global(owner.global_position + marker.position)
		enemy.health_component.died.connect(_on_enemy_die)
		enemy.stun_component.start_stun(0.5)
		await get_tree().create_timer(SPAWN_COOLDOWN).timeout
	spawning = false


func _on_enemy_die():
	enemies_alive -= 1
	if enemies_alive == 0 and not spawning:
		enemies_in_room_clear.emit()
		GameEvents.room_cleared.emit()

class_name SoulComponent
extends RefCounted


@export var soul : SoulData = null

var level : int = 1
var experience_points : int = 1
var experience_points_to_next_level : int = 1
var is_max_level : bool = false
var usable_perks : Array[Variant] = []

const BASE_EXP_REQUIREMENT : int = 25

signal add_buff(effect : Effect)
signal add_ability(ability : Ability)
signal experience_gained(how_much : int)
signal leveled_up(lvl : int, exp_to_next : int)
signal soul_set(to : SoulData)



func _init() -> void:
	experience_points_to_next_level = calculate_exp_to_next_level()


func setup_game_events():
	for effect in soul.soul_effects:
		if is_instance_of(effect, TriggeredEffect):
			effect = effect as TriggeredEffect
			var trigger_signal = Signal(GameEvents, effect.signal_name)
			if not trigger_signal.is_null():
				trigger_signal.connect(_on_soul_effect_trigger.bind(effect))


func _on_soul_effect_trigger(data : Dictionary, triggered_effect : TriggeredEffect):
	if triggered_effect.should_trigger(data) and triggered_effect in usable_perks:
		triggered_effect.apply_with_data(data)


func set_soul(_soul : SoulData):
	soul = _soul
	setup_game_events()
	update_soul_perks()
	soul_set.emit(_soul)


func increase_experience(by : int):
	experience_points += by
	experience_gained.emit(by)
	if can_level_up():
		level_up()


func can_level_up() -> bool:
	return experience_points >= experience_points_to_next_level


func level_up():
	experience_points = 0
	if level == soul.max_level:
		is_max_level = true
	update_soul_perks()
	experience_points_to_next_level = calculate_exp_to_next_level()
	leveled_up.emit(level, experience_points_to_next_level)
	# Recalculate exp to next level


func calculate_exp_to_next_level() -> int:
	return (BASE_EXP_REQUIREMENT *  level ) + BASE_EXP_REQUIREMENT


func update_soul_perks():
	if level < soul.max_level:
		add_effect(soul.soul_effects[level -  1]) # Account for zero indexing
	elif level == soul.max_level:
		usable_perks.append(soul.ability)
		add_ability.emit(soul.ability)


func add_effect(_effect : Effect):
	if is_instance_of(_effect, TriggeredEffect):
		usable_perks.append(soul.soul_effects[1])
	else:
		usable_perks.append(_effect)
		add_buff.emit(_effect)


func is_ability_unlocked():
	return soul.ability in usable_perks

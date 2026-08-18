extends Control



@onready var soul_icon : TextureRect = $HBoxContainer/Panel/TextureRect
@onready var ability_bar : ProgressBar = $HBoxContainer/Panel/VBoxContainer/AbilityBar
@onready var experience_bar : ProgressBar = $HBoxContainer/Panel/VBoxContainer/ExperienceBar
@onready var level_label : Label = $LevelLabel

var ability_component_cooldown_timer : CooldownComponent = null


func setup(player : Player):
	var soul_component : SoulComponent = player.soul_component
	
	if not soul_component:
		return
	
	soul_component.leveled_up.connect(_on_level_up)
	soul_component.experience_gained.connect(_on_experience_gained)
	soul_component.soul_set.connect(_on_soul_set)
	soul_component.add_ability.connect(_on_ability_unlocked.bind(player))

	
	if not soul_component.is_ability_unlocked():
		ability_bar.hide()
	else:
		setup_ability_bar(soul_component.soul.ability, player)
		
	
	if soul_component.soul:
		_on_soul_set(soul_component.soul)
		experience_bar.value = 0 
		experience_bar.max_value = soul_component.experience_points_to_next_level
		level_label.text = "LVL %s" % soul_component.level


func _on_ability_unlocked(ability : Ability, player : Player):
	setup_ability_bar(ability, player)


func setup_ability_bar(ability : Ability, player : Player):
	ability_bar.max_value = ability.cooldown_time
	var ability_component : AbilityComponent = player.get_ability_component()
	ability_component_cooldown_timer = ability_component.cooldown_timer


func _physics_process(delta : float) -> void:
	if ability_component_cooldown_timer:
		ability_bar.value = ability_component_cooldown_timer.current_time


func _on_experience_gained(how_much : int):
	update_experience_bar_progress(how_much)


func _on_soul_set(to : SoulData):
	soul_icon.texture = to.texture


func _on_level_up(level : int, exp_to_next : int):
	experience_bar.max_value = exp_to_next
	experience_bar.value = 0 
	level_label.text = "LVL %" % level


func update_experience_bar_progress(by : int):
	experience_bar.value += by

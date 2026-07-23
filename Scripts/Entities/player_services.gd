class_name PlayerServices
extends RefCounted

var context : PlayerContext
var stats : StatisticComponent
var input : InputCollector
var player_node : CharacterBody2D
#var events : PlayerEvents


func _init(_context, _stats, _input, _player_node) -> void:
	context = _context
	stats = _stats
	input = _input
	player_node = _player_node

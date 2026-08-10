class_name GunRotationComponent
extends Node2D

const FACE_BUFFER : float = 5.0

@onready var primary_hand_anchor : Marker2D = $WeaponPivot/PrimaryHandAnchor
@onready var primary_hand_sprite : Sprite2D = $WeaponPivot/PrimaryHandAnchor/PrimaryHandSprite
@onready var off_hand_anchor : Marker2D = $WeaponPivot/OffHandAnchor
@onready var off_hand_sprite : Sprite2D = $WeaponPivot/OffHandAnchor/OffHandSprite
@onready var muzzle_marker : Marker2D = $WeaponPivot/GunSprite/MuzzleMarker


@export_range(1, 90, 1)
var snap_interval : float = 30.0
var is_facing_left : bool = false
var weapon_system : WeaponSystem = null
var current_gun_data : GunData = null
var gun_sprite : GunSprite = null
var previous_is_facing_left : bool = false

var target : Vector2 = Vector2.ZERO # Set my owner every frame


func setup(_gun_sprite : GunSprite, _weapon_system : WeaponSystem):
	gun_sprite = _gun_sprite
	weapon_system = _weapon_system
	weapon_system.gun_switched.connect(update_current_gun)
	update_current_gun(_weapon_system.current_gun_instance)
	apply_current_pose()


func _update_facing_left():
	if is_facing_left:
		if rotation_degrees < 90 - FACE_BUFFER or rotation_degrees > 270.0 + FACE_BUFFER:
			is_facing_left = false
	else:
		if rotation_degrees > 90.0 + FACE_BUFFER and rotation_degrees < 270.0 - FACE_BUFFER:
			is_facing_left = true


func get_aiming_direction() -> Vector2:
	return Vector2.RIGHT.rotated(deg_to_rad(rotation_degrees))


func update_current_gun(new_gun : GunInstance):
	if !new_gun:
		hide_sprites()
		return
	show_sprites()
	current_gun_data = new_gun.gun_data
	_update_facing_left()
	apply_current_pose()


func tick(_target : Vector2) -> void:
	target = _target
	gun_rotate()


func gun_rotate():
	look_at(target)
	var previous_facing_left = is_facing_left
	_update_facing_left()

	rotation_degrees = wrapf(rotation_degrees, 0, 360)
	
	if previous_facing_left != is_facing_left:
		apply_current_pose()


func apply_current_pose() -> void:
	if !current_gun_data:
		hide_sprites()
		return
	var hold_data : GunHoldData = current_gun_data.gun_hold_data
	var pose : GunHoldPose = hold_data.get_pose(is_facing_left)
	muzzle_marker.position = pose.muzzle_pos
	position = pose.weapon_pivot_position
	if !pose:
		return
	# Secondary hand setup
	if hold_data.offhand_required:
		off_hand_sprite.show()
		off_hand_anchor.position = pose.off_hand_anchor_position
		off_hand_sprite.flip_h = pose.off_hand_flip_h
		off_hand_sprite.flip_v = pose.off_hand_flip_v
	else:
		# TODO fix off hand positions when not being used
		# TODO And see why its so janky someitmes
		off_hand_sprite.hide()
	# Primary hand setup
	primary_hand_anchor.position = pose.primary_hand_anchor_position
	gun_sprite.flip_v = pose.gun_flip_v
	primary_hand_sprite.flip_h = pose.primary_hand_flip_h
	primary_hand_sprite.flip_v = pose.primary_hand_flip_v


func hide_sprites():
	primary_hand_sprite.hide()
	off_hand_sprite.hide()
	gun_sprite.hide()


func show_sprites():
	primary_hand_sprite.show()
	off_hand_sprite.show()
	gun_sprite.show()

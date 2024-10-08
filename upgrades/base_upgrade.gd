class_name BaseUpgrade
extends Node


@export var id: String
@export var label: String
@export var description: String
@export var cost: int
@export var max_purchases: int = -1 # Maximum, number of times this upgrade can be purchased
@export var treats_to_unlock: int = 0 # Minimum number of treats at which this becomes visible

var player_stats: PlayerStats
var n_purchases: int = 0 # Number of times this upgrade has been purchased so far


func link_dependencies(tree: SceneTree):
	pass


func set_player_stats(stats: PlayerStats):
	player_stats = stats


func _on_purchase_logic():
	push_error("Must implement custom purchase logic!")


func _is_purchasable_logic() -> bool:
	return true


func _should_display_logic() -> bool:
	return true


func purchase():
	var n_times := 1
	if Input.is_action_pressed("ModifierKey"):
		n_times = 10 # Purchase 10 times when the modifier key is pressed
		
	for i in range(n_times):
		if not is_purchasable() or not should_display():
			break
		n_purchases += 1
		player_stats.upgrade_purchases[id] = n_purchases
		player_stats.n_treats -= cost
		_on_purchase_logic()


func is_purchasable() -> bool:
	var has_stock := (max_purchases < 0 or n_purchases < max_purchases)
	var sufficient_treats := player_stats.n_treats >= cost
	return _is_purchasable_logic() and has_stock and sufficient_treats


func should_display() -> bool:
	var has_stock := (max_purchases < 0 or n_purchases < max_purchases)
	var tier_unlocked := player_stats.highest_treats >= treats_to_unlock
	return _should_display_logic() and has_stock and tier_unlocked

class_name SpawnManager
extends Node


@onready var spawn_container: Node = %InuContainer
@onready var building_container: Node = %BuildingContainer
@onready var player_stats: PlayerStats = %PlayerStats


static var INU_RESOURCES := {
	"base_shiba_inu": preload("res://scenes/shiba_inu.tscn"),
	"double_shiba_inu": preload("res://scenes/double_shiba_inu.tscn")
}

static var BUILDING_RESOURCES := {
	"gym": preload("res://scenes/gym.tscn")
}

func spawn_inu(inu_type: String):
	if !INU_RESOURCES.has(inu_type):
		push_error(
			"Inu type '%s' cannot be spawned because that inu type does not exist" % inu_type)

	var inu: CharacterBody2D = INU_RESOURCES[inu_type].instantiate()
	inu.visible = false
	spawn_container.add_child(inu)
	inu.position = inu.choose_random_spot()
	inu.visible = true
	
	player_stats.creature_score += 1
	
func spawn_building(building_type: String):
	if !BUILDING_RESOURCES.has(building_type):
		push_error("
		Building type '%s' cannot be spawned because that building does not exist" % building_type)
		
	var building: RigidBody2D = BUILDING_RESOURCES[building_type].instatiate()
	building.visible = false
	building_container.add_child(building)
	building.position = building.choose_open_spot()
	building.visible = true
	
	

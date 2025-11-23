## Temporary workaround to avoid breaking other people's code.
class_name UIHandler
extends Node

static func refresh_ui(entity: Entity):
	if not entity.is_inside_tree():
		Logging.log("Error: %s not in scene tree."%[entity.name])
	
	# Refresh health test
	var health_bar: HealthBar = entity.get_node("HealthBar")
	if not health_bar: return
	health_bar.max_health = entity.max_hp
	health_bar.current_health = entity.current_hp
	health_bar._update_bar()
	Logging.log("%s Health: %.3f / %.3f"%[entity.name, entity.current_hp, entity.max_hp])
	
	# Refresh name test
	var name:Label = entity.get_node_or_null("Name")
	if not name: return
	name.text = entity.name

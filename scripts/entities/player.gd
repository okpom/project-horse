class_name Player
extends Entity

# Stats + Skills

# Potential Stats
# Health
# Speed
# Luck

# offsets you can tweak in Inspector
const skills_column_offset_x: float = 400
const skills_column_offset_y: float = 0.0

@onready var skills_column = $SkillsColumn
var _base_column_position: Vector2  

func _ready():
	# Save original position from scene (what the editor set)
	_base_column_position = skills_column.position
	_update_skills_column_position()

func _update_skills_column_position():
	skills_column.position = _base_column_position + Vector2(
		skills_column_offset_x,
		skills_column_offset_y
	)

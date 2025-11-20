# player_skills_bar.gd
class_name SkillsBar
extends Control

@export var y_offset := -130

@onready var bar_3: Control = $TripleSkills

# NEW: references to empty slots and filled slots
@onready var empty_container: GridContainer  = $TripleSkills/EmptySkillsContainer
@onready var skills_container: GridContainer = $TripleSkills/SkillsContainer


func _ready():
	# position skill boxes above player
	position.y = y_offset

	# hide all skill icons until selected
	for i in range(skills_container.get_child_count()):
		var icon := skills_container.get_child(i) as TextureRect
		if icon:
			icon.visible = false
			icon.texture = null

			# click to delete filled slot
			icon.gui_input.connect(_on_skill_slot_gui_input.bind(i))


func show_bar():
	bar_3.visible = true


# ===========================================================
#                PUBLIC API — CALLED BY SkillsColumn
# ===========================================================

# column_index: 0 = Skill1, 1 = Skill2, 2 = Skill3
func populate_skill_bar(column_index: int, tex: Texture2D) -> void:
	if column_index < 0 or column_index >= skills_container.get_child_count():
		push_warning("populate_skill_bar: index out of range %d" % column_index)
		return

	var icon_slot  := skills_container.get_child(column_index) as TextureRect
	var empty_slot := empty_container.get_child(column_index) as ColorRect

	icon_slot.texture = tex
	icon_slot.visible = true
	empty_slot.visible = false


func delete_skill_bar(column_index: int) -> void:
	if column_index < 0 or column_index >= skills_container.get_child_count():
		push_warning("delete_skill_bar: index out of range %d" % column_index)
		return

	var icon_slot  := skills_container.get_child(column_index) as TextureRect
	var empty_slot := empty_container.get_child(column_index) as ColorRect

	if icon_slot.texture == null:
		return  # slot was already empty

	icon_slot.texture = null
	icon_slot.visible = false
	empty_slot.visible = true


# ===========================================================
#                        INTERNAL
# ===========================================================

# Clicking a filled slot clears it
func _on_skill_slot_gui_input(event: InputEvent, column_index: int) -> void:
	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed:
		delete_skill_bar(column_index)

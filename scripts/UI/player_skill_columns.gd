class_name SkillsColumn
extends Control

const SKILL_ICONS : Array[Texture2D] = [
	preload("res://assets/UI_Visuals/Skills_Icons/guard.png"),
	preload("res://assets/UI_Visuals/Skills_Icons/heavy_melee.png"),
	preload("res://assets/UI_Visuals/Skills_Icons/light_attack.png"),
	preload("res://assets/UI_Visuals/Skills_Icons/light_spell.png"),
	preload("res://assets/UI_Visuals/Skills_Icons/magic_guard.png"),
	preload("res://assets/UI_Visuals/Skills_Icons/melee_buff.png"),
	preload("res://assets/UI_Visuals/Skills_Icons/team_heal.png"),
]

@onready var col1: GridContainer = $TripleCol/Column1/SkillsContainer
@onready var col2: GridContainer = $TripleCol/Column2/SkillsContainer
@onready var col3: GridContainer = $TripleCol/Column3/SkillsContainer
@onready var desc_box: SkillDescriptionBox = $CanvasLayer/SkillDescriptionBox
@onready var root_3 = $TripleCol

# sibling under the same Player node
@onready var player_bar: SkillsBar = (get_parent().get_node_or_null("SkillsBar")) as SkillsBar

var columns: Array
const ROWS_PER_COLUMN := 3

func _ready():
	root_3.visible = false
	columns = [col1, col2, col3]
	desc_box.visible = false
	#print("[SkillsColumn] Ready. Columns =", columns.size())
	print("[SkillsColumn] Ready.")

func generate_fake_skills():
	print("[SkillsColumn] generate_skills()")
	root_3.visible = true

	# Clear old icons
	for container in columns:
		for child in container.get_children():
			child.queue_free()

	var icon_size := Vector2(100, 100)

	for container in columns:
		for i in range(ROWS_PER_COLUMN):

			# Random icon
			var tex: Texture2D = SKILL_ICONS[randi() % SKILL_ICONS.size()]

			var icon := TextureRect.new()
			icon.texture = tex
			icon.custom_minimum_size = icon_size
			icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED

			container.add_child(icon)

			# Connect hover events
			icon.mouse_entered.connect(_on_icon_hover_enter.bind(icon))
			icon.mouse_exited.connect(_on_icon_hover_exit.bind(icon))

			print("  Added icon:", tex)

func _on_icon_hover_enter(icon: TextureRect):
	print("[Hover] enter:", icon.texture)

	# Set the SAME icon texture in the box
	desc_box.icon_tex.texture = icon.texture

	# Position next to cursor
	#desc_box.global_position = get_global_mouse_position() + Vector2(20, 20)
	desc_box.position = get_viewport().get_mouse_position() + Vector2(20, 20)

	desc_box.visible = true

func _on_icon_hover_exit(icon: TextureRect):
	print("[Hover] exit")
	desc_box.visible = false

#  RANDOM PLACEHOLDER ICONS (BEFORE REAL PLAYER SKILLS ARE ASSIGNED)
func generate_skills():
	print("\n[SkillsColumn] generate_skills()")

	root_3.visible = true

	# Clear old icons
	for container in columns:
		for child in container.get_children():
			child.queue_free()
	print("  Cleared old icons.")

	var icon_size := Vector2(100, 100)

	for col_i in range(columns.size()):
		var container = columns[col_i]
		for row_i in range(ROWS_PER_COLUMN):

			var tex: Texture2D = SKILL_ICONS[randi() % SKILL_ICONS.size()]
			var icon := TextureRect.new()

			icon.texture = tex
			icon.custom_minimum_size = icon_size
			icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED

			icon.set_meta("skill", null)   # placeholder has no skill yet

			container.add_child(icon)

			print("  [+] Placeholder icon added :: Column", col_i,
				  "Row", row_i, "Texture =", tex.resource_path)

	print("  Placeholder icons created. Hover NOT connected.\n")

#  ASSIGN REAL SKILLS AND CONNECT HOVER EVENTS
func show_skills(player: Entity) -> void:
	print("\n[SkillsColumn] show_skills() for", player.name)

	var skills = player.skills
	var skill_index := 0

	print("  Total skills found =", skills.size())

	for col_i in range(columns.size()):
		var container = columns[col_i]

		for row_i in range(container.get_child_count()):
			var icon = container.get_child(row_i)

			# Reset metadata + signals
			icon.set_meta("skill", null)
			#_disconnect_hover(icon)

			if skill_index >= skills.size():
				print("    [-] No skill for Column", col_i, "Row", row_i, "(empty slot)")
				continue

			# Assign real skill
			var skill: Skill = skills[skill_index]
			icon.set_meta("skill", skill)

			print("    [+] Skill assigned -> Column", col_i,
				  "Row", row_i, "SkillID =", skill.skill_id)

			# Set real texture if provided
			if icon is TextureRect and skill.icon_texture:
				icon.texture = skill.icon_texture
				print("       Set icon texture:", skill.icon_texture.resource_path)

			#_connect_hover(icon)
			print("       Hover connected.")

			skill_index += 1

	print("[SkillsColumn] Skill assignment complete.\n")

## SAFE SIGNAL DISCONNECT (REPLACES disconnect_all)
#func _disconnect_hover(icon: Control):
	## Disconnect only the callback this script uses
	#if icon.mouse_entered.is_connected(_on_skill_mouse_entered):
		#print("       [Disconnect] mouse_entered for", icon.name)
		#icon.mouse_entered.disconnect(_on_skill_mouse_entered)
#
	#if icon.mouse_exited.is_connected(_on_skill_mouse_exited):
		#print("       [Disconnect] mouse_exited for", icon.name)
		#icon.mouse_exited.disconnect(_on_skill_mouse_exited)
#
## CONNECT HOVER SIGNALS SAFELY
#func _connect_hover(icon: Control):
	#print("       [Connect] Hover signals for", icon.name)
#
	## ensure no duplicates — looping calls won't stack
	#if not icon.mouse_entered.is_connected(_on_skill_mouse_entered):
		#icon.mouse_entered.connect(_on_skill_mouse_entered.bind(icon))
#
	#if not icon.mouse_exited.is_connected(_on_skill_mouse_exited):
		#icon.mouse_exited.connect(_on_skill_mouse_exited.bind(icon))
#
#func _on_skill_mouse_entered(icon: Control):
	#var skill: Skill = icon.get_meta("skill")
	#print("[Hover] mouse_entered for icon =", icon, "| skill =", skill)
#
	#if skill == null:
		#print("  [Hover] Ignored — icon has NO skill metadata.")
		#desc_box.visible = false
		#return
#
	#desc_box.visible = true
	##desc_box.update_description(skill)
	#desc_box.global_position = get_global_mouse_position() + Vector2(20, 20)
#
#func _on_skill_mouse_exited(icon: Control):
	#print("[Hover] mouse_exited for icon =", icon)
	#desc_box.visible = false

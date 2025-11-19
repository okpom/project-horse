class_name BossFightManager
extends Node

const PLAYER_SCENE = preload("res://scenes/entities/player.tscn")
const BOSS_SCENE = preload("res://scenes/entities/boss.tscn")
const ARROW_SCENE := preload("res://scenes/UI/boss_preview_arrows.tscn")
const MAX_PLAYERS = 2

var players: Array[Entity] = []
var boss: Entity
var boss_preview_arrows : Node = null

func _ready() -> void:
	spawn_players()
	spawn_boss()
	show_boss_preview() #shows lines from boss to 
	start_boss_fight()

func spawn_players() -> void:
	var player_positions = [Vector2(-600, -150), Vector2(-200, -150)]
	#player_positions = [Vector2(-600, -120), Vector2(20, 0)] #comment out to move back to original 
	
	for i in range(MAX_PLAYERS):
		var player_instance = PLAYER_SCENE.instantiate() as Entity
		player_instance.global_position = player_positions[i]
		player_instance.name = "Player_%d" % (i + 1)
		print(player_instance.name)
		
		add_child(player_instance)
		players.append(player_instance)
			
		#generate skills bar for this player
		var bar = player_instance.get_node_or_null("SkillsBar")
		if bar:
			bar.show_bar()
			
		#generate skills column for this player
		var col = player_instance.get_node_or_null("SkillsColumn")
		if col:
			col.generate_skills()


func spawn_boss() -> void:
	var boss_position = Vector2(600, -150)
	#boss_position = Vector2(700, 100)
	var boss_instance = BOSS_SCENE.instantiate() as Entity
	boss_instance.global_position = boss_position
	boss_instance.name = "Boss"
	
	add_child(boss_instance)
	boss = boss_instance

	#boss_preview_arrows = boss_instance.get_node("SkillsBar/TripleSkills/BossPreviewArrows")
	boss_preview_arrows = boss_instance.get_node("SkillsBar/BossPreviewArrows")
	#boss_preview_arrows = get_node("BossPreviewArrows")

	var bar: SkillsBar = boss_instance.get_node_or_null("SkillsBar")
	if bar:
		#print("Boss bar found. Showing bar.")
		bar.show_bar()
	else:
		push_error("Boss has NO SkillsBar node!")

func get_player_skill_nodes() -> Array[Control]:
	var result : Array[Control] = []

	for player in players:
		var root := player.get_node_or_null("SkillsBar/TripleSkills/EmptySkillsContainer")
		if root == null:
			continue

		for child in root.get_children():
			if child is ColorRect or child is TextureRect:
				result.append(child)

	#print("[get_player_skill_nodes] Found ", result.size(), "player skills total.")
	#for n in result:
		#print("  Player Skill:", n.name, "@", n.global_position)

	return result
	
func get_boss_skill_nodes() -> Array[Control]:
	var result : Array[Control] = []

	var root := boss.get_node_or_null("SkillsBar/TripleSkills/EmptySkillsContainer")
	if root == null:
		print("ERROR: Boss TripleSkills not found.")
		return result

	for child in root.get_children():
		# Your Skill icons are ColorRect or TextureRect
		if child is ColorRect or child is TextureRect:
			result.append(child)

	#print("[get_boss_skill_nodes] Found ", result.size(), "boss skills.")
	#for n in result:
		#print("  Boss Skill: ", n.name, " @", n.global_position)

	return result

func show_boss_preview():
	print("\n================ SHOW BOSS PROJECTIONS ================")

	# contains array of ColorRect nodes (skill icons)
	var boss_skills := get_boss_skill_nodes()
	var player_skills := get_player_skill_nodes()

	if boss_skills.is_empty():
		print("ERROR: No boss skills detected.")
		return
	if player_skills.is_empty():
		print("ERROR: No player skills detected.")
		return

	#print("\nGenerating arrows:")
	#print("  Boss skills:", boss_skills.size())
	#print("  Player skills:", player_skills.size())

	# random skill arrow mapping
	# for i in range(boss_skills.size()):
	#     var start_node = boss_skills[i]
	#     var end_node = player_skills[randi() % player_skills.size()]
	#
	#     print("\n[Arrow #", i+1, "]")
	#     print("  FROM:", start_node.name, " @", start_node.global_position)
	#     print("  TO:  ", end_node.name, " @", end_node.global_position)
	#
	#     var arrow := ARROW_SCENE.instantiate()
	#     boss_preview_arrows.add_child(arrow)
	#
	#     arrow.node_start = start_node
	#     arrow.node_end   = end_node
	
	# 1:1 skill arrow mapping
	var count: int = min(boss_skills.size(), player_skills.size())
	#print("\n=== Deterministic Mapping (1-to-1) ===")
	for i in range(count):
		var start_node = boss_skills[i]
		var end_node   = player_skills[i]

		#print("\n[Arrow #", i+1, "]")
		#print("  FROM:", start_node.name, " @", start_node.global_position)
		#print("  TO:  ", end_node.name, " @", end_node.global_position)

		var arrow := ARROW_SCENE.instantiate()
		boss_preview_arrows.add_child(arrow)

		arrow.node_start = start_node
		arrow.node_end   = end_node

	#print("\n=== All boss projection arrows generated (1:1 matching). ===")
	
	#var heads = get_tree().get_nodes_in_group("circle_heads")
	#for h in heads:
		#print("CIRCLE ->", h, " parent=", h.get_parent(), "  pos=", h.global_position)

func start_boss_fight() -> void:
	print("Boss fight started!")
	 #Transitions to the actual boss fight
	pass

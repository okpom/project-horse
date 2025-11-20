class_name Boss
extends Entity

# Stats + Skills


@onready var preview_arrows := $SkillsBar/BossPreviewArrows

func _ready():
	preview_arrows.visible = false  # default hidden

func _on_hover_area_mouse_entered() -> void:
	preview_arrows.visible = true
	
func _on_hover_area_mouse_exited() -> void:
	preview_arrows.visible = false

class_name Skill
extends Resource

@export var skill_id: int = 0
@export var base_dmg: float = 0.0
@export var bonus_dmg: float = 0.0
@export var coins: int = 1
@export var odds: float = 0.5

func _init(_skill_id: int = 0, _base_dmg: float = 0.0, \
	_bonus_dmg: float = 0.0, _coins: int = 1, _odds: float = 0.5):
	
	skill_id = _skill_id
	base_dmg = _base_dmg
	bonus_dmg = _bonus_dmg
	coins = _coins
	odds = _odds

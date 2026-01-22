extends Node2D
class_name PlayerCoin

@onready var coins := $Coins
@onready var coinsEffect := $CoinsEffect

enum CoinLevel {
	SMALL,
	MEDIUM,
	BIG
}

@onready var coin_map := {
	CoinLevel.SMALL:  coins.get_node("Coins-1"),
	CoinLevel.MEDIUM: coins.get_node("Coins-2"),
	CoinLevel.BIG:    coins.get_node("Coins-3"),
}

enum WinTier {
	SMALL_WIN,
	MEDIUM_WIN,
	BIG_WIN
}

const TIER_TO_ANIM := {
	WinTier.SMALL_WIN: "COINS_SMALL_WIN",
	WinTier.MEDIUM_WIN: "COINS_MEDIUM_WIN",
	WinTier.BIG_WIN:   "COINS_BIG_WIN",
}

func _ready() -> void:
	hide_all()
		
func hide_all():
	coins.visible = false
	for c in coin_map.values():
		c.visible = false
		
func show_coin(level: CoinLevel):
	hide_all()
	coins.visible = true
	coin_map[level].visible = true
	
func play_coin_animation(tier:WinTier):
	if not TIER_TO_ANIM.has(tier):
		return
	$AnimationPlayer.play(TIER_TO_ANIM[tier])

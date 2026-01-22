extends Node2D
class_name Main

@onready var slot = $ViewportContainer/Viewport/SlotMachine

@onready var spin_roulette = $Roll/spin_roulette
@onready var spin_coin = $Roll/spin_coin
@onready var monster = $Monster
@onready var player_coin = $PlayerCoin

func _ready():
	slot.connect("stopped", Callable(self, "_on_slot_machine_stopped"))
	player_coin.show_coin(PlayerCoin.CoinLevel.MEDIUM)
	
func monster_draw():
	monster.play("draw")
	await get_tree().create_timer(1.6).timeout
	monster.play("laugh")
	
func _on_Roll_button_down():
	if slot.state == slot.State.OFF:
		monster_draw()
		slot.start()
		spin_coin.play()
	elif slot.state == slot.State.ON:
		monster.play("laugh")
		slot.stop()
		spin_coin.play()
	#if $Roll.text == "Roll":
		#slot.start()
		#$Roll.text = "Stop"
	#else:
		#slot.stop()
	
func _on_slot_machine_stopped():
	monster.play("laugh")
	spin_coin.stop()
	slot.count_stopped_show_damage(Vector2(monster.position.x * 1.07,monster.position.y * 1.6))

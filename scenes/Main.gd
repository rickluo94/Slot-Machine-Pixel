extends Node2D

@onready var slot = $ViewportContainer/Viewport/SlotMachine

@onready var spin_roulette = $Roll/spin_roulette
@onready var spin_coin = $Roll/spin_coin
@onready var monster = $Monster
# 已停止轉軸
var _total_stop :int = 0

func _ready():
	slot.connect("stopped", Callable(self, "_on_slot_machine_stopped"))

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
func show_damage_number(hit_position: Vector2) -> void:
	var dn := preload("res://scenes/DamageNumber.tscn").instantiate()
	add_child(dn)
	dn.position = hit_position
	var rnumber = randi_range(1, 9999)
	dn.play(rnumber)
	
func _on_slot_machine_stopped():
	monster.play("laugh")
	spin_coin.stop()
	_count_stopped_show_damage()
	
	#$Roll.text = "Roll"
func _count_stopped_show_damage():
	_total_stop += 1
	if (_total_stop >= 4):
		show_damage_number(monster.position * 0.9)
		_total_stop = 0

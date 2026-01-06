extends Node2D

@onready var slot = $ViewportContainer/Viewport/SlotMachine

@onready var spin_roulette = $Roll/spin_roulette
@onready var spin_coin = $Roll/spin_coin
@onready var monster = $Monster

func _ready():
	slot.connect("stopped", Callable(self, "_on_slot_machine_stopped"))

func _on_Roll_button_down():
	if slot.state == slot.State.OFF:
		monster.play("draw")
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
	print("machine_stopped")
	monster.play("laugh")
	spin_coin.stop()
	#$Roll.text = "Roll"

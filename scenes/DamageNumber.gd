extends Node2D
class_name DamageNumber

# 數字間距
@export var digit_spacing: float = 20.0
# 漂浮高度
@export var rise_distance: float = 100.0
# 持續時間
@export var duration: float = 1
# 最多顯示幾位（可調）
@export var max_digits: int = 8  

@onready var digits_holder: Node2D = $Digits

# 0~9 的貼圖來源（從你現有 Digits_0~9 取出）
var digit_textures: Array[Texture2D] = []

# 實際顯示用的 slot（每一位一個 Sprite2D）
var slots: Array[Sprite2D] = []


func _ready() -> void:
	_cache_digit_textures()
	_build_slots(max_digits)
	_hide_all_slots()
	
func play(value: int) -> void:
	_hide_all_slots()
	var text := str(value)
	var count := 0
	# 填 slot：每個字元用一個 slot（因此 9999 會有 4 個 slot 顯示 9）
	for i in range(text.length()):
		if not text[i].is_valid_int():
			continue
		if count >= slots.size():
			break
		var n := int(text[i])
		var s := slots[count]
		s.texture = digit_textures[n]
		s.visible = true
		count += 1
		
	_layout_slots_centered(count)
	_play_hit_animation()
	#_play_crit_shake()
	
# -------------------------------------------------
# Setup
# -------------------------------------------------
func _cache_digit_textures() -> void:
	digit_textures.clear()
	digit_textures.resize(10)
	
	for i in range(10):
		var node := digits_holder.get_node("Digits_%d" % i) as Sprite2D
		digit_textures[i] = node.texture
		node.visible = false  # 模板不顯示
		
func _build_slots(n: int) -> void:
	# 建立顯示槽 Slot_0..Slot_(n-1)
	slots.clear()
	for i in range(n):
		var s := Sprite2D.new()
		s.name = "Slot_%d" % i
		s.visible = false
		digits_holder.add_child(s)
		slots.append(s)
		
func _hide_all_slots() -> void:
	for s in slots:
		s.visible = false
		
# -------------------------------------------------
# Layout
# -------------------------------------------------
func _layout_slots_centered(count: int) -> void:
	if count <= 0:
		return
	var total_width := float(count - 1) * digit_spacing
	var start_x := -total_width * 0.5
	for i in range(count):
		slots[i].position = Vector2(start_x + float(i) * digit_spacing, 0.0)
		
# -------------------------------------------------
# Animation (打擊感：小 → 標準 → 彈跳 → 上浮 → 消失)
# -------------------------------------------------
func _play_hit_animation() -> void:
	# 初始：被打中的壓縮感
	scale = Vector2.ONE * 1.2
	modulate.a = 1.0
	
	var tween := create_tween()
	
	# 1️⃣ 小 → 大（瞬間衝出）
	tween.tween_property(
		self,
		"scale",
		Vector2.ONE * 1.2,
		0.08
	).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	
	# 2️⃣ 彈跳上浮（同時進行）
	#    scale 回到 1.0 + position 往上
	tween.parallel().tween_property(
		self,
		"scale",
		Vector2.ONE * 2,
		0.12
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	tween.parallel().tween_property(
		self,
		"position",
		position + Vector2(0, -rise_distance),
		duration
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	# 3️⃣ 消失（淡出）
	tween.parallel().tween_property(
		self,
		"modulate:a",
		0.0,
		0.2
	).set_delay(duration - 0.2)
	
	# 4️⃣ 結束後釋放
	tween.finished.connect(func():
		queue_free()
	)
	
# 爆擊
func _play_crit_shake(
	strength: float = 10.0,
	shake_time: float = 0.16,
	frequency: int = 6
) -> void:
	scale = Vector2.ONE * 1.6
	
	# 以「目前畫面位置」為基準
	var base_pos := position
	
	var tween := create_tween()
	
	tween.set_parallel(false)
	
	for i in range(frequency):
		var offset := Vector2(
			randf_range(-strength, strength),
			randf_range(-strength, strength)
		)
		tween.tween_property(
			self,
			"position",
			base_pos + offset,
			shake_time / float(frequency)
		).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		
	# 結尾一定要回到 base_pos（關鍵）
	tween.tween_property(
		self,
		"position",
		base_pos,
		0.04
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	# 消失（淡出）
	tween.parallel().tween_property(
		self,
		"modulate:a",
		0.0,
		0.2
	).set_delay(duration - 0.2)
	
	# 結束後釋放
	tween.finished.connect(func():
		queue_free()
	)
	

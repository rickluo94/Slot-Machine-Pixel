extends Node2D
class_name SlotMachine

const SlotTile := preload("res://scenes/SlotTile.tscn")
const Player := preload("res://scenes/Player.tscn")
const ActionEffect := preload("res://scenes/ActionEffect.tscn")

@onready var player_coin := $"../../../PlayerCoin"

var player:Node2D
var actionEffect:Node2D

# 儲存 SlotTile 的 SPIN_UP 動畫移動距離
const SPIN_UP_DISTANCE = 100.0


signal stopped

# 材質陣列
@export var pictures :Array[Texture2D] = [
	# 小丑 Joker (0)
	preload("res://sprites/kenney_playing-cards-pack/PNG/Cards (large)/card_joker_red_v2.png"),
	# 黑桃 (1-13)
	preload("res://sprites/kenney_playing-cards-pack/PNG/Cards (large)/card_spades_A.png"),
	preload("res://sprites/kenney_playing-cards-pack/PNG/Cards (large)/card_spades_02.png"),
	preload("res://sprites/kenney_playing-cards-pack/PNG/Cards (large)/card_spades_03.png"),
	preload("res://sprites/kenney_playing-cards-pack/PNG/Cards (large)/card_spades_04.png"),
	preload("res://sprites/kenney_playing-cards-pack/PNG/Cards (large)/card_spades_05.png"),
	preload("res://sprites/kenney_playing-cards-pack/PNG/Cards (large)/card_spades_06.png"),
	preload("res://sprites/kenney_playing-cards-pack/PNG/Cards (large)/card_spades_07.png"),
	preload("res://sprites/kenney_playing-cards-pack/PNG/Cards (large)/card_spades_08.png"),
	preload("res://sprites/kenney_playing-cards-pack/PNG/Cards (large)/card_spades_09.png"),
	preload("res://sprites/kenney_playing-cards-pack/PNG/Cards (large)/card_spades_10.png"),
	preload("res://sprites/kenney_playing-cards-pack/PNG/Cards (large)/card_spades_J.png"),
	preload("res://sprites/kenney_playing-cards-pack/PNG/Cards (large)/card_spades_Q.png"),
	preload("res://sprites/kenney_playing-cards-pack/PNG/Cards (large)/card_spades_K.png"),
	# 紅心 (14-26)
	preload("res://sprites/kenney_playing-cards-pack/PNG/Cards (large)/card_hearts_A.png"),
	preload("res://sprites/kenney_playing-cards-pack/PNG/Cards (large)/card_hearts_02.png"),
	preload("res://sprites/kenney_playing-cards-pack/PNG/Cards (large)/card_hearts_03.png"),
	preload("res://sprites/kenney_playing-cards-pack/PNG/Cards (large)/card_hearts_04.png"),
	preload("res://sprites/kenney_playing-cards-pack/PNG/Cards (large)/card_hearts_05.png"),
	preload("res://sprites/kenney_playing-cards-pack/PNG/Cards (large)/card_hearts_06.png"),
	preload("res://sprites/kenney_playing-cards-pack/PNG/Cards (large)/card_hearts_07.png"),
	preload("res://sprites/kenney_playing-cards-pack/PNG/Cards (large)/card_hearts_08.png"),
	preload("res://sprites/kenney_playing-cards-pack/PNG/Cards (large)/card_hearts_09.png"),
	preload("res://sprites/kenney_playing-cards-pack/PNG/Cards (large)/card_hearts_10.png"),
	preload("res://sprites/kenney_playing-cards-pack/PNG/Cards (large)/card_hearts_J.png"),
	preload("res://sprites/kenney_playing-cards-pack/PNG/Cards (large)/card_hearts_Q.png"),
	preload("res://sprites/kenney_playing-cards-pack/PNG/Cards (large)/card_hearts_K.png"),
	# 方塊 (27-39)
	preload("res://sprites/kenney_playing-cards-pack/PNG/Cards (large)/card_diamonds_A.png"),
	preload("res://sprites/kenney_playing-cards-pack/PNG/Cards (large)/card_diamonds_02.png"),
	preload("res://sprites/kenney_playing-cards-pack/PNG/Cards (large)/card_diamonds_03.png"),
	preload("res://sprites/kenney_playing-cards-pack/PNG/Cards (large)/card_diamonds_04.png"),
	preload("res://sprites/kenney_playing-cards-pack/PNG/Cards (large)/card_diamonds_05.png"),
	preload("res://sprites/kenney_playing-cards-pack/PNG/Cards (large)/card_diamonds_06.png"),
	preload("res://sprites/kenney_playing-cards-pack/PNG/Cards (large)/card_diamonds_07.png"),
	preload("res://sprites/kenney_playing-cards-pack/PNG/Cards (large)/card_diamonds_08.png"),
	preload("res://sprites/kenney_playing-cards-pack/PNG/Cards (large)/card_diamonds_09.png"),
	preload("res://sprites/kenney_playing-cards-pack/PNG/Cards (large)/card_diamonds_10.png"),
	preload("res://sprites/kenney_playing-cards-pack/PNG/Cards (large)/card_diamonds_J.png"),
	preload("res://sprites/kenney_playing-cards-pack/PNG/Cards (large)/card_diamonds_Q.png"),
	preload("res://sprites/kenney_playing-cards-pack/PNG/Cards (large)/card_diamonds_K.png"),
	# 梅花 (40-52)
	preload("res://sprites/kenney_playing-cards-pack/PNG/Cards (large)/card_clubs_A.png"),
	preload("res://sprites/kenney_playing-cards-pack/PNG/Cards (large)/card_clubs_02.png"),
	preload("res://sprites/kenney_playing-cards-pack/PNG/Cards (large)/card_clubs_03.png"),
	preload("res://sprites/kenney_playing-cards-pack/PNG/Cards (large)/card_clubs_04.png"),
	preload("res://sprites/kenney_playing-cards-pack/PNG/Cards (large)/card_clubs_05.png"),
	preload("res://sprites/kenney_playing-cards-pack/PNG/Cards (large)/card_clubs_06.png"),
	preload("res://sprites/kenney_playing-cards-pack/PNG/Cards (large)/card_clubs_07.png"),
	preload("res://sprites/kenney_playing-cards-pack/PNG/Cards (large)/card_clubs_08.png"),
	preload("res://sprites/kenney_playing-cards-pack/PNG/Cards (large)/card_clubs_09.png"),
	preload("res://sprites/kenney_playing-cards-pack/PNG/Cards (large)/card_clubs_10.png"),
	preload("res://sprites/kenney_playing-cards-pack/PNG/Cards (large)/card_clubs_J.png"),
	preload("res://sprites/kenney_playing-cards-pack/PNG/Cards (large)/card_clubs_Q.png"),
	preload("res://sprites/kenney_playing-cards-pack/PNG/Cards (large)/card_clubs_K.png"),
]

# 定義有幾個轉軸
@export_range(1,20) var reels :int = 5
# 定義轉軸有幾個瓦片數字
@export_range(1,20) var tiles_per_reel :int = 4
# 定義轉軸旋轉的持續時間
@export_range(0,10) var runtime :float = 2.0
# 定義轉軸旋轉的速度
@export_range(0.1,10) var speed :float = 5.0
# 定義每個轉軸之間的啟動延遲時間
@export_range(0,2) var reel_delay :float = 0.3

# 定義安全邊界
@export var grid_padding := Vector2(128, 128)

# 依照視窗大小調整瓦片尺寸
@onready var viewport_size := get_viewport_rect().size
@onready var usable_size := viewport_size - grid_padding * 2
@onready var tile_size := usable_size / Vector2(reels, tiles_per_reel)
# 將速度正規化，使其不受瓦片數量影響而保持一致
@onready var speed_norm := speed * tiles_per_reel
# 在每個捲軸中增加瓦片在鏡頭外增加動畫流暢度
# Grid 增加兩個瓦片在前後的 TODO 當前也會因為增加的瓦片在停止時未依照預期結果
@onready var extra_tiles := 0 #int(ceil(SPIN_UP_DISTANCE / tile_size.y)*2)

# 儲存實際的瓦片列數
@onready var rows := tiles_per_reel + extra_tiles

enum State {OFF, ON, STOPPED}
var state = State.OFF
var result := {}

# 儲存 SlotTile 實例
var tiles := []
# 儲存每個格子左上角的位置
var grid_pos := []

# 1/speed*runtime*reels 次
# 儲存每個轉軸期望的移動次數
@onready var expected_runs :int = int(runtime * speed_norm)
# 儲存每個轉軸目前已移動的次數
var tiles_moved_per_reel := []
# 當被強制停止時，儲存目前的移動次數
var runs_stopped := 0
# 儲存與實際執行方式無關的總移動次數
var total_runs : int

# 儲存連線位置
var wins := []

# 儲存連線花色
var wins_suit := []

# 已停止轉軸
var _total_stop_col :int = 0

# 已停止轉軸
var _total_stop :int = 0

# 決定「數字」權重
var SYMBOL_WEIGHT := {}

# 決定「花色」權重
var SYMBOL_SUIT_WEIGHT := {}

# 贏分
var WIN_POINT := 0

# BOSS 金幣數量
var MONSTER_COINS :int = 100

# 聲音
@onready var spin_sound = $"../../../SpinSound"
@onready var stop_sound = $"../../../StopSound"
@onready var bgm_sound = $"../../../BGMSound"
@onready var big_win_sound = $"../../../BigWinSound"
@onready var big_win_coin_sound = $"../../../BigWinCoinSound"
@onready var Jackpot_sound = $"../../../JackpotSound"
@onready var MegaWin_Sound = $"../../../MegaWinSound"

# 得獎大圖
@onready var big_win_coin_img = $"../../../big_win_coin"
@onready var coin_treasure_img = $"../../../coin_treasure"

# 動畫
@onready var bigWin_Ani = $"../../../turmp_point"

	
	
func _on_anim_finished():
	big_win_coin_img.visible = false
	coin_treasure_img.visible = false
	bigWin_Ani.visible = false
	bigWin_Ani.pause()
	big_win_sound.stop()
	big_win_coin_sound.stop()
	
func bigWin_Ani_ini():
	big_win_coin_img.visible = false
	coin_treasure_img.visible = false
	bigWin_Ani.visible = false
	
func play_once_bigWin_Ani():
	big_win_coin_img.pop_big()
	big_win_coin_img.visible = true
	coin_treasure_img.visible = true
	bigWin_Ani.visible = true
	bigWin_Ani.frame = 0
	bigWin_Ani.play()
	big_win_sound.play()
	big_win_coin_sound.play()

func _count_stopped():
	_total_stop_col += 1
	if (_total_stop_col >= 4):
		play_all_wins()
		_total_stop_col = 0
		
func _init_math():
	# 層級 2：決定「數字」權重
	SYMBOL_WEIGHT = {
		0: 1,
		1: 14,
		2: 13,
		3: 12,
		4: 11,
		5: 10,
		6: 9,
		7: 8,
		8: 7,
		9: 6,
		10: 5,
		11: 4,
		12: 3,
		13: 2
	}
	
	# 層級 3：決定「花色」
	SYMBOL_SUIT_WEIGHT = {
		1: 1,
		2: 1,
		3: 1,
		4: 1,
	}
	
func _init_tiles():
	for col in range(reels):
		grid_pos.append([])
		tiles_moved_per_reel.append(0)
		for row in range(rows):
			var pos := Vector2(
				col,
				row - 0.5 * extra_tiles
			) * tile_size + grid_padding
			grid_pos[col].append(pos)
			_add_tile(col, row)
			
func _ready():
	# BGM
	bgm_sound.play()
	
	# 初始化權重數值
	_init_math()
	
	# WIN ANI
	bigWin_Ani_ini()
	
	# 初始化瓦片格子
	_init_tiles()

  
# 在指定的格子位置儲存並初始化一個新的瓦片
func _add_tile(col :int, row :int) -> void:
	tiles.append(SlotTile.instantiate())
	var tile := get_tile(col, row)
	tile.set_speed(speed_norm)
	tile.set_texture(_randomTexture())
	tile.set_text("col: %d row: %d" % [col, row])
	tile.set_size(tile_size)
	tile.position = grid_pos[col][row]
	add_child(tile)
	tile.show_text()
	print("{index: ",tiles.size(), ", col: %d ,row: %d}" % [col, row])

# 回傳指定格子位置的瓦片
func get_tile(col :int, row :int) -> SlotTile:
	return tiles[(col * rows) + row]
	
func start() -> void:
	_on_anim_finished()
	# 僅在尚未運作時才開始
	if state == State.OFF:
		state = State.ON
		total_runs = expected_runs
		# 停止所有瓦片動畫
		for tile in tiles:
			tile.card_reset()
		# 向伺服器請求結果
		_get_result()
		print("Start Get Random :",result)
		# 旋轉所有轉軸
		for reel in reels:
			_spin_reel(reel)
			# 稍後再旋轉下一個轉軸
			if reel_delay > 0:
				spin_sound.play(0.1)
				await get_tree().create_timer(reel_delay).timeout
				spin_sound.stop()

# 在運行時間結束前強制停止機器
func stop():
	# 告知機器在下一個可行時機停止
	state = State.STOPPED
	# 儲存第一個轉軸目前的移動次數
	# 增加移動次數以更新瓦片為結果圖片
	runs_stopped = current_runs()
	total_runs = runs_stopped + tiles_per_reel
	print(" total_runs: ",total_runs);
	
# 當動畫停止時呼叫
func _stop() -> void:
	for reel in reels:
		tiles_moved_per_reel[reel] = 0
	state = State.OFF
	emit_signal("stopped")
	_count_stopped()
	
# 開始移動指定轉軸上的所有瓦片
func _spin_reel(reel :int) -> void:
	# 移動該轉軸上的每一個瓦片
	spin_sound.stop()
	for row in rows:
		_move_tile(get_tile(reel, row))

func _move_tile(tile :SlotTile) -> void:
	# 播放啟動旋轉動畫
	tile.spin_up()
	await tile.get_node("Animations").animation_finished
	# 每次只移動一個瓦片高度，以避免速度過快產生的畫面瑕疵
	tile.move_by(Vector2(0, tile_size.y))
	# 轉軸會在 _on_tile_moved 函式中繼續移動
  
func _on_tile_moved(tile: SlotTile, _nodePath) -> void:
	# 計算該瓦片所屬的轉軸
	var reel := int(tile.position.x / tile_size.x)
	# 計算每個轉軸已移動的瓦片數量
	tiles_moved_per_reel[reel] += 1
	var reel_runs := current_runs(reel)
	var current_idx = total_runs - reel_runs
	
	
	# 若瓦片移出視窗，則將其移到最上方的不可見列
	if (tile.position.y > grid_pos[0][-1].y):
		tile.position.y = grid_pos[0][0].y
		
		# 設定新的隨機貼圖
		if (tiles_per_reel > current_idx):
			# 判斷當前是否為命中瓦片
			if (is_win_tile(reel,current_idx,wins)):
				tile.show_text()
			else:
				tile.hide_text()
			# 針對特定數字設定效果
			if (result.tiles[reel][current_idx] == 0):
				tile.set_arlez80s_glitch_card_shader()
			else:
				tile.reset_shader_empty()
			tile.set_texture(pictures[result.tiles[reel][current_idx]])
			# 停轉時設定層級避免遮擋
			tile.set_index(current_idx)
		else:
			tile.set_texture(_randomTexture())
				
	# 當轉軸達到期望的移動次數後停止
	# 或者玩家已強制停止
	if (state != State.OFF && reel_runs < total_runs):
		tile.move_by(Vector2(0, tile_size.y))
	else: # 停止該轉軸的移動
		tile.spin_down()
		stop_sound.stop()
		stop_sound.play()
		await tile.get_node("Animations").animation_finished
		# 當最後一個轉軸停止時，整台機器停止
		if reel == reels - 1:
			_stop()

# 將移動次數除以瓦片數量，以得知整個轉軸移動了幾次
# 由於此函式會被每個瓦片呼叫，數值會逐步變化（例如 6 個瓦片時：1/6、2/6...）
# 使用 ceil，確保 1/7 與 7/7 都會回傳轉軸已運行 1 次
func current_runs(reel_idex := 0) -> int:
	return int(ceil(float(tiles_moved_per_reel[reel_idex]) / rows))

func _randomTexture() -> Texture2D:
	return pictures[randi() % pictures.size()]

# 取得結果
func _get_result() -> void:
	
	# 層級 1：先決定「這一把會不會中」
	var hit_rate := 0.35 # 35% 命中機率
	var is_win := randf() < hit_rate # 贏或輸
	var prepare_tiles: Array = []
	
	
	prepare_tiles = generate_tiles_v1(SYMBOL_WEIGHT,SYMBOL_SUIT_WEIGHT)
	#prepare_tiles = [
			#[44, 5, 2, 8], 
			#[5, 49, 9, 3], 
			#[33, 5, 5, 16], 
			#[33, 9, 7, 25], 
			#[33, 0, 47, 12]
		#]
		
	# 瓦片材質陣列
	var format_tiles:=[]
	for tile in prepare_tiles:
		var format_line := []
		for t in tile:
			format_line.append(t.pic_index)
		format_tiles.append(format_line)
	
	# 取數字
	var symbol_tiles:=[]
	for tile in prepare_tiles:
		var symbol_line := []
		for t in tile:
			symbol_line.append(t.symbol)
		symbol_tiles.append(symbol_line)
		
	# 判斷數字連線
	check_all_line(symbol_tiles)
	
	# 取花色
	var suit_tiles:=[]
	for tile in prepare_tiles:
		var suit_line := []
		for t in tile:
			suit_line.append(t.suit)
		suit_tiles.append(suit_line)
		
	# 判斷花色連線
	check_suit_line(suit_tiles)
	
	print(prepare_tiles)
	
	# 印出所有連線
	print(wins)
	
	# 贏得分數
	print("Win Point:",calculate_score(wins, wins_suit))
	
	result = {
		"tiles": format_tiles
	}
	
# 權重分佈取值
func pick_weighted(weight_map: Dictionary) -> int:
	var total_weight := 0
	for w in weight_map.values():
		total_weight += w
	var roll := randi_range(1, total_weight)
	var acc := 0
	for key in weight_map.keys():
		acc += weight_map[key]
		if roll <= acc:
			return key
	return weight_map.keys()[0]
	
# 權重分佈版本
func generate_tiles_v1(SYMBOL_WEIGHT:Dictionary,SYMBOL_SUIT_WEIGHT:Dictionary) -> Array:
	var prepare_tiles := []
	for row in range(5):
		var line := []
		for col in range(4):
			var symbol := pick_weighted(SYMBOL_WEIGHT)
			var suit := 0
			var pic_index := 0
			if (symbol != 0):
				suit = pick_weighted(SYMBOL_SUIT_WEIGHT)
			match suit:
				1:
					pic_index = symbol
				2:
					pic_index = symbol + 13
				3:
					pic_index = symbol + 26
				4:
					pic_index = symbol + 39
				_:
					pic_index = 0
			line.append({"symbol":symbol, "suit":suit, "pic_index": pic_index})
		prepare_tiles.append(line)
	return prepare_tiles
	
# 判斷直線
func check_vertical_linked_tiles(tiles: Array,type: String) -> Array:
	var hits:= []
	var rows: int = tiles.size()
	var cols: int = tiles[0].size()
	for col in range(cols):
		var current_symbol: int = -1
		var run_start: int = 0
		var run_length: int = 0
		for row in range(rows):
			var v: int = tiles[row][col]
			if v == current_symbol:
				run_length += 1
			else:
				# 結束上一段
				if run_length >= 3:
					for i in range(run_length):
						hits.append({
							"type": type,
							"directions": "→",
							"col": run_start + i,
							"row": col,
							"symbol": current_symbol,
							"point": 1
						})
				# 開新段
				current_symbol = v
				run_start = row
				run_length = 1
		# 處理結尾段
		if run_length >= 3:
			for i in range(run_length):
				hits.append({
					"type": type,
					"directions": "→",
					"col": run_start + i,
					"row": col,
					"symbol": current_symbol,
					"point": 1
				})
	return hits
	
# 判斷斜線向上 ↗
#func check_diagonal_up_right(tiles: Array) -> Array:
	#var hits: Array = []
	#var rows: int = tiles.size()
	#var cols: int = tiles[0].size()
	#for row in range(2, rows):
		#for col in range(cols - 2):
			#var v: int = tiles[row][col]
			#if tiles[row - 1][col + 1] == v and tiles[row - 2][col + 2] == v:
				## 展開成 3 個命中格子
				#for i in range(3):
					#hits.append({
						#"type": "↗",
						#"row": row,
						#"col": col + i,
						#"symbol": v
					#})
	#return hits
	
# 判斷斜線向下
#func check_diagonal_down_right(tiles: Array) -> Array:
	#var hits: Array = []
	#var rows: int = tiles.size()
	#var cols: int = tiles[0].size()
	#
	#for row in range(rows - 2):
		#for col in range(cols - 2):
			#var v: int = tiles[row][col]
			#
			#if tiles[row + 1][col + 1] == v and tiles[row + 2][col + 2] == v:
				#for i in range(3):
					#hits.append({
						#"type": "↘",
						#"row": row + i,
						#"col": col + i,
						#"symbol": v
					#})
					#
	#return hits
	
# 檢查所有線
func check_all_line(tiles: Array) -> Array:
	# 初始化
	wins = []
	wins += check_vertical_linked_tiles(tiles,"number")
	return wins
	
func check_suit_line(tiles: Array) -> Array:
	# 初始化
	wins_suit = []
	wins_suit += check_vertical_linked_tiles(tiles,"suit")
	return wins_suit
	
# 判斷當前是否命中內
func is_win_tile(col: int, row: int, wins: Array) -> bool:
	for p in wins:
		if p.row == row and p.col == col:
			return true
	return false
	
# 計分用
func calculate_score(wins, wins_suit) -> int:
	var score := 0
	
	for w in wins:
		score += w.point
		
	for w in wins_suit:
		score += w.point
		
	return score
	
			
# 播放命中動畫
func play_all_wins():
	await play_win_group(wins, "CARD_FIRE")
	await play_suit_group(wins_suit)
				
# 播放數字連線
func play_win_group(win_list, anim_type: String) -> void:
	var playing := []
	
	for w in win_list:
		for tile in tiles:
			if tile.position == grid_pos[w.col][w.row]:
				playing.append(tile)
				tile.play_sequence([{ "type": anim_type }])
				
	# 等所有 tile 播完
	for tile in playing:
		await tile.sequence_finished
		
# 播放花色連線
func play_suit_group(win_list) -> void:
	var playing := []
	
	for w in win_list:
		var anim := suit_to_anim(w.symbol)
		
		for tile in tiles:
			if tile.position == grid_pos[w.col][w.row]:
				playing.append(tile)
				tile.play_sequence([{ "type": anim }])
				
	for tile in playing:
		await tile.sequence_finished
		
func build_win_animation_list():
	var list := []
	
	for w in wins:
		list.append({
			"win": w,
			"anim": "CARD_FIRE"
		})
		
	for w in wins_suit:
		list.append({
			"win": w,
			"anim": suit_to_anim(w.symbol)
		})
		
	return list
	
func suit_to_anim(symbol: int) -> String:
	match symbol:
		1: return "CARD_SUITS_SPADES"
		2: return "CARD_SUITS_HEARTS"
		3: return "CARD_SUITS_DIAMONDS"
		4: return "CARD_SUITS_CLUBS"
		_: return ""
		
func count_stopped_show_damage(hit_position:Vector2):
	_total_stop += 1
	if (_total_stop >= 4):
		show_damage_number(hit_position)
		_total_stop = 0
		
func show_damage_number(hit_position: Vector2) -> void:
	var rnumber = calculate_score(wins, wins_suit)
	if (rnumber <= 0):
		return
	var dn := preload("res://scenes/DamageNumber.tscn").instantiate()
	dn.connect("request_coin_animation", Callable(self, "_on_request_coin_animation"))
	
	var main := get_tree().current_scene
	main.add_child(dn)
	dn.global_position = hit_position
	dn.play(rnumber)
	
func _on_request_coin_animation(win_tier):
	player_coin.play_coin_animation(win_tier)

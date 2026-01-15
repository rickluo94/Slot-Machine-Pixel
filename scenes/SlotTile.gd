extends Node2D
class_name SlotTile

var _size : Vector2
var _speed : float

@onready var _sprite = $Sprite
@onready var _label = $Sprite/Label

signal finished

func _ready() -> void:
	pass
	
func show_text():
	_label.visible = true
	
func hide_text():
	_label.visible = false
	
func set_texture(tex):
	$Sprite.texture = tex
	set_size(_size)

func set_size(new_size: Vector2):
	_size = new_size
	$Sprite.scale = _size / $Sprite.texture.get_size()
	
func set_text(new_text: String):
	$Sprite/Label.text = new_text
	$Sprite/Label.add_theme_font_size_override("font_size", 8)
	$Sprite/Label.add_theme_color_override("font_color", Color("00ff00ff"))

func set_speed(new_speed: float):
	_speed = new_speed

func move_to(to: Vector2):
	var tween : Tween = create_tween()
	tween.set_speed_scale(_speed)
	tween.tween_interval(0.6)
	tween.tween_property(self, "position", to, 1.0).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	tween.tween_callback(func(): _on_finished())
	
func move_by(by: Vector2):
	move_to(position + by)
	
func spin_up():
	$Animations.play('SPIN_UP')
  
func spin_down():
	$Animations.play('SPIN_DOWN')

func card_scale():
	$Animations.play('SPIN_SCALE')
	
func card_fire():
	$Animations.play('CARD_FIRE')
	
func card_suits_spades():
	$Animations.play('CARD_SUITS_SPADES')
	
func card_reset():
	$Animations.play("RESET")
	
func play_anim(anim: StringName) -> void:
	$Animations.play(anim)
	await finished
		
func play_sequence(sequence: Array) -> void:
	for step in sequence:
		match step.type:
			"spin_up":
				await play_anim("SPIN_UP")
			"spin_down":
				await play_anim("SPIN_DOWN")
			"scale":
				await play_anim("SPIN_SCALE")
			"fire":
				await play_anim("CARD_FIRE")
			"suits_spades":
				await play_anim("CARD_SUITS_SPADES")
			"reset":
				await play_anim("RESET")
	
func set_foil_card_shader():
	var shader := load("res://VFX/shaders/Balatro_Foil_card_effect.gdshader")
	var mat := ShaderMaterial.new()
	mat.shader = shader
	# 設定 shader 參數
	_sprite.material = mat
	
func set_fire_card_shader():
	var shader := load("res://VFX/shaders/Balatro_Fire.gdshader")
	var mat := ShaderMaterial.new()
	mat.shader = shader
	var n := NoiseTexture2D.new()
	n.noise = FastNoiseLite.new()
	mat.set_shader_parameter("noise_tex", n)
	# 設定 shader 參數
	_sprite.material = mat
	
func reset_shader_empty():
	_sprite.material = null
	
func _on_finished():
	get_parent()._on_tile_moved(self, self)

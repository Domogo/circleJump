extends Node

# warning-ignore:unused_class_variable
var score_file = "user://highscore.save"
# settings save file - to remember settings
var settings_file = "user://settings.save"
var enable_sound = true
var enable_music = true

# warning-ignore:unused_class_variable
var circles_per_level = 5

var color_schemes = {
	"NEON1": {
		'background': Color8(0, 0, 0),
		'player_body': Color8(203, 255, 0),
		'player_trail': Color8(204, 0, 255),
		'circle_fill': Color8(255, 0, 110),
		'circle_static': Color8(0, 255, 102),
		'circle_limited': Color8(204, 0, 255)
	},
	"NEON2": {
		'background': Color8(0, 0, 0),
		'player_body': Color8(246, 255, 0),
		'player_trail': Color8(255, 255, 255),
		'circle_fill': Color8(255, 0, 110),
		'circle_static': Color8(151, 255, 48),
		'circle_limited': Color8(127, 0, 255)
	},
	"NEON3": {
		'background': Color8(0, 0, 0),
		'player_body': Color8(255, 0, 187),
		'player_trail': Color8(255, 148, 0),
		'circle_fill': Color8(255, 148, 0),
		'circle_static': Color8(170, 255, 0),
		'circle_limited': Color8(204, 0, 255)
	}
}

# warning-ignore:unused_class_variable
var theme = color_schemes["NEON1"]

static func rand_weighted(weights):
	var sum = 0
	for weight in weights:
		sum += weight

	var num = rand_range(0, sum)
	for i in weights.size():
		if num < weights[i]:
			return i
		num -= weights[i]

func _ready():
	load_settings()

func save_settings():
	var f = File.new()
	f.open(settings_file, File.WRITE)
	f.store_var(enable_sound)
	f.store_var(enable_music)
	f.close()

func load_settings():
	var f = File.new()
	if f.file_exists(settings_file):
		f.open(settings_file, File.READ)
		enable_sound = f.get_var()
		enable_music = f.get_var()
		f.close()

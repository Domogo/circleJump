extends Area2D

onready var orbit_position = $Pivot/OrbitPosition

enum MODES {STATIC, LIMITED}

var radius = 100
var rotation_speed = PI
var mode = MODES.STATIC
var num_orbits = 3
var current_orbits = 0
var orbit_start = null
var jumper = null

func init(_position, _radius=radius, _mode=MODES.LIMITED):
	set_mode(_mode)
	position = _position
	radius = _radius
	$CollisionShape2D.shape = $CollisionShape2D.shape.duplicate()
	$CollisionShape2D.shape.radius = radius
	var img_size = $Sprite.texture.get_size().x / 2
	$Sprite.scale = Vector2(1, 1) * radius / img_size
	orbit_position.position.x = radius + 25

func set_mode(_mode):
	mode = _mode
	match mode:
		MODES.STATIC:
			$Label.hide()
		MODES.LIMITED:
			current_orbits = num_orbits
			$Label.set_text(str(current_orbits))
			$Label.show()

func _process(delta):
	$Pivot.rotation += rotation_speed * delta
	if mode == MODES.LIMITED and jumper:
		check_orbits()

func check_orbits():
	if abs($Pivot.rotation - orbit_start) > 2 * PI:
		current_orbits -= 1
		$Label.set_text(str(current_orbits))
		orbit_start = $Pivot.rotation

func implode():
	$AnimationPlayer.play("implode")
	yield($AnimationPlayer, "animation_finished")
	queue_free()

func capture(_jumper):
	jumper = _jumper
	$AnimationPlayer.play("capture")
	$Pivot.rotation = (jumper.position - position).angle()
	orbit_start = $Pivot.rotation

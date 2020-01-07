extends Area2D

onready var orbit_position = $Pivot/OrbitPosition
onready var move_tween = $MoveTween

enum MODES {STATIC, LIMITED}

var radius = 100
var rotation_speed = PI
var mode = MODES.STATIC
var move_range = 100
var move_speed = 1.0
var num_orbits = 3
var current_orbits = 0
var orbit_start = null
var jumper = null

func init(_position, _radius=radius, _mode=MODES.LIMITED):
	set_mode(_mode)
	position = _position
	radius = _radius
	$Sprite.material = $Sprite.material.duplicate()
	$SpriteEffect.material = $Sprite.material
	$CollisionShape2D.shape = $CollisionShape2D.shape.duplicate()
	$CollisionShape2D.shape.radius = radius
	var img_size = $Sprite.texture.get_size().x / 2
	$Sprite.scale = Vector2(1, 1) * radius / img_size
	orbit_position.position.x = radius + 25
	set_tween()

func set_mode(_mode):
	mode = _mode
	var color
	match mode:
		MODES.STATIC:
			$Label.hide()
			color = settings.theme["circle_static"]
		MODES.LIMITED:
			current_orbits = num_orbits
			$Label.set_text(str(current_orbits))
			$Label.show()
			color = settings.theme["circle_limited"]
	$Sprite.material.set_shader_param("color", color)

func _process(delta):
	$Pivot.rotation += rotation_speed * delta
	if mode == MODES.LIMITED and jumper:
		check_orbits()
		update()

func check_orbits():
	if abs($Pivot.rotation - orbit_start) > 2 * PI:
		current_orbits -= 1
		if settings.enable_sound:
			$Beep.play()
		$Label.set_text(str(current_orbits))
		if current_orbits <= 0:
			jumper.die()
			jumper = null
			implode()
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

func _draw():
    if jumper:
        var r = ((radius - 50) / num_orbits) * (1 + num_orbits - current_orbits)
        draw_circle_arc_poly(Vector2.ZERO, r, orbit_start + PI/2,
                            $Pivot.rotation + PI/2, settings.theme["circle_fill"])

func draw_circle_arc_poly(center, draw_radius, angle_from, angle_to, color):
    var nb_points = 32
    var points_arc = PoolVector2Array()
    points_arc.push_back(center)
    var colors = PoolColorArray([color])

    for i in range(nb_points + 1):
        var angle_point = angle_from + i * (angle_to - angle_from) / nb_points - PI/2
        points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * draw_radius)
    draw_polygon(points_arc, colors)

func set_tween(object=null, key=null):
	if move_range == 0:
		return
	move_range *= -1
	move_tween.interpolate_property(self, "position:x",
				position.x, position.x + move_range,
				move_speed, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	move_tween.start()

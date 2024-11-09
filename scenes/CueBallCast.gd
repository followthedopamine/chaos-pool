extends ShapeCast2D

var hit_points
@onready var cue_ball = $"../../CueBall"
@onready var cue_ball_shape = $"../../CueBall/CueBallCollision"

func _ready():
	shape = cue_ball_shape.shape

func get_player_target():
	return get_global_mouse_position()
	
func get_player_target_direction():
	var direction = (get_player_target() - global_position).normalized()
	return direction

func cast_shape():
	#rotation = get_parent().rotation
	global_position = cue_ball.global_position
	#var extended_point = get_player_target_direction() * 1000
	#var shape_cast = ShapeCast2D.new()
	#target_position = extended_point
	#print(shape_cast.collision_result)
	#hit_points = extended_point
	var closest_distance = INF
	var closest_point = Vector2.INF
	
	for i in range(0, get_collision_count()):
		var collision_point = get_collision_point(i)
		var radius = cue_ball_shape.shape.radius
		var hit_direction = get_collision_normal(i)
		collision_point = collision_point + (hit_direction * radius)
		var distance = global_position.distance_to(collision_point)
		if distance < closest_distance:
			closest_distance = distance
			closest_point = collision_point
			
		hit_points = closest_point
		#print(get_collision_point(i))
		
	
	queue_redraw()
		
func _draw():
	if hit_points != null:
		draw_line(to_local(global_position), to_local(hit_points), Color(1, 1, 1, 0.3), 1.5)
		#draw_circle(to_local(hit_points), cue_ball_shape.shape.radius, Color(1, 0, 0, 0.3))
		draw_arc(to_local(hit_points), cue_ball_shape.shape.radius, 0, TAU, 50, Color(1, 1, 1, 0.3), 1.5)
		
func _physics_process(delta):
	cast_shape()


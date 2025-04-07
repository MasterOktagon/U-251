extends Node2D


var cooldown = 2
var battery := preload("res://scenes/battery_enemy.tscn")

var n : int = 0
var ppos: Vector2 = Vector2(0,0)
var rays: Array[CustomRaycast] = []

func _ready() -> void:
	randomize()
	$Timer.start(cooldown)

func _process(delta: float) -> void:
	for r in rays:
		r.process()

func _on_player_move(pos: Vector2):
	self.ppos = pos

func _on_timer_timeout() -> void:
	n = get_tree().get_node_count_in_group("Batteries")
	if n >= 10:
		$Timer.start(cooldown)
		return

	for i in range(0, 8, 1):
		var r: CustomRaycast = CustomRaycast.new()
		r.connect("got_result", self.ray_hit)
		r.p = self.ppos
		r.v = (Vector2.from_angle(i*PI/4)*5000) / 100
		r.m = 5000
		r.w = true
		r.c = $"../Map".check_depth
		rays.append(r)
	$Timer.start(cooldown)


func ray_hit(res: bool, pos: Vector2, r: CustomRaycast):
	if res:
		rays = []
		var m := battery.instantiate()
		m.depth = 0
		m.position = pos
		$"..".add_child(m)
	else:
		rays.erase(r)

class CustomRaycast:
	signal got_result(pos: Vector2)
	var c: Callable
	var p: Vector2 	# cur position
	var d: float = 0				# distance travelled
	var m: float				# max distance
	var v: Vector2	# "velocity"
	var w: bool			# in water
	var r: bool = false				# result

	func process():
		p = p+v
		d += v.length()
		if w!=(c.call(p.x,p.y)<0):
			v = -v/2
			w = !w
		
		if d>m:
			got_result.emit(r, p, self)
			return
		if v.length()<10:
			r = true
			got_result.emit(r, p, self)
			return
		

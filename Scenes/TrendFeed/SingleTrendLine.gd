"""
A Path2D and PathFollow2D which trends can follow to demonstrate activity over time.

It's possible a line2D is better suited for this, but whatever. (time pressure)
"""


extends Path2D

var current_week : int = 0
var draw_week : int = 0
var trend_name: String
var trend : Gene
var viewing_area : Rect2
onready var name_label = get_node("PathFollow2D/PathFollower/TrendName")

var color : Color

func _ready():
	#set_temporal_position(0)
	pass

func start(gene_name : String, area : Rect2):

	initialize_curve()
	viewing_area = area
	set_random_color()
	trend = DataStore.get_gene(gene_name)
	trend_name = trend.name
	name_label.set_text(trend_name)
	populate_curve(Game.week)
	set_temporal_position(float(Game.week))

func initialize_curve():
	curve = Curve2D.new()

func set_random_color():
	var colors : Array = [
		Color.red,
		Color.blueviolet,
		Color.purple,
		Color.greenyellow,
		Color.antiquewhite,
		Color.bisque,
		Color.aliceblue

	]
	color = colors[randi()%colors.size()]


func populate_curve(weeks):

#	var x_spacing = viewing_area.size.x / weeks
#	var y_spacing = viewing_area.size.y / 100

	#for week in range(weeks):
		#curve.add_point(Vector2(week * x_spacing, trend.get_temporal_value(week) * y_spacing))
	#print(self.name, " points: ", curve.get_point_count())
	update()

func set_temporal_position(week : float):
	# set the offset of the path follower
	pass










func advance():
	current_week = min(int(current_week)+1, int(Game.week))

func _draw():
	if curve.get_point_count() < 2:
		return

	var point : Vector2 = Vector2.ZERO
	var last_point : Vector2 = Vector2.ZERO

	for point_num in curve.get_point_count():
		point = curve.get_point_position(point_num)
		if point_num > 1:
			last_point = curve.get_point_position(point_num-1)
		draw_line(last_point, point, color, 1, true)
		last_point = point







func _on_NextPointTimer_timeout():
	draw_week += 1
	if draw_week < Game.week:
		var x_spacing = viewing_area.size.x / Game.week
		var y_spacing = viewing_area.size.y / 100
		curve.add_point(Vector2(draw_week * x_spacing, trend.get_temporal_value(draw_week) * y_spacing))
		$PathFollow2D.set_unit_offset(1)
		update()

		$NextPointTimer.start()

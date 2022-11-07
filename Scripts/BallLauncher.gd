extends Area2D

# What this scene should do:
# 1. Click down
# 2. Drag
# 3. When released, it will emit a signal that will pass along to whatever
#	method it is connected to, the vector we just dragged 

# A signal to connect to the ball. Will be emitted when the user stops clicking
signal vector_created(vector)

# Max length of the vector, to be able to better control the velocity
@export var maximum_length := 200

# Keep track of whether the user has clicked or not
var touch_down := false
# Start position of the dragging
var position_start := Vector2.ZERO
# End position of the dragging
var position_end := Vector2.ZERO

# The vector that will be emitted with the signal
var vector := Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
#	 Connect the 'input_event' to the method
	connect("input_event", Callable(self, "_on_input_event"))

func _draw():
#	Line following the pull
	draw_line(position_start - global_position, # From
			(position_end - global_position), # To
			Color(0,0,1,1), # Blue color
			8) # Width
	
#	Line pointing to where to launch
	draw_line(position_start - global_position, # From
			(position_start - global_position + vector), # To
			Color(1,0,0,1), # Blue color
			16) # Width

func _reset():
	position_start = Vector2.ZERO
	position_end = Vector2.ZERO
	vector = Vector2.ZERO
	queue_redraw()

# This is the dragging method
func _input(event):
#	If not touching or clicking anything, do nothing.
	if !touch_down:
		return
	
#	If mouse or touch is released
	if event.is_action_released("ui_touch"):
#		set the touch to false
		touch_down = false
#		send the signal with the vector
		emit_signal("vector_created", vector)
#		reset the values
		_reset()
		
#	If moving mouse or finger
	if event is InputEventMouseMotion:
#		set the end position to be the current event's position
		position_end = event.position
#		then set the vector to be reversed difference of the end and start but clamped at the max. 
#		This will work like a windup with a bow when you pull it back and release.
		vector = -(position_end - position_start).limit_length(maximum_length)
#		update the CanvasItem to redraw
		queue_redraw()

# This method will only trigger when the event happens in the collision shape 
# 	that we defined
func _on_input_event(_viewport, event, _shape_idx):
#	Set the event to be a click with mouse or touch of the screen
	if event.is_action_pressed("ui_touch"):
		touch_down = true
		position_start = event.position

extends Area2D

export var speed = 2.0
export var senseRadius = 4.0
var foodReserve = 1

onready var rabbit = load("res://scenes/rabbit.tscn")

var ntvel = Vector2()

var r = RandomNumberGenerator.new()

var mutation_chance = 0.1
var mutation_range = 2
var lifetime = 10
var foodNeed = 4

var target

var hunter = false


func _ready():
	r.randomize()
	$sense.scale = Vector2(senseRadius, senseRadius)
	$sense.rotation_degrees = r.randi_range(0, 360)
	if !hunter:
		$Polygon2D.color.b = 1-speed/4
		$Polygon2D.color.r = 1-speed/4
	else:
		$Polygon2D.color.b = 1-speed/4
		$Polygon2D.color.g = 1-speed/4
	if hunter:
		remove_from_group("rabbit")
		add_to_group("hunter")
		speed += 0.2

func _process(delta):
	foodReserve -= delta*speed*(int(hunter)+1)/lifetime + delta*senseRadius/100
	if foodReserve <= 0:
		queue_free()
	for i in $sense.get_overlapping_areas():
		if i.is_in_group("rabbit") and hunter and not is_instance_valid(target):
			target = i
		elif i.is_in_group("food") and !hunter and not is_instance_valid(target):
			target = i
		if i.is_in_group("hunter") and is_in_group("rabbit"):
			target = null
			$sense.look_at(i.position)
			$sense.rotation_degrees += 270
			break
	if is_instance_valid(target):
		$sense.look_at(target.position)
		$sense.rotation_degrees += 90
	if position.y > OS.window_size.y*0.60:
		position.y = 0
	if position.x > OS.window_size.x*0.60:
		position.x = 0
	if position.y < 0:
		position.y = OS.window_size.y*0.60
	if position.x < 0:
		position.x = OS.window_size.x*0.60
	position += Vector2(0, -speed/2).rotated($sense.rotation)

func _on_rabbit_area_entered(area):
	if !hunter:
		if area.is_in_group("food"):
			area.queue_free()
			foodReserve += 1
			if foodReserve > foodNeed:
				rabbit = load("res://scenes/rabbit.tscn").instance()
				foodReserve -= (foodNeed-1)
				rabbit.position = position 
				rabbit.speed = speed
				rabbit.foodReserve = 1
				rabbit.senseRadius = senseRadius
				r.randomize()
				if r.randi_range(1, 10) <= mutation_chance*10:
					r.randomize()
					rabbit.speed += r.randi_range(-mutation_range*2, mutation_range*2)*0.1
					r.randomize()
					rabbit.senseRadius += r.randi_range(-mutation_range, mutation_range)*0.5
				r.randomize()
				rabbit.hunter = hunter
				if r.randi_range(1, 100) < 2:
					rabbit.hunter = !hunter
				get_parent().call_deferred("add_child", rabbit)
			r.randomize()
			$sense.rotation_degrees = r.randi_range(0, 360)
	else:
		if area.is_in_group("rabbit"):
			area.queue_free()
			foodReserve += 1
			if foodReserve > foodNeed:
				rabbit = load("res://scenes/rabbit.tscn").instance()
				foodReserve -= (foodNeed-1)
				rabbit.position = position 
				rabbit.speed = speed
				rabbit.foodReserve = 1
				rabbit.senseRadius = senseRadius
				r.randomize()
				if r.randi_range(1, 10) <= mutation_chance*10:
					r.randomize()
					rabbit.speed += r.randi_range(-mutation_range*2, mutation_range*2)*0.1
					r.randomize()
					rabbit.senseRadius += r.randi_range(-mutation_range, mutation_range)*0.5
					if rabbit.senseRadius<0:
						rabbit.senseRadius = 0
				r.randomize()
				rabbit.hunter = hunter
				if r.randi_range(1, 100) < 2:
					rabbit.hunter = !hunter
				get_parent().call_deferred("add_child", rabbit)
			r.randomize()
			$sense.rotation_degrees = r.randi_range(0, 360)

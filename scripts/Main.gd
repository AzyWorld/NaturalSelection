extends Node2D

onready var food = preload("res://scenes/food.tscn")
onready var rabbit = preload("res://scenes/rabbit.tscn")

var r = RandomNumberGenerator.new()

var spawn_cd = 0.5
var spawn_count = 2
var food_limit = 150

func _ready():
	for i in range(0):
		rabbit = preload("res://scenes/rabbit.tscn").instance()
		rabbit.position.x = 50 + 60*i
		rabbit.position.y = 300
		add_child(rabbit)
	for i in range(20):
		food = preload("res://scenes/food.tscn").instance()
		r.randomize()
		food.position.x = r.randi_range(10, OS.window_size.x*0.6)
		r.randomize()
		food.position.y = r.randi_range(10, OS.window_size.y*0.6)
		add_child(food)

func _process(_delta):
	$food_spawner.wait_time = spawn_cd

func _on_food_spawner_timeout():
	if len(get_tree().get_nodes_in_group("food")) < food_limit:
		for i in range(spawn_count):
			food = preload("res://scenes/food.tscn").instance()
			r.randomize()
			food.position.x = r.randi_range(10, OS.window_size.x*0.6)
			r.randomize()
			food.position.y = r.randi_range(10, OS.window_size.y*0.6)
			add_child(food)

extends CanvasLayer

var count = []
var huntersCount = []
var speed = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
var sense = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
var countCounter = 0
var speedCounter = 0
var frame = 0

onready var main = get_parent()

func ArrSum(arr):
	var sum = 0
	for i in arr:
		sum += i
	return sum
	
func _process(delta):
	frame += 1
	$count.clear_points()
	if frame % 5 == 0:
		count.append(len(get_tree().get_nodes_in_group("rabbit")))
		#huntersCount.append(len(get_tree().get_nodes_in_group("hunter")))
	if len(count)>OS.window_size.x:
		count.remove(0)
		#huntersCount.remove(0)
	for i in count:
		$count.add_point(Vector2(5+countCounter, OS.window_size.y*0.8 + count[len(count)-1]*2 - i*2))
		#$hunters.add_point(Vector2(5+countCounter, OS.window_size.y*0.8 + huntersCount[len(huntersCount)-1]*2 - huntersCount[int(countCounter*2)]*2))
		countCounter += 0.5
	countCounter = 0
	for i in get_tree().get_nodes_in_group("rabbit"):
		if i.speed <= 4:
			speed[int(i.speed*5)] += 1
		else:
			speed[len(speed)-1] += 1
		if i.senseRadius <= 5.5:
			sense[int((i.senseRadius-2.5)*10)] += 1
		else:
			sense[len(sense)-1] += 1
	for i in range(21):
		$speed.points[i] = (Vector2(OS.window_size.x*0.5+i*15, (OS.window_size.y - 10 - speed[i]*5)))
	for i in range(len(sense)-1):
		$sense.points[i] = Vector2(OS.window_size.x*0.70+i*15, OS.window_size.y - 10 - sense[i]*5)
	speed = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
	sense = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]


func _on_Button_pressed():
	main = get_parent()
	main.spawn_cd = float($Entrys/spawn_cd.text)
	main.spawn_count = int($Entrys/spawn_count.text)
	main.food_limit = int($Entrys/food_limit.text)
	for rabbit in get_tree().get_nodes_in_group("rabbit"):
		rabbit.mutation_chance = float($Entrys/mutation_chance.text)
		rabbit.mutation_range = int($Entrys/mutation_range.text)
		rabbit.lifetime = float($Entrys/lifetime.text)
		rabbit.foodNeed = float($Entrys/foodNeed.text)

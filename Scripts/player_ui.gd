extends CanvasLayer

@onready var healthContainer = $HealthContainer
var hearts : Array = []
@onready var player = get_parent()

func _ready():
	hearts = healthContainer.get_children()
	player.OnUpdateHealth.connect(_update_hearts)
	_update_hearts(player.health)
	
func _update_hearts(health : int):
	for i in len(hearts):
		hearts[i].visible = i < health

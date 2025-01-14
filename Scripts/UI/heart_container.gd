class_name HeartsContainer extends HBoxContainer

@onready var hearth_prefab = preload("res://Scenes/UI/ui_hearth.tscn")

func init_hearts(max_hearts: int, current: int):
	var hearth_count = int(max_hearts / 4.0)
	for i in range(hearth_count):
		var heart = hearth_prefab.instantiate()
		add_child(heart)
	update_hearts(current)

func update_hearts(current_health: int):
	var hearts = get_children()

	var heart_count = hearts.size()
	for i in heart_count:
		var heart: UIHeart = hearts[i]
		heart.update(current_health - i * 4)

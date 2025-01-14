extends Node2D

@onready var heartsContainer: HeartsContainer = $CanvasLayer/HeartContainer
@onready var player: Player = $Player

func _ready():
  heartsContainer.init_hearts(player.max_health, player.current_health)
  player.health_changed.connect(heartsContainer.update_hearts)
  
# Debug poison
var timer = 10.0
func _physics_process(delta):
  timer -= delta
  if timer <= 0:
    timer = 10.0
    player.take_damage(4)

func set_player_movement(can_move: bool):
  player.can_move = can_move

func _on_ui_is_open(is_open: bool):
  set_player_movement(!is_open)

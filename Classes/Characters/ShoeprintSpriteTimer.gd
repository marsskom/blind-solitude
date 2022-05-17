extends Timer

onready var sprite: Sprite

func run():
	connect("timeout", self, "_modulate")
	one_shot = true
	start(1)

	sprite = get_parent()

func _modulate() -> void:
	sprite.modulate.a = lerp(sprite.modulate.a, 0, 0.6)

	disconnect("timeout", self, "_modulate")
	connect("timeout", self, "_on_timer_timeout")
	start(3)

func _on_timer_timeout() -> void:
	sprite.call_deferred("queue_free")

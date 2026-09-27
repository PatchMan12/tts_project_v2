extends Area2D
# Attach to every trash pickup's Area2D root.
# Set item_id, category, and icon per instance in the Inspector.

@export var item_id: String = "potato_chip"       # unique key, e.g. "broken_bulb"
@export var category: PickupManager.Category = PickupManager.Category.GENERAL
@export var icon: Texture2D                        # small icon shown in the HUD

@export var pickup_sound: AudioStream
@export var destroy_on_pickup: bool = true

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if not body.is_in_group("player"):
		return

	PickupManager.collect(item_id, icon, category)

	if pickup_sound:
		var player := AudioStreamPlayer2D.new()
		player.stream = pickup_sound
		player.global_position = global_position
		get_tree().current_scene.add_child(player)
		player.play()
		player.finished.connect(player.queue_free)

	if destroy_on_pickup:
		owner.queue_free()

extends Node
# Autoload this as "PickupManager"
# Project Settings > Autoload > add this script with name "PickupManager"

enum Category { RECYCLABLE, BIODEGRADABLE, GENERAL, HAZARDOUS }

# Fired every time a trash item is collected or its count changes.
# item_id: String, icon: Texture2D, count: int, category: Category
signal inventory_updated(item_id: String, icon: Texture2D, count: int, category: int)

var counts: Dictionary = {}   # item_id -> int
var icons: Dictionary = {}    # item_id -> Texture2D
var categories: Dictionary = {} # item_id -> Category
var order: Array = []         # preserves first-seen order for UI layout

func collect(item_id: String, icon: Texture2D, category: int) -> void:
	if not counts.has(item_id):
		counts[item_id] = 0
		icons[item_id] = icon
		categories[item_id] = category
		order.append(item_id)

	counts[item_id] += 1
	inventory_updated.emit(item_id, icon, counts[item_id], category)

func get_count(item_id: String) -> int:
	return counts.get(item_id, 0)

func get_category_total(category: int) -> int:
	var total := 0
	for id in counts.keys():
		if categories[id] == category:
			total += counts[id]
	return total

func reset() -> void:
	counts.clear()
	icons.clear()
	categories.clear()
	order.clear()

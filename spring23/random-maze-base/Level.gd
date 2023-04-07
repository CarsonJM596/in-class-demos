extends Node2D

onready var space = $Space
onready var dungeon = $Dungeon

var border = Rect2(1, 1, 30, 17)
var level_map

export (PackedScene) var collectable
const NUM_COINS = 6

# Bitmasking
const BITS = [1,  2,   4,
			  8,  16,  32, 
			  64, 128, 256]

var LOC_OFFSETS = {}

func _ready():
	randomize()
	generate_level()
	level_map.shuffle()
	for i in 3:
		for j in 3:
			LOC_OFFSETS[BITS[3*i+j]] = Vector2.ONE + Vector2(j,i)
	add_collectables()
	#$Player.position = Vector2(15*32 + 16, 17*32+16)
	$Player.position = level_map[NUM_COINS] * 32 + Vector2(16,16)
	
func generate_level():
	var etch_a_sketch = Walker.new(Vector2(15, 17), border)
	level_map = etch_a_sketch.make_map(500)
	for loc in level_map:
		space.set_cellv(loc, -1)
	for x in border.size.x + 2:
		for y in border.size.y + 2:
			var pt = Vector2(x, y)
			if not pt in level_map:
				dungeon.set_cellv(pt, -1)
	space.update_bitmask_region()
	dungeon.update_bitmask_region()

func add_collectables():
	for i in NUM_COINS:
		var coin = collectable.instance()
		coin.position = level_map[i]*32 + gen_offset(level_map[i])
		#print($Dungeon.get_cell_autotile_coord(level_map[i].x, level_map[i].y))
		#print($Dungeon.get_tileset().autotile_get_bitmask(0, $Dungeon.get_cell_autotile_coord(level_map[i].x, level_map[i].y)))
		add_child(coin)

func gen_offset(loc):
	var at_coord = $Dungeon.get_cell_autotile_coord(loc.x, loc.y)
	var bitmask = $Dungeon.get_tileset().autotile_get_bitmask(0, at_coord)
	print(at_coord, bitmask)
	var masks = BITS.duplicate()
	masks.shuffle()
	var mask = masks.pop_back()
	while not mask & bitmask:
		mask = masks.pop_back()
	
	return LOC_OFFSETS[mask] * 8

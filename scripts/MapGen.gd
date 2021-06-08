extends Node2D

func genMap(mapArray: PoolStringArray, lineLengh: int, essTilemap: TileMap, playerTilemap: TileMap):
	var arrayLengh := mapArray.size()
	for pos in range(arrayLengh):
		var y = pos / lineLengh
		var x = pos - (y * lineLengh)
		var tile = _getTileByString(mapArray[pos])
		if _walkable(tile):
			essTilemap.set_cell(x, y, tile)
		else:
			playerTilemap.set_cell(x, y, tile)

func _getTileByString(key: String) -> int:
	match key:
		' ':
			return -1
		'X':
			return 3
		'B':
			return 1
		'1':
			return 0
		'2':
			return 5
		'F':
			return 2
		'G':
			return 4
	return -1

func _walkable(tile: int) -> bool:
	return tile == _getTileByString('F') || tile == _getTileByString('G')

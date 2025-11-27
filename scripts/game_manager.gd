extends Node

# Global game state
var points := 0
var enemy_points := 10  # Points for killing an enemy
var chest_points := 25  # Points for opening a chest

signal points_changed(new_points: int)

func add_points(amount: int):
	points += amount
	points_changed.emit(points)
	print("Points: ", points)

func reset_points():
	points = 0
	points_changed.emit(points)

func get_points() -> int:
	return points

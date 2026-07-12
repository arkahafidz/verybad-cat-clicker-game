extends Node

var coins: int = 0
var cpc: int = 1
var autoclick: int = 0

var upgcost1: int = 50
var upgcost2: int = 100

func add_coins(amount: int) -> void:
	coins += amount

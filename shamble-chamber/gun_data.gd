class_name GunData
extends Resource

# Notes/revision:
# A resource is a plain data container, an object that can hold values that is saved to the disk with no position,
# sprite, nor spot in the tree.

# This script defines what a gun has (damage, magazine size, reload speed, etc.), each of it can be changed to
# the gun's setting by creating a .tres (text reource) file that is connected to GunData:
# FileSystem > (right click) NewResource > search GunData > Create > gun_name.tres


@export var gun_name: String = "Pistol"
@export var damage: int = 10
@export var fire_rate: float = 0.3
@export var mag_size: int = 12
@export var reload_time: float = 1.2
@export var bullet_speed: float = 1000.0
@export var pallets: int = 1
@export var spread_degrees: float = 0.0

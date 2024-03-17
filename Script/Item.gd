extends Resource

class_name ItemResource

enum TYPE {COSUMABLE, WEAPON, FARMINGTOOL, EQUIPMENT, FURNITURE, SEED}

export var name : String
export var stackable : bool
export var max_stack_size : int
export var texture : Texture
export(TYPE) var type
export var subname : String
export var weapon_code : int
export var size : Vector2

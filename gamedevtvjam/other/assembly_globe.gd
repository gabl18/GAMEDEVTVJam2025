extends CharacterBody2D

enum Parts {
	Globe,
	Base,
	Inside
}

var owned_parts: Array[GlobePart]

func add_part(part:GlobePart) -> GlobePart:
	for part_ in owned_parts:
		if part_.parttype == part.parttype:
			return part
	owned_parts.append(part)
	return null
	
	

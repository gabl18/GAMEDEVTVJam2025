extends Node

enum Mouse_States {
	idle,dragging,pointing
}

var Mouse_Hovers: Array

var moues_state: Mouse_States = Mouse_States.idle

var Mouse_idx: int

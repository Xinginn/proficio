extends Node

class_name Item

# _name pour la logique interne, label pour l'affichage UI
var _name: String
var label: String
var weight: float
var description: String

# methode pour liberer la memoire car pas fait automatiquement (instancié avec new(), donc orphelin)
# destiné a etre surchargé par les classes-filles
func destroy():
  queue_free()

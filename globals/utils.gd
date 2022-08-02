extends Node

func get_files_in_directory(path: String) -> Array:
  var dir = Directory.new()
  dir.open(path)
  var files = []
  dir.list_dir_begin()
  while true:
    var file = dir.get_next()
    if file == "":
      break
    elif not file.begins_with("."):
      files.append(file)
  dir.list_dir_end()
  return files

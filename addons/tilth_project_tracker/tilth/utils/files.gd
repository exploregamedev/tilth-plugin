tool

extends Reference
class_name Files

static func copy_dir_contents(src_dir_path: String, dest_dir_path: String,
                             file_extention: String = "") -> bool:
    var copied_all_files = true
    file_extention = file_extention.to_lower()
    var src_dir = Directory.new()
    if not src_dir.dir_exists(dest_dir_path):
        printerr("Files.copy_dir_contents; Destination dir not found: %s" % dest_dir_path)
        return false
    src_dir.open(src_dir_path)
    src_dir.list_dir_begin(true)
    var file_name = src_dir.get_next()
    while file_name != "":
        if file_extention and not file_name.to_lower().ends_with(file_extention):
            continue
        var dest_file_path = dest_dir_path.plus_file(file_name)
        var result = src_dir.copy(src_dir_path.plus_file(file_name),
                                 dest_dir_path.plus_file(file_name))
        if result != OK:
            printerr("Copy of file %s from dir %s to dir %s failed" %
                    [file_name, src_dir_path, dest_dir_path])
            copied_all_files = false
        else:
            print("Coppied project file %s --> %s" % [file_name, dest_dir_path.plus_file(file_name)])
        file_name = src_dir.get_next()
    return copied_all_files

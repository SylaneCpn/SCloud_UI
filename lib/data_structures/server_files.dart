

class ServerFile {

 final String name;
 final String content_type;
 final String full_path; 

 const ServerFile({required this.name , required this.content_type , required this.full_path});


 factory ServerFile.fromJson(dynamic json) {
  return switch (json) {
    {
      'name' : String name,
      'content_type' : String content_type,
      'full_path' : String full_path,
    } => 
    ServerFile(name : name, content_type: content_type , full_path: full_path),
    _ => throw const FormatException('Failed to load file')
  };
 }

  static List<ServerFile> deserializeFiles(List<dynamic> json) => (json).map((item) => ServerFile.fromJson(item)).toList(); 
}
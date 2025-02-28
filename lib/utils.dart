String? getExtention(String fileName) {

  final pointpos = fileName.lastIndexOf('.');
  final ext = fileName.substring(pointpos + 1);
  return ext;
}


String matchMimetype(String fileName , String contentType) {

  String mime;

  switch(contentType) {

    case 'txt' :
          mime = "text/plain";
    case 'code_file' :
          mime = "text/${getExtention(fileName)}"; 
    case 'image' :
          mime = "image/${getExtention(fileName)}";
    case 'pdf' :
          mime = "application/pdf";
    case 'video' :
        mime = "video/${getExtention(fileName)}";
    default :
          mime = "application/octet-stream";

  }

  return mime;

}


String matchMimetypeFromExt(String fileName) {

  String mime;
  String ext = getExtention(fileName)!;

  switch(ext) {

    case 'txt' :
          mime = "text/plain";
    case 'c' || 'cpp' || 'py' || 'rs'  :
          mime = "text/$ext"; 
    case "png" || "jpg" || "svg" || "webp" || "gif" :
          mime = "image/$ext";
    case 'pdf' :
          mime = "application/pdf";
    case "mp4" || "webm" :
        mime = "video/$ext";
    default :
          mime = "application/octet-stream";

  }

  return mime;

}

String getRessourceName(String path) {

  final pointpos = path.lastIndexOf('/');
  final ext = path.substring(pointpos + 1);
  return ext;

}

String makeValidDirname(String dirName) {
  dirName.trim();
  dirName.replaceAll(" ", '_');
  return dirName;

}
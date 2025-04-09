import 'dart:io';
import 'dart:typed_data';

import 'package:highlighting/languages/rust.dart';
import 'package:highlighting/languages/c.dart';
import 'package:highlighting/languages/python.dart';
import 'package:highlighting/languages/javascript.dart';
import 'package:highlighting/languages/css.dart';
import 'package:highlighting/languages/php-template.dart';
import 'package:highlighting/languages/typescript.dart';
import 'package:http/http.dart' as http;

String? getExtention(String fileName) {

  final pointpos = fileName.lastIndexOf('.');
  final ext = fileName.substring(pointpos + 1);
  return ext;
}


String localPath(String path) {
  final pos = path.indexOf("/");
  return path.substring(pos);
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

  final pointpos = Platform.isWindows ? path.lastIndexOf("\\") : path.lastIndexOf('/');
  final ext = path.substring(pointpos + 1);
  return ext;

}

String makeValidName(String name) {
  
  return name.trim().replaceAll(" ", '_');
  
}

String languageId(String name) {
  final ext = getExtention(name)!;
  return switch (ext) {
    "rs" => rust.id,
    'py' => python.id,
    "js" => javascript.id,
    "html" => phpTemplate.id,
    "css" => css.id,
    "ts" => typescript.id,
    _ => c.id,
  };
  
  }

  Future<Uint8List> fetchData(String url) async  {

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return response.bodyBytes;
    }

    else {
      throw Exception("Une erreur s'est produite lors du chargement des données");
    }


  }

  bool isValidAscii(String name) {
    return !name.codeUnits.any((b) => b > 127);
  }

  String shortenText(String text , int size) {
    if (text.length > size) {
      return '${text.substring(0,size-3)}...';
    }
    return text;
  }
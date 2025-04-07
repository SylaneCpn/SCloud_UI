import "dart:typed_data";

import "package:file_picker/file_picker.dart";
import "package:flutter/material.dart";
import "package:http/http.dart" as http;
import "package:sylcpn_io/data_structures/fetching_report.dart";
import "package:sylcpn_io/data_structures/fetching_state.dart";
import "package:sylcpn_io/data_structures/server_files.dart";
import "dart:convert";
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:dio/dio.dart';
import 'package:path/path.dart' as path;
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'dart:io' show File, Platform;
import "package:sylcpn_io/utils.dart";
import 'package:web/web.dart' show HTMLAnchorElement;

class AppState extends ChangeNotifier {
  static final addr = "https://sylcpn.ddns.net";
  String name = "null";
  String password = "null";
  String currentPath = "files/";
  bool isConnected = false;
  List<ServerFile> filesInPath = [];
  FetchingState pathState = FetchingState.init;
  Color appColor = Color.fromARGB(255, 82, 113, 255);
 

  String parseGetExtPath(String path) => "$addr/usr/$name/psw/$password/$path";
  String parseVerifPath(String n, String p) => "$addr/usr/$n/psw/$p/";
  String parseGetPath() => "$addr/usr/$name/psw/$password/$currentPath";
  String parseRmPath(String path) => "$addr/rm/usr/$name/psw/$password/$path";
  String parseAddFilePath(String fileName) =>
      "$addr/addfile/usr/$name/psw/$password/$currentPath$fileName";
  String parseAddDirPath(String dirName) =>
      "$addr/adddir/usr/$name/psw/$password/$currentPath$dirName";
  String userAvatarPath() =>
      "$addr/usr/$name/psw/$password/files/$name/portrait.jpg";
  String parseRenamePath(String path , String newName) => "$addr/rename/usr/$name/psw/$password/to/$newName/$path";
  bool isRootPath() => currentPath == "files/" ;

  Future<FetchingReport> sendFile(String path) async {

    try {
      if (!isValidAscii(path)) return FetchingReport.inputFail;
      //get the file 
      final file =  File(path);
      final body = await file.readAsBytes();
      final fName = getRessourceName(path);

      // send data to the network
      final headers = <String, String> { 'Content-Type' : matchMimetypeFromExt(fName) }; 
      final response = await http.post(Uri.parse(parseAddFilePath(fName)) , headers: headers , body : body);

      if (response.statusCode == 200) return FetchingReport.success;
      return FetchingReport.refused;
      
    } 
    catch (e) {
      rethrow;
    }
    
  }

  Future<FetchingReport> sendFileWeb(String fileName , Uint8List content ) async {

    try {
      
      if (!isValidAscii(fileName)) return FetchingReport.inputFail;

      // send data to the network
      final headers = <String, String> { 'Content-Type' : matchMimetypeFromExt(fileName) }; 
      final response = await http.post(Uri.parse(parseAddFilePath(fileName)) , headers: headers , body : content);

      if (response.statusCode == 200) return FetchingReport.success;
      return FetchingReport.refused;
      
    } 
    catch (e) {
      rethrow;
    }
    
  }

  Future<FetchingReport> addDir(String dirName) async {

    try {
     
      final response = await http.post(Uri.parse(parseAddDirPath(dirName)));

      if (response.statusCode == 200) return FetchingReport.success;
      return FetchingReport.refused;
      
    } 
    catch (e) {
      rethrow;
    }
    
  }

  Future<FetchingReport> renameRessource(String path , String newName) async {

    try {
     
      final response = await http.post(Uri.parse(parseRenamePath(path , newName)));

      if (response.statusCode == 200) return FetchingReport.success;
      return FetchingReport.refused;
      
    } 
    catch (e) {
      rethrow;
    }
    
  }

  Future<FetchingReport> rmRessource(String path) async {

    try {

      final response = await http.delete(Uri.parse(parseRmPath(path)));
      if (response.statusCode == 200) return FetchingReport.success;
      return FetchingReport.refused;

    }

    catch(e) {
      return FetchingReport.networkFail;
    }
 
  }

  Future<void> downloadFile(int index, BuildContext context) async {
    try {
      final String url = parseGetExtPath(filesInPath[index].full_path);

      

      if (kIsWeb) {
        

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Début du téléchergement de : ${filesInPath[index].name}.')),
        );

        HTMLAnchorElement()
      ..href = url
      ..download = filesInPath[index].name
      ..click();

      
      } else {
        if (Platform.isAndroid || Platform.isIOS) {
          final selectedDir = await FlutterFileDialog.pickDirectory();
          if (selectedDir == null) return;
          final mimeType = matchMimetype(
            filesInPath[index].name,
            filesInPath[index].content_type,
          );
          ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Début du téléchergement de : ${filesInPath[index].name}.')),
          );
          final bytes = await getRawRessource(filesInPath[index].full_path);
          final filePath = await FlutterFileDialog.saveFileToDirectory(
            mimeType: mimeType,
            directory: selectedDir,
            data: bytes,
            fileName: filesInPath[index].name,
          );

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Fichier téléchargé à : $filePath')),
          );
        } else {
          final selectedDir = await FilePicker.platform.getDirectoryPath();
          if (selectedDir == null) return;

          final fileName = path.basename(url);
          final dio = Dio();
          final savePath = "$selectedDir/$fileName";
          ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Début du téléchergement de : ${filesInPath[index].name}.')),
          );
          await dio.download(url, savePath);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Fichier téléchargé à : $savePath')),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Une erreur s'est produite. Le fichier n'a pas pu être téléchargé.",
          ),
        ),
      );
    }
  }

  Future<String> getStringRessource(String path) async {
    final response = await http.get(Uri.parse(parseGetExtPath(path)));

    if (response.statusCode == 200) {
      return response.body;
    }

    throw Exception('Impossible de charger la ressource');
  }

  Future<Uint8List> getRawRessource(String path) async {
    final response = await http.get(Uri.parse(parseGetExtPath(path)));

    if (response.statusCode == 200) {
      return response.bodyBytes;
    }

    throw Exception('Impossible de charger la ressource');
  }

  String parentDirectoryPath() {
    if (currentPath != "files/") {
      String current = currentPath;
      //remove last slash
      current = current.substring(0, current.length);
      List<String> splitted = current.split("/");
      String result = "";

      for (int i = 0; i < (splitted.length - 2); i++) {
        result += "${splitted[i]}/";
      }

      return result;
    }

    return currentPath;
  }

  Future<FetchingReport> getPrevDir() async {
    try {
      final response = await http.get(
        Uri.parse(parseGetExtPath(parentDirectoryPath())),
      );
      //final response = await http.get(Uri.parse("https://67b30ef1bc0165def8cfbbf0.mockapi.io/api/v1/connect"));
      if (response.statusCode == 200) {
        currentPath = parentDirectoryPath();
        filesInPath = ServerFile.deserializeFiles(jsonDecode(response.body));
        pathState = FetchingState.success;
        notifyListeners();
        return FetchingReport.success;
      }

      return FetchingReport.refused;
    } catch (e) {
      return FetchingReport.networkFail;
    }
  }

  Future<FetchingReport> getNextDir(String dirPath) async {
    try {
      final response = await http.get(Uri.parse(parseGetExtPath(dirPath)));
      //final response = await http.get(Uri.parse("https://67b30ef1bc0165def8cfbbf0.mockapi.io/api/v1/connect"));
      if (response.statusCode == 200) {
        currentPath = dirPath;
        filesInPath = ServerFile.deserializeFiles(jsonDecode(response.body));
        pathState = FetchingState.success;
        notifyListeners();
        return FetchingReport.success;
      }

      return FetchingReport.refused;
    } catch (e) {
      return FetchingReport.networkFail;
    }
  }

  Future<FetchingReport> refreshDir() async {
    try {
      final response = await http.get(Uri.parse(parseGetPath()));
      if (response.statusCode == 200) {
        filesInPath = ServerFile.deserializeFiles(jsonDecode(response.body));
        pathState = FetchingState.success;
        notifyListeners();
        return FetchingReport.success;
      }

      return FetchingReport.refused;
    } catch (e) {
      return FetchingReport.networkFail;
    }
  }

  Future<FetchingReport> getFilesInPath() async {
    try {
      final response = await http.get(Uri.parse(parseGetPath()));
      if (response.statusCode == 200) {
        filesInPath = ServerFile.deserializeFiles(jsonDecode(response.body));
        pathState = FetchingState.success;
        notifyListeners();
        return FetchingReport.success;
      } else {
        return FetchingReport.refused;
      }
    } catch (e) {
      return FetchingReport.networkFail;
    }
  }

  Future<void> initFilesInPath() async {
    try {
      currentPath = "files/";
      final response = await http.get(Uri.parse(parseGetPath()));
      //final response = await http.get(Uri.parse("https://67b30ef1bc0165def8cfbbf0.mockapi.io/api/v1/connect"));

      if (response.statusCode == 200) {
        filesInPath = ServerFile.deserializeFiles(jsonDecode(response.body));
        pathState = FetchingState.success;
      } else {
        filesInPath = <ServerFile>[];
        pathState = FetchingState.failure;
      }
    } catch (e) {
      pathState = FetchingState.failure;
    } finally {
      notifyListeners();
    }
  }

  void resetFileInPath() {
    pathState = FetchingState.init;
    filesInPath.clear();
    currentPath = "files/";
    notifyListeners();
  }

  Future<FetchingReport> checkUser(String n, String p) async {
    try {
      final response = await http.get(Uri.parse(parseVerifPath(n, p)));
      if (response.statusCode == 200 && n.isNotEmpty && p.isNotEmpty) {
        connect(n, p);
        return FetchingReport.success;
      }

      return FetchingReport.refused;
    } catch (e) {
      return FetchingReport.networkFail;
    }
  }

  void disconnect() {
    isConnected = false;
    name = "null";
    password = "null";
    resetFileInPath();
  }

  void connect(String n, String p) {
    isConnected = true;
    name = n;
    password = p;
    resetFileInPath();
  }

}

import 'package:path/path.dart' as path;
import "package:dio/dio.dart";
import "package:file_picker/file_picker.dart";
import "package:flutter/material.dart";
import "package:sylcpn_io/data_structures/downloader/downloader.dart";
import 'dart:io';


class NativeDownloader extends Downloader {
  @override
  Future<void> download(BuildContext context , String url , String nameFile) async {


    if (Platform.isAndroid || Platform.isIOS) {
          
          final selectedDir = await FilePicker.platform.getDirectoryPath();
          if (selectedDir == null) return;

          final fileName = path.basename(url);
          final dio = Dio();
          final savePath = "$selectedDir/$fileName";
          ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Début du téléchergement de : $fileName.')),
          );
          await dio.download(url, savePath);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Fichier téléchargé à : $savePath')),
          );


    }
      
    else {

          final selectedDir = await FilePicker.platform.saveFile(fileName: nameFile);
          if (selectedDir == null) return;

          final fileName = path.basename(url);
          final dio = Dio();
          final savePath = selectedDir;
          ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Début du téléchergement de : $fileName.')),
          );
          await dio.download(url, savePath);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Fichier téléchargé à : $savePath')),
          );
    }
          
  }
  
}

Downloader getDownloader() => NativeDownloader();



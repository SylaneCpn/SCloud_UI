import 'package:web/web.dart' show HTMLAnchorElement;
import "package:flutter/material.dart";
import "package:sylcpn_io/data_structures/downloader/downloader.dart";

class WebDownloader extends Downloader {
  @override
  Future<void> download(BuildContext context, String url, String fileName) async {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Début du téléchergement de : $fileName.')),
          );

        HTMLAnchorElement()
      ..href = url
      ..download = fileName
      ..click();
  }
  
}

Downloader getDownloader() => WebDownloader();
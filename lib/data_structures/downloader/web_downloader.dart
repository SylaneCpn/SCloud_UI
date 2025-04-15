import 'dart:js_interop' as js;


//import 'package:web/web.dart' show HTMLAnchorElement;

import "package:flutter/material.dart";

import "package:sylcpn_io/data_structures/downloader/downloader.dart";



@js.JS('saveFile') 
external js.JSPromise<js.JSString> saveFile(String url , String name);

class WebDownloader extends Downloader {
  @override
  Future<void> download(BuildContext context, String url, String nameFile) async {


          final result = await (saveFile(url , nameFile)).toDart;

          switch(result.toDart) {
            case 'refused':
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Téléchargement échoué , le serveur refuse le téléchargement de : $nameFile.')),
              );
            

            case 'network_fail':
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Une erreur réseau s'est produite. Réessayez ultérieurement.")),
              );

            case 'success':
              ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Fichier téléchargé avec succès.')),
          );

          case 'fail':
              ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Le téléchargement a échoué.')),
          );

          case _ :
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Téléchargement annulé.')),
          );

          }

          
  /*       
        HTMLAnchorElement()
      ..href = url
      ..download = fileName
      ..click();

  */
  }
  
}

Downloader getDownloader() => WebDownloader();
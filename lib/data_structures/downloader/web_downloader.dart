import 'dart:js_interop' as js;


//import 'package:web/web.dart' show HTMLAnchorElement;

import "package:flutter/material.dart";

import "package:sylcpn_io/data_structures/downloader/downloader.dart";



@js.JS('saveFile') 
external js.JSPromise<js.JSString> saveFile(String url , String name);

class WebDownloader extends Downloader {
  @override
  Future<void> download(BuildContext context, String url, String fileName) async {

  
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Choisissez où savegarder : $fileName.')),
          );

          final result = await (saveFile(url , fileName)).toDart;

          switch(result.toDart) {
            case 'refused':
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Téléchargement échoué , le serveur refuse le téléchargement de : $fileName.')),
              );
            

            case 'network_fail':
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Une erreur réseau s'est produite. Réessayez ultérieurement.")),
              );

            case 'success':
              ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Fichier téléchargé avec succès.')),
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
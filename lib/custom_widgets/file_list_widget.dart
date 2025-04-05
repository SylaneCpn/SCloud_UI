

import 'package:flutter/material.dart';


class FileListWidget extends StatelessWidget{

  final List<String> fileNames;

  const FileListWidget({super.key , required this.fileNames});

  @override
  Widget build(BuildContext context) {

     List<Widget> children = fileNames.isEmpty ? [Padding(
       padding: const EdgeInsets.all(20.0),
       child: Text('Aucun fichier sélectionné'),
     )] : fileNames.map((n) =>  ListTile(title: Text(n),) ).toList();

     return Column( children: children,);
    
  }

}
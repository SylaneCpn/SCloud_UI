
import 'package:flutter/material.dart';
import 'package:sylcpn_io/utils.dart';

class FileListWidget extends StatelessWidget{

  final List<String> paths;

  const FileListWidget({super.key , required this.paths});

  @override
  Widget build(BuildContext context) {

     List<Widget> children = paths.isEmpty ? [Padding(
       padding: const EdgeInsets.all(20.0),
       child: Text('Aucun fichier sélectionné'),
     )] : paths.map((p) =>  ListTile(title: Text(getRessourceName(p)),) ).toList();

     return Column( children: children,);
    
  }

}
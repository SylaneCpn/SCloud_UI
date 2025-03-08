

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:provider/provider.dart';
import 'package:sylcpn_io/custom_widgets/video_player.dart';
import 'package:sylcpn_io/data_structures/appstate.dart';
import 'package:sylcpn_io/data_structures/fetching_state.dart';
import 'package:flutter_highlighting/flutter_highlighting.dart';
import 'package:flutter_highlighting/themes/vs.dart';
import 'package:sylcpn_io/utils.dart';

class FullFile extends StatelessWidget{

  final int index;

  const FullFile({super.key , required this.index});


  Widget mapContentTypeWidget(String fileName ,String contentType , Uint8List content ) {

    return switch (contentType) {
      "txt" => Card(
        child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SelectableText(String.fromCharCodes(content)),
            ),
      ),
      "code_file" => Card(
        child: SingleChildScrollView(
          child: HighlightView(padding: EdgeInsets.all(20.0), languageId: languageId(fileName), theme: vsTheme ,String.fromCharCodes(content)),
        ),
      ),
      "image" => Image.memory(content),
      "video" => VideoPlayer(content: content),
      "pdf" => PdfViewer.data(content, sourceName: "" , params: PdfViewerParams(enableTextSelection: true , enableKeyboardNavigation: true , panEnabled: true),),
      _ =>   Card(
        child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: content.length < 10000 ? SelectableText(String.fromCharCodes(content)) : Text("Le fichier est trop volumineux pour être ouvert..."),
            ),
      ),

    };
  }

  @override
  Widget build(BuildContext context) {

    final state = context.watch<AppState>();

    final fileName = state.filesInPath[index].name;
    final contentType = state.filesInPath[index].content_type;
    final path = state.filesInPath[index].full_path;


    if (state.fileState == FetchingState.init) state.initFullFile(path);


    
    final body = switch (state.fileState) {
      FetchingState.init =>
        Center(
      child: Column( 
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: CircularProgressIndicator(color: Theme.of(context).primaryColorLight,),
          ),
          Text('En attente de données...')
        
      ],),
    ),

    FetchingState.failure =>
        Center(
      child: Column( 
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
    
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text('Une erreur est survenue.'),
          ),
          ElevatedButton(onPressed: state.resetFileInPath , child: Text("Réessayez"))
        
      ],),
    ),

    _ => mapContentTypeWidget(state.name, contentType, state.fileContent ),
        
        
    };

    

    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar( 
        backgroundColor: Color.fromARGB(255, 82, 113, 255),
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: Text(fileName),
        leading: IconButton(onPressed: () { Navigator.pop(context); state.resetFullFile();} , icon: Icon(Icons.arrow_back)),),
        body: Container(color: Theme.of(context).colorScheme.primaryContainer, child: Center(child: body,)),
      ),
    );
  }
}
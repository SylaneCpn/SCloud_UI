
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sylcpn_io/data_structures/appstate.dart';
import 'package:sylcpn_io/data_structures/fetching_state.dart';


class FullFile extends StatelessWidget{

  final int index;

  const FullFile({super.key , required this.index});


  @override
  Widget build(BuildContext context) {

    final state = context.watch<AppState>();

    final fileName = state.filesInPath[index].name;
    final contentType = state.filesInPath[index].content_type;
    final path = state.filesInPath[index].full_path;


    if (state.fileState == FetchingState.init) state.initFullFile(path);


    final Widget body;
    switch (state.fileState) {
      case FetchingState.init:
        body = Center(
      child: Column( 
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: CircularProgressIndicator(color: Theme.of(context).primaryColorLight,),
          ),
          Text('En attente de données...')
        
      ],),
    );

    case FetchingState.failure:
        body = Center(
      child: Column( 
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
    
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text('Une erreur est survenue.'),
          ),
          ElevatedButton(onPressed: state.resetFileInPath , child: Text("Réessayez"))
        
      ],),
    ) ;

    default:
        if (contentType == 'image') {
            body = Image.memory(state.fileContent) ;
        }

        else {
          body = Padding(
            padding: const EdgeInsets.all(20.0),
            child: SelectableText(String.fromCharCodes(state.fileContent)),
          );
        }
        
    }

    

    return Scaffold(
      appBar: AppBar( 
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
      title: Text(fileName),
      leading: IconButton(onPressed: () { Navigator.pop(context); state.resetFullFile();} , icon: Icon(Icons.arrow_back)),),
      body: Center(child: Card(child: body),),
    );
  }
}
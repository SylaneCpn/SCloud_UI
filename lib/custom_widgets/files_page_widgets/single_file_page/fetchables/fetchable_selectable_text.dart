import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sylcpn_io/utils.dart';

class FetchableSelectableText extends StatefulWidget {

  final String url;

  const FetchableSelectableText({super.key , required this.url});

  @override
  State<FetchableSelectableText> createState() => _FetchableSelectableTextState();
}

class _FetchableSelectableTextState extends State<FetchableSelectableText> {


  late Future<Uint8List> content;


  void refetch() {
    setState(() {
      content = fetchData(widget.url);
    });
  }

  @override
  void initState() {
    super.initState();
    content = fetchData(widget.url);
  }

  

  @override 
  Widget build(BuildContext context) {  

    return FutureBuilder<Uint8List>(
            future: content,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SelectableText( snapshot.data!.length < 100000 ? String.fromCharCodes(snapshot.data!) : 'Le fichier est trop volumineux pour être affiché...' ),
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(
      child: Column( 
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
    
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text('Une erreur est survenue.'),
          ),
          ElevatedButton(onPressed: refetch , child: Text("Réessayez"))
        
      ],),
    );
              }

              // By default, show a loading spinner.
              return Center(
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
            },
          );
  }
} 
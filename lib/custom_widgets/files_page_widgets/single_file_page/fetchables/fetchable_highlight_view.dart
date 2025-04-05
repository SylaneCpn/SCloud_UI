import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_highlighting/flutter_highlighting.dart';
import 'package:sylcpn_io/utils.dart';

class FetchableHighlightView extends StatefulWidget{

  final String url;
  final EdgeInsets padding;
  final String languageId;
  final Map<String , TextStyle> theme;

  const FetchableHighlightView({super.key , required this.url, required this.padding, required this.languageId, required this.theme});

  @override
  State<FetchableHighlightView> createState() => _FetchableHighlightViewState();
}

class _FetchableHighlightViewState extends State<FetchableHighlightView> {

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
                return Card.filled(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: HighlightView(padding : widget.padding , theme : widget.theme, languageId: widget.languageId , snapshot.data!.length < 100000 ? String.fromCharCodes(snapshot.data!) : 'Le fichier est trop volumineux pour être affiché...'  ),
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
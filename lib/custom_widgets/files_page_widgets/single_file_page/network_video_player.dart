import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:sylcpn_io/custom_widgets/files_page_widgets/single_file_page/video_player.dart';
import 'package:sylcpn_io/utils.dart';



class NetworkVideoPlayer extends StatefulWidget{

  final String url;

  const NetworkVideoPlayer({super.key , required this.url});

  @override
  State<NetworkVideoPlayer> createState() => _NetworkVideoPlayerState();
}

class _NetworkVideoPlayerState extends State<NetworkVideoPlayer> {
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
                    child: Container(color : Theme.of(context).colorScheme.primaryContainer, child: VideoPlayer(content : snapshot.data!)),
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
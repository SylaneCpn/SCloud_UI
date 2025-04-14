// ignore_for_file: prefer_function_declarations_over_variables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sylcpn_io/custom_widgets/alert_dialog.dart';
import 'package:sylcpn_io/custom_widgets/files_page_widgets/rename_ressource_dialog.dart';
import 'package:sylcpn_io/custom_widgets/files_page_widgets/single_file_page/single_file.dart';
import 'package:sylcpn_io/data_structures/appstate.dart';
import 'package:sylcpn_io/data_structures/fetching_report.dart';
import 'package:sylcpn_io/utils.dart';

class FileCard extends StatelessWidget{

  const FileCard({super.key , required this.index});

  final int index;
  
  
  
  @override
  Widget build(BuildContext context) {
    
    final state = context.watch<AppState>();

    final contentType = state.filesInPath[index].content_type;
    final targetPath = state.filesInPath[index].full_path;
    final name = state.filesInPath[index].name;

    var image = switch (contentType) {


      "pdf" => Image.asset("assets/img/pdf.png"),
      "dir" => Image.asset("assets/img/dir.png"),
      "code_file" => Image.asset("assets/img/code_file.png"),
      "image" => Image(image : NetworkImage(state.parseGetExtPath(targetPath))),
      "video" => Image.asset("assets/img/video.png"),
      _ => Image.asset("assets/img/file.png")

    };


    final openDir = () async  {
                          final report = await state.getNextDir(targetPath);
                          if (report == FetchingReport.refused) {
                          // ignore: use_build_context_synchronously
                          showSnackBarRefused(context);
                          }
                                    
                          else if (report == FetchingReport.networkFail) {
                          // ignore: use_build_context_synchronously
                          showSnackBarNetworkFail(context);
                          }

    };

    final openFile = () {
      Navigator.push(context, MaterialPageRoute(builder: (_) => SingleFile(url : state.parseGetExtPath(targetPath) , name: name , contentType: contentType,)));
    };

    final rmDir = () {

      if (state.isConnected) {showConfirmRmDialog(context,index);}

      else{ showNotConnectedDialog(context); }

    };



    final iconWidgets = <Widget>[
                    Expanded(
                      child: IconButton(onPressed: contentType == "dir" ? openDir : openFile
                      , icon: Icon(Icons.zoom_out_map_rounded)),
                    ),
                    if (!state.isRootPath())Expanded(
                      child: IconButton(onPressed: rmDir, icon: Icon(Icons.delete)),
                    ),
                  ];
    if (contentType != "dir") {
      iconWidgets.insert(1,Expanded(
                      child: IconButton(onPressed: () {
                        state.downloadFile(index , context);
                      }, icon: Icon(Icons.download)),
                    ),);
    }

    return Card(
      child: Column(
        children: [
          Expanded(
            flex : 1,
            child: image ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              !state.isRootPath() ? GestureDetector(onTap : () {state.isConnected ? showDialog(barrierDismissible: false, context: context, builder: (BuildContext context) {return RenameRessourceDialog(index: index,);}) : showNotConnectedDialog(context);} ,child : FittedBox(child: Text( textAlign: TextAlign.center, shortenText(name, 35) ))) : FittedBox(child: Text( textAlign: TextAlign.center, shortenText(name, 35))) ,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: iconWidgets,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
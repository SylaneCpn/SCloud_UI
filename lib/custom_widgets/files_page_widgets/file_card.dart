// ignore_for_file: prefer_function_declarations_over_variables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sylcpn_io/custom_widgets/alert_dialog.dart';
import 'package:sylcpn_io/custom_widgets/files_page_widgets/full_file.dart';
import 'package:sylcpn_io/data_structures/appstate.dart';
import 'package:sylcpn_io/data_structures/fetching_report.dart';

class FileCard  extends StatelessWidget{

  const FileCard({super.key , required this.index});

  final int index;
  
  
  
  @override
  Widget build(BuildContext context) {
    
    final state = context.watch<AppState>();

    final contentType = state.filesInPath[index].content_type;
    final targetPath = state.filesInPath[index].full_path;
    final name = state.filesInPath[index].name;

    final image = switch (contentType) {

      "dir" => NetworkImage("https://www.iconpacks.net/icons/2/free-folder-icon-1485-thumb.png"),
      "image" => NetworkImage(state.parseGetExtPath(targetPath)),
      _ => NetworkImage("https://w7.pngwing.com/pngs/401/463/png-transparent-document-file-format-computer-icons-paper-sheet-miscellaneous-template-angle-thumbnail.png")

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
      Navigator.push(context, MaterialPageRoute(builder: (_) => FullFile(index: index,)));
    };



    final iconWidgets = <Widget>[
                    Expanded(
                      child: IconButton(onPressed: contentType == "dir" ? openDir : openFile
                      , icon: Icon(Icons.zoom_out_map_rounded)),
                    ),
                    Expanded(
                      child: IconButton(onPressed: () {}, icon: Icon(Icons.delete)),
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
            child: Image(image: image)),
          Expanded(
            flex : 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text( textAlign: TextAlign.center, name),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: iconWidgets,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
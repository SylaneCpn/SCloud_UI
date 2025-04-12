import 'package:flutter/material.dart';
import 'package:flutter_highlighting/themes/vs.dart';
import 'package:pdfrx/pdfrx.dart';

import 'package:sylcpn_io/custom_widgets/files_page_widgets/single_file_page/fetchables/fetchable_highlight_view.dart';
import 'package:sylcpn_io/custom_widgets/files_page_widgets/single_file_page/fetchables/fetchable_selectable_text.dart';
import 'package:sylcpn_io/custom_widgets/files_page_widgets/single_file_page/network_video_player.dart';

import 'package:sylcpn_io/utils.dart';

class SingleFile  extends StatelessWidget{

  final String url;
  final String contentType;
  final String name;

  const SingleFile({super.key , required this.url , required this.contentType, required this.name});

  Widget mapContentTypeWidget(BuildContext context) {

    return switch (contentType) {
      "txt" => FetchableSelectableText(url : url),
      "code_file" => FetchableHighlightView(padding: EdgeInsets.all(20.0), languageId: languageId(name), theme: vsTheme , url : url),
      "image" => Image.network(url),
      "video" =>NetworkVideoPlayer(url: url,),
      "pdf" => PdfViewer.uri(Uri.parse(url), params: PdfViewerParams(enableTextSelection: true , enableKeyboardNavigation: true , panEnabled: true),),
      _ =>   FetchableSelectableText(url : url),

    };
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar( 
        title: Text(name),
        leading: IconButton(onPressed: () { Navigator.pop(context);} , icon: Icon(Icons.arrow_back)),),
        body: Container(color : Theme.of(context).colorScheme.primaryContainer ,child: Center(child: mapContentTypeWidget(context),)),
      );
  }
}
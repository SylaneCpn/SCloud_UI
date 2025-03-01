import 'package:flutter/material.dart';
import 'package:sylcpn_io/custom_widgets/files_page_widgets/error_files_page.dart';
import 'package:sylcpn_io/custom_widgets/files_page_widgets/success_file_page.dart';
import 'package:sylcpn_io/data_structures/appstate.dart';
import 'package:provider/provider.dart';
import 'package:sylcpn_io/custom_widgets/files_page_widgets/default_files_page.dart';
import 'package:sylcpn_io/data_structures/fetching_state.dart';


class FilesPage extends StatelessWidget {
  const FilesPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    final state = context.watch<AppState>();
    if (state.pathState == FetchingState.init) state.initFilesInPath();

    Widget userPicture = state.isConnected && (state.pathState == FetchingState.success) ? Padding(
      padding: const EdgeInsets.all(8.0),
      child: CircleAvatar(backgroundImage: NetworkImage(state.userAvatarPath()),),
    )  : Padding(
      padding: const EdgeInsets.all(8.0),
      child: Image.asset('assets/icon/icon_white.png'),
    ) ;

    final body = switch (state.pathState) {

      FetchingState.init => DefaultFilesPage(),
      FetchingState.success => SuccessFilesPage(),
      FetchingState.failure => ErrorFilesPage(), 

    };

    

    return Scaffold(
      appBar: AppBar(title: Text('Fichiers'),
      leading: GestureDetector( onTap: state.resetFileInPath,child: userPicture ,),
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: body ,
    );
  }
}


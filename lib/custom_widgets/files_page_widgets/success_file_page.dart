// ignore_for_file: prefer_function_declarations_over_variables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sylcpn_io/custom_widgets/alert_dialog.dart';
import 'package:sylcpn_io/custom_widgets/files_page_widgets/add_ressource_dialog.dart';
import 'package:sylcpn_io/custom_widgets/files_page_widgets/file_card.dart';
import 'package:sylcpn_io/data_structures/appstate.dart';
import 'package:sylcpn_io/data_structures/fetching_report.dart';
import 'package:sylcpn_io/custom_widgets/files_page_widgets/path_navigator.dart';

class SuccessFilesPage extends StatelessWidget {
  const SuccessFilesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    var cards = <Widget>[];

    // back button
    final backTap = () async {
      final report = await state.getPrevDir();
      if (report == FetchingReport.refused) {
        // ignore: use_build_context_synchronously
        showSnackBarRefused(context);
      } else if (report == FetchingReport.networkFail) {
        // ignore: use_build_context_synchronously
        showSnackBarNetworkFail(context);
      }
    };

    final refreshTap = () async {
      final report = await state.refreshDir();
      if (report == FetchingReport.refused) {
        // ignore: use_build_context_synchronously
        showSnackBarRefused(context);
      } else if (report == FetchingReport.networkFail) {
        // ignore: use_build_context_synchronously
        showSnackBarNetworkFail(context);
      }
    };

    final addResource = () {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AddRessourceDialog();
        },
      );
    };

    if (!state.isRootPath())
      cards.add(
        Card(
          child: SizedBox(
            child: IconButton(icon: Icon(Icons.arrow_back), onPressed: backTap),
          ),
        ),
      );

    //refresh arrow
    cards.add(
      Card(
        child: SizedBox(
          child: IconButton(icon: Icon(Icons.refresh), onPressed: refreshTap),
        ),
      ),
    );
    for (int i = 0; i < state.filesInPath.length; i++) {
      cards.add(FileCard(index: i));
    }

    //add someting
    if (!state.isRootPath())
      cards.add(
        Card(
          child: SizedBox(
            child: IconButton(icon: Icon(Icons.add), onPressed: addResource),
          ),
        ),
      );

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final isMobile = constraints.maxWidth <= 650;
        final isSuperthin = constraints.maxWidth <= 300;
        final boxHeight = 75.0;
        return Stack(
          children: [
            Container(color: Theme.of(context).colorScheme.primaryContainer),
            Container(
              color: Colors.transparent,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: boxHeight),
                    GridView.count(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      primary: true,
                      padding: EdgeInsets.all(12),
                      crossAxisSpacing: isMobile ? 4 : 20,
                      mainAxisSpacing: isMobile ? 4 : 20,
                      crossAxisCount:
                          isSuperthin
                              ? 1
                              : isMobile
                              ? 2
                              : 3,
                      children: cards,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: boxHeight,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: FittedBox(child: PathNavigator()),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

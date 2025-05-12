import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sylcpn_io/custom_widgets/alert_dialog.dart';
import 'package:sylcpn_io/data_structures/appstate.dart';
import 'package:sylcpn_io/data_structures/fetching_report.dart';
import 'package:sylcpn_io/utils.dart';

class RenameRessourceDialog extends StatefulWidget {
  final int index;
  const RenameRessourceDialog({super.key, required this.index});

  @override
  State<RenameRessourceDialog> createState() => _RenameRessourceDialogState();
}

class _RenameRessourceDialogState extends State<RenameRessourceDialog> {
  var nameController = TextEditingController();

  Future<void> rename(BuildContext context, String path) async {
    if (nameController.text.isEmpty) {
      showAlertDialogEmptyName(context);
      return;
    }

    if (nameController.text.codeUnits.any((b) => b > 127)) {
      showAlertDialogInvalidString(context);
      return;
    }

    try {
      final state = context.read<AppState>();
      final result = await state.renameRessource(
        path,
        makeValidName(nameController.text),
      );

      if (result != FetchingReport.success) {
        Navigator.pop(context);
        showSnackBarFailRename(context);
        return;
      }

      Navigator.pop(context);
      showSnackBarSuccessRename(context);
      final fetchingReport = await state.refreshDir();

      if (fetchingReport == FetchingReport.networkFail)
        showSnackBarNetworkFail(context);
      if (fetchingReport == FetchingReport.refused)
        showSnackBarRefused(context);
    } catch (e) {
      showSnackBarNetworkFail(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.read<AppState>();
    final name = state.filesInPath[widget.index].name;
    final path = state.filesInPath[widget.index].full_path;
    return AlertDialog(
      title: Text('Renommer : $name ?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Retour'),
        ),
      ],
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: nameController,
              obscureText: false,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Nouveau nom',
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              rename(context, path);
            },
            child: Text('Renommer'),
          ),
        ],
      ),
    );
  }
}
